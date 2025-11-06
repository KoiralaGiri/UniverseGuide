# Celestial Navigator — System Design

## 1. Vision
- Build an immersive, multi-scale explorer where users fluidly zoom from a living Earth to the solar system, exoplanet neighborhoods, and deep-field galaxies.
- Fuse NASA and partner APIs (Planet, ISS, le-systeme-solaire, Illustris) into a unified storytelling layer with science-grade data and cinematic visuals.
- Ship an interactive UI by July that feels like a mission control table: touch-friendly globe, orbit visualizations, contextual media, and live alerts.

## 2. Experience Pillars
- **Living Earth:** 3D globe with real-time weather, natural events, satellites, ISS track, and APOD sky annotations.
- **Solar System Theater:** Planetary orbits, asteroid flybys, launch trajectories, and Mars/ Moon surface tiles with GIBS/WMTS imagery.
- **Exoplanet & Galaxy Atlas:** Procedurally generated planet renders, stellar data overlays, and connections to Illustris/other galaxy catalogs.
- **Narrative Media Tours:** Guided walkthrough of NASA’s Image & Video Library, TechPort innovations, and APOD stories mapped to celestial coordinates.

## 3. Data Inputs
| Domain | Primary APIs | Data Highlights | Update Cadence |
| --- | --- | --- | --- |
| Earth weather & imagery | GIBS, EPIC, EONET, Insight (Mars) | Cloud layers, fires, dust storms, polar imagery | Hourly to daily depending on source |
| Near-Earth objects | Asteroids NeoWs, SSD/CNEOS, DONKI | Asteroid tracks, impact risk, space weather alerts | Hourly to daily |
| Satellites & ISS | TLE API, Satellite Situation Center, wheretheiss.at | Orbital elements, positions, region tagging | Every few seconds to minutes |
| Media & storytelling | APOD, NASA Image/Video Library, TechPort, TechTransfer | Featured assets, patents, mission context | Daily to on-demand |
| Solar/planetary data | le-systeme-solaire, Planet API, Vesta/Mars/Moon WMTS | Orbital params, albedo, terrain tiles | Static to weekly |
| Deep universe | Exoplanet Archive, Illustris Project API | Planet candidates, galaxy simulations | Daily to static |

## 4. High-Level Architecture
```
[React/Three.js Client] <—WebSockets/HTTPS—> [Django API Gateway]
                                           ↘
                                [Celery & ETL Workers]
                                  |        |
                            [Postgres]  [Redis/Tile Cache]
                                  |
                         [Object Storage for media tiles]
```
- Django REST + optional GraphQL acts as the single API, normalizes external responses, handles auth, rate limiting, and caching.
- Celery workers pull from NASA/partner APIs, enrich data, and populate Postgres + Redis staged caches for low-latency visualization layers.
- Static tiles (terrain, imagery) stored in S3-compatible buckets or CDN (CloudFront/Cloudflare) to feed Three.js textures.

## 5. Backend Services
### Django API Gateway
- Django + Django REST Framework for REST endpoints; Graphene for GraphQL queries (useful for front-end slicing of large payloads).
- JWT or session tokens for user auth (future personalization). Admin panel to trigger manual refreshes.
- WebSocket support (Django Channels) for ISS position feeds, launch countdowns, and alert banners.

### Data Ingestion & Workers
- Celery beat schedules per API; tasks fan out to fetch, transform, and store.
- Rate-limiter and exponential backoff for APIs with strict quotas (Planet, Illustris).
- Inline geospatial transforms (e.g., convert orbital elements to Cartesian vectors for rendering) stored as JSONB in Postgres.

## 6. Storage Strategy
| Store | Purpose | Notes |
| --- | --- | --- |
| Postgres + PostGIS | Authoritative catalog: planets, satellites, launches, media metadata, tileset manifests | Spatial indices for bounding-box queries, timeline tables for events |
| Redis | Cache of latest live feeds (ISS, DONKI alerts) and precomputed Three.js buffers | Expire aggressively for live layers |
| Object Storage (S3/MinIO) | High-res textures, APOD assets, storyline scripts | Version assets, serve via CDN |

## 7. Frontend & Visualization
- Next.js + React for routing, server-side rendering of content pages, and API proxying for secrets.
- Three.js + react-three-fiber for multi-scene rendering: Earth globe, solar orrery, deep-space cube map.
- Deck.gl overlays for 2D/3D data layers (storms, satellite swarms, launch pads).
- Zustand or Redux Toolkit for client state; incorporate WebGL performance budgeting (LOD, frustum culling, instanced meshes).

## 8. Core Feature Modules
### EarthOps Globe
- Base from GIBS Blue Marble + EPIC layers; dynamic shaders for day/night terminator.
- Weather overlays: NASA GIBS (MODIS) + Insight/Mars layers when switching planet context.
- Satellite + ISS trails computed from TLE/SSC data; highlight key missions with tooltips.
- APOD sky compass: plot RA/Dec on celestial sphere and project onto local sky view.

### Solar System Navigator
- Orbital mechanics using SSD/CNEOS & le-systeme-solaire parameters to render planet/asteroid orbits.
- DONKI CME trajectories and asteroid close-approach arcs visualized with animated splines.
- Launch tracker: integrate TechPort + public launch manifest; display historical launch pads, trajectories, re-entry footprints.

### Exoplanet & Galaxy Explorer
- Fetch Exoplanet Archive datasets; generate procedural 3D planet meshes based on radius, temperature, star type.
- Illustris data for galaxy distribution; convert to point clouds and allow zoom out to cosmic web.
- Bookmarking “discoveries” to create sharable tours.

### Media & Knowledge Tours
- NASA Image/Video Library search ingested nightly; build curated storylines (e.g., “Mars Dust Storm 2020”).
- TechTransfer and TechPort cards surfaced contextually (click a satellite to see related patents/tech).

## 9. Data Refresh & Messaging
| Feed | Method | Frequency | Delivery |
| --- | --- | --- | --- |
| ISS / satellites | Poll TLE + wheretheiss.at | 5–15 sec | WebSocket push |
| Weather & events | Celery beat + API fetch | 30–60 min | REST cache |
| APOD / Media | Scheduled fetch at UTC midnight | Daily | REST + CDN |
| Asteroids / DONKI | Hourly | REST + WebSocket alerts |
| Exoplanet / Illustris | Daily/offline | REST |

## 10. Deployment & Infra
- Containerize (Docker) services: `web`, `worker`, `scheduler`, `nginx`.
- Use AWS (or Render/Fly) with managed Postgres + Redis; enable autoscaling for worker pool during NASA event surges.
- Infrastructure as Code (Pulumi/Terraform) for repeatable environments.
- Observability: Prometheus/Grafana or OpenTelemetry; alert on API failure rates, worker lag, WebGL bundle errors.

## 12. Risks & Mitigations
- **API rate limits / downtime:** Cache via Postgres + Redis, expose stale-but-fresh fallback timestamps.
- **Data volume & rendering cost:** Implement level-of-detail tiling, request paging, and lazy loading of heavy catalogs (Illustris).
- **Time-to-July:** Prioritize EarthOps + Solar System features for MVP; ship exoplanet/galaxy explorer as progressive module.
- **Licensing & terms:** Review NASA/Public Domain vs. Planet commercial terms; store attribution metadata per asset.

## 13. Next Steps
1. Confirm NASA/Planet API access keys and quotas.
2. Sketch UI flows (Earth view, Solar view, Explorer view) to guide component decomposition.
3. Scaffold Django + Next.js repos with shared contract (OpenAPI/GraphQL schema) and begin implementing ingestion tasks.
