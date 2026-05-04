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
