#!/bin/bash

set -e

echo "🚀 Starting Trackr Backend..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Start PostgreSQL and Redis
echo "📦 Starting PostgreSQL and Redis..."
docker-compose up -d postgres redis

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 5

# Check if migrate tool is installed
if ! command -v migrate &> /dev/null; then
    echo "⚠️  migrate tool not found. Installing..."
    brew install migrate 2>/dev/null || {
        echo "❌ Failed to install migrate. Please install manually:"
        echo "   brew install migrate"
        exit 1
    }
}

# Run migrations
echo "🔄 Running database migrations..."
MIGRATION_DIR="./migrations"
DB_URL="postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable"

if [ -d "$MIGRATION_DIR" ]; then
    migrate -path "$MIGRATION_DIR" -database "$DB_URL" up || {
        echo "⚠️  Migration failed, but continuing..."
    }
else
    echo "⚠️  Migrations directory not found, skipping..."
fi

# Set environment variables
export PORT=8080
export ENV=development
export DB_HOST=localhost
export DB_PORT=5432
export DB_USER=trackr_user
export DB_PASSWORD=trackr_password
export DB_NAME=trackr_db
export DB_SSLMODE=disable
export REDIS_HOST=localhost
export REDIS_PORT=6379
export JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
export JWT_EXPIRY_HOURS=24
export JWT_REFRESH_EXPIRY_HOURS=168
export CORS_ALLOWED_ORIGINS=*

echo "✅ Environment configured"
echo ""
echo "🚀 Starting Go server on port 8080..."
echo "   Press Ctrl+C to stop"
echo ""

# Start the server
go run cmd/api/main.go

