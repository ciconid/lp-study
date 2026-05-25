# Registros y Uniones (tipos compuestos)

> Tema relacionado: Tipos y Sistema de Tipos (Clases 04 y 05)
> Fuentes: `teoria/05-Tipos.pdf`, `teoria/06-SistemaDeTipos.pdf`, `teoria/Clase 04 - Tipos compuestos.pdf`

---

## Contexto

Ambos son **constructores de tipo compuesto**, es decir, formas de combinar tipos más simples en uno nuevo.

> *"Los tipos compuestos son una forma de unir varios tipos más simples en uno nuevo utilizando un constructor de tipo. La lista de constructores más comunes incluye: Registros o producto cartesiano, Registros variantes o uniones."*
> — 05-Tipos (p. 2)

---

## Registro (producto cartesiano)

Un registro agrupa campos de **tipos distintos** bajo un mismo nombre. Todos los campos **coexisten en memoria al mismo tiempo**.

El nombre "producto cartesiano" viene de la teoría: el dominio del tipo registro es el producto cartesiano de los dominios de cada campo. Si un campo puede tomar 10 valores y otro puede tomar 5, el registro puede tomar $10 \times 5 = 50$ combinaciones posibles.

**Ejemplo (de las diapositivas):**

```c
// C
struct elemento {
    char   nombre[2];
    int    num_atomico;
    double peso_atomico;
    bool   metalico;
}

// Pascal
type elemento = record
    nombre:       two_chars;
    num_atomico:  integer;
    peso_atomico: real;
    metalico:     Boolean
end;
```

**Layout en memoria:** los campos se ubican de forma contigua, cada uno con un *offset* fijo desde la dirección base del registro.

```
[ nombre | num_atomico | peso_atomico | metalico ]
    ^
  base
```

El acceso es por nombre de campo (`elem.nombre`, `elem.peso_atomico`), y el compilador lo traduce a `base + offset`.

---

## Unión (registro variante)

Una unión también combina varios tipos, pero **no todos coexisten simultáneamente**: la variable puede tener *uno u otro* tipo en un momento dado, y todos **comparten el mismo espacio de memoria**. El espacio asignado es el del **campo más grande**.

**Ejemplo (de las diapositivas):**

```c
union {
    int    i;
    double d;
    bool   b;
};
```

Si `double` ocupa 8 bytes e `int` ocupa 4, la unión entera ocupa 8 bytes. Cuando se usa como `int`, solo se usan los primeros 4 bytes de ese espacio.

**Diferencia clave con el registro:**

| | Registro | Unión |
|---|---|---|
| Campos simultáneos | Todos coexisten | Solo uno activo a la vez |
| Memoria | Suma de todos los campos | Tamaño del campo más grande |
| Acceso | Siempre válido | Depende de cuál está activo |

---

## Dos variantes de unión: libre vs. discriminada

**Unión libre** (como `union` en C): el sistema **no sabe** qué variante está activa. El programador es responsable de llevar esa cuenta. Esto la hace **insegura**: se puede leer el campo `d` (double) aunque se haya escrito en `i` (int), interpretando los bytes de forma errónea sin que el compilador lo detecte.

**Unión discriminada** (como los `variant record` de Ada/Pascal): incluye un campo extra llamado **discriminante** o *tag* que indica cuál variante está activa. Esto permite hacer chequeos en tiempo de ejecución.

Esto explica el siguiente comentario del apunte de sistemas de tipos:

> *"Hay características de los lenguajes que no son controlables estáticamente, aunque el lenguaje tenga tipado estático. ¿Un ejemplo? El acceso a las componentes de un registro variante."*
> — 06-SistemaDeTipos (p. 2)

Cuál variante está activa solo se sabe en tiempo de ejecución, no en compilación. Un lenguaje fuertemente tipado con uniones **discriminadas** puede al menos chequearlo en ejecución; uno con uniones **libres** directamente no puede garantizarlo.

---

## Para qué sirve una unión

La utilidad aparece cuando una misma entidad puede ser de **tipos distintos según el contexto**:

- Un token en un parser que puede ser un número, un string o una palabra clave.
- Un valor numérico que puede ser entero o punto flotante según un flag.
- Protocolos de red donde el mismo campo se interpreta diferente según el tipo de mensaje.

En lenguajes modernos, las uniones discriminadas evolucionaron hacia los **tipos suma** o *tagged unions* con soporte completo del sistema de tipos: `enum` en Rust, tipos algebraicos en Haskell y F#.
