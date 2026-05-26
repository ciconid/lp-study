# Unidades o Subrutinas

> Fuente: `teoria/07-Unidades.pdf` — Lenguajes de Programación, DCIC - UNS

---

## ¿Qué son las unidades?

Las unidades son abstracciones a nivel sentencia/expresión que permiten agrupar un comportamiento bajo un nombre. Sin ellas, todo programa es monolítico. Su incorporación promueve:

- **Eficiencia**: factorización del código (ahorro de almacenamiento).
- **Legibilidad**: diseño top-down.
- **Verificación**: una unidad puede pensarse como un mapeo entre dominios de valores.

---

## Atributos de una unidad

| Atributo | Descripción |
|---|---|
| **Nombre** | Identificador asociado. Puede ser anónima (bloque) o nombrada (subprograma). |
| **Lista de parámetros** | Vía de comunicación con el resto del programa. |
| **Ambiente de referenciamiento** | Qué otras entidades puede referenciar. |
| **Bloque ejecutable** | Código que implementa la unidad. Si puede llamarse a sí misma → recursividad. |
| **Alcance** | Segmento donde puede ser invocada. |

---

## Estructura estática

El **encabezamiento** incluye: nombre + lista de parámetros + tipo de retorno (si tiene).  
El **cuerpo** incluye: declaraciones locales + sección ejecutable.

Conceptos relacionados:
- **Perfil**: número, orden y tipo de los parámetros formales.
- **Protocolo**: perfil + tipo de retorno.
- **Signatura**: nombre + protocolo (define la interfaz pública).

Estados de una unidad:
- *Estáticamente*: declaración, definición, invocación.
- *Dinámicamente*: pasiva, activa o suspendida.

---

## Tipos de unidades

### Abstracciones procedurales (procedimientos)
Provocan un cambio de estado (efecto colateral). Se invocan como una instrucción.

### Abstracciones funcionales (funciones)
Evalúan una expresión y devuelven un resultado. Idealmente sin efecto colateral. Se invocan dentro de una expresión.

---

## Clausuras (*Closures*)

Una **clausura** es un subprograma junto con su ambiente de referenciamiento en el momento de su definición. Es el mecanismo que permite que un subprograma anidado "se lleve" el entorno léxico que lo rodea y pueda usarlo más tarde, incluso fuera de ese entorno.

> *"A closure is a subprogram and the referencing environment where it was defined. The referencing environment is needed if the subprogram can be called from any arbitrary place in the program."*
> — Sebesta, Cap. 9

**Ejemplo en Python:**
```python
def make_adder(n):
    def adder(x):
        return x + n   # 'n' es capturado del ámbito externo
    return adder

add5 = make_adder(5)
print(add5(3))  # 8
```

### `def` en Python como instrucción ejecutable

En Python, `def` es una **instrucción ejecutable en tiempo de ejecución** (a diferencia de C/Java donde las funciones son estáticas). Esto implica:
- Una función no existe hasta que su `def` es ejecutado.
- Puede aparecer dentro de `if/else`, bucles u otras funciones → permite definiciones condicionales.
- Cada ejecución de `def` captura el ambiente en ese instante (crea una clausura).

En SML, `let fun ... in ... end` también crea funciones locales con cierre léxico, pero como *expresión funcional* (no instrucción), por lo que no puede producir definiciones condicionales en tiempo de ejecución.

---

## Administración de memoria

Cada unidad tiene dos partes en memoria:
- **Registro de activación (RA) / stack frame**: datos de la unidad.
- **Segmento de código**: instrucciones.

El acceso a una variable se calcula como:
```
Dirección Base del RA + desplazamiento
```

### Objetos de datos del registro de activación

```
[ Objetos de datos del sistema (PR, ED, EE) ]
[ Parámetros formales                        ]
[ Variables locales                          ]
```

- **PR** (Puntero de Retorno): dirección de la instrucción siguiente a la invocación.
- **ED** (Enlace Dinámico): dirección base del RA de la unidad llamadora.
- **EE** (Enlace Estático): dirección base del RA del contenedor léxico (solo en bloques anidados).

---

## Administración estática

- No admite recursividad.
- Todo el espacio se conoce en compilación.
- Solo requiere Puntero de Retorno.
- Las variables globales se declaran con `common` y tienen un área separada.

**Invocación**: guardar PR + saltar a la unidad.  
**Epílogo**: saltar al PR.

---

## Administración dinámica basada en pila

Registros rápidos: `actual` (base del RA en ejecución) y `libre` (primera locación libre).

### Pasos en la invocación
1. Reservar espacio en la pila.
2. Guardar PR.
3. Guardar ED.
4. Guardar EE (si hay bloques anidados).
5. Actualizar `actual`.
6. Actualizar `libre`.
7. Saltar al código de la unidad.

### Pasos en el epílogo
1. Liberar memoria del RA.
2. Restaurar `actual` con el ED.
3. Saltar al PR.

---

## Cálculo del Enlace Estático (EE)

Para lenguajes con bloques anidados hay tres situaciones:

| Situación | Descripción | Instrucción |
|---|---|---|
| **Misma profundidad** | Q llama a S (mismo nivel) | `SET Libre+2, D[actual+2]` |
| **Distancia +1** | Q llama a R (R está dentro de Q) | `SET Libre+2, actual` |
| **Distancia negativa** | R llama a Q (Q contiene a R) | Se recorre la cadena estática tantos niveles como indique la distancia |

Ejemplo (distancia -2):
```
SET Libre+2, D[D[actual+2]+2]
```

---

## Unidades como parámetros

Para que el lenguaje sea ortogonal debería admitir tanto datos como unidades como parámetros. Sin embargo, el costo es alto en lenguajes imperativos/OO, porque obliga a resolver dos problemas:

### 1. Type safety del subprograma pasado

El tipo de un subprograma pasado como parámetro debe representar su **protocolo completo**: número, orden y tipo de parámetros formales + tipo de retorno.  
Solo así el compilador puede verificar que el subprograma real sea compatible con el parámetro formal.

En C/C++ no se pueden pasar funciones directamente; se pasan **punteros a función**, lo que incluye el protocolo y permite type-checking completo:
```cpp
float (*pfun)(float, int);
// pfun apunta a cualquier función que tome (float, int) y devuelva float
```

### 2. Ambiente de referenciamiento del subprograma pasado

Cuando un subprograma pasado como parámetro es invocado, ¿en qué ambiente de referenciamiento se ejecuta? Hay tres alternativas:

| Alternativa | Ambiente usado | Apropiado para | Ventaja |
|---|---|---|---|
| **Ligadura superficial** (*shallow binding*) | Sitio de activación (quien lo invoca) | Alcance dinámico | Implementación simple |
| **Ligadura profunda** (*deep binding*) | Sitio de definición (donde fue definido) | Alcance estático | Coherente con la semántica léxica; predecible. Requiere clausura |
| **Ligadura ad hoc** | Sitio donde fue pasado como parámetro | — (nunca usada) | Solo coincide con deep en casos especiales |

**Ejemplo ilustrativo:**
```javascript
function sub1() {
  var x;
  function sub2() { alert(x); }   // definida en sub1
  function sub3() {
    var x = 3;
    sub4(sub2);                    // sub2 pasada como parámetro
  }
  function sub4(subx) {
    var x = 4;
    subx();                        // sub2 activada aquí
  }
  x = 1;
  sub3();
}
```

| Alternativa | `x` accedida | Salida |
|---|---|---|
| Shallow (ambiente de `sub4`) | `x = 4` | `4` |
| Deep (ambiente de `sub1`) | `x = 1` | `1` |
| Ad hoc (ambiente de `sub3`) | `x = 3` | `3` |

Los lenguajes modernos de alcance estático usan **ligadura profunda** (clausuras).

---

## Parámetros

### Terminología

- **Argumento**: datos de entrada de una unidad (variables no locales, parámetros, archivos).
- **Parámetro formal**: declarado en el encabezado de la unidad.
- **Parámetro actual**: lo que se pasa en la invocación (variable, constante, expresión).

### Correspondencia formal ↔ actual

- **Posicional**: por orden. Es la más habitual.
- **Por nombre (*keyword parameters*)**: se indica explícitamente el nombre del formal. Permite independizarse del orden. La desventaja es que el usuario debe conocer los nombres de los formales. Ada y Python lo admiten.

**Restricción clave**: una vez que aparece un keyword parameter en la lista, todos los siguientes también deben serlo (la posición ya no está bien definida).

```python
pay = compute_pay(20000.0, tax_rate=0.15)  # válido
# compute_pay(income=20000.0, 0.15)         # ERROR
```

Los keyword parameters suelen combinarse con **valores por defecto** (*default parameters*), de forma que los parámetros omitidos en la llamada toman el valor declarado en la definición:

```ada
Procedure P(A, B: int := 1; C: real := 0)
-- P(A=100)  →  B=1, C=0 por defecto
```

---

## Formas de pasaje de parámetros

### Por copia (evaluación estricta)

| Modo | Descripción | Implementación |
|---|---|---|
| **Por valor** (in) | Inicializa el formal con el valor del actual al llamar. | Se copia el valor en la invocación. Epílogo sin cambios. |
| **Por resultado** (out) | Al terminar, copia el formal en el actual. | En la invocación se guarda la *dirección* del actual. En el epílogo se copia el valor. |
| **Por valor-resultado** (in-out) | Combina ambos: copia al entrar y al salir. | Se guarda la dirección del actual y se inicializa el formal; en el epílogo se copia el resultado. |

### Por referencia

Se pasa la **dirección** del parámetro actual. El formal es un alias del actual; los cambios son inmediatos y visibles durante toda la ejecución. El epílogo no necesita copiar nada.

### Por nombre

Se reemplaza cada referencia al formal por una llamada a una rutina (*thunk*) que evalúa el actual en su entorno. La sobrecarga en ejecución es alta.

### Por necesidad (evaluación perezosa)

Igual que por nombre, pero el thunk se invoca como máximo una vez; el resultado se guarda para reutilizarlo (*memoización*).

### ¿Por qué nombre y necesidad son inconvenientes en lenguajes imperativos?

| Problema | Por nombre | Por necesidad |
|---|---|---|
| **Evaluación múltiple con efectos laterales** | La expresión del actual se evalúa cada vez que se usa el formal → si tiene efectos laterales, produce valores distintos en cada uso | Resuelto por la memoización |
| **Orden de evaluación indefinido** | — | El momento exacto de la evaluación no está definido; en lenguajes imperativos el orden importa |
| **Aliasing no intencional** | La sustitución textual puede hacer que el formal sea alias de variables globales del cuerpo | — |
| **Requiere transparencia referencial** | Solo funciona de manera intuitiva cuando `expr` siempre evalúa al mismo valor; los lenguajes imperativos no garantizan eso | Igual |
| **Alto costo de implementación** | Requiere thunks (par subprograma/ambiente) | Requiere thunks + memoización |

Ambos mecanismos son naturales en **lenguajes funcionales puros** (como Haskell), donde no hay efectos laterales ni asignaciones destructivas.

---

## Cuadro comparativo de pasajes

| Pasaje | Modo | Copia en invocación | Copia en epílogo | Observaciones |
|---|---|---|---|---|
| Por valor | in | valor | — | El formal es variable local |
| Por resultado | out | dirección del actual | formal → actual | Parámetro actual debe ser variable |
| Por valor-resultado | in-out | dirección + valor | formal → actual | Combina ambos |
| Por referencia | in-out | dirección del actual | — | Alias; un acceso extra a memoria |
| Por nombre | — | dirección del thunk | — | Alta sobrecarga |
| Por necesidad | — | dirección del thunk | — | Evaluación lazy; memoiza |

---

## Corutinas (*Coroutines*)

Una **corutina** es una unidad que puede suspender su propia ejecución y ceder el control a otra corutina, retomándola luego desde el punto exacto donde la dejó. A diferencia de una subrutina (relación llamador/llamado jerárquica), las corutinas tienen una relación **simétrica**: cualquiera puede transferir el control a cualquier otra.

Operaciones clave:
- **`detach`**: suspende la corutina actual y retoma la que la activó.
- **`transfer(C)`**: suspende la corutina actual y activa `C`.

```
Coroutine check_file_sys       Coroutine Update_screen
  Inicializar                    Inicializar
  Detach                         Detach
  For all files                  Loop
    ....                           ....
    transfer(us)                   transfer(cfs)
```

Las corutinas son útiles para modelar **concurrencia cooperativa** (sin paralelismo real): el programador decide cuándo ceder el control.

---

## Iteradores y Generadores

Un **iterador** es una unidad que produce una secuencia de valores, uno a la vez. Los **generadores** (como los de Python con `yield`) son una forma de implementar iteradores usando el mecanismo de corutinas: la función se suspende con `yield` y retoma desde ahí en la siguiente llamada.

```python
class ParesIterador:
    def __init__(self, limite):
        self.limite = limite
        self.valor = 0
    def __iter__(self): return self
    def __next__(self):
        if self.valor > self.limite:
            raise StopIteration
        resultado = self.valor
        self.valor += 2
        return resultado

for par in ParesIterador(10):
    print(par)   # 0 2 4 6 8 10
```

La diferencia con las corutinas generales es que los iteradores/generadores mantienen una relación **asimétrica** con el llamador (el llamador siempre solicita el siguiente valor).
