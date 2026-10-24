# ClamAwake 💻✨

Aplicación nativa, ligera y minimalista para macOS (Apple Silicon y macOS 14+) que permite mantener la Mac funcionando al cerrar la tapa sin necesidad de conectar monitores externos ni adaptadores ficticios.

## Características

1. **Mantener Mac activa al cerrar la tapa**:
   - Tu Mac sigue trabajando exactamente como si estuviera abierta.
   - Tu **hub USB**, interfaces de audio, discos externos y periféricos se mantienen encendidos.
   - Todos los servicios, servidores, descargas, scripts y procesos en segundo plano siguen ejecutándose sin interrupción.
   - La pantalla interna se apaga automáticamente al cerrarse para ahorrar energía y evitar calor en el panel LCD, y se despierta al reabrir la tapa.

2. **Silenciar sonido al cerrar la tapa**:
   - Pausa automáticamente la música y videos (Spotify, Apple Music, YouTube en navegador, VLC, podcasts) cuando la tapa se cierra.
   - Silencia el volumen del sistema.
   - Restaura el volumen cuando la tapa vuelve a abrirse.

3. **Cero AI Slop & Ultraligera**:
   - Construida en Swift nativo con SwiftUI y AppKit.
   - Peso total: apenas **~330 KB**.
   - Vive discretamente en la barra de menú superior (`NSStatusItem`).
   - Cero consumo de CPU en reposo (0.0%).

## Uso

1. La aplicación ya está instalada y corriendo en tu barra de menú:
   - Haz clic en el icono de la laptop en la barra de menús superior.
   - **Interruptor 1**: Activar/Desactivar mantener Mac activa al cerrar la tapa (te solicitará Touch ID o contraseña de administrador la primera vez para configurar la política del sistema).
   - **Interruptor 2**: Activar/Desactivar silenciar sonido al cerrar la tapa.
2. Indicadores en tiempo real:
   - Estado del sensor físico de la tapa (Abierta / Cerrada).
   - Estado de protección del hub USB y procesos del sistema.

## Scripts de desarrollo

- `./build.sh`: Compila el paquete `.app` optimizado en Release.
- `./install.sh`: Compila, firma e instala directamente en `/Applications/ClamAwake.app`.
