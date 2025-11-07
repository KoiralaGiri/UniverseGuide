# UniverseGuide - Initialization Commands Reference

This document provides step-by-step commands to initialize Django apps/modules and Next.js project structure.

## Quick Start (Automated)

Run the initialization script:
```bash
./scripts/dev/init-project.sh
```

## Manual Setup Commands

### 1. Django API Setup

```bash
cd apps/api

# Install Django and dependencies
pip install django djangorestframework django-cors-headers django-environ django-channels graphene-django celery redis

# Initialize Django project (if not done)
django-admin startproject universeguide .

# Move settings to settings/ directory
mkdir -p universeguide/settings
mv universeguide/settings.py universeguide/settings/base.py
touch universeguide/settings/__init__.py

# Create Django apps/modules
python manage.py startapp core modules/core
python manage.py startapp earthops modules/earthops
python manage.py startapp solar modules/solar
python manage.py startapp media modules/media
python manage.py startapp auth modules/auth

# Create __init__.py files for modules
touch modules/__init__.py
touch modules/core/__init__.py
touch modules/earthops/__init__.py
touch modules/solar/__init__.py
touch modules/media/__init__.py
touch modules/auth/__init__.py

# Create GraphQL structure
mkdir -p graphql
touch graphql/__init__.py
touch graphql/schema.py

# Create Channels structure
mkdir -p channels
touch channels/__init__.py
touch channels/routing.py
touch channels/consumers.py

# Create serializers, services, middleware
mkdir -p serializers services middleware
touch serializers/__init__.py
touch services/__init__.py
touch middleware/__init__.py
```

### 2. Celery Ingestion Setup

```bash
cd apps/ingestion

# Create celery.py
cat > celery.py << 'EOF'
from celery import Celery
import os

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'universeguide.settings.base')

app = Celery('universeguide')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
EOF

# Create __init__.py
touch __init__.py

# Create source API folders (one per API)
mkdir -p sources/{apod,neo,dONKI,eonet,epic,exoplanet,gibs,iss,tle,techport,techtransfer,ssd_cneos,le_systeme_solaire,illustris,planet}

# Create standard files for each API source
for dir in sources/*/; do
    touch "${dir}__init__.py"
    touch "${dir}fetchers.py"
    touch "${dir}transforms.py"
    touch "${dir}tasks.py"
done

touch sources/__init__.py

# Create other ingestion folders
mkdir -p schedules pipelines storage telemetry
touch schedules/__init__.py
touch pipelines/__init__.py
touch storage/__init__.py
touch telemetry/__init__.py
```

### 3. Next.js Client Setup

```bash
cd apps/client

# Initialize Next.js project
npx create-next-app@latest . --typescript --tailwind --app --no-src --import-alias "@/*" --yes

# OR if that fails, create manually:
npm init -y
npm install next@latest react@latest react-dom@latest typescript @types/react @types/node
npm install -D @types/node @types/react @types/react-dom

# Create app directory structure
mkdir -p src/app/{earthops,solar,explorer,tours}
mkdir -p src/components/{ui,layout,globe}
mkdir -p src/features/{iss-tracker,exoplanet-gallery,asteroid-tracker}
mkdir -p src/lib/{api,utils,three}
mkdir -p src/scenes/{earth,solar-system,deep-space}
mkdir -p src/state/{stores,queries}
mkdir -p src/styles
mkdir -p src/tests

# Create placeholder files
touch src/app/layout.tsx
touch src/app/page.tsx
touch src/lib/api/client.ts
touch src/lib/utils/index.ts
```

### 4. Shared Packages Setup

```bash
# TypeScript packages
cd packages/js/shared-schemas
npm init -y
npm install zod  # or io-ts for schema validation
touch index.ts

cd ../ui-toolkit
npm init -y
npm install react react-dom
touch index.tsx

# Python packages
cd ../../py/sdk
touch __init__.py
touch nasa_client.py

cd ../utils
touch __init__.py
touch constants.py
```

### 5. Django Settings Configuration

After creating the Django project, you'll need to configure `apps/api/universeguide/settings/base.py`:

```python
# Add to INSTALLED_APPS
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'corsheaders',
    'channels',
    'graphene_django',
    'modules.core',
    'modules.earthops',
    'modules.solar',
    'modules.media',
    'modules.auth',
]

# Add middleware
MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    # ... other middleware
]
```

### 6. Create Requirements Files

```bash
# For Django API
cd apps/api
pip freeze > requirements.txt

# For Celery Ingestion
cd ../ingestion
pip freeze > requirements.txt
```

### 7. Database Migrations

```bash
cd apps/api
python manage.py makemigrations
python manage.py migrate
```

## Verification

Check that all directories and files were created:

```bash
# Count Django apps
ls -d apps/api/modules/*/ | wc -l

# Count API sources
ls -d apps/ingestion/sources/*/ | wc -l

# Check Next.js structure
ls -la apps/client/src/
```

## Common Django Commands

```bash
# Create a new model migration
python manage.py makemigrations <app_name>

# Apply migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run development server
python manage.py runserver

# Start Celery worker
celery -A celery worker --loglevel=info

# Start Celery beat
celery -A celery beat --loglevel=info
```

## Common Next.js Commands

```bash
cd apps/client

# Development server
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Run tests
npm test

# Type checking
npm run type-check
```

