#!/usr/bin/env bash
set -euo pipefail
: "${NETLIFY_AUTH_TOKEN:?Configura NETLIFY_AUTH_TOKEN en GitHub Secrets}"
: "${NETLIFY_SITE_ID:?Configura NETLIFY_SITE_ID en GitHub Secrets}"
npx --yes netlify-cli@23 deploy --prod --dir=dist --functions=netlify/functions --message="GitHub Actions ${GITHUB_SHA:-manual}"
