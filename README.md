# Awake! 💻⚡

Aplicación nativa, hiperligera y elegante para macOS (Apple Silicon y macOS 14+) con interfaz **Liquid Glass** idéntica a la del Centro de Control de Apple.

Permite que tu Mac siga funcionando exactamente como si estuviera abierta cuando cierras la tapa: **no se suspenden los servicios, no se desactivan los puertos o hubs USB, y las sesiones remotas (Sills, VNC) no sufren de pantalla negra**.

---

## Características de la Versión 1.0.0

1. **Awake!**: *Mantén despierta tu mac*
   - Impide que la Mac entre en modo reposo al cerrar la tapa.
   - Procesadores, descargas, servidores locales y puertos USB continúan operando con normalidad.
2. **Shh!**: *Silencio al cerrar*
   - Pausa automáticamente cualquier audio o video en reproducción (`NowPlaying`).
   - Silencia tanto los altavoces internos como interfaces de audio externas por USB (Focusrite Scarlett Solo, etc.).
3. **Escritorio Remoto Funcional (Sills / VNC)**:
   - Al cerrar la tapa, la pantalla física se atenúa a brillo cero a nivel de hardware, pero el framebuffer de WindowServer y la GPU permanecen activos, evitando pantallas negras en conexiones remotas.
4. **Cero avisos de contraseña (0 Prompts)**:
   - Utiliza una regla segura `NOPASSWD` para `/usr/bin/pmset -a disablesleep *` en `/etc/sudoers.d/awake`.
   - Activar o desactivar ocurre en ~1 milisegundo sin ventanas de contraseña.
5. **Onboarding nativo de primer inicio**:
   - Ventana flotante de bienvenida con guía visual y verificación de permisos en 1 solo clic.
   - Acceso permanente a la guía desde el botón "Guía" en el menú.
6. **Diseño Anti-AI-Slop Dark HUD Liquid Glass**:
   - Fondo `NSVisualEffectView` con material `.hudWindow` y apariencia `.vibrantDark`.
   - Cápsulas de esquinas continuas con biseles especulares refractivos.

---

## Documentación Completa

Para la especificación técnica completa y arquitectura de la versión 1.0.0, consulta [RELEASE_V1.md](file:///Users/playlouder/.gemini/antigravity/scratch/ClamAwake/RELEASE_V1.md).

---

## Instalación

```bash
./install.sh
```

El script compila, firma, verifica permisos e instala `Awake!.app` en tu carpeta `/Applications`.
