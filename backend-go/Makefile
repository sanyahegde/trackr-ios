.PHONY: run test migrate-up migrate-down docker-up docker-down docker-build clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  make run          - Run the API server locally"
	@echo "  make test         - Run tests"
	@echo "  make migrate-up   - Run database migrations up"
	@echo "  make migrate-down - Rollback database migrations"
	@echo "  make docker-up    - Start Docker containers"
	@echo "  make docker-down  - Stop Docker containers"
	@echo "  make docker-build - Build Docker image"
	@echo "  make clean        - Clean build artifacts"

# Run the API server
run:
	@echo "🚀 Starting API server..."
	go run cmd/api/main.go

# Run tests
test:
	@echo "🧪 Running tests..."
	go test -v ./...

# Run migrations up
migrate-up:
	@echo "📊 Running migrations..."
	migrate -path migrations -database "postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable" up

# Rollback migrations
migrate-down:
	@echo "📊 Rolling back migrations..."
	migrate -path migrations -database "postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable" down 1

# Start Docker containers
docker-up:
	@echo "🐳 Starting Docker containers..."
	docker-compose up -d

# Stop Docker containers
docker-down:
	@echo "🐳 Stopping Docker containers..."
	docker-compose down

# Build Docker image
docker-build:
	@echo "🔨 Building Docker image..."
	docker-compose build

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	go clean
	rm -f trackr-api

