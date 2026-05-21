# Resumen Clase 2: Nombres, Alcance y Ligaduras

## Introducción
La abstracción en los lenguajes de programación comienza con el uso de nombres (identificadores) para entidades. El diseño de nombres afecta la legibilidad y funcionalidad del lenguaje.

## Características de los nombres
- Longitud máxima
- Sensibilidad a mayúsculas/minúsculas
- Uso de conectores
- Palabras clave, reservadas y predefinidas

## Atributos de los nombres
- Nombre
- Dirección (memoria)
- Valor
- Tipo
- Tiempo de vida
- Alcance

## Ligaduras
Una ligadura es la asociación entre un nombre y una entidad o atributo. El tiempo de ligadura puede ser:
- Estático (en compilación, diseño, implementación, etc.)
- Dinámico (en ejecución)

## Alcance y ambiente de referenciamiento
- **Alcance:** Región del programa donde una entidad es visible.
- **Ambiente de referenciamiento:** Conjunto de entidades visibles en una sentencia.
- Alcance puede ser estático (léxico) o dinámico.

## Consideraciones
- El aliasing y la sobrecarga pueden afectar la interpretación de los nombres.
- La correcta gestión del alcance y las ligaduras es fundamental para evitar errores y ambigüedades en los programas.