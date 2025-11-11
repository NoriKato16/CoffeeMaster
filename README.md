
# Coffee Master 

## Características

Aplicación desarrollada para consultar el uso de las distintas formas de preparar café en varias cafeteras distintas, de esta forma ayuda a los baristas nuevo a ver como se usa cada máquina y poder tener la información a la mano añadiendo a favoritos las que más va a usar.
Además de poder compartir y subir sus propios video tutoriales para ayudar a otros baristas.

La aplicación permitirá navegar desde home al resto de cafeteras mediante la interacción en las fotos que contendrá el menú principal, además de tener un submenú lateral donde estará la configuración.



## Requerimientos funcionales:

- La aplicación permite agregar cafeteras.

- La aplicación permite subir fotos de máquinas.

- La aplicación permite compartir la información de las cafeteras.


## Requerimientos no funcionales:

- La aplicación va a tener un apartado de buenas prácticas.

- La aplicación va a ofrecer añadir cafeteras favoritas.

- La aplicación va a ofrecer subir vídeos tutoriales.

## Características Técnicas

- Navegación fluida e intuitiva:

- Bases de datos para almacenar las cafeteras y las añadidas por el usuario

- Pantalla "acerca de" para obtener información del desarrollador y la aplicación

## Tecnologías Utilizadas
- Flutter : Framework de trabajo
- Dart : Lenguaje de programación
- Visual Studio Code
- GitHub : Control de versiones

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


