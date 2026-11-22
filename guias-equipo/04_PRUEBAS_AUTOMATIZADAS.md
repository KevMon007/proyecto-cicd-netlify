# Integrante 4 — pruebas automatizadas

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Validar el contrato mínimo del servicio. Tus archivos son `tests/health.test.js`, `scripts/test.sh` y `docs/07-pruebas.md`. Rama: `feature/pruebas`.

## Trabajo independiente

1. Prueba el handler con `node:test` y `node:assert/strict`.
2. Verifica código HTTP 200, cuerpo `{"status":"ok"}` y encabezado `content-type` con JSON.
3. Conserva en `scripts/test.sh`:

   ```bash
   set -euo pipefail
   npm test
   npm run build
   ```

4. Ejecuta el script y comprueba que se genera `dist/index.html`.
5. Documenta caso, entrada, resultado esperado y resultado local. Abre PR.

Después del despliegue, añade una sola validación pública con `curl -i URL/api/health`. No se requiere crear una prueba rota ni otro PR solo para provocar un fallo.

## Terminado cuando

- [ ] Las tres aserciones pasan.
- [ ] Pruebas y build se detienen ante errores.
- [ ] La comprobación local y, al final, la pública están documentadas.
