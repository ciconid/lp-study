---
name: tp-mcp-workflow
description: Flujo obligatorio para responder preguntas del TP usando MCP con citas y marcado automático de estado.
---

# Skill: TP con MCP + citas + marcado

## Objetivo
Responder preguntas del TP de forma trazable y consistente.

## Instrucciones obligatorias
1. **Antes de responder cualquier pregunta**, buscar información relevante usando MCP de PDFs y una breve búsqueda online (o en la base de conocimiento del modelo):
   - Realizar las búsquedas tanto en español como en inglés, ya que la bibliografía puede estar en ambos idiomas. No es obligatorio traducir citas del inglés al español; pueden citarse en el idioma original.
   - `mcp_pdf-search_search_pdfs` para ubicar material.
   - `mcp_pdf-search_read_pdf` para validar contexto cuando haga falta.
   - Realizar una breve búsqueda online (o en la base de conocimiento del modelo) sobre el tema de la pregunta. Si se encuentra información adicional relevante que no esté en la bibliografía, agregarla al final de la respuesta bajo el subtítulo "Información adicional".
2. **Siempre citar fuentes** del material teórico consultado.
   - Las citas deben aparecer **inmediatamente después** de la afirmación que las respalda, no agrupadas al final.
   - Usar siempre el formato blockquote de Markdown para diferenciarlas visualmente:
     ```
     > *"texto citado o síntesis de la fuente"*
     > — Archivo (p. N)
     ```
   - Si la cita es propia (síntesis, no cita textual), igualmente usar blockquote con `— Archivo (p. N)` al pie.
   - Incluir al menos 1 cita por afirmación relevante derivada del material.
3. **Crear o actualizar el archivo individual de respuesta** para cada pregunta:
   - El archivo se ubica en el directorio del TP activo (ej. `TP8/pNN.md` para la pregunta N del TP8).
   - El nombre sigue el patrón `pNN.md` donde `NN` es el número de pregunta con cero a la izquierda (p01, p02, ..., p10, p11, ...).
   - Si el archivo ya existe, actualizar su contenido; si no existe, crearlo.
   - Cada archivo debe comenzar con el encabezado:
     ```
     # Trabajo Práctico N° X — <Título del TP>
     **Universidad Nacional del Sur — Lenguajes de Programación**

     ---

     ## Pregunta N
     > <enunciado completo de la pregunta>
     ```
   - A continuación, la respuesta completa con citas inline.
4. **Marcar la pregunta como respondida** en el archivo de enunciado del TP (ej. `TP8.md`) cambiando:
   - `⬜ **N.**` → `✅ **N.**`
5. Confirmar al final qué archivos se crearon o actualizaron.

## Checklist de ejecución
- [ ] Busqué en PDFs con MCP.
- [ ] Incluí citas explícitas **inline**, después de cada afirmación respaldada por el material.
- [ ] Creé o actualicé `TPX/pNN.md` con la respuesta completa.
- [ ] Marqué `✅` en `TPX.md`.
- [ ] Verifiqué que no queden cambios incompletos.

## Regla de calidad
Si no hay evidencia suficiente en fuentes, **no inventar**: ampliar búsqueda MCP y recién después responder. Se pueden usar fuentes por fuera de la documentacion de este proyecto, pero es obligatorio citarlas. Las fuentes pueden ser externas, pero deben ser confiables y relevantes al tema. En caso de usar fuentes externas, se debe citar claramente con el formato indicado, incluyendo el nombre del autor o la organización, el título del documento o página web, y la fecha de consulta si es relevante.
