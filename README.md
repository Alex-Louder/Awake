# Awake! 💻⚡

Aplicación nativa, hiperligera y elegante para macOS (Apple Silicon y macOS 14+) con interfaz **Liquid Glass** purificada, que mantiene la Mac funcionando al cerrar la tapa sin necesidad de monitores externos ni adaptadores ficticios.

## Icono oficial y de barra de menú

- **Logo oficial de la app (`AppIcon.icns`)**: La silueta estilizada de una MacBook abierta con **`A!`** en la pantalla.
- **Icono en la barra de menú**: MacBook nativa en plantilla vectorial con **`A!`** en la pantalla (se ilumina cuando está activa y se adapta automáticamente a modo oscuro/claro).
- **Comportamiento**: Un clic en el icono abre directamente el menú Liquid Glass sin pedir contraseñas ni avisos de seguridad.

## Opciones esenciales (Sin sobrecarga)

1. **Mantener activa**:
   - Tu Mac sigue trabajando exactamente como si estuviera abierta.
   - Tu **hub USB**, interfaces de audio (Focusrite Scarlett Solo, etc.), discos externos y periféricos se mantienen encendidos.
   - Todos los servicios, compilaciones, servidores y descargas continúan ejecutándose.
   - Atenúa el brillo físico de la pantalla interna a 0% sin matar WindowServer, permitiendo conexiones remotas desde **Sills, Screens, VNC o RustDesk** sin pantallas negras.
2. **Silenciar al cerrar**:
   - Pausa automáticamente la música (Spotify, Apple Music, YouTube en navegadores, Podcasts, VLC) mediante `MediaRemote` nativo.
   - Redirige el flujo de audio de interfaces USB externas hacia los altavoces internos silenciados a 0.
   - Al volver a abrir la tapa, restaura el volumen y tu interfaz USB original inmediatamente.
3. **Indicadores de estado en vivo**:
   - Sensor físico de tapa: *Abierta 🟢 / Cerrada 🟠*.
   - Hub USB y servicios: *Siempre activos ⚡ / Modo normal*.

## Versiones

- **`v2.1.0` (Actual)**:
  - Regreso al logo de la MacBook abierta con **`A!`** en la pantalla (oficial en barra de menú y en `.icns`).
  - Eliminación total de avisos de seguridad al hacer clic en el icono: el clic abre el menú Liquid Glass sin ejecutar llamadas de administración innecesarias.
  - Eliminación de atajos, temporizadores y opciones superfluas; sólo las opciones esenciales solicitadas con textos 100% legibles.
- **`v2.0.0`**: Versión con diseño CaffeinateBar.
- **`v1.2.0`**: Pods Liquid Glass.
- **`v1.1.0`**: Soporte para acceso remoto sin pantallas negras (Sills/VNC) y silenciamiento para interfaces USB (Scarlett Solo).
- **`v1.0.0`**: Versión inicial.

## Cambiar o regresar de versión

Puedes cambiar a cualquiera de las versiones con un solo comando:
```bash
cd ~/.gemini/antigravity/scratch/ClamAwake
./rollback_v1.sh v2.1.0    # Versión actual (MacBook con A!, Liquid Glass puro)
./rollback_v1.sh v2.0.0    # Versión con diseño CaffeinateBar
./rollback_v1.sh v1.2.0    # Versión 1.2
./rollback_v1.sh v1.0.0    # Versión inicial
```
