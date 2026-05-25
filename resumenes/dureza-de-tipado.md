# Dureza de Tipado — Ejemplos por característica

> Tema relacionado: Sistema de Tipos (Clase 05)
> Fuente base: `teoria/06-SistemaDeTipos.pdf`

---

## Concepto

La dureza del tipado **no es una propiedad binaria** de los lenguajes, sino un **grado** que surge de las restricciones que impone el sistema de tipos sobre cada característica particular.

> *"La dureza del tipado no es una propiedad de los lenguajes, sino que es un grado que surge como consecuencia de las restricciones que impone el sistema de tipos para cada uno de los ítems mencionados."*
> — 06-SistemaDeTipos (p. 2)

Esto significa que un lenguaje puede ser **más duro en una característica y más laxo en otra**. El análisis siempre debe hacerse **respecto a una característica concreta**.

---

## Ejemplo del apunte: expresiones mixtas

```
A = 2        (int)
B = "2"      (string)
```

| Operación | Tipado más duro | Tipado menos duro |
|---|---|---|
| `Concatenar(A, B)` | error de tipos | retorna `"22"` (coerción implícita int→string) |
| `Sumar(A, B)` | error de tipos | retorna `4` (coerción implícita string→int) |

> *"Un lenguaje más duro exige que el programador establezca qué operación es la que quiere aplicar, mientras que en uno más débil las transformaciones de tipo ocurren de manera implícita."*
> — 06-SistemaDeTipos (p. 2)

---

## Ejemplo 1: asignación con tipos distintos

```python
# Python (menos duro en este caso)
x: int = 3.7   # x vale 3.7 (float), sin error aunque se declaró int
                # Python ignora la anotación de tipo en tiempo de ejecución

# TypeScript (más duro)
let x: number = "hola";  // error de tipos en compilación
```

```c
// C (menos duro)
int x = 3.14;   // silenciosamente trunca a 3, sin error

// Java (más duro)
int x = 3.14;   // error de compilación: incompatible types
```

En C, la asignación entre numéricos compatibles es permisiva (conversión implícita silenciosa). En Java se exige conversión explícita: `int x = (int) 3.14;`.

---

## Ejemplo 2: comparaciones entre tipos distintos

```javascript
// JavaScript (menos duro)
0 == "0"    // true  → coerción implícita
0 == false  // true  → coerción implícita
null == undefined  // true

// JavaScript con ===  (más duro dentro del mismo lenguaje)
0 === "0"   // false → sin coerción, compara tipo y valor

// Python (más duro)
0 == "0"    // False → no hay coerción implícita entre int y str
```

JavaScript tiene dos operadores de igualdad precisamente porque el sistema de tipos es laxo por defecto. Usar `===` es más duro: no permite coerciones.

---

## Ejemplo 3: aritmética con booleanos

```python
# Python (menos duro)
True + 1    # 2   → bool se trata como int (True=1, False=0)
False * 10  # 0

# Haskell (más duro)
True + 1    -- error de tipos: no existe instancia de Num para Bool
```

En Python, `bool` es subclase de `int`, por lo que la aritmética se permite silenciosamente. Haskell lo rechaza porque no define operaciones numéricas sobre booleanos.

---

## Ejemplo 4: paso de parámetros con tipo incorrecto

```c
// C (menos duro)
void imprimir(int x) { printf("%d", x); }

imprimir(3.14);   // compila: trunca el float a int silenciosamente
```

```java
// Java (más duro)
void imprimir(int x) { System.out.println(x); }

imprimir(3.14);   // error de compilación: posible pérdida de precisión
```

```haskell
-- Haskell (más duro aún)
imprimir :: Int -> IO ()
imprimir 3.14   -- error: Literal 3.14 :: Fractional a => a, no es Int
```

---

## Ejemplo 5: punteros y acceso a memoria (C vs C++)

```c
// C (menos duro)
void* p = malloc(10);
int* q = p;   // permitido: void* se asigna a cualquier puntero sin cast

// C++ (más duro)
void* p = malloc(10);
int* q = p;          // error de compilación
int* q = (int*) p;   // correcto: requiere cast explícito
```

C permite asignar `void*` a cualquier tipo de puntero sin conversión explícita. C++ lo rechaza para forzar al programador a ser consciente de lo que está haciendo.

---

## Ejemplo 6: acceso a uniones (libre vs. discriminada)

```c
// C — unión libre (menos duro)
union { int i; double d; } u;
u.i = 42;
printf("%f", u.d);  // compila sin error: se leen los bytes de i como double
                    // el resultado es basura, pero no hay chequeo
```

```ada
-- Ada — registro variante con discriminante (más duro)
type Figura (Kind : Tipo_Figura) is record
   case Kind is
      when Circulo  => Radio   : Float;
      when Rect     => Ancho, Alto : Float;
   end case;
end record;

-- acceder al campo incorrecto → Constraint_Error en ejecución
```

Esto explica por qué el apunte señala que el acceso a un registro variante no puede chequearse **estáticamente**: incluso en lenguajes con tipado estático, este chequeo ocurre en ejecución.

> *"Hay características de los lenguajes que no son controlables estáticamente, aunque el lenguaje tenga tipado estático. ¿Un ejemplo? El acceso a las componentes de un registro variante."*
> — 06-SistemaDeTipos (p. 2)

---

## Ejemplo 7: funciones con argumentos de más o de menos

```javascript
// JavaScript (menos duro)
function suma(a, b) { return a + b; }

suma(1, 2, 3, 4);   // válido: ignora los argumentos extra
suma(1);            // válido: b es undefined, retorna NaN
```

```python
# Python (más duro)
def suma(a, b): return a + b

suma(1, 2, 3)   # TypeError: suma() takes 2 positional arguments but 3 were given
```

---

## Resumen

La dureza no es absoluta: se mide **por característica**. Un mismo lenguaje puede ser:

| Característica | Lenguaje más duro | Lenguaje menos duro |
|---|---|---|
| Expresiones mixtas | Java, Haskell | C, JavaScript |
| Asignación entre numéricos | Java | C |
| Comparaciones | Python, `===` en JS | `==` en JavaScript |
| Aritmética con booleanos | Haskell | Python |
| Paso de parámetros | Java, Haskell | C |
| Punteros void | C++ | C |
| Acceso a uniones | Ada (discriminada) | C (libre) |
| Aridad de funciones | Python | JavaScript |

El objetivo de un sistema de tipos más duro es detectar errores antes (idealmente en compilación), a costa de obligar al programador a ser más explícito.
