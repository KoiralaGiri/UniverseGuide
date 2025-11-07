#!/bin/bash
# UniverseGuide Setup Script
# This script initializes Django apps/modules and Next.js project structure

set -e

echo "🚀 UniverseGuide Project Initialization"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -d "apps/api" ] || [ ! -d "apps/client" ]; then
    echo "❌ Error: Please run this script from the UniverseGuide root directory"
    exit 1
fi

# ============================================================================
# DJANGO API SETUP
# ============================================================================
echo -e "${BLUE}📦 Setting up Django API...${NC}"

cd apps/api

# Check if Django is installed
if ! command -v django-admin &> /dev/null; then
    echo -e "${YELLOW}⚠️  Django not found. Installing Django...${NC}"
    pip install django djangorestframework django-cors-headers django-environ
fi

# Initialize Django project if not already done
if [ ! -f "manage.py" ]; then
    echo "Creating Django project..."
    django-admin startproject universeguide .
    
    # Move settings to settings/ directory
    mkdir -p universeguide/settings
    mv universeguide/settings.py universeguide/settings/base.py
    
    # Create __init__.py for settings
    touch universeguide/settings/__init__.py
    
    echo "✅ Django project created"
else
    echo "✅ Django project already exists"
fi

# Create Django apps/modules
echo ""
echo "Creating Django modules..."

# Core modules
python manage.py startapp core modules/core || echo "core app may already exist"
python manage.py startapp earthops modules/earthops || echo "earthops app may already exist"
python manage.py startapp solar modules/solar || echo "solar app may already exist"
python manage.py startapp media modules/media || echo "media app may already exist"
python manage.py startapp auth modules/auth || echo "auth app may already exist"

# Create __init__.py files
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

cd ../..

# ============================================================================
# CELERY INGESTION SETUP
# ============================================================================
echo ""
echo -e "${BLUE}📦 Setting up Celery Ingestion...${NC}"

cd apps/ingestion

# Create celery.py if it doesn't exist
if [ ! -f "celery.py" ]; then
    cat > celery.py << 'EOF'
from celery import Celery
import os

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'universeguide.settings.base')

app = Celery('universeguide')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
EOF
    echo "✅ celery.py created"
fi

# Create __init__.py for ingestion
touch __init__.py

# Create source API folders
mkdir -p sources/{apod,neo,dONKI,eonet,epic,exoplanet,gibs,iss,tle,techport,techtransfer,ssd_cneos,le_systeme_solaire,illustris,planet}
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

cd ../..

# ============================================================================
# NEXT.JS CLIENT SETUP
# ============================================================================
echo ""
echo -e "${BLUE}📦 Setting up Next.js Client...${NC}"

cd apps/client

# Check if Next.js is installed
if ! command -v npx &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js/npx not found. Please install Node.js first.${NC}"
else
    # Initialize Next.js if not already done
    if [ ! -f "package.json" ]; then
        echo "Creating Next.js project..."
        npx create-next-app@latest . --typescript --tailwind --app --no-src --import-alias "@/*" --yes || {
            # If create-next-app fails, create basic structure manually
            echo "Creating Next.js structure manually..."
            npm init -y
            npm install next@latest react@latest react-dom@latest typescript @types/react @types/node
        }
        echo "✅ Next.js project created"
    else
        echo "✅ Next.js project already exists"
    fi
    
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
fi

cd ../..

# ============================================================================
# PACKAGES SETUP
# ============================================================================
echo ""
echo -e "${BLUE}📦 Setting up shared packages...${NC}"

# TypeScript packages
cd packages/js/shared-schemas
if [ ! -f "package.json" ]; then
    npm init -y
    echo "✅ shared-schemas package initialized"
fi
touch index.ts
cd ../../..

cd packages/js/ui-toolkit
if [ ! -f "package.json" ]; then
    npm init -y
    echo "✅ ui-toolkit package initialized"
fi
touch index.tsx
cd ../../..

# Python packages
cd packages/py/sdk
touch __init__.py
touch nasa_client.py
cd ../..

cd packages/py/utils
touch __init__.py
touch constants.py
cd ../..

# ============================================================================
# FINAL SETUP
# ============================================================================
echo ""
echo -e "${GREEN}✅ Project structure initialized!${NC}"
echo ""
echo "Next steps:"
echo "1. Install Python dependencies:"
echo "   cd apps/api && pip install -r requirements.txt"
echo "   cd apps/ingestion && pip install -r requirements.txt"
echo ""
echo "2. Install Node.js dependencies:"
echo "   npm install"
echo ""
echo "3. Set up environment variables:"
echo "   cp .env.example .env.local"
echo "   # Edit .env.local with your API keys"
echo ""
echo "4. Run database migrations:"
echo "   cd apps/api && python manage.py migrate"
echo ""
echo "5. Start development:"
echo "   make dev-up"
echo ""

