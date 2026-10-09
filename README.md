# Trancas Viejas — Sitio Web Comunitario

Sitio web documental y comunitario dedicado a **Trancas Viejas, municipio de Moloacán, Veracruz**.

El proyecto tiene como objetivo presentar información sobre la comunidad, su historia, lugares representativos, actividades y fotografías, utilizando una estructura web sencilla, accesible y fácil de mantener.

## Tecnologías

* HTML5
* CSS3
* JavaScript (Vanilla)
* Google Fonts
* SVG para imágenes provisionales

No se utilizan frameworks ni dependencias de JavaScript para la versión actual del proyecto.

## Estructura del proyecto

```text
trancas-viejas/
├── index.html
├── historia.html
├── galeria.html
├── lugares.html
├── eventos.html
│
├── css/
│   └── styles.css
│
├── js/
│   └── main.js
│
├── img/
│   ├── portada/
│   ├── comunidad/
│   ├── historia/
│   ├── lugares/
│   ├── eventos/
│   ├── galeria/
│   └── placeholders/
│
└── README.md
```

## Organización de imágenes

Las fotografías definitivas se almacenarán dentro de las siguientes carpetas:

### `img/portada/`

Imagen principal de la página de inicio.

Archivo previsto:

```text
hero-principal.jpg
```

### `img/comunidad/`

Fotografías generales de la comunidad.

Archivo previsto:

```text
comunidad-intro.jpg
```

### `img/historia/`

Fotografías relacionadas con la historia y los orígenes de la comunidad.

Archivo previsto:

```text
historia-origenes.jpg
```

### `img/lugares/`

Fotografías de lugares representativos.

Archivos previstos:

```text
lugar-1.jpg
lugar-2.jpg
lugar-3.jpg
lugar-4.jpg
```

### `img/eventos/`

Fotografías de eventos y actividades comunitarias.

Archivos previstos:

```text
evento-1.jpg
evento-2.jpg
evento-3.jpg
```

### `img/galeria/`

Fotografías destinadas a la galería general.

Archivos previstos:

```text
galeria-comunidad-1.jpg
galeria-comunidad-2.jpg
galeria-comunidad-3.jpg

galeria-paisaje-1.jpg
galeria-paisaje-2.jpg
galeria-paisaje-3.jpg

galeria-tradicion-1.jpg
galeria-tradicion-2.jpg
galeria-tradicion-3.jpg
```

### `img/placeholders/`

Contiene las imágenes SVG provisionales utilizadas mientras se recopilan fotografías reales.

Estas imágenes se conservarán como respaldo y no representan fotografías reales de Trancas Viejas.

## Fotografías reales

Las fotografías definitivas deberán:

* Corresponder realmente a Trancas Viejas o al contexto indicado.
* Tener buena calidad y resolución.
* Mantener los nombres establecidos en este documento.
* Evitar datos personales innecesarios.
* Contar con autorización cuando aparezcan personas identificables, especialmente menores de edad.

Se recomienda utilizar formatos `.jpg` o `.webp` para las fotografías finales.

## Información del contenido

Los textos relacionados con la historia, lugares, eventos y datos comunitarios deberán verificarse antes de publicarse.

No se deben inventar:

* Fechas históricas.
* Nombres de personas.
* Fundadores.
* Tradiciones.
* Festividades.
* Lugares.
* Datos oficiales.
* Información de contacto.

Mientras la información no haya sido verificada, se mantendrán los marcadores `[Pendiente: ...]`.

## Páginas del sitio

### Inicio

Presenta la comunidad y proporciona acceso a las principales secciones del sitio.

### Historia

Contiene información sobre los orígenes y evolución de la comunidad.

### Galería

Muestra fotografías organizadas por categorías.

### Lugares

Presenta sitios representativos de la comunidad.

### Eventos

Presenta festividades, actividades y acontecimientos comunitarios.

## Desarrollo local

Para visualizar el proyecto localmente se recomienda utilizar la extensión **Live Server** de Visual Studio Code.

También es posible abrir `index.html` directamente en un navegador, aunque Live Server facilita el desarrollo y las pruebas.

## Estado actual

El proyecto cuenta con:

* Estructura de cinco páginas.
* Navegación funcional.
* Diseño responsive.
* Menú móvil.
* Estilos centralizados.
* JavaScript para interacción básica.
* Imágenes provisionales locales.
* Estructura preparada para incorporar fotografías reales.
* Marcadores provisionales para información que todavía debe verificarse.

## Próximas etapas

1. Recopilar fotografías reales.
2. Recopilar y verificar información de la comunidad.
3. Integrar fotografías definitivas.
4. Reemplazar los textos provisionales.
5. Mejorar la galería.
6. Optimizar imágenes para la web.
7. Revisar accesibilidad y SEO.
8. Realizar pruebas finales.
9. Preparar la publicación del sitio.
