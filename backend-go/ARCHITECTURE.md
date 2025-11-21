# Trackr Backend - Architecture Overview

## 🏗️ System Architecture

The Trackr backend follows **clean architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                    HTTP Layer (Gin)                     │
│                   /api/v1/* endpoints                   │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                   Handlers Layer                        │
│   (HTTP request/response, validation, error handling)   │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                   Services Layer                        │
│        (Business logic, orchestration, rules)           │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                 Repository Layer                        │
│        (Data access, queries, database operations)      │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│              Database (PostgreSQL)                      │
│              Redis (Cache/Jobs)                         │
└─────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
backend-go/
├── cmd/
│   └── api/
│       └── main.go              # Application entry point, server setup
│
├── internal/
│   ├── auth/                    # Authentication logic (future)
│   │
│   ├── config/                  # Configuration management
│   │   └── config.go           # Loads env vars, validates config
│   │
│   ├── database/                # Database connection & migration
│   │   └── database.go         # PostgreSQL connection, auto-migrate
│   │
│   ├── handlers/                # HTTP handlers (controllers)
│   │   ├── auth.go             # Auth endpoints (signup, login, me)
│   │   ├── goals.go            # Goal endpoints
│   │   ├── health.go           # Health check
│   │   └── progress.go         # Progress/check-in endpoints
│   │
│   ├── middleware/              # HTTP middleware
│   │   └── auth.go             # JWT auth middleware, CORS
│   │
│   ├── models/                  # Data models (GORM)
│   │   └── models.go           # All entity models
│   │
│   ├── repository/              # Data access layer
│   │   ├── user_repository.go
│   │   ├── goal_repository.go
│   │   ├── checkin_repository.go
│   │   ├── friendship_repository.go
│   │   └── streak_repository.go
│   │
│   ├── services/                # Business logic layer
│   │   └── (To be implemented)
│   │
│   └── redis/                   # Redis connection
│       └── redis.go            # Redis client setup
│
├── pkg/                         # Public packages
│   ├── jwt/                     # JWT utilities
│   │   └── jwt.go              # Token generation, validation
│   └── password/                # Password hashing
│       └── password.go         # bcrypt hash/check
│
├── migrations/                  # Database migrations (SQL)
│   ├── 000001_create_users.up.sql
│   ├── 000002_create_goals.up.sql
│   ├── 000003_create_checkins.up.sql
│   ├── 000004_create_friendships.up.sql
│   ├── 000005_create_streaks.up.sql
│   ├── 000006_create_challenges.up.sql
│   ├── 000007_create_challenge_participants.up.sql
│   ├── 000008_create_achievements.up.sql
│   └── 000009_create_activity_feed.up.sql
│
├── scripts/                     # Utility scripts
│   ├── migrate-up.sh
│   └── migrate-down.sh
│
├── docker-compose.yml           # Docker services (Postgres, Redis, API)
├── Dockerfile                   # API container definition
├── Makefile                     # Common tasks
├── go.mod                       # Go dependencies
└── .env.example                 # Environment variables template
```

## 🔑 Key Design Decisions

### 1. **Clean Architecture**
- **Handlers**: Handle HTTP concerns only
- **Services**: Business logic (to be implemented)
- **Repositories**: Data access only
- **Models**: Domain entities with GORM annotations

### 2. **UUID Primary Keys**
- All IDs use `uuid.UUID` instead of auto-increment integers
- Better for distributed systems
- Prevents ID enumeration attacks

### 3. **JWT Authentication**
- Access tokens (short-lived, 24 hours)
- Refresh tokens (long-lived, 7 days)
- Tokens stored in HTTP-only cookies (recommended) or Authorization header

### 4. **Repository Pattern**
- Abstracts database operations
- Makes testing easier
- Enables future database switching

### 5. **Migration-Based Schema**
- SQL migrations for version control
- Reproducible database setup
- Easy rollbacks

### 6. **Redis for Caching**
- Cache frequently accessed data
- Background job queues (future)
- Session storage (optional)

## 🔐 Authentication Flow

```
1. User signs up → POST /api/v1/auth/signup
   └─> Hash password with bcrypt
   └─> Create user in database
   └─> Generate JWT tokens
   └─> Return tokens + user

2. User logs in → POST /api/v1/auth/login
   └─> Verify email/password
   └─> Generate JWT tokens
   └─> Return tokens + user

3. Protected requests → Include "Authorization: Bearer <token>"
   └─> Middleware validates token
   └─> Extract user_id from claims
   └─> Continue to handler

4. Token refresh → POST /api/v1/auth/refresh
   └─> Validate refresh token
   └─> Generate new access token
   └─> Return new tokens
```

## 📊 Data Models

### Core Entities

1. **User**: Email, name, username, password hash
2. **Goal**: User's habit/goal with frequency
3. **CheckIn**: Progress update for a goal
4. **Friendship**: Follow relationship between users
5. **Streak**: Current/longest streak for goal
6. **Challenge**: Community challenges
7. **ChallengeParticipant**: User participation in challenges
8. **Achievement**: Badges/achievements earned
9. **ActivityFeed**: Feed items (check-ins, streaks, achievements)

### Relationships

- User → Goals (one-to-many)
- User → CheckIns (one-to-many)
- Goal → CheckIns (one-to-many)
- User → User (many-to-many via Friendships)
- User → Streaks (one-to-many)
- User → Achievements (one-to-many)
- Challenge → Participants (one-to-many)

## 🔄 Request Flow Example

**Creating a Check-in:**

```
1. iOS App → POST /api/v1/goals/:id/checkins
   {
     "note": "Did 30 minutes of exercise",
     "value": 30.0
   }

2. Auth Middleware
   └─> Validates JWT token
   └─> Extracts user_id
   └─> Stores in context

3. CheckIn Handler
   └─> Validates request body
   └─> Gets user_id from context
   └─> Calls CheckInService.Create()

4. CheckIn Service (to be implemented)
   └─> Validates goal belongs to user
   └─> Creates check-in
   └─> Updates streak
   └─> Creates activity feed item
   └─> Returns check-in

5. CheckIn Repository
   └─> Inserts into database
   └─> Returns created record

6. Response → 201 Created
   {
     "id": "uuid",
     "goal_id": "uuid",
     "user_id": "uuid",
     "note": "Did 30 minutes of exercise",
     "value": 30.0,
     "timestamp": "2024-01-01T12:00:00Z"
   }
```

## 🚀 Future Enhancements

1. **Services Layer**: Implement business logic services
2. **Background Jobs**: Streak calculation, notifications
3. **Caching**: Redis cache for frequently accessed data
4. **Rate Limiting**: Prevent abuse
5. **Search**: Full-text search for users, goals
6. **Analytics**: Weekly/monthly statistics
7. **File Upload**: Image uploads for check-ins
8. **WebSockets**: Real-time notifications
9. **Unit Tests**: Comprehensive test coverage
10. **Integration Tests**: API endpoint testing

## 📝 Implementation Status

✅ **Completed:**
- Project structure
- Database models
- Migrations
- Repository layer (partial)
- JWT authentication
- Password hashing
- Docker setup
- Config management
- Redis connection
- Basic handlers (auth, goals, check-ins)
- Middleware (auth, CORS)
- Swift API examples
- Documentation

⚠️ **In Progress:**
- Service layer implementation
- Complete handlers for all endpoints
- Streak calculation logic
- Activity feed generation
- Challenge management

📋 **To Do:**
- Complete service layer
- Analytics endpoints
- Achievement system
- Background jobs
- Unit tests
- Integration tests
- Rate limiting
- Search functionality

## 🔒 Security Considerations

1. **Password Hashing**: bcrypt with default cost
2. **JWT Tokens**: HS256 signing, expiration enforced
3. **SQL Injection**: GORM uses parameterized queries
4. **CORS**: Configurable origins
5. **Input Validation**: Gin binding for request validation
6. **UUIDs**: Prevent ID enumeration

## 📈 Scalability

- **Horizontal Scaling**: Stateless API, can run multiple instances
- **Database**: PostgreSQL with proper indexing
- **Caching**: Redis for hot data
- **Background Jobs**: Redis streams for async tasks
- **Connection Pooling**: GORM manages database connections

## 🧪 Testing Strategy

1. **Unit Tests**: Services, repositories, utilities
2. **Integration Tests**: API endpoints with test database
3. **E2E Tests**: Full flow tests with real HTTP requests

## 📚 Documentation

- `README.md`: Setup and usage
- `ARCHITECTURE.md`: This file
- `SWIFT_API_EXAMPLES.md`: iOS client integration

## 🔗 Dependencies

- **Gin**: HTTP framework
- **GORM**: ORM
- **PostgreSQL**: Database
- **Redis**: Cache/jobs
- **JWT**: Authentication
- **bcrypt**: Password hashing
- **golang-migrate**: Database migrations

