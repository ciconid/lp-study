# Trabajo Práctico N° 8 — Lenguajes Orientados a Objetos
**Universidad Nacional del Sur — Lenguajes de Programación**

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
