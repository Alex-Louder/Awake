# Awake! para Windows: Blueprint Técnico y Plan Maestro de Portabilidad
**Documento de Arquitectura e Ingeniería de Sistemas**
*Autor: Antigravity AI Engine para Alex Louder (@Alex-Louder)*
*Fecha: Octubre 2026 | Versión de Referencia: Awake! macOS v1.0.0*

---

## 1. Resumen Ejecutivo y Visión General

**Awake!** en macOS resolvió con elegancia uno de los mayores problemas de productividad y servidores portátiles: mantener la laptop plenamente operativa con la tapa cerrada (*clamshell mode*) sin requerir pantallas externas ni conectores HDMI falsos (*dummy plugs*), silenciando automáticamente el audio al cerrar la pantalla pero protegiendo audífonos/AirPods, y apagando la retroiluminación física al 0% para permitir streaming remoto fluido (Sill, Parsec, RustDesk, AnyDesk) a 60 FPS sin pantallas negras.

Este documento detalla la **estrategia de portabilidad 1:1 a Windows 10 y Windows 11 (x86_64 y ARM64 Snapdragon X Elite)**, mapeando cada framework nativo de Apple (`IOKit`, `CoreAudio`, `MediaRemote`, `DisplayServices`, `AppKit/SwiftUI`) a sus equivalentes directos de bajo nivel en la API de Windows (`Win32`, `Core Audio`, `GSMTC`, `WMI`, `DWM`).

---

## 2. Matriz de Equivalencia de APIs: macOS vs. Windows

| Módulo / Función en Awake! | Implementación en macOS (`Sources/Awake/`) | Equivalente Nativo en Windows 10 / 11 | Nivel de Privilegios |
| :--- | :--- | :--- | :--- |
| **Detección del Sensor de Tapa** | `LidDetector.swift`: Polling a `IOPMrootDomain` con clave `"AppleClamshellState"` cada 250ms. | `RegisterPowerSettingNotification` con `GUID_LIDSWITCH_STATE_CHANGE` interceptando `WM_POWERBROADCAST` (`PBT_POWERSETTINGCHANGE`). | Usuario estándar (0 ms latencia, reactivo por interrupción). |
| **Suspensión por Tapa Cerrada** | `PowerManager.swift`: `pmset -a disablesleep 1/0` mediante regla NOPASSWD en `/etc/sudoers.d/awake`. | Win32 API: `PowerWriteACValueIndex` y `PowerWriteDCValueIndex` con `GUID_SYSTEM_BUTTON_SUBGROUP` y `GUID_LIDACTION_SETTING_INDEX = 0` ("Do nothing"). Fallback: `powercfg /setacvalueindex`. | Usuario estándar (esquema activo) o Administrador (esquemas globales). |
| **Aserciones de Energía / Keep-Alive** | `PowerManager.swift`: `IOPMAssertionCreateWithName` (`PreventSystemSleep`, `PreventUserIdleSystemSleep`, `PreventUserIdleDisplaySleep`, `NetworkClientActive`, `kIOPMUserActiveRemote`). | `PowerCreateRequest` + `PowerSetRequest` (`PowerRequestSystemRequired`, `PowerRequestAwayModeRequired`, `PowerRequestExecutionRequired`). Fallback: `SetThreadExecutionState`. | Usuario estándar (sin elevación). |
| **Pausa Universal de Multimedia** | `AudioManager.swift`: `MRMediaRemoteSendCommand(kMRPause / kMRPlay)` (MediaRemote privado) + AppleScript para Spotify/Music. | WinRT: `GlobalSystemMediaTransportControlsSessionManager` (GSMTC) -> `TryPauseAsync()` / `TryPlayAsync()`. | Sesión de usuario interactiva (API oficial y pública). |
| **Muteo y Enrutamiento de Audio** | `AudioManager.swift`: CoreAudio `kAudioHardwarePropertyDefaultOutputDevice`, detección de `kAudioDeviceTransportTypeBluetooth`. | Windows Core Audio API: `IMMDeviceEnumerator`, `IAudioEndpointVolume::SetMute()`, `PKEY_AudioEndpoint_FormFactor` (`EndpointFormFactor::Headphones`). | Usuario estándar. |
| **Apagado de Pantalla para Remote Desktop** | `BrightnessController.swift`: `DisplayServicesSetBrightness(displayID, 0.0)` manteniendo activo el Framebuffer virtual de WindowServer a 60 FPS. | WMI: `WmiMonitorBrightnessMethods.WmiSetBrightness(0)` o DDC/CI `SetMonitorBrightness(0)` + Fallback de Driver Virtual IddCx (`Virtual-Display-Driver`). | Usuario estándar para WMI; Administrador para instalación de IddCx. |
| **UI Menú / System Tray** | `AppDelegate.swift` & `MenuView.swift`: `NSStatusItem` + `NSPopover` con SwiftUI, VisualEffectView `.hudWindow` (Liquid Glass). | `Shell_NotifyIconW` en el System Tray + Ventana flotante Win32/XAML con DWM Acrylic Blur (`DwmSetWindowAttribute` `DWMSBT_ACRYLIC`). | Usuario estándar. |
| **Inicio al Arrancar** | `LaunchAtLoginManager.swift`: `SMAppService.mainApp.register()` y `~/Library/LaunchAgents/com.playlouder.Awake.plist`. | Tarea programada en Windows Task Scheduler (`schtasks.exe`) con `HighestAvailable` o clave de Registro `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`. | Estándar en Registro; Administrador único para Task Scheduler silencioso. |
| **Soporte y Donaciones** | `TipJarStore.swift`: StoreKit 2 (`Product.purchase()`) + Redirección a Ko-fi (`https://ko-fi.com/alexlouder`). | `Windows.Services.Store` (Microsoft Store) + Redirección a Ko-fi / Stripe vía navegador web. | Estándar. |

---

## 3. Arquitectura Detallada por Componentes

### 3.1 Detección del Sensor de Tapa (`LidDetector`)
En macOS, Awake! consulta periódicamente el estado de la tapa mediante un temporizador de 250ms contra IOKit:
```swift
// macOS Awake!: Sources/Awake/LidDetector.swift:46-56
let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMrootDomain"))
let property = IORegistryEntryCreateCFProperty(service, "AppleClamshellState" as CFString, ...)
```

**En Windows**, la arquitectura es superior porque es **100% orientada a eventos** (cero consumo de CPU por sondeo). El sistema operativo emite una interrupción hardware cuando el sensor magnético Hall de la bisagra cambia:

1. **Registro:**
   ```cpp
   // GUID_LIDSWITCH_STATE_CHANGE: {BA3E0F4D-B817-4094-A2D1-D56379E6A0F3}
   HPOWERNOTIFY hLidNotify = RegisterPowerSettingNotification(
       hWnd, 
       &GUID_LIDSWITCH_STATE_CHANGE, 
       DEVICE_NOTIFY_WINDOW_HANDLE
   );
   ```
2. **Procesamiento de Mensajes (`WndProc`):**
   ```cpp
   case WM_POWERBROADCAST:
       if (wParam == PBT_POWERSETTINGCHANGE) {
           auto* setting = reinterpret_cast<POWERBROADCAST_SETTING*>(lParam);
           if (setting->PowerSetting == GUID_LIDSWITCH_STATE_CHANGE) {
               UCHAR lidState = setting->Data[0]; 
               // 0 = Tapa Cerrada (Closed)
               // 1 = Tapa Abierta (Open)
               OnLidStateChanged(lidState == 0);
           }
       }
       break;
   ```
3. **Consulta WMI de Respaldo:**
   Para inicialización antes del primer broadcast: `SELECT * FROM Win32_PnPEntity WHERE PNPDeviceID LIKE '%PNP0C0D%'` (Controlador de conmutador de tapa ACPI).

---

### 3.2 Gestión de Energía y Prevención de Suspensión (`PowerManager`)

#### A. La realidad de Windows: ¿Por qué `SetThreadExecutionState` no es suficiente?
En Windows, cuando el usuario cierra la tapa, el subsistema ACPI dispara una acción de hardware configurable (`LIDACTION`). La función clásica `SetThreadExecutionState(ES_SYSTEM_REQUIRED)` **solo previene la suspensión por inactividad del usuario**, pero Windows la ignora deliberadamente ante el cierre físico de la tapa para evitar accidentes térmicos.

Por lo tanto, la solución exacta y equivalente a `pmset -a disablesleep 1` es modificar programáticamente el esquema de energía activo:

#### B. Modificación Dinámica de `LIDACTION`:
Windows define las siguientes constantes en `powersetting.h`:
* Subgrupo de botones: `GUID_SYSTEM_BUTTON_SUBGROUP` (`4f971e89-eebd-4455-a8de-9e59040e7347`)
* Acción de la tapa: `GUID_LIDACTION_SETTING_INDEX` (`5ca83367-6e45-459f-a27b-476b1d01c936`)
* Valores: `0` = No hacer nada (*Do nothing*), `1` = Suspender (*Sleep*), `2` = Hibernar (*Hibernate*), `3` = Apagar (*Shut down*).

**Implementación nativa en C++ / C#:**
```csharp
// 1. Obtener el GUID del esquema de energía activo
PowerGetActiveScheme(IntPtr.Zero, out IntPtr activeSchemeGuidPtr);
Guid activeScheme = Marshal.PtrToStructure<Guid>(activeSchemeGuidPtr);

// 2. Guardar el valor original del usuario para restaurar al salir
PowerReadACValueIndex(IntPtr.Zero, ref activeScheme, ref GUID_SYSTEM_BUTTON_SUBGROUP, ref GUID_LIDACTION_SETTING_INDEX, out uint originalACAction);
PowerReadDCValueIndex(IntPtr.Zero, ref activeScheme, ref GUID_SYSTEM_BUTTON_SUBGROUP, ref GUID_LIDACTION_SETTING_INDEX, out uint originalDCAction);

// 3. Al Activar Awake!: Establecer Acción en 0 ("Do Nothing") tanto en AC como en Batería (DC)
PowerWriteACValueIndex(IntPtr.Zero, ref activeScheme, ref GUID_SYSTEM_BUTTON_SUBGROUP, ref GUID_LIDACTION_SETTING_INDEX, 0);
PowerWriteDCValueIndex(IntPtr.Zero, ref activeScheme, ref GUID_SYSTEM_BUTTON_SUBGROUP, ref GUID_LIDACTION_SETTING_INDEX, 0);

// 4. Aplicar inmediatamente los cambios al sistema
PowerSetActiveScheme(IntPtr.Zero, ref activeScheme);
```

#### C. Power Availability Requests (Equivalente exacto a IOKit Assertions):
Para asegurar que Windows mantenga encendida la tarjeta Wi-Fi en estado de alta potencia D0, los puertos USB activos y los hilos en ejecución:
```cpp
REASON_CONTEXT context = {0};
context.Version = POWER_REQUEST_CONTEXT_VERSION;
context.Flags = POWER_REQUEST_CONTEXT_SIMPLE_STRING;
context.SimpleReasonString = L"Awake! Windows: Computo ininterrumpido y proteccion USB";

HANDLE hRequest = PowerCreateRequest(&context);
// 1. Previene suspensión general del sistema
PowerSetRequest(hRequest, PowerRequestSystemRequired);
// 2. Modo Away: Permite que procesos en segundo plano y sockets continúen funcionando
PowerSetRequest(hRequest, PowerRequestAwayModeRequired);
// 3. Previene throttling extremo de ejecución
PowerSetRequest(hRequest, PowerRequestExecutionRequired);
```

---

### 3.3 Cortina de Audio Inteligente ("Shh!") y Control Multimedia (`AudioManager`)

En macOS, `AudioManager.swift` recurre al framework privado `MediaRemote.framework` para invocar `MRMediaRemoteSendCommand(1)` y utiliza CoreAudio para mutear el dispositivo por defecto mientras protege los AirPods.

**En Windows, esto es aún más robusto y 100% público:**

#### A. Pausa Universal Multimedia (WinRT GSMTC):
A partir de Windows 10 (1607+), Microsoft introdujo el **Global System Media Transport Controls Session Manager (GSMTC)**. Cualquier reproductor moderno (Spotify, Google Chrome, Microsoft Edge, YouTube, VLC, iTunes/Apple Music Windows, Deezer, Tidal, PotPlayer) se registra en este bus.

```csharp
// Pausa inteligente al cerrar la tapa
var manager = await GlobalSystemMediaTransportControlsSessionManager.RequestAsync();
var sessions = manager.GetSessions();

foreach (var session in sessions)
{
    var playbackInfo = session.GetPlaybackInfo();
    if (playbackInfo.PlaybackStatus == GlobalSystemMediaTransportControlsSessionPlaybackStatus.Playing)
    {
        await session.TryPauseAsync();
    }
}
```

Al abrir la tapa (o cuando "Shh!" está desactivado por el usuario):
```csharp
// Reanudación diferida para contrarrestar pausas automáticas de controladores Bluetooth
await Task.Delay(150);
await activeSession.TryPlayAsync();
await Task.Delay(300);
await activeSession.TryPlayAsync();
```

#### B. Clasificación y Muteo Selectivo de Dispositivos (Core Audio API):
Mediante `IMMDeviceEnumerator`, `IMMDevice` y la propiedad `PKEY_AudioEndpoint_FormFactor`:
```cpp
// Obtener el dispositivo de salida predeterminado
IMMDevice* pDevice = nullptr;
pEnumerator->GetDefaultAudioEndpoint(eRender, eConsole, &pDevice);

// Consultar el factor de forma
IPropertyStore* pProps = nullptr;
pDevice->OpenPropertyStore(STGM_READ, &pProps);
PROPVARIANT varName;
PropVariantInit(&varName);
pProps->GetValue(PKEY_AudioEndpoint_FormFactor, &varName);
EndpointFormFactor formFactor = static_cast<EndpointFormFactor>(varName.uiVal);

// Distinguir entre altavoces internos y audífonos/AirPods:
bool isHeadphonesOrBluetooth = (formFactor == Headphones || formFactor == Headset);

if (!isHeadphonesOrBluetooth) {
    // Si son altavoces de la laptop o monitores HDMI/DP: Mutear
    IAudioEndpointVolume* pVolume = nullptr;
    pDevice->Activate(__uuidof(IAudioEndpointVolume), CLSCTX_ALL, nullptr, (void**)&pVolume);
    pVolume->SetMute(TRUE, nullptr);
}
```

---

### 3.4 Operación Headless para Escritorio Remoto y Retroiluminación al 0% (`BrightnessController`)

#### A. El reto de Windows con DWM (Desktop Window Manager)
En macOS, `DisplayServicesSetBrightness(0.0)` apaga los LEDs de la pantalla pero mantiene vivo el frame buffer de WindowServer a 60 FPS.
En muchas laptops Windows con gráficos integrados Intel Iris Xe, AMD Radeon 780M o Qualcomm Adreno, al cerrar la tapa con `LIDACTION=0`, el controlador de pantalla desactiva físicamente el puerto eDP interno (`DISPLAYCONFIG_PATH_TARGET_INFO`).
Esto causa que aplicaciones de escritorio remoto como **Sill, Parsec, RustDesk y AnyDesk**:
1. Reciban un error `DXGI_ERROR_ACCESS_LOST` de la API de duplicación de escritorio (`IDXGIOutputDuplication`).
2. Transmitan una **pantalla negra** o se congelen a resolución `0x0`.

#### B. La Solución Dual de Awake! para Windows:
1. **Control Físico de Retroiluminación (0% Brillo):**
   Para evitar sobrecalentamiento de la pantalla contra el teclado y ahorrar batería:
   ```cpp
   // Vía WMI WmiMonitorBrightnessMethods (root\wmi)
   // Invoca WmiSetBrightness(Timeout: 1, Brightness: 0)
   ManagementClass mc = new ManagementClass("root\\wmi", "WmiMonitorBrightnessMethods", null);
   foreach (ManagementObject mo in mc.GetInstances()) {
       mo.InvokeMethod("WmiSetBrightness", new object[] { 1, 0 });
   }
   ```
2. **Driver de Pantalla Virtual de Respaldo (IddCx Virtual Display Driver):**
   Para garantizar que Sill, Parsec y RustDesk tengan siempre una superficie DirectX/D3D11 activa a 60 FPS:
   - Awake! Windows incluirá una opción de 1 clic para integrar el driver open-source **IddCx** (Indirect Display Driver, similar al VDD de Parsec o Virtual-Display-Driver de itsmikethetech).
   - Cuando la tapa se cierre y no haya monitores físicos externos conectados, Awake! activa al vuelo una pantalla virtual a 1080p o 4K a 60Hz. Los escritorios remotos transmiten de inmediato a 60 FPS sin pantalla negra.

---

### 3.5 Interfaz de Usuario y Notificación en System Tray (`UI & Shell`)

#### A. Diseño y Estética Visual 1:1
Awake! en macOS destaca por su tarjeta emergente de 270 px con estilo *Liquid Glass* (cristal líquido translúcido oscuro con bordes sutiles y cápsulas de control).

En Windows 11, esta misma estética se logra de manera nativa utilizando la API de DWM:
* Atributo: `DwmSetWindowAttribute(hWnd, DWMWA_SYSTEMBACKDROP_TYPE, DWMSBT_ACRYLIC)`
* Tema Oscuro: `DwmSetWindowAttribute(hWnd, DWMWA_USE_IMMERSIVE_DARK_MODE, TRUE)`
* Esquinas Redondeadas: `DwmSetWindowAttribute(hWnd, DWMWA_WINDOW_CORNER_PREFERENCE, DWMWCP_ROUND)`

#### B. Estructura de Controles de la Tarjeta (270 px):
1. **Header Bar:**
   - Ícono vectorizado de laptop con `A!` en pantalla (en Windows renderizado vía Direct2D o SVG en XAML).
   - Título "Awake!".
   - Selector bilingüe instantáneo (píldoras `ES` / `EN`).
   - Botón de encendido para Inicio al Arrancar (*Launch at login*).
   - Píldora de estado: `ACTIVO` (verde esmeralda `#34D399`) / `INACTIVO` (blanco translúcido).
2. **Cápsulas de Cristal Líquido (Estilo Control Center):**
   - **Cápsula 1 (Awake!):** Ícono de escudo con rayo (`bolt.shield.fill`), título, subtítulo "Mantén despierta tu PC", switch de palanca azul acento (`#0078D4`).
   - **Cápsula 2 (Shh!):** Ícono de altavoz tachado (`speaker.slash.fill`), subtítulo "Silenciar al cerrar", switch de palanca.
3. **Cápsula de Diagnóstico en Tiempo Real:**
   - Sensor de Tapa: Círculo verde (Abierta) / Naranja (Cerrada).
   - USB: Rayo verde (Activo) / Normal.
4. **Footer:**
   - Versión `v1.0`.
   - Botón `Guía` (abre ventana de bienvenida).
   - Botón `Apoyar` (abre ventana de donaciones con corazón rosado).
   - Botón `Salir` (restaura esquemas de energía y cierra limpiamente).

---

### 3.6 Privilegios, Elevación y UAC

En macOS, Awake! resuelve los permisos mediante `/etc/sudoers.d/awake` para que el binario `/usr/bin/pmset` no pida contraseñas.

**En Windows:**
1. Las llamadas a `PowerWriteACValueIndex` y `PowerSetRequest` para el perfil del usuario actual funcionan en la mayoría de instalaciones **sin requerir permisos de Administrador**.
2. Sin embargo, para garantizar compatibilidad con laptops corporativas y permitir la instalación del driver de pantalla virtual IddCx, se implementa el patrón estándar de utilidades de sistema como Microsoft PowerToys:
   - **Configuración mediante Tarea Programada (Task Scheduler):**
     Durante la bienvenida ("Guía"), el botón "Autorizar (1 clic)" ejecuta una instrucción PowerShell o Win32 que crea una tarea en el Programador de Tareas con el atributo `RunLevel = HighestAvailable`.
   - **Ventaja clave:** Al iniciar sesión en Windows, Awake! arranca automáticamente con privilegios plenos **sin mostrar nunca la ventana de advertencia de UAC**.

---

### 3.7 Seguridad Térmica y Salvaguardas en Laptops Windows

A diferencia de las MacBooks con chips Apple Silicon que consumen 1-3W en reposo y se mantienen frías, las laptops con procesadores Intel Core Ultra, AMD Ryzen o Snapdragon X Elite encerradas en mochilas pueden calentarse severamente si un proceso en segundo plano entra en bucle.

Awake! para Windows debe incorporar **tres salvaguardas inteligentes exclusivas para la plataforma**:

1. **Salvaguarda de Desconexión de Corriente (Guardia de Batería):**
   - Monitorear `GetSystemPowerStatus(&status)`.
   - Si `status.ACLineStatus == 0` (Batería) y el nivel cae por debajo del 15%, Awake! automáticamente restaura `LIDACTION = 1` (Sleep) y libera las aserciones para proteger la batería contra descarga profunda.
2. **Salvaguarda Térmica (Límite 85°C):**
   - Monitorear zonas térmicas ACPI vía WMI (`MSAcpi_ThermalZoneTemperature`) o contadores de rendimiento de CPU.
   - Si la temperatura interna supera los 85°C con la tapa cerrada durante más de 60 segundos, Awake! fuerza el reposo preventivo para proteger el equipo.
3. **Ajuste Automático de Eficiencia Energética (EPP):**
   - Al detectar cierre de tapa, ajustar temporalmente la preferencia energética del procesador al modo de máximo ahorro de energía (`PERFEPP = 100`). Esto reduce el voltaje y frecuencia pico de la CPU, manteniendo descargas y escritorio remoto a 5W-10W en lugar de 45W.

---

## 4. Comparativa y Elección del Stack Tecnológico

| Criterio | Opción A: C# / .NET 9 + WinUI 3 (Native AOT) | Opción B: Rust + `windows-rs` + Win32/Direct2D | Opción C: C++20 / WinRT + XAML Islands |
| :--- | :--- | :--- | :--- |
| **Consumo de Memoria RAM** | ~25 MB - 35 MB | **~6 MB - 10 MB** (A la par o menor que macOS) | ~12 MB - 18 MB |
| **Tamaño del Binario (.exe)** | ~18 MB (Autocontenido con Native AOT) | **~2.5 MB** (Ejecutable único sin dependencias) | ~4 MB |
| **Velocidad de Arranque** | Rápida (~120 ms) | **Instantánea (< 25 ms)** | Rápida (~40 ms) |
| **Tiempo de Desarrollo** | **Muy Rápido** (Sintaxis moderna similar a Swift, XAML idéntico a SwiftUI) | Medio (Requiere escribir controles Win32 o Direct2D a mano) | Complejo (Manejo manual de COM y templates WinRT) |
| **Integración con GSMTC / WinRT** | Nativa y declarativa (`async/await`) | Requiere bindings de `windows::Media::Control` | Nativa (`co_await winrt`) |
| **Recomendación para Awake!** | **Ideal para iteración rápida y UI pulida idéntica a SwiftUI.** | **Ideal para la versión final de máxima eficiencia y distribución ligera.** | Alternativa tradicional. |

### Veredicto del Stack:
Se recomienda iniciar el desarrollo en **C# / .NET 9 con Native AOT y WPF/WinUI 3 Modern Acrylic**, logrando una paridad estética idéntica a la versión de macOS en tiempo récord, o bien en **Rust con `windows-rs`** si se prioriza un ejecutable ultraligero de 3 MB sin dependencias de runtime.

---

## 5. Hoja de Ruta para la Implementación Futura

Cuando Alex Louder decida dar inicio al desarrollo de Awake! para Windows, el orden óptimo de construcción será:

1. **Fase 1: Motor de Energía y Sensor de Tapa (Core Engine)**
   - Implementar el bucle de mensajes Win32 con `RegisterPowerSettingNotification(GUID_LIDSWITCH_STATE_CHANGE)`.
   - Implementar `PowerManager.cs / .rs` con lectura y escritura de `PowerWriteACValueIndex` (`LIDACTION = 0`).
2. **Fase 2: Motor de Audio y Multimedia (Shh!)**
   - Integrar `GlobalSystemMediaTransportControlsSessionManager` para pausa y reproducción global.
   - Conectar `IMMDeviceEnumerator` y `IAudioEndpointVolume` para detección y muteo de altavoces.
3. **Fase 3: Pantalla y Operación Headless**
   - Implementar `WmiSetBrightness(0)` para apagar la retroiluminación.
   - Empaquetar el instalador del driver virtual IddCx para soporte de Sill/Parsec.
4. **Fase 4: Shell, System Tray y Liquid Glass UI**
   - Crear el ícono de bandeja con `Shell_NotifyIconW`.
   - Renderizar la tarjeta flotante de 270 px con efecto Acrylic Blur y paleta oscura.
5. **Fase 5: Tarea Programada de Arranque y Pruebas Térmicas**
   - Probar en hardware real (Intel Core Ultra, AMD Ryzen y Snapdragon X Elite con Windows 11 24H2).
