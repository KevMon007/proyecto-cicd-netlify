# Niveles de servicio acordados

## 1. Conceptos básicos

- **SLI (Service Level Indicator):** medida cuantitativa del comportamiento del servicio, por ejemplo el porcentaje de respuestas exitosas.
- **SLO (Service Level Objective):** meta que se fija para un SLI, por ejemplo disponibilidad mayor o igual a 99 %.
- **SLA (Service Level Agreement):** acuerdo formal entre proveedor y cliente que define los SLO y sus consecuencias si no se cumplen.

En este caso de estudio se definen **objetivos (SLO) académicos** para el endpoint `/api/health`, con sus indicadores (SLI) y su método de cálculo.

## 2. Objetivos académicos

| Indicador | Objetivo académico |
|---|---|
| Disponibilidad | ≥ 99 % mensual |
| Latencia del health | p95 < 2 s |
| Respuestas 5xx | < 1 % |
| Pipeline previo al deploy | 100 % de despliegues con pruebas aprobadas |

## 3. Definición de cada indicador

| Indicador | Fórmula | Unidad | Fuente | Periodo |
|---|---|---|---|---|
| Disponibilidad | (respuestas exitosas / solicitudes totales) × 100 | % | Solicitudes HTTP a `/api/health` (código HTTP 200) | Objetivo mensual; la muestra del proyecto es puntual |
| Latencia del health | Percentil 95 (p95) de los tiempos de respuesta de la muestra | segundos (s) | Tiempo total de cada solicitud a `/api/health` (`curl`, variable `time_total`) | Muestra de solicitudes tomada después del despliegue |
| Respuestas 5xx | (respuestas con código 5xx / solicitudes totales) × 100 | % | Código HTTP de cada solicitud a `/api/health` | Muestra de solicitudes tomada después del despliegue |
| Pipeline previo al deploy | (despliegues con job `test` aprobado / despliegues totales) × 100 | % | Historial de ejecuciones de GitHub Actions (jobs `test` y `deploy`) | Ejecuciones del proyecto sobre `main` |

Notas de cálculo:

- Una respuesta es exitosa cuando devuelve HTTP 200 con cuerpo `{"status":"ok"}` dentro del tiempo límite de la solicitud.
- En el pipeline, el job `deploy` depende de `test` (`needs: test`), por lo que un despliegue solo se ejecuta si las pruebas pasaron.

## 4. Alcance de estos objetivos

Estos valores son **objetivos del caso de estudio**, propuestos por el equipo con fines académicos. **No son una garantía contractual de Netlify** ni de GitHub, ni un compromiso de servicio real.

## 5. Metas y resultados observados

Las metas de la sección 2 se distinguen de los resultados observados. Los resultados se registran al final del proyecto, cuando exista la URL pública y las ejecuciones reales.

| Indicador | Meta | Resultado observado |
|---|---|---|
| Disponibilidad | ≥ 99 % mensual | Pendiente (no evaluable como valor mensual) |
| Latencia del health | p95 < 2 s | Pendiente (no evaluable como p95 estable) |
| Respuestas 5xx | < 1 % | Pendiente |
| Pipeline previo al deploy | 100 % | Pendiente |

## 6. Limitaciones

- Los pocos datos disponibles se usan solo como **evidencia puntual**, no como medición de un mes completo.
- Una muestra pequeña de solicitudes no permite afirmar disponibilidad mensual ni calcular un p95 estable; en ese caso el resultado se indica como **no evaluable**.
- No se extrapolan resultados a periodos más largos que los realmente observados.
- Los resultados dependen de que el despliegue en Netlify y los secretos de GitHub estén configurados.