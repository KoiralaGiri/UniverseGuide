# UniverseGuide

> An immersive, multi-scale celestial explorer powered by NASA and partner APIs. Zoom from a living Earth to the solar system, exoplanet neighborhoods, and deep-field galaxies.

## 🚀 Quick Start

### Prerequisites

- **Node.js** >= 18.0.0
- **Python** >= 3.11
- **Docker** and **Docker Compose** (for local development)
- **NASA API Key** ([Get one here](https://api.nasa.gov/))

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd UniverseGuide
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your API keys
   ```

3. **Start all services**
   ```bash
   make setup
   # or manually:
   make install
   make dev-up
   ```

4. **Access the application**
   - **Client**: http://localhost:3000
   - **API**: http://localhost:8000
   - **API Docs**: http://localhost:8000/api/docs
   - **Flower (Celery)**: http://localhost:5555
   - **MinIO Console**: http://localhost:9001

## 📁 Project Structure

This is a monorepo containing:

- **`apps/client`** - Next.js frontend with Three.js visualizations
- **`apps/api`** - Django REST/GraphQL API gateway
- **`apps/ingestion`** - Celery workers for data ingestion from NASA/partner APIs
- **`packages/`** - Shared TypeScript and Python libraries
- **`infra/`** - Infrastructure as Code (Terraform/Pulumi)
- **`docs/`** - Project documentation

See [`docs/org.md`](docs/org.md) for detailed directory structure.

---

## 🗂️ Complete Directory Structure Explained

This section explains what every directory and file does in plain English, so you know exactly where to put your code and how everything connects.

### How Everything Works Together (The Big Picture)

Think of UniverseGuide like a restaurant:
- **Frontend (`apps/client`)** = The dining room where customers (users) see and interact with everything
- **API (`apps/api`)** = The kitchen that prepares and serves data to the frontend
- **Ingestion (`apps/ingestion`)** = The delivery service that goes out to NASA and other sources to get fresh ingredients (data)
- **Packages** = Shared tools and recipes that both the kitchen and delivery service use

The flow: **Ingestion** fetches data from NASA → stores it → **API** processes and serves it → **Frontend** displays it beautifully in 3D.

---

### 📱 Frontend (`apps/client/`)

This is what users see and interact with. Built with Next.js (React framework) and Three.js (3D graphics).

#### `apps/client/src/app/` - Pages & Routes
- **`layout.tsx`** - The main wrapper that wraps every page (like a website template)
- **`page.tsx`** - The home page users see first
- **`earthops/`** - All pages related to the Earth view (3D globe, weather, ISS tracking)
- **`solar/`** - All pages for the solar system view (planets, asteroids, orbits)
- **`explorer/`** - Pages for exploring exoplanets and deep space
- **`tours/`** - Guided tour pages through NASA's media library

**What to put here:** Create new page files (like `page.tsx`) in these folders to add new routes.

#### `apps/client/src/components/` - Reusable UI Pieces
- **`ui/`** - Basic building blocks (buttons, cards, inputs, dialogs)
- **`layout/`** - Page structure components (headers, footers, sidebars, navigation)
- **`globe/`** - 3D Earth globe components and controls

**What to put here:** Any component that can be reused across multiple pages goes here. For example, a "Satellite Tracker" component would go in `globe/` if it's Earth-related.

#### `apps/client/src/features/` - Complete Features
- **`iss-tracker/`** - Everything needed for the International Space Station tracker feature
- **`exoplanet-gallery/`** - Everything for browsing exoplanets
- **`asteroid-tracker/`** - Everything for tracking near-Earth asteroids

**What to put here:** Self-contained features that have their own components, logic, and state. Each feature folder can have its own components, hooks, and utilities.

#### `apps/client/src/scenes/` - 3D Visualizations
- **`earth/`** - Three.js scenes for Earth visualization (globe, weather layers, satellite orbits)
- **`solar-system/`** - Three.js scenes for solar system (planets, orbits, asteroid paths)
- **`deep-space/`** - Three.js scenes for galaxies, stars, exoplanets

**What to put here:** Complex 3D scene setups using Three.js. These are the "worlds" users explore.

#### `apps/client/src/lib/` - Utilities & Helpers
- **`api/`** - Functions to call the backend API (`client.ts` is the main API client)
- **`utils/`** - Helper functions (date formatting, calculations, etc.)
- **`three/`** - Three.js utilities and helpers (camera controls, lighting setups, etc.)

**What to put here:** Code that doesn't belong to a specific component but is used by many. Think of it as your toolbox.

#### `apps/client/src/state/` - Data Management
- **`stores/`** - Global state management (using Zustand or similar)
- **`queries/`** - API data fetching and caching (using React Query)

**What to put here:** Where you manage data that needs to be shared across components or cached from the API.

#### `apps/client/src/styles/` - Styling
- Global CSS, theme files, and styling utilities

#### `apps/client/src/tests/` - Frontend Tests
- Unit tests, component tests, and integration tests for the frontend

#### `apps/client/public/` - Static Files
- Images, fonts, favicons, and other files served directly (not processed by Next.js)

---

### 🔧 Backend API (`apps/api/`)

This is the server that handles requests from the frontend, processes data, and talks to the database.

#### `apps/api/modules/` - Business Logic Modules
These are Django "apps" (modules) that handle different parts of the system:

- **`core/`** - Core functionality and shared models
  - `models.py` - Database table definitions
  - `views.py` - API endpoints (REST endpoints)
  - `admin.py` - Django admin panel configuration
  - `serializers.py` - Converts database models to JSON (if using DRF)
  - `tests.py` - Tests for this module
  - `migrations/` - Database migration files (tracks database schema changes)

- **`auth/`** - User authentication and authorization
  - Handles login, registration, user permissions

- **`earthops/`** - Earth-related data and endpoints
  - Weather data, natural events, Earth observation endpoints

- **`solar/`** - Solar system data
  - Planets, asteroids, orbits, launch trajectories

- **`media/`** - NASA media library integration
  - Images, videos, and media metadata

**What to put here:** 
- New database models go in `models.py`
- New API endpoints go in `views.py` (or create `urls.py` in the module)
- Business logic that doesn't fit in views goes in `services/`

#### `apps/api/graphql/` - GraphQL API
- **`schema.py`** - GraphQL schema definitions (alternative to REST API)
- Allows frontend to request exactly the data it needs

#### `apps/api/channels/` - WebSocket Support
- **`consumers.py`** - Handles WebSocket connections (for real-time updates)
- **`routing.py`** - Routes WebSocket connections to the right handlers
- Used for live updates like ISS position, real-time weather, etc.

#### `apps/api/serializers/` - Data Formatting
- Converts Python objects (models) to JSON format for API responses
- Validates incoming data from frontend

#### `apps/api/services/` - Business Logic
- Complex business logic that doesn't belong in views or models
- Example: Calculating satellite positions, processing image data

#### `apps/api/middleware/` - Request Processing
- Code that runs on every request (authentication, logging, rate limiting)

#### `apps/api/universeguide/` - Django Project Configuration
- **`settings/base.py`** - Main Django settings (database, installed apps, etc.)
- **`urls.py`** - Root URL routing (connects URLs to views)
- **`wsgi.py`** - Entry point for production servers
- **`asgi.py`** - Entry point for async servers (WebSockets)

#### `apps/api/tests/` - Backend Tests
- Integration tests and API contract tests

---

### 📥 Data Ingestion (`apps/ingestion/`)

This service runs in the background, fetching data from NASA and other APIs, then storing it in the database.

#### `apps/ingestion/sources/` - API Integrations
One folder per external API source. Each has:
- **`fetchers.py`** - Code that calls the external API and downloads data
- **`transforms.py`** - Code that converts external API data into our database format
- **`tasks.py`** - Celery tasks that schedule when to fetch data

**Current sources:**
- **`apod/`** - Astronomy Picture of the Day
- **`neo/`** - Near Earth Objects (asteroids)
- **`iss/`** - International Space Station position
- **`exoplanet/`** - Exoplanet data
- **`eonet/`** - Earth Observatory Natural Event Tracker (fires, storms, etc.)
- **`epic/`** - Earth Polychromatic Imaging Camera
- **`gibs/`** - Global Imagery Browse Services (satellite imagery)
- **`tle/`** - Two-Line Element (satellite orbital data)
- **`dONKI/`** - Space Weather Database
- **`techport/`** - NASA Technology Portfolio
- **`techtransfer/`** - NASA Technology Transfer
- **`ssd_cneos/`** - Solar System Dynamics (comets, asteroids)
- **`le_systeme_solaire/`** - Solar system data (French API)
- **`illustris/`** - Galaxy simulation data
- **`planet/`** - Planet Labs satellite imagery

**What to put here:** When adding a new NASA API, create a new folder here with the three files above.

#### `apps/ingestion/pipelines/` - Data Processing Workflows
- Complex workflows that combine multiple sources or process data in stages

#### `apps/ingestion/schedules/` - Timing Configuration
- When to run each data fetch (daily, hourly, etc.)

#### `apps/ingestion/storage/` - Storage Helpers
- Code for saving data to database, Redis cache, or file storage (S3/MinIO)

#### `apps/ingestion/telemetry/` - Monitoring
- Logging, metrics, and error tracking for ingestion jobs

#### `apps/ingestion/celery.py` - Task Queue Configuration
- Configures Celery (the background job system) to run ingestion tasks

---

### 📦 Shared Packages (`packages/`)

Code shared between multiple services.

#### `packages/js/` - TypeScript/JavaScript Packages
- **`shared-schemas/`** - Data type definitions shared between frontend and backend
- **`ui-toolkit/`** - Reusable UI components used across the frontend

#### `packages/py/` - Python Packages
- **`sdk/`** - Reusable clients for calling NASA APIs (used by both API and ingestion)
- **`utils/`** - Common Python utilities (date helpers, constants, etc.)

---

### 🏗️ Infrastructure (`infra/`)

Code for deploying and running the application in production.

- **`terraform/`** - Infrastructure definitions (servers, databases, etc.)
- **`pulumi/`** - Alternative infrastructure tool
- **`docker/`** - Dockerfile definitions for containers
- **`k8s/`** - Kubernetes deployment configurations
- **`ci/`** - Continuous Integration pipelines (GitHub Actions, etc.)

---

### 📊 Data (`data/`)

Large files and datasets (not committed to git, but structure is tracked).

- **`seeds/`** - Sample data for local development
- **`exports/`** - Data exports for analysis
- **`tmp/`** - Temporary files during processing

---

### 🧪 Tests (`tests/`)

Cross-service integration tests.

- **`e2e/`** - End-to-end tests (tests the whole system working together)
- **`load/`** - Performance/load testing scripts
- **`contracts/`** - Tests that verify our API contracts with external services

---

### 📝 Documentation (`docs/`)

- **`SYSTEM_DESIGN.md`** - High-level architecture
- **`UniverseGuide_Tech_Architecture.md`** - Technology choices and setup
- **`UniverseGuide_API_Landscape.md`** - External APIs we use
- **`api_catalog.md`** - Our API documentation
- **`org.md`** - Detailed directory structure
- **`GIT_WORKFLOW.md`** - How to contribute code

---

### 🛠️ Scripts (`scripts/`)

Automation scripts for common tasks.

- **`dev/`** - Development helpers (setup, git workflows)
- **`maintenance/`** - Data cleanup, backups
- **`ops/`** - Deployment and operations scripts

---

## 🔄 How Data Flows Through the System

1. **Data Ingestion** (`apps/ingestion/`)
   - Celery workers run scheduled tasks
   - Each task calls an external API (NASA, etc.)
   - Data is transformed and saved to the database

2. **API Layer** (`apps/api/`)
   - Frontend makes HTTP requests to API endpoints
   - API reads from database, processes data
   - Returns JSON response to frontend
   - For real-time data (ISS position), uses WebSockets via Channels

3. **Frontend** (`apps/client/`)
   - React components fetch data from API
   - Three.js renders 3D visualizations
   - User interactions trigger API calls
   - State management keeps UI in sync

---

## 🎯 Where to Add New Features

**Adding a new NASA API:**
1. Create folder in `apps/ingestion/sources/new-api-name/`
2. Add `fetchers.py`, `transforms.py`, `tasks.py`
3. Create models in `apps/api/modules/core/models.py` (or appropriate module)
4. Add API endpoints in `apps/api/modules/core/views.py`
5. Add frontend components in `apps/client/src/features/new-feature/`

**Adding a new page:**
1. Create `page.tsx` in `apps/client/src/app/new-page/`
2. Add components in `apps/client/src/components/` or `features/`
3. Add API endpoints in `apps/api/modules/` if needed

**Adding a new 3D visualization:**
1. Create scene in `apps/client/src/scenes/new-scene/`
2. Add Three.js setup code
3. Connect to API endpoints for data

---

See [`docs/org.md`](docs/org.md) for the technical directory map.

## 🛠️ Development

### Common Commands

```bash
make help          # Show all available commands
make dev-up        # Start all services
make dev-down      # Stop all services
make dev-logs      # View service logs
make lint          # Run linters
make test          # Run tests
```

### Frontend Development

```bash
cd apps/client
npm install
npm run dev
```

### Backend Development

```bash
cd apps/api
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Data Ingestion

```bash
cd apps/ingestion
celery -A celery worker --loglevel=info
celery -A celery beat --loglevel=info
```

## 📚 Documentation

- **[System Design](docs/SYSTEM_DESIGN.md)** - High-level architecture and vision
- **[Tech Architecture](docs/UniverseGuide_Tech_Architecture.md)** - Technology stack and configuration
- **[API Landscape](docs/UniverseGuide_API_Landscape.md)** - Third-party API catalog
- **[API Catalog](docs/api_catalog.md)** - Detailed API documentation
- **[Directory Map](docs/org.md)** - Monorepo structure guide

## 🎯 Core Features

- **EarthOps Globe** - 3D Earth with real-time weather, natural events, satellites, and ISS tracking
- **Solar System Navigator** - Planetary orbits, asteroid flybys, launch trajectories
- **Exoplanet & Galaxy Explorer** - Procedurally generated planets, stellar data, galaxy simulations
- **Media & Knowledge Tours** - Guided walkthroughs of NASA's Image & Video Library

## 🔑 API Keys Required

- **NASA API Key** (Required) - [Get one here](https://api.nasa.gov/)
- **Le Système Solaire Token** (Required) - [Generate here](https://api.le-systeme-solaire.net/generatekey.html)
- **Illustris API Key** (Required) - [Register here](https://www.illustris-project.org/)
- **Planet Labs API Key** (Optional) - Commercial imagery

See [API Catalog](docs/api_catalog.md) for full details.

## 🧪 Testing

```bash
# Run all tests
make test

# Frontend tests
cd apps/client && npm test

# Backend tests
cd apps/api && pytest
cd apps/ingestion && pytest

# E2E tests
cd tests/e2e && npm test
```

## 🚢 Deployment

Infrastructure as Code is located in `infra/`. See deployment documentation for staging and production setup.

## 📝 Contributing

1. Create a feature branch
2. Make your changes
3. Run linters and tests
4. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

Built with data from NASA APIs, Planet Labs, Le Système Solaire, and the Illustris Project.

---

**Document version**: 0.1  
**Last updated**: November 2025

