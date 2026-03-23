# Documentación de Arquitectura - EduConnect

Este documento explica la organización del proyecto tras la reestructuración para mejorar la escalabilidad y facilitar el trabajo grupal. El código se ha dividido en componentes lógicos, siguiendo las mejores prácticas de Flutter.

## 🏗️ Estructura de Carpetas

La aplicación ahora utiliza una estructura modular basada en carpetas:

```text
lib/
├── main.dart             # Punto de entrada y configuración global
├── screens/              # Pantallas completas de la aplicación
│   ├── login_screen.dart # Pantalla de inicio de sesión (Móvil/Escritorio)
│   └── splash_screen.dart # Pantalla de carga (Splash Screen)
└── widgets/              # Componentes visuales reutilizables
    └── role_chip.dart    # Chip personalizado para roles de usuario
```

---

## 📄 Descripción de Archivos

### 1. `lib/main.dart`
Es el corazón de la aplicación. Se encarga de:
- Configurar el tema visual global (`ThemeData`).
- Definir el punto de inicio de la app (`SplashPage`).
- Mantener el archivo limpio para que solo contenga configuraciones generales.

### 2. `lib/screens/splash_screen.dart`
Contiene la pantalla inicial que ve el usuario al abrir la app.
- **Responsabilidad**: Mostrar el logo y cargar recursos (por ahora simulado con un temporizador de 3 segundos).
- **Componentes**: Incluye el `_BrandShieldIcon` y utiliza el widget compartido `RoleChip`.
- **Navegación**: Al terminar el tiempo, redirige automáticamente a la pantalla de login con una transición suave.

### 3. `lib/screens/login_screen.dart`
Esta es la pantalla más compleja y está diseñada para ser **responsiva**.
- **Adaptabilidad**: Utiliza `LayoutBuilder` para decidir si muestra el diseño de móvil/tablet o el de escritorio.
- **Componentes**: Contiene widgets privados al archivo (que empiezan con `_`) para organizar el formulario, el banner y el panel lateral de escritorio.
- **Funcionalidad**: Maneja el estado local para mostrar/ocultar la contraseña.

### 4. `lib/widgets/role_chip.dart`
Un widget pequeño pero importante que se reutiliza en varias partes del proyecto.
- **Propósito**: Mostrar los diferentes perfiles (Estudiantes, Docentes, Admin) con un estilo consistente.
- **Ventaja**: Si decides cambiar el diseño de los chips, solo tienes que editar este archivo y se actualizará en todas las pantallas.

---

## 🚀 Ventajas para el Grupo

1.  **Menos Conflictos**: Al estar el código en archivos separados, es menos probable que dos personas choquen al editar la misma pantalla.
2.  **Escalabilidad**: Cuando necesitemos añadir nuevas pantallas (como el Dashboard o Mensajes), simplemente creamos un nuevo archivo en `lib/screens/`.
3.  **Mantenibilidad**: Es mucho más rápido encontrar un error en un archivo de 200 líneas que en uno de 1200.
4.  **Reutilización**: Los widgets en la carpeta `widgets/` pueden ser usados en cualquier parte del proyecto sin duplicar código.

---

*© 2026 - Proyecto de Gestión Universitaria EduConnect*
