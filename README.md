# Awake! 💻⚡

Aplicación nativa, hiperligera y elegante para macOS (Apple Silicon y macOS 14+) con interfaz **Liquid Glass** idéntica a la del Centro de Control de Apple (cápsulas translúcidas de 240 px con biseles refractivos).

## Cero avisos de contraseña (0 Prompts)

- La aplicación utiliza una regla segura `NOPASSWD` para `/usr/bin/pmset -a disablesleep *` en `/etc/sudoers.d/awake`.
- Activar o desactivar la suspensión ocurre instantáneamente en **1 milisegundo**, **sin pedir contraseñas ni mostrar avisos de seguridad jamás**.

## Interfaz Control Center Liquid Glass

- **Cápsulas de cristal líquido**: Diseño idéntico a los módulos de Wi-Fi y Bluetooth del Centro de Control de macOS.
- **Bisel especular refractivo**: Gradiente luminoso que simula la refracción física de la luz sobre el cristal.
- **Textos ultra concisos (3 a 4 palabras)**:
  - *Mantener activa*: **"Nunca se duerme"**
  - *Silenciar sonido*: **"Muta al cerrar"**
- **Diagnóstico en vivo**:
  - *Tapa: Abierta 🟢 / Cerrada 🟠*
  - *USB: Activo ⚡ / Normal*

## Icono oficial y de barra de menú

- **Logo oficial de la app (`AppIcon.icns`)**: La silueta de una MacBook abierta con **`A!`** en la pantalla.
- **Icono en la barra de menú**: MacBook vectorial con **`A!`** en la pantalla que se adapta automáticamente a modo oscuro/claro y se ilumina al estar activa.

## Versiones

- **`v2.3.0` (Actual)**:
  - Acabado visual idéntico al Centro de Control de Apple (cápsulas oscuras translúcidas con biseles refractivos y botones circulares blancos).
  - Eliminación definitiva del aviso de contraseña al activar/desactivar mediante integración `NOPASSWD` con `pmset`.
  - Textos resumidos a un máximo de 3 a 4 palabras.
- **`v2.2.0`**: Reducción de dimensiones a 250 px.
- **`v2.1.0`**: Regreso al logo de MacBook con `A!`.
- **`v2.0.0`**: Versión con diseño CaffeinateBar.
- **`v1.0.0`**: Versión inicial.
