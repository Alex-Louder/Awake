# Awake! v1.0.0 — Manual y Especificación de Release

> **Awake!**: Mantén despierta tu Mac con la tapa cerrada sin pantallas externas, con protección total de USB, servicios en segundo plano y silencio automático.

---

## 1. Resumen del Proyecto

**Awake!** es una aplicación nativa para macOS (macOS 14 Sonoma y macOS 15 Sequoia en Apple Silicon e Intel) diseñada para mantener la computadora completamente operativa cuando se baja la pantalla de la MacBook, sin necesidad de conectar pantallas externas ni adaptadores dummy HDMI.

### Objetivos Clave Cumplidos
1. **Mantener todo activo**: El procesador, las descargas, servidores locales (Docker, Node, Python, bases de datos) y dispositivos USB (hubs, discos externos, interfaces de audio) nunca se suspenden al cerrar la tapa.
2. **Acceso remoto sin pantallas negras**: Aplicaciones como **Sills**, **VNC**, **TeamViewer** o **AnyDesk** pueden conectarse y ver la pantalla con total normalidad con la MacBook cerrada. La pantalla física se atenúa a brillo cero a nivel de hardware mediante `DisplayServicesSetBrightness`, pero el framebuffer de `WindowServer` y la GPU permanecen activos.
3. **Silenciar al cerrar (Shh!)**: Al cerrar la tapa, la música o videos se pausan inmediatamente y el sonido se silencia tanto en altavoces internos como en **AirPods, audífonos o altavoces externos**.
4. **Cero solicitudes de contraseña**: Tras la autorización inicial (1 clic en el onboarding o script de instalación), Awake! activa y desactiva el modo sin pedir contraseñas ni autenticaciones molestas.
5. **Selector de Idioma Dinámico (ES / EN)**: Selector integrado en el Onboarding y en el menú desplegable que traduce toda la interfaz al instante.
6. **Sistema de Donaciones / Tip Jar ($1, $3, $5)**: Sistema idéntico a CaffeinateBar con soporte nativo de StoreKit 2 y fallback a donaciones web (PayPal/Tarjeta):
   - **$1**: *Gracias por tu apoyo*
   - **$3**: *¡Muchas gracias!*
   - **$5**: *¡Muchísimas gracias!*
7. **Icono Oficial Personalizado**: Squircle oscuro con la MacBook (`A!`) y el Memoji del desarrollador recortado limpiamente sin el aro degradado en la esquina inferior izquierda.
8. **Diseño Dark HUD Liquid Glass**: Interfaz inspirada directamente en el Centro de Control de macOS, con cápsulas simétricas de esquinas continuas (`cornerRadius: 18`), efecto translúcido HUD y reflejos de borde specular highlight. Cumple estrictamente con los estándares **Anti-AI-Slop UI/UX**.

---

## 2. Los Dos Controles Principales

| Control | Subtítulo (ES) | Subtítulo (EN) | Función Principal |
| :--- | :--- | :--- | :--- |
| **Awake!** | *Mantén despierta tu mac* | *Keep your Mac awake* | Impide que el sistema entre en reposo al cerrar la tapa. Conserva el suministro eléctrico en los puertos USB y previene la interrupción de procesos y sesiones remotas. |
| **Shh!** | *Silenciar al cerrar* | *Mute on lid close* | Pausa automáticamente la música o videos en reproducción y silencia el sonido en AirPods, audífonos o altavoces al bajar la pantalla. |

Adicionalmente, el panel incluye un indicador de estado en tiempo real:
- **Tapa / Lid**: `Abierta` / `Open` (punto verde) o `Cerrada` / `Closed` (punto naranja).
- **USB**: `Activo` / `Active` (con icono de rayo cuando Awake! está activo) o `Normal`.

---

## 3. Sistema de Donaciones (Tip Jar)

Inspirado en el sistema de CaffeinateBar, Awake! ofrece 3 niveles de contribución:

- **$1**: **Gracias por tu apoyo** (*Thanks for your support*) — *Impulsa el desarrollo continuo*
- **$3**: **¡Muchas gracias!** (*Thank you so much!*) — *Un gran gesto de agradecimiento*
- **$5**: **¡Muchísimas gracias!** (*Thank you very much!*) — *Patrocinador oficial de Awake!*

### Integración Técnica
1. **StoreKit 2**: Mapeado con productos consumibles (`com.playlouder.Awake.tip.1`, `com.playlouder.Awake.tip.3`, `com.playlouder.Awake.tip.5`). Incluye archivo de configuración local `AwakeTips.storekit`.
2. **Ko-fi Direct Support**: Enlace oficial conectado a [ko-fi.com/alexlouder](https://ko-fi.com/alexlouder) con 0% de comisión de plataforma y opciones configuradas de $1, $3 y $5. Si la aplicación se ejecuta fuera de la Mac App Store, los botones y el enlace directo redirigen inmediatamente a la página de donación.

---

## 4. Arquitectura Técnica

```
Sources/Awake/
├── AppDelegate.swift           # Ciclo de vida, status item en barra de menú y ventanas flotantes
├── AppViewModel.swift          # Estado reactivo (@Published) que orquesta los subsistemas
├── LocalizationManager.swift   # Motor centralizado de traducción en vivo (ES / EN)
├── PowerManager.swift          # Control de pmset disablesleep e IOKit power assertions
├── LidDetector.swift           # Sensor de tapa física mediante IOKit IOPMrootDomain
├── BrightnessController.swift  # Atenuación física de pantalla sin apagar WindowServer
├── AudioManager.swift          # Pausa de MediaRemote y enrutamiento CoreAudio de interfaces USB
├── MenuView.swift              # Interfaz Dark HUD Liquid Glass estilo Centro de Control
├── OnboardingView.swift        # Ventana de bienvenida, selector de idioma y permisos
├── TipJarStore.swift           # Gestor de StoreKit 2 y enlaces de pago
├── TipJarView.swift            # Panel visual de donaciones ($1, $5, $10)
└── main.swift                  # Punto de entrada de la aplicación NSApplication

Resources/
├── AppIcon.icns                # Icono macOS compilado con Memoji en esquina inferior izquierda
├── AppIcon_1024.png            # Master PNG de alta resolución 1024x1024
├── Memoji.png                  # Sprite aislado del Memoji sin aro degradado
└── AwakeTips.storekit          # Configuración de compras dentro de la app para Xcode
```

---

## 5. Compilación e Instalación

### Instalación Rápida
```bash
./install.sh
```

El script:
1. Compila la aplicación en modo Release (`swift build -c release`).
2. Empaqueta el bundle `Awake!.app` con sus recursos (`AppIcon.icns`, `AppIcon_1024.png`, `AwakeTips.storekit`).
3. Firma localmente con `codesign`.
4. Configura la regla NOPASSWD en `/etc/sudoers.d/awake` para el usuario actual.
5. Instala en `/Applications/Awake!.app` y la ejecuta.
