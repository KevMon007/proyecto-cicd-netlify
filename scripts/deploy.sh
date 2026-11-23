#!/usr/bin/env bash
set -euo pipefail

echo "=== Validando secretos y artefactos para Netlify ==="

if [ -z "${NETLIFY_SITE_ID:-}" ]; then
  echo "Error: NETLIFY_SITE_ID no está definido."
  exit 1
fi

if [ -z "${NETLIFY_AUTH_TOKEN:-}" ]; then
  echo "Error: NETLIFY_AUTH_TOKEN no está definido."
  exit 1
fi

if [ ! -d "dist" ]; then
  echo "Error: No existe el directorio dist/."
  exit 1
fi

echo "=== Desplegando a producción con Netlify CLI 23 ==="
npx --yes netlify-cli@23 deploy \
  --prod \
  --dir=dist \
  --functions=netlify/functions \
  --site="$NETLIFY_SITE_ID" \
  --auth="$NETLIFY_AUTH_TOKEN"