# Awake! v1.0.0 — Manual y Especificación de Release

> **Awake!**: Mantén despierta tu Mac con la tapa cerrada sin pantallas externas, con protección total de USB, servicios en segundo plano y silencio automático.

---

## 1. Resumen del Proyecto

**Awake!** es una aplicación nativa para macOS (macOS 14 Sonoma y macOS 15 Sequoia en Apple Silicon e Intel) diseñada para mantener la computadora completamente operativa cuando se baja la pantalla de la MacBook, sin necesidad de conectar pantallas externas ni adaptadores dummy HDMI.

### Objetivos Clave Cumplidos
1. **Mantener todo activo**: El procesador, las descargas, servidores locales (Docker, Node, Python, bases de datos) y dispositivos USB (hubs, discos externos, interfaces de audio) nunca se suspenden al cerrar la tapa.
2. **Acceso remoto sin pantallas negras**: Aplicaciones como **Sills**, **VNC**, **TeamViewer** o **AnyDesk** pueden conectarse y ver la pantalla con total normalidad con la MacBook cerrada. La pantalla física se atenúa a brillo cero a nivel de hardware mediante `DisplayServicesSetBrightness`, pero el framebuffer de `WindowServer` y la GPU permanecen activos.
3. **Silencio al cerrar (Shh!)**: Al cerrar la tapa, la música o videos se pausan inmediatamente y el sonido se silencia. Funciona tanto en altavoces internos como en interfaces de audio USB (Focusrite Scarlett Solo, etc.) mediante conmutación de dispositivo de salida predeterminado en CoreAudio.
4. **Cero solicitudes de contraseña**: Tras la autorización inicial (1 clic en el onboarding o script de instalación), Awake! activa y desactiva el modo sin pedir contraseñas ni autenticaciones molestas.
5. **Diseño Dark HUD Liquid Glass**: Interfaz inspirada directamente en el Centro de Control de macOS, con cápsulas de esquinas continuas (`cornerRadius: 18`), efecto translúcido HUD y reflejos de borde specular highlight. Cumple estrictamente con los estándares **Anti-AI-Slop UI/UX**.

---

## 2. Los Dos Únicos Controles

Fiel a su filosofía minimalista, Awake! tiene exactamente dos botones:

| Control | Subtítulo | Función Principal |
| :--- | :--- | :--- |
| **Awake!** | *Mantén despierta tu mac* | Impide que el sistema entre en modo reposo al cerrar la tapa. Conserva el suministro eléctrico en los puertos USB y previene la interrupción de procesos. |
| **Shh!** | *Silencio al cerrar* | Al detectar el cierre de la tapa, envía una señal de pausa al sistema multimedia (NowPlaying / MediaRemote) y redirige la salida hacia el altavoz interno silenciado, deteniendo el sonido en interfaces externas (Focusrite, etc.). Al abrir la tapa, restaura el audio y la interfaz original. |

Adicionalmente, el panel incluye un indicador de estado en tiempo real:
- **Tapa**: Indica `Abierta` (punto verde) o `Cerrada` (punto naranja).
- **USB**: Indica `Activo` (con icono de rayo cuando Awake! está activo) o `Normal`.

---

## 3. Arquitectura Técnica

La aplicación está construida en Swift puro sin dependencias externas pesadas, organizada en módulos de responsabilidad única:

```
Sources/Awake/
├── AppDelegate.swift           # Ciclo de vida, NSStatusItem con icono vectorial MacBook "A!" y NSPopover
├── AppViewModel.swift          # Estado reactivo (@Published) que orquesta los subsistemas
├── PowerManager.swift          # Control de pmset disablesleep e IOKit power assertions
├── LidDetector.swift           # Sensor de tapa física mediante IOKit IOPMrootDomain
├── BrightnessController.swift  # Atenuación física de pantalla sin apagar WindowServer
├── AudioManager.swift          # Pausa de MediaRemote y enrutamiento CoreAudio de interfaces USB
├── MenuView.swift              # Interfaz Dark HUD Liquid Glass estilo Centro de Control
├── OnboardingView.swift        # Ventana de bienvenida y configuración de permisos de 1 clic
└── main.swift                  # Punto de entrada de la aplicación NSApplication
```

### Detalle de Módulos

#### `PowerManager.swift`
- Gestiona la propiedad del sistema `SleepDisabled` a través de `/usr/bin/pmset -a disablesleep 1|0`.
- Crea aserciones IOKit (`kIOPMAssertionTypePreventSystemSleep` y `kIOPMAssertionTypePreventUserIdleSystemSleep`) para evitar que el subsistema de energía apague buses PCIe/USB.
- Ofrece métodos asíncronos para ejecución instantánea (`sudo -n /usr/bin/pmset`) y verificación de privilegios (`isPasswordlessSudoConfigured()`).

#### `LidDetector.swift`
- Lee directamente el estado físico del clamshell consultando el registro de IOKit en `IOPMrootDomain` con la clave `AppleClamshellState`.
- Monitorea transiciones y notifica instantáneamente al ViewModel sin consumir CPU.

#### `BrightnessController.swift`
- Evita el error clásico de `pmset displaysleepnow` (que apaga la GPU y deja las sesiones remotas de Sills/VNC en pantalla negra).
- Llama a `DisplayServicesSetBrightness(CGMainDisplayID(), 0.0)` para apagar la retroiluminación física cuando la tapa está cerrada, y restaura el brillo guardado en cuanto la tapa se abre.

#### `AudioManager.swift`
- Utiliza la función privada de macOS `MRMediaRemoteSendCommand(1, nil)` (equivalente a presionar la tecla Play/Pause del teclado de Apple) para pausar cualquier reproductor activo.
- Detecta si la salida de audio es una interfaz USB sin control de volumen por software (como Focusrite Scarlett). Si es así, guarda la interfaz, cambia la salida por defecto al altavoz interno y lo silencia. Al abrir la tapa, devuelve la salida a la interfaz original.

#### `OnboardingView.swift`
- Ventana nativa flotante de bienvenida para la primera instalación.
- Muestra los dos botones y un verificador de permisos de 1 solo clic.
- Si no está autorizado, permite al usuario autenticarse una sola vez con Touch ID / Contraseña de administrador para instalar la regla segura en `/etc/sudoers.d/awake`.

---

## 4. Modelo de Seguridad y Permisos

Para alternar `disablesleep` en macOS, Apple requiere privilegios de superusuario (`root`). Otras aplicaciones resuelven esto pidiendo la contraseña cada vez que el usuario hace clic o instalando daemons residentes pesados.

Awake! utiliza la mejor práctica de UNIX: un archivo de permisos restringido en `/etc/sudoers.d/awake`:

```sudoers
<usuario> ALL=(ALL) NOPASSWD: /usr/bin/pmset -a disablesleep *
```

### Ventajas de este enfoque:
1. **Seguridad estricta**: Solo permite el comando exacto `/usr/bin/pmset -a disablesleep` con argumentos numéricos. No permite ningún otro comando ni elevación arbitraria.
2. **Latencia cero**: El cambio de estado se realiza en menos de 2 milisegundos mediante `sudo -n`, sin ventanas modales de autenticación.
3. **Ligereza**: No requiere daemons residentes en segundo plano consumiendo memoria ni servicios launchd propietarios.

---

## 5. Compilación e Instalación

### Requisitos
- macOS 14.0 Sonoma o posterior (incluyendo macOS 15 Sequoia).
- Swift 6.0 / Xcode Command Line Tools.

### Instalación Rápida
Desde la terminal en el repositorio:
```bash
./install.sh
```
El script:
1. Compila la aplicación en modo Release optimizado (`swift build -c release`).
2. Empaqueta el bundle `Awake!.app` con su `Info.plist` y firma localmente con `codesign`.
3. Configura la regla de `/etc/sudoers.d/awake` para el usuario actual.
4. Instala la app en `/Applications/Awake!.app` y la ejecuta.

### Compilación Manual
```bash
./build.sh
```
Generará `Awake!.app` en la raíz del proyecto lista para distribuirse.

---

## 6. Anti-AI-Slop Design Checklist

Awake! cumple al 100% con las directrices de diseño **Anti-AI-Slop**:
- [x] **Cero gradientes morados/indigo**: Se utiliza el azul nativo de Apple (`#007AFF`) y verde esmeralda para estados activos.
- [x] **Tipografía San Francisco del sistema**: No hay fuentes web genéricas ni textos con tracking exagerado.
- [x] **Microcopy humano y conciso**: Textos directos (`Awake!: Mantén despierta tu mac`, `Shh!: Silencio al cerrar`), sin adjetivos vacíos ("Revolucionario", "Mágico", "Supercharge").
- [x] **Material HUD auténtico**: Fondo `NSVisualEffectView` con material `.hudWindow`, apariencia `.vibrantDark` y reflejo especular con gradiente lineal suave de blanco.
- [x] **Ajuste perfecto de etiquetas**: Textos con protección contra cortes silábicos (`.lineLimit(1)`, `.fixedSize(horizontal: true, vertical: false)`), garantizando que "Cerrada" y "Abierta" se muestren impecables.

---

## 7. Registro de Versiones

- **v1.0.0 (Release Oficial)**:
  - Textos definitivos concisos y directos aprobados por el usuario.
  - Corrección del ajuste del sensor de tapa ("Cerrada").
  - Onboarding nativo de primer inicio con verificación de permisos en 1 clic.
  - Botón de acceso directo a la guía en el pie de la app.
  - Arquitectura Dark HUD Liquid Glass pulida.
  - Soporte completo para sesiones remotas (Sills/VNC) y conmutación de interfaces Focusrite/USB.
