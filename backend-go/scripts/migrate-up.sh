#!/bin/bash

# Migration script to run migrations up
set -e

echo "📊 Running database migrations..."

# Get database URL from environment or use default
DB_URL="${DATABASE_URL:-postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable}"

# Run migrations
migrate -path migrations -database "$DB_URL" up

echo "✅ Migrations completed successfully"

