# Form App con Gemini

Esta es una aplicación de ejemplo construida con Flutter que demuestra un formulario de registro de usuario de varios pasos, gestión de perfiles y una función de chat impulsada por la API de Google Gemini.

## Características

- **Creación y edición de perfiles de usuario:** Los usuarios pueden crear un perfil con su nombre, apellido y fecha de nacimiento.
- **Gestión de direcciones:** Los usuarios pueden añadir, editar y eliminar varias direcciones asociadas a su perfil.
- **Chat con Gemini:** Una pantalla de chat integrada permite a los usuarios interactuar con el modelo de IA generativa de Google, Gemini.
- **Navegación fluida:** La aplicación utiliza una barra de navegación inferior para cambiar fácilmente entre las pantallas de registro, direcciones y perfil.

## Cómo empezar

Sigue estos pasos para tener el proyecto en funcionamiento en tu máquina local.

### Prerrequisitos

- Asegúrate de que tienes el [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado.
- Una clave API de Google Gemini. Puedes obtener una desde [Google AI Studio](https://makersuite.google.com/).

### Instalación y ejecución

1. **Clona el repositorio:**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd <NOMBRE_DEL_DIRECTORIO>
   ```

2. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

3. **Configura la clave API de Gemini:**
   La aplicación espera que la clave API de Gemini se proporcione como una variable de entorno al compilar.

   Ejecuta la aplicación usando el siguiente comando, reemplazando `TU_API_KEY` con tu clave API real:
   ```bash
   flutter run --dart-define=API_KEY=TU_API_KEY
   ```

¡Y eso es todo! La aplicación debería iniciarse en tu emulador o dispositivo conectado.
