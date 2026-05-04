# Trabajo Práctico N° 8 — Lenguajes Orientados a Objetos
**Universidad Nacional del Sur — Lenguajes de Programación**

---

## Pregunta 1
> Describa cómo los lenguajes orientados a objetos brindan polimorfismo y son a la vez fuertemente tipados. ¿Es necesario realizar todos los chequeos de tipo en tiempo de compilación?

Los lenguajes orientados a objetos logran combinar polimorfismo y tipado fuerte mediante el mecanismo de herencia y la relación de subtipado: si B es subclase de A, entonces cualquier objeto de tipo B puede ser tratado como un objeto de tipo A. Esto permite que una variable declarada de tipo A pueda referenciar en tiempo de ejecución a objetos de tipo A o de cualquier subclase suya, sin violar las reglas del sistema de tipos.

El polimorfismo relevante en OO es el llamado **polimorfismo por inclusión** (universal), que se basa precisamente en esta relación de subtipado. Se diferencia de otras formas de polimorfismo como:

- **Polimorfismo paramétrico** (generics/templates)
- **Polimorfismo ad-hoc aparente**: sobrecarga y coerción — no son verdadero polimorfismo, son una ilusión para el programador; internamente las entidades no son polimórficas.

El polimorfismo por inclusión se manifiesta a través del **despacho dinámico de métodos** (ligadura dinámica): cuando se envía un mensaje a un objeto, el método que se ejecuta es el definido (o redefinido) en la clase real del objeto receptor, no en el tipo estático de la variable. Así, dos objetos de distintas clases responden al mismo mensaje de manera diferente, preservando la seguridad de tipos.

Sin embargo, en un lenguaje OO con sistema fuertemente tipado, el polimorfismo de las variables se ve **limitado**. Para evitar violaciones de tipos se debe poder sustituir un objeto de una clase derivada por uno de la clase base en cualquier contexto. Si se garantiza esta sustitución, el tipo derivado puede verse como un subtipo del tipo base. Para garantizarla se deben imponer restricciones en el uso de la herencia. Existen dos mecanismos:

1. **Extensión del tipo** (ej. Ada 95): la clase derivada *solo* puede extender la funcionalidad de la base, sin modificar ni esconder sus operaciones.

2. **Sobre-escritura de operaciones**: permite redefinir operaciones heredadas, pero con restricciones para garantizar la sustitución:
   - Los parámetros de **entrada** deben ser super-tipos de los originales (contravarianza).
   - Los parámetros de **salida** deben ser sub-tipos de los originales (covarianza).

### ¿Es necesario hacer todos los chequeos en compilación?

No es estrictamente necesario. Según el material de la materia, un lenguaje es **fuertemente tipado** (*strongly typed*) si detecta **todos** los errores de tipos, sin importar en qué momento lo haga. No hay grises: o lo detecta todo o no cumple la propiedad. Existen dos enfoques:

| Enfoque | Ejemplos | Características |
|---|---|---|
| **Tipado estático** | Java, C++ | Chequeos en compilación. La propiedad de fuertemente tipado está asociada a un alto grado de dureza en las características vinculadas al polimorfismo. Algunos chequeos (downcasts) se difieren al runtime. |
| **Tipado dinámico** | Smalltalk | Chequeos íntegramente en ejecución. Smalltalk es fuertemente tipado con chequeos en tiempo de ejecución. El polimorfismo es más amplio ya que no hay restricciones estáticas sobre qué objetos pueden recibir qué mensajes. |

**Conclusión:** el polimorfismo en OO no exige que todos los chequeos sean estáticos. La propiedad de fuertemente tipado solo exige que todos los errores de tipo sean detectados en algún momento (compilación o ejecución). La elección entre chequeo estático y dinámico implica un balance entre seguridad temprana y flexibilidad/expresividad.

---

## Pregunta 2
> Explique por qué en los lenguajes orientados a objetos es necesario que la ligadura entre un mensaje (llamada) y el método correspondiente se resuelva dinámicamente.

### ¿Qué es la ligadura dinámica de código?

La **ligadura dinámica de código** es uno de los tres pilares que debe soportar un lenguaje orientado a objetos (junto con los tipos de datos abstractos y la herencia). Consiste en que un mensaje puede ser resuelto de distintas maneras dependiendo del **tipo dinámico** del objeto receptor, es decir, la clase real del objeto en tiempo de ejecución.

### ¿Por qué es necesaria?

La razón fundamental es que, en presencia de **herencia y polimorfismo por inclusión**, el tipo estático de una variable y el tipo dinámico del objeto que referencia pueden diferir. Por ejemplo:

```java
Persona p = new PersonaConPerro("José", 30, toto);
p.salirACaminar();  // ¿qué método se ejecuta?
```

Aquí `p` tiene tipo estático `Persona`, pero referencia a un objeto de clase `PersonaConPerro` que redefine `salirACaminar`. Si la ligadura fuera estática, siempre se ejecutaría el método de `Persona`, ignorando la redefinición — lo cual es incorrecto y destruye el polimorfismo.

Para que el mensaje `salirACaminar` se resuelva al método correcto (el de `PersonaConPerro`), es necesario **esperar a tiempo de ejecución**, cuando ya se conoce el tipo real del objeto receptor.

### Relación con la implementación

A la hora de enviar un mensaje, el runtime debe:
1. Crear el registro de activación para el método a invocar.
2. **Identificar el método** extrayendo el patrón del objeto receptor (o buscando en la superclase si no lo encuentra).
3. Transmitir los parámetros al registro de activación del receptor.
4. Suspender al llamador y establecer el camino de retorno.

El paso 2 requiere conocer la clase real del objeto, lo que solo está disponible en ejecución. Esto se implementa típicamente mediante una **tabla de métodos virtuales (vtable)**: cada objeto lleva una referencia a la tabla de métodos de su clase, y el despacho se reduce a un acceso indexado dentro de esa tabla.

### Ligadura estática donde es posible

No toda ligadura en OO debe ser dinámica. La ligadura estática puede usarse cuando no hay ambigüedad posible:

- **Atributos y métodos de clase**: su localización puede determinarse en compilación.
- **Métodos privados**: no pueden ser redefinidos en subclases, por lo que no requieren despacho dinámico.

### Costo vs. beneficio

| | Ligadura estática | Ligadura dinámica |
|---|---|---|
| **Eficiencia** | Mayor (resuelto en compilación) | Menor (búsqueda en vtable en ejecución) |
| **Flexibilidad** | Menor (no soporta polimorfismo por inclusión) | Mayor (el código funciona con cualquier subclase presente o futura) |

La ligadura dinámica es el mecanismo que hace posible el polimorfismo por inclusión: permite que el código que opera sobre una superclase funcione correctamente con cualquier subclase, sin necesidad de modificarlo.

---

## Pregunta 3
> Analice la noción de efectos colaterales en el contexto de la programación orientada a objetos. ¿Es posible evitarlos? Justifique su respuesta.

### ¿Qué es un efecto colateral?

Un **efecto colateral** ocurre cuando la ejecución de una unidad modifica el ambiente de referenciamiento de la unidad llamadora, más allá de lo que se expresa a través de su valor de retorno. En términos más generales, un operador o función produce un efecto colateral si **influencia al resto de la computación de otra manera que no sea a través de su retorno**.

> *"Un efecto colateral es parte del cómputo y genera un cambio, pero este cambio no puede establecerse en la semántica de la operación; es un cambio que no es visible desde la parte pública de la operación."*
> — 01-Sintaxis, Semántica y Traductores (p. 4)

### Efectos colaterales en OO

En los lenguajes orientados a objetos, las unidades (métodos) tienen **tres vías de comunicación** con el resto del programa:

1. **Parámetros y resultado** — la vía ideal, explícita y controlable.
2. **Ambiente global** — acceso a variables compartidas entre objetos/clases; puede generar efectos colaterales clásicos.
3. **Ambiente implícito** — el estado interno del objeto receptor (`self`/`this`); puede generar **comportamiento sensible a la historia**.

> *"Un servicio puede acceder y hasta modificar el estado interno del objeto que recibe el mensaje que provoca la ejecución de ese servicio."*
> — 07-Unidades (p. 2)

El tercer caso es particularmente interesante en OO: los **métodos que modifican el estado del objeto receptor** (setters, mutadores) son por definición generadores de efectos colaterales, ya que alteran el ambiente implícito. Esto es diferente a los paradigmas funcionales y es inherente al modelo de objetos con estado mutable.

Las **abstracciones procedurales** (procedimientos/métodos void) están pensadas precisamente para provocar cambios en el estado de la computación — es decir, su propósito *es* el efecto colateral. En cambio, las **abstracciones funcionales** (funciones puras) idealmente no deberían producirlos.

### ¿Es posible evitarlos?

**No completamente**, en el contexto de la programación orientada a objetos convencional. Las razones son:

1. **El estado mutable es central al modelo OO**: los objetos encapsulan estado que se modifica a lo largo del tiempo mediante mensajes. Eliminar los efectos colaterales implicaría eliminar la mutabilidad, lo que contradice el paradigma.

2. **El aliasing amplifica el problema**: en OO los objetos se pasan típicamente por referencia. Esto significa que dos variables pueden referenciar al mismo objeto, y una modificación hecha a través de una referencia afecta a la otra. El aliasing perjudica la legibilidad ya que el programador debe tener presente todos los alias de una locación.
   > *"El aliasing perjudica la legibilidad de los programas, ya que el programador que lee el programa debe tener presente todos los alias de una locación."*
   > — 02-Nombres-Alcance-Ligaduras (p. 2)

3. **El orden de evaluación importa**: la presencia de efectos colaterales hace que el resultado de una expresión pueda depender del orden en que se evalúan sus subexpresiones. Por ejemplo, `a + f(b)` puede dar resultados distintos si `f` modifica el valor de `a`.
   > — 03-Expresiones (p. 3)

### Mitigación (no eliminación)

Si bien no se pueden eliminar completamente en OO imperativo, sí se pueden **mitigar**:

- **Encapsulamiento**: al ocultar el estado interno, se reduce la superficie de efecto colateral. Los cambios de estado quedan circunscriptos a la interfaz pública del objeto.
- **Inmutabilidad selectiva**: diseñar objetos inmutables cuando sea posible (como `String` en Java), de modo que los métodos retornen nuevos objetos en lugar de modificar el existente.
- **Minimizar el uso del ambiente global**: preferir la comunicación por parámetros y resultado, que es explícita y verificable.
- **Paradigma funcional dentro de OO**: lenguajes como Scala o Kotlin permiten mezclar estilos; usar funciones puras donde sea posible reduce los efectos colaterales.

En definitiva, en OO los efectos colaterales son **inevitables por diseño** del paradigma, pero el encapsulamiento y el buen diseño permiten **contenerlos y hacerlos predecibles**.

