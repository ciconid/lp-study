#!/usr/bin/env bash
# Setup del entorno para lp-study MCP
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR/../.."

echo "Instalando dependencias Python..."
pip3 install -r "$ROOT/requirements.txt"

echo ""
echo "Listo! Abrí el proyecto en VS Code y el servidor MCP debería iniciar automáticamente."
