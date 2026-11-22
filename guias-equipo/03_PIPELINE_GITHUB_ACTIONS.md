# Integrante 3 — pipeline de GitHub Actions

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Configurar la liberación continua. Tus archivos son `.github/workflows/pipeline.yml` y `docs/06-pipeline.md`. Rama: `feature/pipeline`.

## Trabajo independiente

1. Conserva los eventos `pull_request` y `push` a `main`, permisos `contents: read`, Ubuntu y Node 22.
2. El job `test` debe ejecutar checkout, setup de Node, `scripts/setup.sh` y `scripts/test.sh`.
3. El job `deploy` debe declarar `needs: test`, preparar su propio runner y usar esta condición:

   ```yaml
   if: github.event_name == 'push' && github.ref == 'refs/heads/main' && vars.DEPLOY_ENABLED == 'true'
   ```

4. Expón los dos secretos únicamente al paso `scripts/deploy.sh`.
5. Documenta eventos, jobs, orden, variable y secretos sin escribir sus valores. Abre PR.

En PR es correcto que `deploy` aparezca omitido. El día 2, comprueba con el líder una ejecución de `main` donde `test` y `deploy` estén verdes. No es necesaria una prueba deliberadamente rota.

## Terminado cuando

- [ ] Un PR ejecuta `test` sin desplegar.
- [ ] `main` despliega solo después de `test` y con la variable habilitada.
- [ ] `docs/06-pipeline.md` explica el flujo.
