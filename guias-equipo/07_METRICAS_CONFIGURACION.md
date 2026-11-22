# Integrante 7 — métricas y configuración

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Documentar monitoreo y parámetros en `docs/04-metricas.md` y `docs/05-configuracion.md`. Rama: `docs/metricas`. Puedes preparar ambos archivos sin esperar la URL final.

## Trabajo independiente

1. Para cada métrica indica qué mide, unidad, fuente y forma de obtención:
   - estado HTTP y cuerpo de `/api/health`;
   - disponibilidad de la muestra;
   - latencia de respuesta;
   - resultado y duración de GitHub Actions;
   - resultado del deploy de Netlify.
2. Documenta los parámetros: Node 22, `ubuntu-latest`, eventos de Actions, comandos npm, `dist`, ruta de funciones, redirect, Netlify CLI 23, nombres de secretos y `DEPLOY_ENABLED`. No incluyas valores secretos.
3. Abre PR con tablas preparadas y marca los valores remotos como pendientes.
4. Cuando exista la URL, ejecuta cinco solicitudes:

   ```bash
   for i in 1 2 3 4 5; do
     curl --max-time 15 -sS -o /dev/null -w 'HTTP %{http_code} | %{time_total}s\n' https://SITIO.netlify.app/api/health
   done
   ```

5. Registra fecha, cinco resultados, éxitos/total y latencias. Añade duración y resultado de la ejecución final de Actions.

Cinco peticiones describen solo una muestra; no prueban disponibilidad mensual ni una p95 estable.

## Terminado cuando

- [ ] Métricas y parámetros están documentados.
- [ ] No se expusieron secretos.
- [ ] Los resultados reales o su condición de pendiente están claramente indicados.
