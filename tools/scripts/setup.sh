#!/usr/bin/env bash
# Setup del entorno para lp-study MCP
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
VENV_DIR="$ROOT/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"
VENV_PIP="$VENV_DIR/bin/pip"

echo "Creando entorno virtual en $VENV_DIR ..."
if ! python3 -m venv "$VENV_DIR"; then
	echo ""
	echo "No se pudo crear el entorno virtual."
	echo "En Debian/Ubuntu/Mint instalá primero:"
	echo "  sudo apt update && sudo apt install -y python3-venv python3-pip"
	exit 1
fi

echo "Instalando dependencias Python en el entorno virtual..."
"$VENV_PYTHON" -m pip install -U pip
"$VENV_PIP" install -r "$ROOT/requirements.txt"

echo "Configurando .vscode/mcp.json para usar el venv..."
mkdir -p "$ROOT/.vscode"
cat > "$ROOT/.vscode/mcp.json" <<EOF
{
	"servers": {
		"pdf-search": {
			"type": "stdio",
			"command": "$VENV_PYTHON",
			"args": [
				"\${workspaceFolder}/tools/scripts/pdf_search_mcp.py"
			]
		}
	}
}
EOF

echo ""
echo "Listo."
echo "Si VS Code ya estaba abierto, recargá la ventana para reiniciar el servidor MCP."
