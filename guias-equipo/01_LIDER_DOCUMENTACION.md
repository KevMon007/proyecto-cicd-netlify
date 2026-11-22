# Integrante 1 — líder y documento final

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Habilitar el trabajo paralelo y entregar un solo reporte que reúna el caso de estudio. Tus archivos son `README.md`, `docs/01-justificacion.md` y `docs/reporte.md`.

## Día 1

1. Crea o reutiliza un repositorio privado. No sobrescribas un repositorio que ya tenga trabajo.
2. Antes del primer push, comprueba que el job `deploy` contenga:

   ```yaml
   if: github.event_name == 'push' && github.ref == 'refs/heads/main' && vars.DEPLOY_ENABLED == 'true'
   ```

3. Publica la base, invita a seis colaboradores y comparte la guía general.
4. En `docs/lider-inicial`, crea `docs/01-justificacion.md` con el caso, el flujo PR → test → merge → test → build → deploy y sus beneficios.
5. Actualiza el README con ejecución local, responsables y estado actual. Abre tu PR.

No actives `DEPLOY_ENABLED` todavía y no edites los archivos exclusivos de otra persona.

## Día 2

1. Revisa y fusiona PR con CI verde.
2. Cuando los scripts, workflow y secretos estén listos, configura la variable `DEPLOY_ENABLED=true`.
3. Comprueba la ejecución final de `main`, la URL y `/api/health`.
4. Integra los documentos `01` a `08` en `docs/reporte.md`; conserva resultados reales y limitaciones.
5. Actualiza README con la URL pública, enlace al reporte y forma de ejecutar el proyecto.

## Terminado cuando

- [ ] Repositorio y accesos listos.
- [ ] Justificación integrada.
- [ ] Siete aportes revisados.
- [ ] Reporte, URL y ejecución final verificados.
