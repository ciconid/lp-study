# Criterios de Evaluación de Lenguajes de Programación
**Universidad Nacional del Sur — Lenguajes de Programación**

> Fuente principal: *Clase 01 - Introducción.pdf*

---

Los lenguajes de programación son software con propósito especial, por lo que se evalúan con criterios distintos al software convencional. Los criterios principales son: **legibilidad**, **facilidad de escritura**, **confiabilidad** y **costo**.

---

## 1. Legibilidad (Readability)
Es la facilidad para leer e interpretar programas. Es uno de los criterios más importantes, ya que el código se lee con mucho más frecuencia de lo que se escribe.

> *"La facilidad para leer e interpretar programas es fundamental."*
> — Clase 01 - Introducción (p. 10)

### Características que contribuyen a la legibilidad:

- **Simplicidad**
  - Se logra combinando un número pequeño de constructores primitivos con un uso limitado (ni mucho ni poco) del concepto de ortogonalidad.
  - Un lenguaje con demasiados constructores o formas alternativas para hacer lo mismo dificulta la lectura.

- **Ortogonalidad**
  - Significa que un conjunto pequeño de constructores primitivos puede combinarse en un número relativamente pequeño de maneras para construir estructuras de control y datos.
  - Cada combinación es legal y tiene sentido; no hay excepciones ni casos especiales.
  - Demasiada ortogonalidad puede dificultar la detección de errores.

- **Estructuras de control y de datos**
  - Contar con estructuras legibles es fundamental. El uso abusivo de `goto` o la ausencia del tipo `boolean` dificultan la lectura.
  - Estructuras bien diseñadas permiten expresar la intención del programador claramente.

- **Consideraciones sobre la sintaxis**
  - Forma de los identificadores, palabras reservadas, coherencia entre forma y significado (por ejemplo, el modificador `static` en Java tiene significados distintos según el contexto).

---

## 2. Facilidad de Escritura (Writability)
Es la facilidad para crear programas dentro de un dominio de aplicación particular. Depende del dominio para el que fue diseñado el lenguaje.

> *"La facilidad para crear programas de un dominio. Este criterio depende del dominio de aplicación del lenguaje."*
> — Clase 01 - Introducción (p. 11)

### Características que contribuyen a la facilidad de escritura:

- **Simplicidad y Ortogonalidad**
  - Demasiada ortogonalidad puede generar menor detección de errores.
  - Si el lenguaje no es simple, el programador solo aprende y usa una pequeña porción de él.

- **Soporte para la abstracción**
  - Capacidad de definir y usar estructuras u operaciones complicadas de manera que sea posible ignorar muchos de los detalles.
  - Ejemplo: subprogramas, tipos de datos abstractos, clases.

- **Expresividad**
  - El lenguaje posee formas convenientes de expresar ciertas operaciones.
  - Ejemplo: `contador++` en lugar de `contador = contador + 1`, o el uso de `for` en lugar del `while` equivalente.

---

## 3. Confiabilidad (Reliability)
Un lenguaje es confiable si sus programas se comportan según lo especificado bajo cualquier condición.

> *"Chequeo de tipos: cuanto antes se encuentren errores menos costoso resulta realizar los arreglos que se requieran."*
> — Clase 01 - Introducción (p. 12)

### Características que contribuyen a la confiabilidad:

- **Chequeo de tipos**
  - Cuanto antes se detecten errores de tipo (idealmente en compilación), menor es el costo de corregirlos.
  - Los lenguajes con tipado estático permiten detectar muchos errores antes de la ejecución.

- **Manejo de excepciones**
  - La habilidad para interceptar errores en tiempo de ejecución, tomar medidas correctivas y continuar.
  - Sin manejo de excepciones, un error en ejecución puede colapsar el programa sin control.

- **Aliasing**
  - El aliasing (dos nombres que referencian la misma locación de memoria) puede perjudicar la confiabilidad y la legibilidad.
  > *"El aliasing perjudica la legibilidad de los programas, ya que el programador que lee el programa debe tener presente todos los alias de una locación."*
  > — 02-Nombres-Alcance-Ligaduras (p. 2)

---

## 4. Costo
Es el costo total de un lenguaje a lo largo de su ciclo de vida. Incluye múltiples dimensiones:

> *"Confiabilidad (escasa confiabilidad conlleva altos costos)."*
> — Clase 01 - Introducción (p. 13)

### Componentes del costo:

- **Aprender el lenguaje** — costo de capacitar programadores para escribir programas cercanos a aplicaciones particulares.
- **Usar el lenguaje** — costo de entrenar programadores para el uso cotidiano del lenguaje.
- **Compilar** — costo de traducción del código fuente a código ejecutable.
- **Ejecutar** — costo en tiempo y recursos de ejecución de los programas.
- **Sistema de implementación del lenguaje** — disponibilidad de compiladores/intérpretes gratuitos o de bajo costo.
- **Confiabilidad** — la escasa confiabilidad conlleva altos costos por errores en producción.
- **Programas de mantenimiento** — costo de mantener y actualizar el software a lo largo del tiempo. Es uno de los costos más altos en la industria.

---

## Relación entre criterios

Los criterios no son independientes; muchas veces se contraponen:

- Una mayor **ortogonalidad** mejora la escritura pero puede reducir la detección de errores (menos confiabilidad).
- Un lenguaje más **simple** es más legible y fácil de aprender, pero puede ser menos expresivo.
- El **tipado estático** aumenta la confiabilidad pero puede reducir la flexibilidad de escritura.
- La búsqueda de mayor **eficiencia en ejecución** (compiladores) puede reducir la flexibilidad del lenguaje.

> *"Hay una contraposición inevitable entre eficiencia y flexibilidad, el optar por garantizar en profundidad una genera un compromiso de pérdida inevitable en la otra."*
> — 06-SistemaDeTipos (p. 1)
