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

