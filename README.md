# Awake! ☕⚡

Aplicación nativa, hiperligera y elegante para macOS (Apple Silicon y macOS 14+) con interfaz inspirada en CaffeinateBar, que permite mantener la Mac funcionando al cerrar la tapa sin necesidad de monitores externos ni adaptadores ficticios.

## Comportamiento del icono en la barra de menú

- **Clic izquierdo (Left Click)**: Activa o desactiva instantáneamente la función principal (**Mantener activa**). El icono de la taza de café se llena al estar activa o pasa a contorno al estar inactiva.
- **Clic derecho (Right Click)**: Despliega el panel de opciones y ajustes detallados al estilo CaffeinateBar.
- **Atajo global `⌘K`**: Alterna el estado activo/inactivo desde el teclado.

## Características

1. **Mantener Mac activa al cerrar la tapa**:
   - Tu Mac sigue trabajando exactamente como si estuviera abierta.
   - Tu **hub USB**, interfaces de audio (Focusrite Scarlett Solo, etc.), discos externos y periféricos se mantienen encendidos.
   - Todos los servicios, compilaciones, servidores y descargas continúan ejecutándose.
   - Atenúa el brillo físico de la pantalla interna a 0% sin matar WindowServer, permitiendo conexiones remotas desde **Sills, Screens, VNC o RustDesk** sin pantallas negras.
2. **Silenciar sonido al cerrar la tapa**:
   - Pausa automáticamente la música (Spotify, Apple Music, YouTube en navegadores, Podcasts, VLC) mediante `MediaRemote` nativo.
   - Redirige el flujo de audio de interfaces USB externas hacia los altavoces internos silenciados a 0.
   - Al volver a abrir la tapa, restaura el volumen y tu interfaz USB original inmediatamente.
3. **Interfaz CaffeinateBar**:
   - Tarjeta superior de estado con taza de café animada e indicador luminoso.
   - Botón de acción rápida (☀️ Activar Awake! / 🌙 Desactivar Awake!) con atajo `⌘K`.
   - Secciones `BLOQUEOS`, `ESTADO Y SENSORES` y `AJUSTES` con toggles nativos y etiquetas monospace (`-pm`, `mute`, `-d`).
   - Caja de comando terminal con el estado en vivo de `pmset`.
   - Peso total: apenas **~330 KB**.

## Versiones

- **`v2.0.0` (Actual)**:
  - Cambio de nombre oficial a **Awake!**.
  - Comportamiento de doble acción: clic izquierdo activa/desactiva instantáneamente, clic derecho abre el menú.
  - Rediseño visual 1:1 idéntico a la estructura de CaffeinateBar (tarjeta superior, filas de bloqueos con etiquetas `-pm`, `-d`, sensores de hardware y caja de terminal).
  - Eliminación definitiva del diálogo de VLC mediante introspección de bundles activos.
- **`v1.2.0`**: Pods Liquid Glass y corrección de truncado de textos.
- **`v1.1.0`**: Soporte para acceso remoto sin pantallas negras (Sills/VNC) y silenciamiento para interfaces USB (Scarlett Solo).
- **`v1.0.0`**: Versión inicial.

## Cambiar o regresar de versión

Puedes cambiar a cualquiera de las versiones con un solo comando:
```bash
cd ~/.gemini/antigravity/scratch/ClamAwake
./rollback_v1.sh v1.0.0    # Versión inicial
./rollback_v1.sh v1.1.0    # Versión 1.1 (Scarlett + Sills)
./rollback_v1.sh v1.2.0    # Versión 1.2 (Liquid Glass pods)
./rollback_v1.sh v2.0.0    # Versión 2.0 (Awake! estilo CaffeinateBar)
```
