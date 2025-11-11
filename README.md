## Coffee Master

## Descripción General

Aplicación móvil diseñada para asistir en la preparación del café. Ofrece un catálogo de recetas y máquinas, ayudando a baristas y entusiastas a consultar el uso detallado de diversas cafeteras y métodos de preparación. Permite la personalización de recetas, la gestión de favoritos y la contribución de contenido (futuros tutoriales) para compartir conocimiento dentro de la comunidad.

## Requerimientos Funcionales 


- Gestión de Catálogos y Recetas

- Consultar el catálogo de cafeteras base desde assets/machines_base.json.

- Consultar las recetas base con variantes por cafetera desde assets/recipes_base.json.

- Gestión de Recetas (CRUD):

- Crear, editar, eliminar y compartir recetas personalizadas con sus variantes.

- Permitir la asociación de una receta a múltiples cafeteras.

- Gestión de Cafeteras Personalizadas:

- Permitir la creación de cafeteras personalizadas desde la aplicación, incluyendo una imagen propia.

- Permitir agregar cafeteras a favoritos.

- Permitir compartir toda la información (cafeteras y recetas) por cualquier aplicación (WhatsApp, etc.), soportando texto e imagen (share_plus).

## Navegación y Uso

- Permitir navegar desde el Home al detalle de las cafeteras mediante la interacción en las fotos del menú principal.

- Disponer de un submenú lateral para acceder a la configuración y otros módulos.

 ## Requerimientos No Funcionales 

- Navegación Fluida: La navegación e interfaz general deben ser fluidas e intuitivas.

- Mantener Pantalla Encendida: La aplicación debe ofrecer la opción de mantener la pantalla encendida durante la preparación de la receta para evitar interrupciones.

- Guía de Buenas Prácticas: La aplicación debe incluir una sección o apartado con la guía de buenas prácticas de preparación de café.

- Información del Proyecto: Debe contar con una pantalla "Acerca de" para obtener información del desarrollador y la aplicación, además de inlcuir una encuesta de satisfacción.

- Persistencia de Datos: Los datos (cafeteras y recetas personalizadas, uso reciente y preferencias) deben ser conservados tras cerrar la aplicación.

- Recordatorios: La aplicación debe ofrecer la gestión de recordatorios (notificaciones locales) para prácticas o tareas.

- Splash Screen: La aplicación debe mostrar una pantalla de bienvenida (Splash screen) con el logo de la aplicación.

 ## Características Técnicas

- Orden del Home: El usuario puede elegir ordenar el Home por uso reciente o alfabético.

- Cafetera por defecto: Permitir definir una cafetera por defecto para la creación de nuevas recetas.

- Tamaño de Texto Global: Ajuste del tamaño de texto en las pantallas de recetas.

 ## Datos y Persistencia

- JSON embebido (Assets)

- assets/machines_base.json: Catálogo base de cafeteras.

- assets/recipes_base.json: Recetas base con variantes por cafetera.


- Recetas y variantes editadas: Se guardan en SharedPreferences.

- Cafeteras personalizadas: Se guardan en SQLite.

- Uso Reciente: Contador por cafetera en SharedPreferences para ordenar el Home.

- Preferencias: Guardadas en SharedPreferences.

## Pantallas Principales

- Home: Grid de cafeteras base y personalizadas. Acceso a detalle, favoritos y compartir.

- Detalle de cafetera: Muestra ratio, molienda, instrucciones y permite la edición local.

- Recetas: Lista plana por variante; permite ver detalle, editar, crear nueva y compartir.

- Buenas prácticas: Guía rápida de consejos.

- Favoritos: Atajos a las cafeteras marcadas.

- Recordatorios: Gestión de notificaciones.

- Preferencias: Pantalla de ajustes descritos en Requerimientos No Funcionales.

- Acerca de: Información del proyecto.

 ## Tecnologías Utilizadas

- Flutter, Dart

- SQLite (persistencia de cafeteras personalizadas)

- SharedPreferences (preferencias y overrides)

- Provider (estado de configuración)

- share_plus, google_fonts, url_launcher (si aplica), flutter_local_notifications o equivalente para notificaciones

## Diagrama de flujo de pantallas

```mermaid
flowchart LR
  SS[Splash Screen] --> H[Home]

  H --> GP[Good Practices]
  H --> AB[About]
  H --> FV[Favorites]
  H --> RC[Recipes]
  H --> PR[Preferences]
  H --> RM[Reminders]
  H --> MR[Machines Catalog]
  H <--> NC[New Custom Machine]

  MR --> MD[Machine Detail]
  MD --> SH1[Share]
  MD --> ME[Edit Override]

  RC --> RD[Recipe Detail]
  RD --> RE[Edit Recipe]
  RD --> SH2[Share]
  RC --> RCN[New Recipe]

  PR --> P1[Keep screen on]
  PR --> P2[Home order]
  PR --> P3[Default machine]
  PR --> P4[Text size]


