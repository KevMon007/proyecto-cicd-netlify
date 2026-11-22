# Integrante 2 — entorno de liberación

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Hacer reproducible el entorno local y de GitHub Actions. Tus archivos son `scripts/setup.sh`, `package.json`, `package-lock.json` y `docs/02-entorno.md`. Rama: `feature/entorno`.

## Trabajo independiente

1. Verifica Git, Bash, Node.js 22 y npm.
2. Conserva únicamente los scripts npm `test` y `build`; no agregues frameworks ni dependencias innecesarias.
3. Ajusta `scripts/setup.sh` para usar:

   ```bash
   set -euo pipefail
   npm ci --no-audit --no-fund
   ```

4. Ejecuta `bash scripts/setup.sh`, `npm test` y `npm run build`. Comprueba `dist/index.html`, pero no subas `dist/`.
5. Documenta requisitos y comandos. Explica que GitHub Actions usa Ubuntu y Node 22, mientras Netlify es el destino de despliegue.
6. Abre PR e incluye versiones y resultado de los comandos.

## Terminado cuando

- [ ] La instalación es reproducible con el lockfile.
- [ ] Prueba y build pasan localmente.
- [ ] `docs/02-entorno.md` está completo.
