# Conversión vs. Coerción

> Tema relacionado: Sistema de Tipos (Clase 05)
> Fuentes: `teoria/06-SistemaDeTipos.pdf`, Sebesta cap. 6, Scott cap. 7

---

## Lo que dice el apunte

> *"Un sistema de tipos flexible brinda reglas de conversión o coerción que permiten aceptar datos de un tipo Q en un contexto en el cual se espera un dato de tipo T."*
> — 06-SistemaDeTipos (p. 2)

El apunte los menciona juntos como concepto general. La distinción más precisa aparece en los libros de referencia.

---

## La distinción

| | Coerción | Conversión explícita (casting) |
|---|---|---|
| **Quién la hace** | El compilador/intérprete, automáticamente | El programador, en el código |
| **Visibilidad** | Implícita, invisible en el código fuente | Explícita, escrita por el programador |
| **Relación con dureza** | Más coerciones implícitas → lenguaje **menos duro** | Exigir cast explícito → lenguaje **más duro** |

```c
// Coerción implícita (el compilador decide)
double d = 5;       // int → double, automático y sin pérdida

// Conversión explícita / cast (el programador decide)
int i = (int) 3.9;  // el programador es responsable de la pérdida de información
```

---

## Conversiones según si hay pérdida de información

El apunte clasifica las conversiones en dos tipos:

**Expansora (sin pérdida):** el tipo destino puede representar todos los valores del tipo origen.
- Ejemplo: `int → double`, `int → long`
- Se considera **segura**. Los lenguajes suelen permitirla de forma implícita.

**Limitante (con pérdida):** el tipo destino no puede representar todos los valores del tipo origen.
- Ejemplo: `double → int` (se pierde la parte decimal), `long → short` (posible desbordamiento)
- Se considera **insegura**. Los lenguajes más duros la prohíben de forma implícita y exigen cast explícito.

> *"Las conversiones limitantes se consideran inseguras, porque se pierde información que no puede recuperarse. Los lenguajes tienden a no utilizarlas de manera implícita."*
> — 06-SistemaDeTipos (p. 2)

---

## Relación con la dureza de tipado

La coerción implícita es el mecanismo más directamente ligado a la dureza:

```c
// C — menos duro: coerciona implícitamente (limitante, con pérdida)
int x = 3.14;    // compila, x vale 3. No hay aviso por defecto.
```

```java
// Java — más duro: prohíbe la coerción limitante implícita
int x = 3.14;    // error de compilación: possible lossy conversion from double to int
int x = (int) 3.14;  // correcto: conversión explícita, el programador asume la pérdida
```

```python
# Python — más duro en este caso: no coerciona entre int y float en asignación
x: int = 3.14    # no hay error en ejecución (las anotaciones no se fuerzan),
                 # pero mypy/pyright lo marca como error de tipos
```

---

## Resumen

- **Coerción**: conversión **implícita**, la hace el sistema sin que el programador lo pida. Característica de lenguajes menos duros.
- **Conversión explícita (cast)**: el programador la escribe. El sistema la ejecuta pero la responsabilidad es del programador.
- **Expansora**: sin pérdida de información → segura, generalmente implícita.
- **Limitante**: con pérdida de información → insegura, los lenguajes más duros la exigen explícita.
