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

---

## Pregunta 4
> Analice bajo qué circunstancias la herencia múltiple puede presentar problemas. ¿Qué mecanismos pueden implementarse para evitarlos?

### ¿Qué es la herencia múltiple?

La herencia múltiple ocurre cuando una clase derivada tiene más de un padre directo. En este caso, la jerarquía de clases deja de ser un árbol y se convierte en un **grafo de derivación** (*derivation graph*). C++ es el ejemplo canónico de lenguaje que la soporta directamente:

> *"The most important features added to C++ Release 2.0 were support for multiple inheritance (classes with more than one parent class) and abstract classes."*
> — Sebesta, *Concepts of Programming Languages* (p. 169)

### Circunstancias problemáticas

La herencia múltiple introduce dos categorías de problemas:

#### 1. Colisión de nombres (*name collision*)

Cuando dos clases padre definen un atributo o método con el mismo nombre, la clase derivada hereda ambas versiones y el lenguaje debe resolver cuál usar. Si no hay un mecanismo de resolución, se produce una ambigüedad que el compilador no puede deshacer automáticamente.

**Ejemplo:** si `A` define `draw()` y `B` también define `draw()`, y `C` hereda de ambas, ¿qué `draw()` invoca `C::draw()`?

En C++, la solución es usar calificación explícita (`A::draw()` o `B::draw()`), lo que obliga al programador a recordar el origen de cada método heredado y añade fragilidad al código.

#### 2. El problema del diamante (*diamond inheritance / diamond problem*)

Es el problema más severo. Se produce cuando dos clases padre de `D` comparten un ancestro común `A`:

```
    A
   / \
  B   C
   \ /
    D
```

En este caso, `D` heredaría dos copias de `A`: una por la rama `B` y otra por la rama `C`. Esto genera preguntas difíciles:

- ¿Cuántas instancias de los atributos de `A` tiene `D`? ¿Una o dos?
- Si `B` y `C` redefinieron métodos de `A`, ¿cuál redefine `D`?
- ¿Las modificaciones al estado de `A` a través de `B` son visibles al acceder por `C`?

> El índice de Sebesta lo menciona explícitamente: *"Diamond inheritance, 491"* y la Figura 12.3 se titula *"An example of diamond inheritance"*.

La dificultad no es solo técnica: **crea dependencias ocultas entre clases** que complican el razonamiento sobre el programa.

> *"[multiple inheritance] creates dependencies [that are a disadvantage]"*
> — Sebesta, *Concepts of Programming Languages* (p. 793)

### Mecanismos para evitar o mitigar los problemas

#### a) Clases base virtuales (C++)

C++ permite declarar `A` como base virtual de `B` y `C`, de modo que `D` reciba **una única copia** de `A`:

```cpp
class B : virtual public A { ... };
class C : virtual public A { ... };
class D : public B, public C { ... };  // solo una copia de A
```

Resuelve el problema del diamante, pero impone costos en implementación (vtable más compleja) y requiere que el diseñador prevea el problema con antelación.

#### b) Calificación explícita (C++)

Para las colisiones de nombres, C++ exige que el programador califique la llamada: `obj.B::metodo()` o `obj.C::metodo()`. Es correcto pero verbose y propenso a errores de mantenimiento.

#### c) Prohibición de herencia múltiple de clases (Java, C#, Smalltalk)

El enfoque más radical es simplemente no permitirla para clases concretas:

> *"Java supports only single inheritance of classes, although some of the benefits of multiple inheritance can be gained by using its interface construct."*
> — Sebesta, *Concepts of Programming Languages* (p. 175)

> *"C# takes Java's approach: it excludes multiple inheritance as Java does."*
> — Sebesta, *Concepts of Programming Languages* (p. 187)

Smalltalk también usa herencia simple:

> *"Smalltalk soporta herencia simple. Una subclase en Smalltalk hereda todas las variables de instancia, métodos de instancia y métodos de clase de su clase padre."*
> — Slides de la cátedra, *Lenguajes Orientados a Objetos* (p. 25)

#### d) Interfaces / tipos abstractos puros

Java y C# permiten que una clase implemente múltiples **interfaces** (o tipos abstractos en general). Una interfaz solo declara firmas de métodos sin estado ni implementación, por lo tanto:

- No hay colisión de estado (no hay atributos en las interfaces).
- Las colisiones de nombres en la interfaz no tienen ambigüedad de implementación (la clase concreta provee la única implementación).

Esto permite capturar las ventajas de herencia múltiple (modelar varios roles) sin sus problemas más serios. A partir de Java 8, con los *default methods*, el problema puede resurgir parcialmente, pero Java define reglas de prioridad explícitas para resolverlo.

#### e) Mixins y Traits

Algunos lenguajes (Ruby, Scala, Rust) ofrecen **mixins** o **traits**: unidades de comportamiento reutilizables que se "mezclan" en una clase. Se parecen a las interfaces pero pueden incluir implementaciones. A diferencia de la herencia múltiple de clases, los traits definen reglas de composición explícitas que resuelven colisiones en tiempo de diseño, sin crear dependencias de estado entre las partes mezcladas.

### Síntesis

| Mecanismo | Lenguaje | Resuelve colisión | Resuelve diamante |
|---|---|---|---|
| Clases base virtuales | C++ | ❌ (solo con calificación) | ✅ |
| Calificación explícita | C++ | ✅ (manualmente) | ❌ |
| Solo herencia simple | Java, C#, Smalltalk | ✅ (evita el problema) | ✅ (evita el problema) |
| Interfaces (sin estado) | Java, C# | ✅ | ✅ |
| Mixins / Traits | Ruby, Scala, Rust | ✅ (con reglas explícitas) | ✅ |

La conclusión de la comunidad de diseño de lenguajes es que la herencia múltiple de clases con estado introduce una complejidad que raramente justifica sus beneficios. La tendencia moderna es separar la **jerarquía de tipos** (interfaces/traits) de la **jerarquía de implementación** (herencia simple de clases), obteniendo así la flexibilidad del polimorfismo múltiple sin la fragilidad del diamante.

---

## Pregunta 5
> En algunos problemas, una clasificación ortogonal de clases resulta más natural (...). ¿Qué forma de herencia basada en clases se ajusta mejor? ¿Y cómo incorporar casos como el ornitorrinco?

En una clasificación **ortogonal** como la tabla (eje `tipo` y eje `dieta`), la forma más natural es la **herencia múltiple**: una clase concreta combina una clase de cada eje. Por ejemplo, `Leon` hereda de `Mamifero` y de `Carnivoro`; `Aguila` de `Ave` y `Carnivoro`.

Esto modela bien la doble pertenencia sin duplicar código en cada combinación.

Para el caso del **ornitorrinco** (mamífero con rasgos reptilianos), lo más apropiado es mantenerlo dentro de la jerarquía principal de mamíferos y agregar solo la parte necesaria de reptiles, es decir, usar una variante de **herencia selectiva** (o múltiple restringida):

- base principal: `Mamifero`
- rasgos incorporados: solo los comportamientos/atributos reptilianos relevantes (por ejemplo, `oviparo`), no toda la interfaz de `Reptil`.

Síntesis:

- para la grilla ortogonal: **herencia múltiple**;
- para categorías híbridas excepcionales como el ornitorrinco: **herencia selectiva/restringida** sobre una clase base principal.

---

## Pregunta 6
> Analice la jerarquía dada e indique si `escalar`, `rotar` y `área` son operaciones polimórficas.

Tomando la jerarquía indicada:

- `escalar` está definida en `FiguraGeométrica` y redefinida en `Rectángulo` y `Triángulo`.
- `área` está definida en `FiguraGeométrica` y redefinida en `Circunferencia`, `Elipse`, `Rectángulo` y `Cuadrado`.
- `rotar` aparece en el protocolo común, pero no se indica redefinición en subclases.

Conclusión:

1. **`escalar` es polimórfica**: el mismo mensaje puede enviarse a objetos de distintas subclases y, por ligadura dinámica, puede ejecutarse una implementación diferente según la clase concreta del receptor.

2. **`área` es polimórfica**: claramente hay varias redefiniciones y el método ejecutado depende del tipo dinámico del objeto (`Circunferencia`, `Rectángulo`, etc.).

3. **`rotar` no es polimórfica en sentido estricto de comportamiento** (con la información dada): aunque todas las clases entienden el mensaje por herencia, no hay redefiniciones, por lo que se ejecuta siempre la misma implementación heredada de `FiguraGeométrica`.

En síntesis: **polimórficas: `escalar` y `área`; no polimórfica efectiva: `rotar`**.

---

## Pregunta 6-alternativa
> Analice la jerarquía dada e indique si `escalar`, `rotar` y `área` son operaciones polimórficas.

Una forma útil de distinguirlo es separar:

- **polimorfismo del mensaje** (muchas clases entienden el mismo selector), y
- **polimorfismo de implementación** (hay redefiniciones y cambia el método ejecutado según clase dinámica).

Con esa distinción:

1. **`escalar`**: **sí es polimórfica de implementación**. Está definida en `FiguraGeométrica` y redefinida en `Rectángulo` y `Triángulo`, así que la ligadura dinámica puede elegir distintas implementaciones para el mismo mensaje.

2. **`área`**: **sí es polimórfica de implementación**. Tiene varias redefiniciones (`Circunferencia`, `Elipse`, `Rectángulo`, `Cuadrado`), por lo que el comportamiento depende del tipo dinámico del receptor.

3. **`rotar`**: 
   - **sí es polimórfica por inclusión/interfaz** (todas las figuras responden al mensaje),
   - pero **no presenta polimorfismo de implementación en la jerarquía dada**, porque no se informa redefinición en subclases.

Conclusión alternativa: si el criterio es “mismo mensaje para toda la familia”, las tres son polimórficas; si el criterio es “múltiples implementaciones seleccionadas dinámicamente”, lo son `escalar` y `área`, mientras `rotar` no.

**Fuentes:** 06-SistemaDeTipos (p. 3, p. 4), 08-Encapsulamiento-Abstracción (p. 2), Concepts of Programming Languages - Sebesta - E12 (p. 170).

---

## Pregunta 7
> Retomando lo realizado en el ejercicio 1, analice si Smalltalk es un lenguaje fuertemente tipado.

Sí: **Smalltalk se considera fuertemente tipado** en el sentido de la materia.

La condición formal usada en la cátedra es que un lenguaje fuertemente tipado debe detectar todos los errores de tipos (propiedad de *type safety*). Esto está explicitado en el material de sistema de tipos.

Además, en Smalltalk los chequeos no se hacen de manera estática en compilación, sino **en tiempo de ejecución**, verificando si el objeto receptor puede responder al mensaje enviado. Si no puede, se produce error de tipos.

Por lo tanto, Smalltalk combina:

- **tipado dinámico** (chequeo en runtime), y
- **fuertemente tipado** (detección de errores de tipo).

No hay contradicción entre ambas ideas: “dinámico” indica **cuándo** se chequea, y “fuertemente tipado” indica **qué tan completo** es el control de errores de tipo.

**Fuentes:** Slides - POO y Smalltalk (p. 13, p. 24), 06-SistemaDeTipos (p. 2).

---

## Pregunta 8
> Evalúe las siguientes expresiones Smalltalk. Para cada una, indique el resultado y cuál es el receptor del mensaje principal.

> *"El orden en que se evalúan los mensajes depende de un esquema de precedencia: mensajes unarios (mayor precedencia) > binarios > con palabra clave (menor). Dentro del mismo nivel, se evalúa de izquierda a derecha."*
> — Slides - POO y Smalltalk (p. 17–18)

| Inciso | Expresión | Resultado | Notas |
|--------|-----------|-----------|-------|
| a | `3 >= 8 and: [ 2 <= 4 ]` | `false` | Binario `>=` primero → `false`; `and:` recibe `false` → bloque no evaluado (cortocircuito) |
| b | `'comenzamos con Smalltalk' size` | `24` | Unario `size` al String |
| c | `#(1 3 5 7) at: 2` | `3` | Keyword `at:` al Array; índices base 1 |
| d | `'Buenos' , ' días'` | `'Buenos días'` | Binario `,` al String `'Buenos'` |
| e | `'Buenos días' at: 8` | `$d` | `'Buenos días'` → B(1)u(2)e(3)n(4)o(5)s(6) (7)d(8)… |
| f | `[3+1.5*3] value` | `13.5` | Dentro del bloque sin paréntesis: `3+1.5=4.5`, luego `4.5*3=13.5` (izq. a der., todos binarios) |
| g | `[ :i :j | 3*i - (i-j)] value: 4 value: 2` | `10` | `i=4, j=2`; `3*4=12`; `(4-2)=2`; `12-2=10` |
| h | `#(1 12 24 36) includes: 4 factorial` | `true` | Unario primero: `4 factorial=24`; `includes: 24` → `true` |
| i | `'smalltalk' at: (#(5 3 1) at: 2)` | `$a` | Paréntesis: `#(5 3 1) at: 2 = 3`; luego `'smalltalk' at: 3` → s(1)m(2)a(3) → `$a` |
| j | `'smalltalk' at: #(5 3 1) at: 2` | **Error** | Se interpreta como el mensaje `at:at:` enviado al String, que no existe |
| k | `'Lenguaje Orientados a Objetos' copyFrom: 10 to: 19; size` | `30` | Cascade `;` reenvía `size` al **receptor original** (el String), no al resultado de `copyFrom:to:` |
| l | `('Lenguaje Orientados a Objetos' copyFrom: 10 to: 19) size` | `10` | Paréntesis fuerzan el orden: `copyFrom:10 to:19` → `'Orientados'`; luego `size` → `10` |
| m | `4 factorial between: 3 + 4 and: 'hello' size * 7` | `true` | Unarios: `4 factorial=24`, `'hello' size=5`; binarios: `3+4=7`, `5*7=35`; keyword: `24 between: 7 and: 35` → `true` |
| n | `3 < 4 ifTrue: ['the true block'] ifFalse: ['the false block']` | `'the true block'` | Binario: `3<4=true`; keyword `ifTrue:ifFalse:` → evalúa el primer bloque |

**Nota sobre k vs l:** la diferencia clave entre ambas es el uso de cascade (`;`) vs paréntesis. El cascade no cambia el receptor, mientras que los paréntesis alteran el flujo de evaluación.

---

## Pregunta 13
> Investigue sobre los distintos iteradores soportados por Smalltalk. ¿En qué clases están definidos? ¿Cómo se utilizan? Compárelos con los mecanismos de iteración provistos por Python y Java.

### Iteradores en Smalltalk

En Smalltalk toda computación se realiza mediante mensajes entre objetos, por lo que los iteradores no son construcciones sintácticas del lenguaje sino **métodos definidos en clases de la biblioteca estándar**.

> *"Al igual que con la selección, las estructuras de iteración se modelan mediante mensajes a objetos."*
> — Slides - POO y Smalltalk (p. 21)

Los principales iteradores se distribuyen en dos clases:

#### Clase `BlockClosure`

Iteradores controlados por condición o cuenta:

| Mensaje | Descripción |
|---|---|
| `[bloque] whileTrue: [bloque]` | Repite mientras la condición sea verdadera |
| `[bloque] whileFalse: [bloque]` | Repite mientras la condición sea falsa |

#### Clase `Integer`

| Mensaje | Descripción |
|---|---|
| `n timesRepeat: [bloque]` | Ejecuta el bloque `n` veces |

#### Clase `Collection` (y subclases como `Array`, `OrderedCollection`, `String`)

Iteradores sobre colecciones:

| Mensaje | Descripción |
|---|---|
| `col do: [:e \| ...]` | Recorre cada elemento |
| `col select: [:e \| cond]` | Filtra elementos que cumplen la condición |
| `col reject: [:e \| cond]` | Filtra los que NO cumplen la condición |
| `col collect: [:e \| expr]` | Aplica una transformación y retorna nueva colección |

> *"Clase Collection: `<collection> do: <bloque>`, `<collection> select: <bloque>`, `<collection> reject: <bloque>`, `<collection> collect: <bloque>`"*
> — Slides - POO y Smalltalk (p. 22)

Ejemplo:
```smalltalk
col := OrderedCollection withAll: #(1 2 3 4).
pares := col select: [:i | i even].   "→ OrderedCollection (2 4)"
cuad  := col collect: [:i | i * i].   "→ OrderedCollection (1 4 9 16)"
```

### Iteradores en Python

Python soporta el protocolo de iteradores mediante los métodos especiales `__iter__` y `__next__`. Cualquier objeto que los implemente puede usarse en un `for`.

> Ejemplo del material de la cátedra:
> ```python
> class ParesIterador:
>     def __init__(self, limite): self.limite = limite; self.valor = 0
>     def __iter__(self): return self
>     def __next__(self):
>         if self.valor > self.limite: raise StopIteration
>         resultado = self.valor; self.valor += 2; return resultado
> for par in ParesIterador(10): print(par)  # 0 2 4 6 8 10
> ```
> — Clase 06 - Subrutinas (p. 38)

Python también provee funciones de orden superior similares a los iteradores de Smalltalk: `map()`, `filter()`, y comprensiones de listas `[expr for x in col if cond]`.

### Iteradores en Java

Java soporta iteración de dos formas:
1. **`for-each` (enhanced for)**: sintaxis azucarada para recorrer cualquier objeto que implemente `Iterable<T>`.
2. **`Iterator<T>`**: interfaz explícita con métodos `hasNext()` y `next()`.

> *"Among these are [...] a new iteration construct, lambda expressions, and numerous class libraries."*
> — Concepts of Programming Languages - Sebesta - E12 (p. 176)

A partir de Java 8, los streams (`Stream.filter()`, `Stream.map()`, `Stream.collect()`) ofrecen iteración funcional similar a Smalltalk.

### Comparación

| Aspecto | Smalltalk | Python | Java |
|---|---|---|---|
| **Mecanismo** | Mensajes a objetos | Protocolo `__iter__`/`__next__` | Interfaz `Iterable`/`Iterator` |
| **Iteración funcional** | `select:`, `collect:`, `reject:` | `filter()`, `map()`, comprensiones | Streams (Java 8+) |
| **Dónde se define** | En clases de la biblioteca (`Collection`, `BlockClosure`, `Integer`) | En cualquier clase con el protocolo | En cualquier clase que implemente `Iterable` |
| **Integración con el lenguaje** | Nativa (todo es mensaje) | Sintaxis especial (`for`) + protocolo | Sintaxis `for-each` + interfaz explícita |

La diferencia central es filosófica: en Smalltalk la iteración es simplemente **envío de mensajes a colecciones**, coherente con que "todo es un objeto y toda computación es un mensaje".

> *"Toda computación se realiza a través de mensajes entre objetos."*
> — Slides - POO y Smalltalk (p. 13)

En Python y Java, la iteración está soportada por el lenguaje con sintaxis dedicada (`for`) sobre un protocolo/interfaz que el objeto debe satisfacer.

---

## Pregunta 14
> Agregue al conjunto de métodos de la clase `BlockClosure` de Smalltalk una nueva estructura de control similar al `repeat until` de Pascal.

En Smalltalk, las estructuras de control se modelan como **mensajes a objetos**, no como construcciones sintácticas especiales del lenguaje.

> *"Al igual que con la selección, las estructuras de iteración se modelan mediante mensajes a objetos. Clase `BlockClosure`: `<bloque> whileTrue: <bloque>`, `<bloque> whileFalse: <bloque>`"*
> — Slides - POO y Smalltalk (p. 21)

Estos mensajes están definidos directamente en `BlockClosure`. Por el mismo mecanismo, se puede **extender** `BlockClosure` con un nuevo método `repeatUntil:`, sin necesidad de subclasificar:

> *"Notar que estamos agregando comportamiento a una clase predefinida, sin tener que definir una subclase."*
> — Slides - POO y Smalltalk (p. 23), en referencia al uso de `extend`.

### Implementación

```smalltalk
BlockClosure extend [
    repeatUntil: condBlock [
        self value.
        (condBlock value) ifFalse: [ self repeatUntil: condBlock ]
    ]
]
```

O bien de forma iterativa usando `whileFalse:`:

```smalltalk
BlockClosure extend [
    repeatUntil: condBlock [
        | continuar |
        continuar := false.
        [ continuar ] whileFalse: [
            self value.
            continuar := condBlock value
        ]
    ]
]
```

### Verificación con el ejemplo del enunciado

```smalltalk
| p k |
p := 0.
k := 0.
[k := k + 1. p := p + k] repeatUntil: [p > 8].
p printNl.  "→ 10"
```

La semántica es: **ejecutar el bloque receptor al menos una vez**, y repetir hasta que el bloque argumento (`condBlock`) evalúe a `true`. Es el equivalente al `repeat...until` de Pascal, donde la condición se evalúa **después** de cada iteración.

