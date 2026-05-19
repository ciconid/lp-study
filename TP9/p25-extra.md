# Trabajo Práctico N° 9 — Paradigmas No Convencionales - Paradigma Funcional
**Universidad Nacional del Sur — Lenguajes de Programación**

---

## Análisis adicional sobre five y apply con String

### a. five
La función `five` tiene tipo `a -> Int`, es decir, acepta cualquier tipo de argumento y siempre devuelve 5. Si le pasamos un `String`, por ejemplo `five "hola"`, el resultado será simplemente 5, sin importar el valor ni el tipo del argumento.

> *"five _ = 5" define una función constante que ignora su argumento, por lo que acepta cualquier tipo, incluyendo String, y siempre retorna 5.*
> — Slides - Paradigma Funcional - Haskell y SML (p. 18)

### b. apply
La función `apply` tiene tipo `(a -> b) -> a -> b`. Si le pasamos un string como segundo argumento, el resultado dependerá de la función que se pase como primer argumento:
- Si la función es compatible con `String` (por ejemplo, `length`), entonces `apply length "hola"` dará 4.
- Si la función no acepta `String` (por ejemplo, `not`), entonces dará un error de tipos en compilación.

> *"El tipo de apply es (a -> b) -> a -> b. El tipo de los argumentos debe coincidir: si se pasa un String, la función debe aceptar String como argumento."*
> — Slides - Paradigma Funcional - Haskell y SML (p. 35)

**Ejemplos en GHCi:**
```haskell
five "hola"      -- Resultado: 5
apply length "hola"  -- Resultado: 4
apply not "hola"     -- Error de tipos: no se puede aplicar 'not' a un String
```

En resumen:
- `five` acepta cualquier tipo, incluyendo String, y siempre devuelve 5.
- `apply` requiere que la función y el argumento sean compatibles en tipo; si no lo son, hay error de tipos en compilación.
