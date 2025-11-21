# 🚀 Run Tests - Quick Guide

## Current Status
- ✅ PostgreSQL is running
- ✅ Redis is running (PONG)
- ❌ Go is not installed
- ❌ Database needs to be created
- ❌ Migrations need to run

## Option 1: Install Go and Run (Recommended for Development)

### 1. Install Go
```bash
# macOS
brew install go

# Or download from: https://golang.org/dl/
```

### 2. Set up Database
```bash
cd backend-go

# Create database
createdb trackr_db

# Install migrate CLI
brew install migrate

# Run migrations
make migrate-up
```

### 3. Install Dependencies & Run
```bash
# Install Go dependencies
go mod download

# Start server
make run
# or
go run cmd/api/main.go
```

### 4. Run Tests
```bash
# Automated tests
./test_api.sh

# Or test manually (see below)
```

## Option 2: Use Docker (Easiest)

### 1. Install Docker Desktop
Download from: https://www.docker.com/products/docker-desktop

### 2. Start Everything
```bash
cd backend-go

# Start PostgreSQL, Redis, and API
docker-compose up -d

# Wait for services to start
sleep 10

# Check logs
docker-compose logs api

# Test health check
curl http://localhost:8080/health
```

### 3. Run Migrations (if not auto-run)
```bash
# Install migrate CLI
brew install migrate

# Run migrations
make migrate-up
```

### 4. Test API
```bash
./test_api.sh
```

## Quick Test Commands

Once server is running on `http://localhost:8080`:

### 1. Health Check
```bash
curl http://localhost:8080/health
```

### 2. Signup
```bash
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@trackr.com",
    "name": "Test User",
    "username": "testuser",
    "password": "password123"
  }'
```

### 3. Create Goal
```bash
# Save token from signup response first
TOKEN="your_access_token_here"

curl -X POST http://localhost:8080/api/v1/goals \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Run Daily",
    "description": "Run 5km every day",
    "frequency": "daily"
  }'
```

### 4. Create Post
```bash
# Use the goal_id from previous response
curl -X POST http://localhost:8080/api/v1/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "caption": "Just completed my run! 🏃",
    "goal_id": "goal-uuid",
    "image_url": "https://example.com/image.jpg"
  }'
```

### 5. Get Feed
```bash
curl http://localhost:8080/api/v1/feed \
  -H "Authorization: Bearer $TOKEN"
```

### 6. Like Post
```bash
curl -X POST http://localhost:8080/api/v1/posts/POST_ID/like \
  -H "Authorization: Bearer $TOKEN"
```

### 7. Comment
```bash
curl -X POST http://localhost:8080/api/v1/posts/POST_ID/comments \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text": "Great job! 💪"}'
```

## Troubleshooting

### Database doesn't exist
```bash
createdb trackr_db
```

### Migrations fail
```bash
# Check if migrate CLI is installed
which migrate

# Install if needed
brew install migrate

# Run manually
migrate -path migrations -database "postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable" up
```

### Server won't start
- Check if port 8080 is free: `lsof -i :8080`
- Check PostgreSQL: `pg_isready`
- Check Redis: `redis-cli ping`

### Can't connect to database
Check your `.env` file or environment variables:
- `DB_HOST=localhost`
- `DB_PORT=5432`
- `DB_USER=your_user`
- `DB_PASSWORD=your_password`
- `DB_NAME=trackr_db`

## Next Steps

1. **Choose Option 1 or 2** above
2. **Install prerequisites** (Go or Docker)
3. **Set up database** and run migrations
4. **Start server**
5. **Run tests** with `./test_api.sh`

Happy testing! 🎉

