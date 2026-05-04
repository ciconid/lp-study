---
name: tp-mcp-workflow
description: Flujo obligatorio para responder preguntas del TP usando MCP con citas y marcado automático de estado.
---

# Skill: TP con MCP + citas + marcado

## Objetivo
Responder preguntas del TP de forma trazable y consistente.

## Instrucciones obligatorias
1. **Antes de responder cualquier pregunta**, buscar información relevante usando MCP de PDFs:
   - `mcp_pdf-search_search_pdfs` para ubicar material.
   - `mcp_pdf-search_read_pdf` para validar contexto cuando haga falta.
2. **Siempre citar fuentes** del material teórico consultado.
   - Formato mínimo recomendado: `Archivo (p. N)`.
   - Incluir al menos 1 cita por respuesta (idealmente 2 o más si corresponde).
3. **Responder en** `TP8-respuestas.md` en la sección de la pregunta.
4. **Marcar la pregunta como respondida** en `TP8.md` cambiando:
   - `⬜ **N.**` → `✅ **N.**`
5. Confirmar al final qué archivos se actualizaron.

## Checklist de ejecución
- [ ] Busqué en PDFs con MCP.
- [ ] Incluí citas explícitas en la respuesta.
- [ ] Actualicé `TP8-respuestas.md`.
- [ ] Marqué `✅` en `TP8.md`.
- [ ] Verifiqué que no queden cambios incompletos.

## Regla de calidad
Si no hay evidencia suficiente en fuentes, **no inventar**: ampliar búsqueda MCP y recién después responder. Se pueden usar fuentes por fuera de la documentacion de este proyecto, pero es obligatorio citarlas.
