# Trabajo Práctico N° 6 — Unidades
**Universidad Nacional del Sur — Lenguajes de Programación**
**Licenciatura en Ciencias de la Computación — 1er Cuatrimestre 2026**

Lectura: Sebesta Cap. 9, Scott Cap. 9.3

---

## Conceptos

⬜ **1.** ¿Cuáles son las formas de pasajes de parámetros que puede implementar un lenguaje de programación? Para dos lenguajes que conozca, mencione qué formas implementan.

⬜ **2.** Considere los programas que se muestran debajo.

**a.** Para el programa que se muestra a la izquierda, muestre la salida del mismo, considerando pasaje de parámetros por valor para `cond`, y para `x` e `y`:
- i. Por valor.
- ii. Por nombre.

**b.** Para el programa que se muestra a la derecha, muestre la salida del mismo, considerando pasaje de parámetros por valor para `cond`, y para `x`:
- i. Por valor-resultado.
- ii. Por referencia.

**Programa izquierdo:**
```pascal
program parametros;
var a:integer;

proc p(cond:boolean; x,y:integer);
begin
  if cond then print (x) else print (y)
end

begin
  a:=2;
  p(true,a,f(a));
  p(false,a,f(a));
  print(a);
end.
```
*(donde `f` es: `func f(c:integer):integer; begin f:=c*a; a:=a*2; end`)*

**Programa derecho:**
```pascal
program parametros;
var a:integer;

proc p(cond:boolean; x:integer);
begin
  if cond then a:=a+1 else x:=x-1;
  print(a,x);
  if not cond then goto 10;
  print(a,x);
end

begin
  a:=2
  p(true,a)
  print(a)
  p(false,a)
  print(a)
  p(true,a)
  10 : print (a)
end.
```

✅ **3.** Considere el siguiente programa incompleto. Escriba un código para `p` de tal forma que lo que se muestra en la instrucción `write(z)` sea diferente según el pasaje de parámetros sea por valor, por valor-resultado, o por referencia. Indique además cuáles serían los valores mostrados en cada caso.

```pascal
program llenar;
var z: integer;
procedure p(x: integer)
  { cuerpo p }
begin
  z := 1;
  p(z);
  write(z)
end.
```

⬜ **4.** Defina y compare los mecanismos de pasaje de parámetros: call by name y call by need. Relacione estos mecanismos con los diferentes tipos de evaluación de expresiones.

⬜ **5.** Muestre la salida del siguiente programa considerando pasaje de parámetros (i) por nombre (by name) y (ii) por necesidad (by need).

```pascal
program p;
var y: int;
function f(a: int);
begin
  y:=y+a;
  a:=a+y;
  return a;
end;
procedure q(x: int);
var b: int;
begin
  b:=x;
  if (x>2) then write(x+b);
end
begin
  y:=0;
  q(f(2));
  write(y);
end.
```

⬜ **6.** Defina aliasing. ¿Con qué tipos de pasaje de parámetros puede producirse?

✅ **7.** ¿Qué consideraciones debería contemplar el sistema de tipos cuando se pasan unidades como parámetro?

✅ **8.** ¿Qué alternativas existen para el manejo del ambiente de referenciamiento de las unidades que se pasan como parámetro? ¿Cuáles es las ventajas de cada una?

✅ **9.** ¿Qué restricciones debe imponer el mecanismo de llamada en un lenguaje que permite parámetros actuales con palabra clave (por nombre)?

✅ **10.** ¿Por qué no sería conveniente utilizar pasaje de parámetros por nombre o por necesidad en lenguajes imperativos?

---

## Casos de Estudio e Investigación

✅ **11.** ¿Qué característica presenta `def` en Python que lo distingue de los mecanismos de definición de funciones en otros lenguajes? Investigue el uso del bloque `let ...in ...end` en SML, y determine si el lenguaje tiene el mismo comportamiento que Python.

⬜ **12.** Describa los mecanismos de pasaje de parámetros en Java y Pascal. Ejemplifique las diferencias entre ellos.

⬜ **13.** El siguiente código parecería indicar que Java utiliza pasaje de parámetros por referencia. Complete el método `foo2` para mostrar que en realidad Java utiliza pasaje de parámetros por valor.

⬜ **14.** Investigue cómo funciona el mecanismo de pasaje de parámetros en Python (puede encontrarlo bajo los nombres de *pass-by-object-reference* o *pass-by-assignment*). Luego, complete el código para complementar la explicación. Finalmente, compare esta forma de pasaje de parámetros frente al enfoque de Java usando algún criterio de evaluación que considere adecuado.

⬜ **15.** Describa y ejemplifique cómo es posible que en Pascal el pasaje de parámetros por referencia, en ciertas circunstancias, no produzca aliasing.

⬜ **16.** Pruebe la siguiente porción de código JavaScript y responda:

```javascript
function generar() {
  var contador = 0;
  function sumar() {
    contador++;
    console.log(contador);
  }
  return sumar;
}

var contar1 = generar();
var contar2 = generar();
contar1();
contar1();
contar2();
contar1();
```

¿Qué valores se imprimen? Investigue el concepto de *closure*. Explique por qué no es simplemente "una función definida dentro de otra función" a partir de considerar qué sucede con los atributos de las variables involucradas.

⬜ **17.** ¿Cómo maneja Python el ambiente de referenciamiento no local para las unidades pasadas por parámetro? ¿Utiliza el ambiente del llamador (caller) o del llamado (callee)? Diseñe un fragmento de código que le ayude a responder esta pregunta.
