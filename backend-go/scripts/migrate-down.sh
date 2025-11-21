#!/bin/bash

# Migration script to rollback migrations
set -e

echo "📊 Rolling back database migrations..."

# Get database URL from environment or use default
DB_URL="${DATABASE_URL:-postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable}"

# Rollback one migration
migrate -path migrations -database "$DB_URL" down 1

echo "✅ Migration rollback completed"

