# Resumen Clase 1: Sintaxis, Semántica y Traductores

## Introducción
La especificación precisa de un lenguaje de programación es esencial para describir su comportamiento. Se utilizan notaciones formales para definir la sintaxis y semántica, lo que ayuda en la comprensión, estandarización, diseño y verificación de lenguajes.

## Tipos de especificación
- **Sintaxis:** Reglas sobre la formación de frases válidas (estructura del programa). Se maneja con gramáticas libres de contexto (BNF) y se apoya en analizadores léxicos (tokens).
- **Semántica:** Reglas sobre el significado de las frases. Se puede especificar mediante semántica axiomática (lógica de Hoare), denotacional (funciones recursivas) u operacional (máquinas abstractas).
- **Pragmatismo:** Uso práctico de las frases, difícil de formalizar.

## Importancia de la especificación formal
- Permite la correcta implementación de compiladores e intérpretes.
- Ayuda a evitar ambigüedades y dialectos en los lenguajes.
- La implementación suele acompañar a la especificación para resolver dudas semánticas.

## Compiladores e intérpretes
- **Compilador:** Traduce el código fuente a código máquina antes de la ejecución. Es eficiente y adecuado para lenguajes con semántica estática fuerte.
- **Intérprete:** Ejecuta el código fuente directamente, resolviendo controles en tiempo de ejecución. Es más flexible, pero menos eficiente.

## Fases de un traductor
1. Análisis léxico (scanner)
2. Análisis sintáctico (parser)
3. Análisis semántico
4. Generación de código

## Conclusión
La correcta definición de la sintaxis y semántica es fundamental para el diseño y uso de lenguajes de programación. La implementación (compilador/intérprete) debe estar alineada con la especificación para evitar ambigüedades.