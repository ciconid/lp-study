# Definiciones y Conceptos Clave — Lenguajes de Programación
**Universidad Nacional del Sur — Lenguajes de Programación**

---

## Ligaduras y Tiempo de Ligadura

- **Ligadura** — asociación entre dos cosas; en particular, la asociación entre un atributo de una variable y su valor (ej: nombre↔tipo, nombre↔dirección, variable↔valor).
  > — 02-Nombres-Alcance-Ligaduras (p. 2)

- **Tiempo de ligadura** — el momento en que se crea la ligadura. Puede ser:
  - *Estático*: diseño del lenguaje, implementación, escritura del programa, compilación, linkeo, carga.
  - *Dinámico*: ejecución.
  - La ligadura **temprana** da mayor eficiencia; la **tardía** da mayor flexibilidad.
  > — 02-Nombres-Alcance-Ligaduras (p. 2)

- **Ligadura estática** — se establece antes de la ejecución y no cambia en tiempo de vida del objeto.
- **Ligadura dinámica** — se establece o cambia durante la ejecución (ej: tipo de una variable en lenguajes con tipado dinámico).

---

## Variables y sus Atributos

- **Variable** — entidad con un conjunto de atributos: nombre, dirección, valor, tipo, tiempo de vida, alcance.

- **Tiempo de vida** — período entre la creación y destrucción de la ligadura entre un nombre y un objeto. Según la administración de memoria:
  - *Estática*: asociada a direcciones absolutas durante toda la ejecución.
  - *Pila (stack)*: se asigna/libera LIFO, con las llamadas a rutinas.
  - *Heap explícito*: el programador administra la asignación (ej: `malloc`/`free`).
  - *Heap implícito*: el lenguaje administra la asignación automáticamente (garbage collection).
  > — 02-Nombres-Alcance-Ligaduras (p. 3)

- **Semántica por valor** — en el paradigma funcional, una variable es una abstracción de un valor, no de una celda de memoria. El valor ligado es inmutable.
  > — Slides - Paradigma Funcional - Haskell y SML (p. 7)

- **Semántica por referencia** — en el paradigma imperativo, una variable es una abstracción de una celda de memoria. El valor puede cambiar a través de asignaciones.

---

## Alcance y Ambiente de Referenciamiento

- **Alcance** — la región textual del programa en la cual una determinada entidad es visible (su ligadura está activa).
  > — 02-Nombres-Alcance-Ligaduras (p. 3)

- **Alcance estático (léxico)** — la ligadura se determina en tiempo de compilación a partir del texto del programa. La visibilidad depende de la estructura del código.
  > — 02-Nombres-Alcance-Ligaduras (p. 4)

- **Alcance dinámico** — la ligadura se resuelve en tiempo de ejecución siguiendo la secuencia de llamados (cadena dinámica), no la estructura del texto.
  > — 02-Nombres-Alcance-Ligaduras (p. 4)

- **Ambiente de referenciamiento** — colección de todos los nombres con ligaduras activas en una sentencia particular.
  - En alcance estático: nombres locales + nombres visibles de todos los ambientes contenedores.
  - En alcance dinámico: nombres locales + nombres visibles de todos los subprogramas activos.
  > — 02-Nombres-Alcance-Ligaduras (p. 4)

---

## Aliasing y Efectos Colaterales

- **Aliasing** — dos nombres diferentes ligados a la misma locación de memoria al mismo tiempo. Perjudica la legibilidad porque el lector debe conocer todos los alias de una locación. Se puede crear con punteros o parámetros por referencia.
  > — 02-Nombres-Alcance-Ligaduras (p. 2)

- **Efecto colateral (side effect)** — ocurre cuando la ejecución de una unidad modifica el ambiente de referenciamiento de la unidad llamadora, es decir, produce un cambio no visible desde la interfaz pública de la operación.
  > — 07-Unidades (p. 3)

- **Transparencia referencial** — propiedad de una función cuyo resultado depende exclusivamente de sus argumentos (no del estado externo). Mismos argumentos → mismo resultado, siempre. Facilita la verificación y comprensión de programas.
  > — Slides - Paradigma Funcional - Haskell y SML (p. 13)

---

## Sistema de Tipos

- **Sistema de tipos** — conjunto de reglas que estructuran y organizan una colección de tipos. Especifica reglas de equivalencia, conversión, inferencia y nivel de polimorfismo.
  > — 06-SistemaDeTipos (p. 1)

- **Tipado estático** — la ligadura del atributo tipo de las variables se establece antes de la ejecución. Permite detectar errores en compilación, mejora la eficiencia.

- **Tipado dinámico** — la ligadura del tipo ocurre en tiempo de ejecución (ej: a través de asignaciones). Mayor flexibilidad, menor eficiencia, detección de errores solo en ejecución.
  > — 06-SistemaDeTipos (p. 1)

- **Fuertemente tipado (strongly typed)** — un lenguaje es fuertemente tipado si detecta **todos** los errores de tipos. No importa en qué momento los detecte, lo importante es que los detecte. Es una propiedad binaria: el lenguaje la tiene o no la tiene.
  > — 06-SistemaDeTipos (p. 2)

- **Dureza del tipado (strong typing)** — grado de restricción que impone el sistema de tipos respecto a una característica particular (ej: expresiones mixtas). No es binaria; es un espectro. Un sistema más duro exige conversiones explícitas; uno menos duro las hace de forma implícita.
  > — 06-SistemaDeTipos (p. 2)

- **Expresiones mixtas** — expresiones que combinan operandos de diferentes tipos. Un lenguaje más duro exige que el programador explicite las conversiones; uno más débil las hace automáticamente.

---

## Conversiones y Equivalencia de Tipos

- **Coerción** — conversión implícita de un tipo a otro realizada automáticamente por el lenguaje.
  > — 06-SistemaDeTipos (p. 2)

- **Conversión expansora** — conversión sin pérdida de información (ej: `int` → `float`). Considerada segura.

- **Conversión limitante** — conversión con pérdida de información (ej: `float` → `int`). Considerada insegura.
  > — 06-SistemaDeTipos (p. 2)

- **Equivalencia por nombre** — dos tipos son equivalentes si fueron declarados con exactamente el mismo nombre de tipo.

- **Equivalencia por declaración** — dos tipos son equivalentes si conducen a la misma expresión de tipo original luego de re-declaraciones.

- **Equivalencia por estructura** — dos tipos son equivalentes si están definidos por expresiones de tipo idénticas, sin importar el nombre.
  > — 06-SistemaDeTipos (p. 3)

---

## Inferencia de Tipos y Polimorfismo

- **Inferencia de tipos** — mecanismo por el cual el lenguaje deduce el tipo de una entidad a partir del contexto (tipo de los operandos, operadores, resultado). Usado en Haskell y SML.
  > — 06-SistemaDeTipos (p. 3)

- **Polimorfismo** — una misma entidad puede tomar diferentes tipos. Hay dos grandes categorías:
  - **Polimorfismo universal**: la entidad realmente puede ligarse a múltiples tipos.
    - *Paramétrico*: mediante variables de tipo (ej: listas genéricas en Haskell/SML).
    - *Por inclusión*: mediante herencia/subtipado (ej: clases derivadas en OO).
  - **Polimorfismo ad-hoc**: ilusión de polimorfismo; en realidad son múltiples entidades monomórficas.
    - *Sobrecarga*: mismo nombre, distintas implementaciones según tipo.
    - *Coerción*: conversión implícita para que los tipos "encajen".
  > — 06-SistemaDeTipos (p. 3-4)

- **Sobrecarga** — mismo nombre para funciones/operadores que tienen implementaciones distintas dependiendo del tipo. No es verdadero polimorfismo porque internamente son funciones monomórficas.

---

## Pasaje de Parámetros

- **Parámetro formal** — nombre local a la unidad, declarado en su encabezado.
- **Parámetro actual** — variable, constante o expresión que se pasa en la invocación.
  > — 07-Unidades (p. 10)

- **Por valor (in)** — se copia el valor del parámetro actual al formal en la invocación. Los cambios al formal no afectan al actual.

- **Por resultado (out)** — el parámetro actual recibe el valor del formal al terminar la ejecución. No inicializa el formal.

- **Por valor-resultado (in-out)** — combinación: el formal se inicializa con el valor del actual, y al terminar se copia el valor del formal al actual.

- **Por referencia** — se pasa la dirección del parámetro actual. El formal es un alias del actual; los cambios afectan directamente al original.

- **Por nombre** — la expresión del parámetro actual se reevalúa cada vez que se usa el formal dentro de la unidad (usando una rutina thunk). Vinculado a la evaluación de orden normal.

- **Por necesidad** — igual al por nombre, pero el resultado se cachea tras la primera evaluación. Vinculado a la evaluación perezosa.
  > — 07-Unidades (p. 11, 18)

---

## Evaluación

- **Evaluación ansiosa (strict/eager)** — los argumentos se evalúan antes de ser pasados a la función. Usada en la mayoría de los lenguajes imperativos y en SML.

- **Evaluación perezosa (lazy)** — los argumentos se evalúan solo cuando su resultado es necesario. Los resultados se memoizan para reutilización. Usada en Haskell.
  > — Slides - Paradigma Funcional - Haskell y SML (p. 14)

---

## Paradigmas y Propiedades Generales

- **Paradigma de programación** — conjunto coherente de métodos para resolver un problema; guía el proceso de desarrollo y determina la estructura de un programa válido.
  > — Clase 01 - Introducción (p. 15)

- **Duck typing** — control de tipos basado en la presencia de atributos/métodos, no en el tipo declarado del objeto. Usado en Python.
  > — Slides - Sistema de tipos - Python y TypeScript (p. 22)

- **Formas funcionales (funciones de alto orden)** — funciones que toman otras funciones como argumento o retornan funciones como resultado.
  > — Slides - Paradigma Funcional - Haskell y SML (p. 12)

- **Currificación (currying)** — técnica que transforma una función de varios argumentos en una cadena de funciones anidadas, cada una tomando un único argumento. Permite aplicación parcial.
  > — Slides - Paradigma Funcional - Haskell y SML (p. 15)

- **Aplicación parcial** — crear una nueva función a partir de otra "fijando" uno o más de sus argumentos.

- **Ciudadano de primera clase** — una entidad es ciudadano de primera clase si puede ser pasada como parámetro, retornada como resultado, y asignada a variables.
