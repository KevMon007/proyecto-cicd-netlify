# Integrante 6 — niveles de servicio

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Definir objetivos académicos claros y medibles en `docs/03-niveles-servicio.md`. Rama: `docs/sla`. No necesitas esperar mediciones para redactar el documento.

## Trabajo independiente

1. Explica brevemente SLA, SLO y SLI.
2. Usa estos objetivos comunes:

   | Indicador | Objetivo académico |
   |---|---|
   | Disponibilidad | ≥ 99 % mensual |
   | Latencia del health | p95 < 2 s |
   | Respuestas 5xx | < 1 % |
   | Pipeline previo al deploy | 100 % de despliegues con pruebas aprobadas |

3. Para cada indicador incluye fórmula, unidad, fuente y periodo. Disponibilidad de una muestra = respuestas exitosas / solicitudes × 100.
4. Aclara que son objetivos del caso de estudio, no una garantía contractual de Netlify.
5. Abre PR con el documento inicial.

Al final, usa los pocos datos disponibles solo como evidencia puntual. Si no existen suficientes muestras o historial, escribe “no evaluable”; no extrapoles un mes completo.

## Terminado cuando

- [ ] Los cuatro objetivos tienen indicador y método de cálculo.
- [ ] Se distinguen metas de resultados observados.
- [ ] Las limitaciones están explícitas.
