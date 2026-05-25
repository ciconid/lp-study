# Gramática de Atributos

> Tema relacionado: Sintaxis, Semántica y Traductores (Clase 01)
> Fuente principal: `teoria/01-Sintaxis, Semántica y Traductores.pdf`

---

## El problema que viene a resolver

Cualquier lenguaje de programación, como lenguaje formal, sería de **Tipo 0** en la jerarquía de Chomsky. Pero eso es inmanejable para un compilador. Entonces se divide el problema:

> *"La descripción de cualquier lenguaje de programación se termina dividiendo en: Sintaxis, Semántica y Pragmatismo."*
> — 01-Sintaxis, Semántica y Traductores (p. 1)

Y dentro de la **sintaxis**, hay otra división:

| Parte | Qué captura | Herramienta formal |
|---|---|---|
| **Sintaxis propiamente dicha** | Estructura de las frases | Gramática libre de contexto (BNF) → **parser** |
| **Semántica estática** | Lo que no puede expresarse en CFG, pero se chequea sin ejecutar | **Gramática de atributos** → **analizador semántico** |

> *"La semántica estática se formaliza a través de lo que se conoce como gramática de atributos y se implementa en el reconocedor a través del analizador semántico."*
> — 01-Sintaxis, Semántica y Traductores (p. 2)

**Ejemplos de semántica estática:**
- ¿Esta variable fue declarada antes de usarse?
- ¿Los tipos en esta expresión son compatibles?

Estas cosas *podrían* escribirse en una CFG, pero la complicarían innecesariamente (para tipos habría que multiplicar todas las reglas de expresiones por cada tipo posible).

---

## Qué es una gramática de atributos

Es una **extensión de las gramáticas libres de contexto**: le agrega información semántica a cada símbolo del árbol de derivación que ya genera el parser.

> *"Para cada símbolo de la gramática X, hay un conjunto A(X) de atributos. El conjunto se divide en dos conjuntos disjuntos S(X) y I(X)."*
> — 01-Sintaxis, Semántica y Traductores (p. 2)

Los tres tipos de atributos:

- **Atributos sintetizados** `S(X)`: se calculan en las **hojas** del árbol y *suben* hacia la raíz. Ejemplo: el tipo de una subexpresión se infiere a partir de sus partes.
- **Atributos heredados** `I(X)`: se calculan en algún nodo y *bajan* hacia las hojas. Ejemplo: el contexto de tipos que se hereda de un scope exterior.
- **Atributos intrínsecos**: solo en las hojas; sus valores vienen directamente del **analizador léxico** (scanner). Ejemplo: el lexema de un identificador o el valor de un literal numérico.

---

## Cómo encaja en el proceso de traducción

```
Código fuente
     ↓
[Scanner / Análisis léxico]  ←── atributos intrínsecos
     ↓ tokens
[Parser / Análisis sintáctico]  ←── gramática libre de contexto (BNF)
     ↓ árbol de derivación
[Analizador semántico]  ←── gramática de atributos (semántica estática)
     ↓
[Generación de código]
```

En la práctica, estas fases no corren en cascada estricta sino colaborativamente por eficiencia: el parser le va pidiendo tokens al scanner a medida que los necesita, y la evaluación de atributos puede ocurrir al mismo tiempo que se construye el árbol.

> *"Si los chequeos se hacen en una sola pasada, la evaluación de los atributos y la generación del árbol sintáctico suceden al mismo tiempo."*
> — 01-Sintaxis, Semántica y Traductores (p. 3)

---

## Por qué importa más en lenguajes con tipado estático

La gramática de atributos es el mecanismo que le permite al compilador hacer **chequeo de tipos en tiempo de compilación**. En lenguajes con tipado dinámico (como Python) ese chequeo se posterga a la ejecución, por lo que la semántica estática es casi inexistente y la gramática de atributos pierde relevancia. En lenguajes como Java o C, en cambio, es central.

---

## Resumen

La gramática de atributos es la herramienta formal que extiende la CFG para capturar la *semántica estática*, decorando el árbol de parsing con atributos que fluyen hacia arriba (sintetizados) o hacia abajo (heredados), implementada en el analizador semántico del compilador/intérprete.
