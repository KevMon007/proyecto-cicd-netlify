#!/usr/bin/env bash
set -euo pipefail

echo "Git:  $(git --version)"
echo "Bash: ${BASH_VERSION}"
echo "Node: $(node -v)"
echo "npm:  $(npm -v)"

major=$(node -p "process.versions.node.split('.')[0]")
if [ "$major" -ne 22 ]; then
  echo "Se requiere Node.js 22, versión actual: $(node -v)" >&2
  exit 1
fi

npm ci --no-audit --no-fund
echo "Entorno listo"
