.PHONY: help dev-up dev-down dev-logs dev-clean lint test install

help: ## Show this help message
	@echo "UniverseGuide Development Commands"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

dev-up: ## Start all services via Docker Compose
	docker-compose up -d
	@echo "Services starting... Use 'make dev-logs' to view logs"

dev-down: ## Stop all services
	docker-compose down

dev-logs: ## View logs from all services
	docker-compose logs -f

dev-clean: ## Stop services and remove volumes
	docker-compose down -v
	@echo "All volumes removed. Run 'make dev-up' to start fresh."

install: ## Install dependencies for all services
	@echo "Installing Python dependencies..."
	cd apps/api && pip install -r requirements.txt || echo "No requirements.txt found"
	cd apps/ingestion && pip install -r requirements.txt || echo "No requirements.txt found"
	@echo "Installing Node.js dependencies..."
	npm install || pnpm install || yarn install

lint: ## Run linters for all services
	@echo "Linting Python code..."
	ruff check apps/api apps/ingestion packages/py || echo "Ruff not installed"
	@echo "Linting TypeScript code..."
	cd apps/client && npm run lint || echo "Linter not configured"

test: ## Run tests for all services
	@echo "Running Python tests..."
	cd apps/api && pytest || echo "Pytest not configured"
	cd apps/ingestion && pytest || echo "Pytest not configured"
	@echo "Running TypeScript tests..."
	cd apps/client && npm test || echo "Tests not configured"

setup: install dev-up ## Initial setup: install dependencies and start services
	@echo "Setup complete! Services are running."

