# Quick Start Guide - Trackr Go Backend

## 🚀 Getting Started

### Prerequisites

1. **Go 1.22+** - [Install Go](https://golang.org/dl/)
2. **PostgreSQL 16+** - [Install PostgreSQL](https://www.postgresql.org/download/)
3. **Redis 7+** - [Install Redis](https://redis.io/download/)
4. **Docker & Docker Compose** (optional, recommended)

### Option 1: Using Docker (Easiest)

1. **Navigate to backend-go directory:**
   ```bash
   cd backend-go
   ```

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```
   This starts:
   - PostgreSQL on port 5432
   - Redis on port 6379
   - API server on port 8080

3. **Run migrations:**
   ```bash
   # Install migrate CLI if needed
   brew install migrate  # macOS
   # or
   go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
   
   # Run migrations
   make migrate-up
   # or
   ./scripts/migrate-up.sh
   ```

4. **Verify server is running:**
   ```bash
   curl http://localhost:8080/health
   ```
   Should return: `{"status":"OK"}`

### Option 2: Manual Setup

1. **Install dependencies:**
   ```bash
   cd backend-go
   go mod download
   ```

2. **Set up PostgreSQL:**
   ```bash
   createdb trackr_db
   ```

3. **Set up Redis:**
   ```bash
   redis-server
   ```

4. **Create .env file:**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

5. **Run migrations:**
   ```bash
   make migrate-up
   ```

6. **Start server:**
   ```bash
   make run
   # or
   go run cmd/api/main.go
   ```

## 📝 First Steps

### 1. Create a User

```bash
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "name": "John Doe",
    "username": "johndoe",
    "password": "password123"
  }'
```

**Response:**
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "user": {
    "id": "...",
    "email": "user@example.com",
    "name": "John Doe",
    "username": "johndoe"
  }
}
```

### 2. Login

```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### 3. Create a Goal (Authenticated)

```bash
TOKEN="your_access_token_here"

curl -X POST http://localhost:8080/api/v1/goals \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "title": "Run Daily",
    "description": "Run 30 minutes every day",
    "frequency": "daily"
  }'
```

### 4. Create a Check-in

```bash
GOAL_ID="your_goal_id_here"

curl -X POST http://localhost:8080/api/v1/goals/$GOAL_ID/checkins \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "note": "Ran 5km today",
    "value": 5.0
  }'
```

### 5. Get Streaks

```bash
curl -X GET http://localhost:8080/api/v1/streaks \
  -H "Authorization: Bearer $TOKEN"
```

## 🔗 API Endpoints

### Authentication (No Auth Required)
- `POST /api/v1/auth/signup` - Register
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/refresh` - Refresh token

### Protected Endpoints (Require Bearer Token)
- `GET /api/v1/auth/me` - Get current user
- `GET /api/v1/users/me` - Get current user
- `GET /api/v1/users/:id` - Get user by ID
- `GET /api/v1/users/:id/followers` - Get followers
- `GET /api/v1/users/:id/following` - Get following
- `POST /api/v1/users/follow/:id` - Follow user
- `DELETE /api/v1/users/follow/:id` - Unfollow user
- `GET /api/v1/users/search?q=query` - Search users
- `POST /api/v1/goals` - Create goal
- `GET /api/v1/goals` - Get user's goals
- `GET /api/v1/goals/:id` - Get goal
- `PATCH /api/v1/goals/:id` - Update goal
- `DELETE /api/v1/goals/:id` - Delete goal
- `POST /api/v1/goals/:id/checkins` - Create check-in
- `GET /api/v1/goals/:id/checkins` - Get check-ins
- `GET /api/v1/feed` - Get activity feed
- `GET /api/v1/streaks` - Get user's streaks
- `GET /api/v1/streaks/:goal_id` - Get streak for goal

## 🐛 Troubleshooting

### Server won't start
- Check if port 8080 is available: `lsof -i :8080`
- Verify PostgreSQL is running: `pg_isready`
- Verify Redis is running: `redis-cli ping`

### Database connection errors
- Check `.env` file exists and has correct DB credentials
- Verify PostgreSQL is running: `pg_isready`
- Check database exists: `psql -l | grep trackr_db`

### Migration errors
- Make sure PostgreSQL is running
- Check database exists: `psql -d trackr_db -c "\dt"`
- Try running migrations manually: `migrate -path migrations -database "postgres://..." up`

### "Command not found: go"
- Install Go from https://golang.org/dl/
- Add Go to your PATH: `export PATH=$PATH:/usr/local/go/bin`

## 📚 Next Steps

1. Read `README.md` for detailed documentation
2. Check `ARCHITECTURE.md` for system architecture
3. See `SWIFT_API_EXAMPLES.md` for iOS integration
4. Review `IMPLEMENTATION_STATUS.md` for what's implemented

## ✅ Verify Installation

Run these commands to verify everything works:

```bash
# Health check
curl http://localhost:8080/health

# Create user
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","name":"Test","username":"test","password":"test123"}'

# Should return 201 with user data
```

If all commands work, you're ready to go! 🎉

