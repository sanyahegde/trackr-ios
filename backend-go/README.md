# Trackr Backend - Go API Server

Production-quality Go backend for Trackr, a social habit-tracking iOS app. Built with Go, PostgreSQL, Redis, and Gin framework.

## 🏗️ Architecture

This backend follows clean architecture principles:

```
backend-go/
├── cmd/
│   └── api/          # Application entry point
├── internal/
│   ├── auth/         # Authentication logic
│   ├── config/       # Configuration management
│   ├── database/     # Database connection
│   ├── handlers/     # HTTP handlers (controllers)
│   ├── middleware/   # HTTP middleware
│   ├── models/       # Data models
│   ├── repository/   # Data access layer
│   ├── services/     # Business logic layer
│   └── redis/        # Redis connection
├── migrations/       # Database migrations
├── pkg/              # Public packages
│   ├── jwt/          # JWT utilities
│   └── password/     # Password hashing
└── scripts/          # Utility scripts
```

## 🚀 Quick Start

### Prerequisites

- Go 1.22+
- PostgreSQL 16+
- Redis 7+
- Docker & Docker Compose (optional)

### Using Docker (Recommended)

1. **Start services:**
   ```bash
   docker-compose up -d
   ```

2. **Run migrations:**
   ```bash
   make migrate-up
   # or
   ./scripts/migrate-up.sh
   ```

3. **Run the server:**
   ```bash
   make run
   # or
   go run cmd/api/main.go
   ```

The API will be available at `http://localhost:8080`

### Manual Setup

1. **Install dependencies:**
   ```bash
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

4. **Configure environment:**
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
   ```

## 📊 Database Migrations

We use [golang-migrate](https://github.com/golang-migrate/migrate) for database migrations.

**Install migrate CLI:**
```bash
brew install migrate  # macOS
# or
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

**Run migrations:**
```bash
make migrate-up      # Apply all migrations
make migrate-down    # Rollback last migration
```

## 🔌 API Endpoints

### Authentication
- `POST /api/v1/auth/signup` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh` - Refresh access token
- `GET /api/v1/auth/me` - Get current user (protected)

### Users
- `GET /api/v1/users/me` - Get current user profile
- `GET /api/v1/users/:id` - Get user by ID
- `GET /api/v1/users/:id/followers` - Get user's followers
- `GET /api/v1/users/:id/following` - Get users they follow
- `POST /api/v1/users/follow/:id` - Follow a user
- `DELETE /api/v1/users/follow/:id` - Unfollow a user
- `GET /api/v1/users/search?q=query` - Search users

### Goals
- `POST /api/v1/goals` - Create a goal
- `GET /api/v1/goals` - Get user's goals
- `GET /api/v1/goals/:id` - Get goal by ID
- `PATCH /api/v1/goals/:id` - Update goal
- `DELETE /api/v1/goals/:id` - Delete goal

### Check-ins
- `POST /api/v1/goals/:id/checkins` - Create check-in
- `GET /api/v1/goals/:id/checkins` - Get check-ins for goal
- `GET /api/v1/feed` - Get activity feed (friends or global)

### Streaks
- `GET /api/v1/streaks` - Get user's streaks
- `GET /api/v1/streaks/:goal_id` - Get streak for specific goal

### Challenges
- `POST /api/v1/challenges` - Create challenge
- `GET /api/v1/challenges` - Get available challenges
- `POST /api/v1/challenges/:id/join` - Join challenge
- `GET /api/v1/challenges/:id/progress` - Get challenge progress

### Achievements
- `GET /api/v1/achievements` - Get user's achievements

### Analytics
- `GET /api/v1/analytics/weekly` - Weekly analytics
- `GET /api/v1/analytics/monthly` - Monthly analytics

## 🔐 Authentication

The API uses JWT (JSON Web Tokens) for authentication.

**Access Token:** Short-lived (24 hours by default)
**Refresh Token:** Long-lived (7 days by default)

Include the access token in the `Authorization` header:
```
Authorization: Bearer <access_token>
```

## 🛠️ Development

### Running Tests
```bash
make test
```

### Project Structure

- **Handlers**: HTTP request/response handling
- **Services**: Business logic (kept separate from handlers)
- **Repositories**: Database access layer
- **Models**: Data models with GORM annotations
- **Middleware**: Auth, CORS, logging, etc.

### Adding a New Feature

1. Create model in `internal/models/`
2. Create repository in `internal/repository/`
3. Create service in `internal/services/`
4. Create handler in `internal/handlers/`
5. Add routes in `cmd/api/main.go`

## 📦 Dependencies

- **Gin**: HTTP web framework
- **GORM**: ORM for database operations
- **JWT**: Authentication tokens
- **Redis**: Caching and background jobs
- **golang-migrate**: Database migrations

## 🌐 Environment Variables

See `.env.example` for all available environment variables.

Key variables:
- `PORT`: Server port (default: 8080)
- `DB_HOST`: PostgreSQL host
- `REDIS_HOST`: Redis host
- `JWT_SECRET`: Secret key for JWT signing

## 📱 iOS Integration

See `SWIFT_API_EXAMPLES.md` for Swift API client examples.

## 🐳 Docker

```bash
docker-compose up -d    # Start all services
docker-compose down     # Stop all services
docker-compose logs -f  # View logs
```

## 📝 License

MIT

