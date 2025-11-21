# 🧪 Testing Guide - Trackr Backend

## Prerequisites

Before testing, you need:

1. **Go 1.22+** installed
2. **PostgreSQL 16+** running
3. **Redis 7+** running (optional but recommended)
4. **Dependencies** installed

## Quick Setup

### Option 1: Using Docker (Recommended)

```bash
cd backend-go

# Start all services (PostgreSQL, Redis, API)
docker-compose up -d

# Wait a few seconds for services to start
sleep 5

# Run migrations
make migrate-up
# or manually:
# migrate -path migrations -database "postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable" up

# Start the API server (if not using docker-compose)
make run
# or
go run cmd/api/main.go
```

### Option 2: Manual Setup

1. **Start PostgreSQL:**
   ```bash
   # macOS with Homebrew
   brew services start postgresql@16
   
   # Create database
   createdb trackr_db
   ```

2. **Start Redis:**
   ```bash
   redis-server
   ```

3. **Install Go dependencies:**
   ```bash
   cd backend-go
   go mod download
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
   ```

## Automated Testing

Run the test script:

```bash
./test_api.sh
```

This will test:
- ✅ Health check
- ✅ User signup
- ✅ Goal creation
- ✅ Post creation
- ✅ Feed
- ✅ Like/unlike
- ✅ Comments
- ✅ Check-ins
- ✅ Streaks

## Manual Testing

### 1. Health Check

```bash
curl http://localhost:8080/health
```

**Expected:** `{"status":"OK"}`

### 2. User Signup

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

**Expected:** JSON with `access_token`, `refresh_token`, and `user`

### 3. Create Goal

```bash
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

**Expected:** Goal object with ID

### 4. Create Social Media Post

```bash
curl -X POST http://localhost:8080/api/v1/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "caption": "Just completed my daily run! 🏃💪",
    "goal_id": "goal-uuid-here",
    "image_url": "https://example.com/run.jpg"
  }'
```

**Expected:** Post object with likes_count, comments_count

### 5. Get Activity Feed

```bash
# Global feed
curl -X GET "http://localhost:8080/api/v1/feed" \
  -H "Authorization: Bearer $TOKEN"

# Friends-only feed
curl -X GET "http://localhost:8080/api/v1/feed?friends_only=true" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected:** Array of posts

### 6. Like Post

```bash
curl -X POST "http://localhost:8080/api/v1/posts/POST_ID/like" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected:** `{"liked": true}` or `{"liked": false}`

### 7. Comment on Post

```bash
curl -X POST "http://localhost:8080/api/v1/posts/POST_ID/comments" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Great job! Keep it up! 💪"
  }'
```

**Expected:** Comment object

### 8. Get Comments

```bash
curl -X GET "http://localhost:8080/api/v1/posts/POST_ID/comments" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected:** Array of comments

### 9. Create Check-in

```bash
curl -X POST "http://localhost:8080/api/v1/goals/GOAL_ID/checkins" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "note": "Ran 5km today!",
    "value": 5.0
  }'
```

**Expected:** Check-in object

### 10. Get Streaks

```bash
curl -X GET "http://localhost:8080/api/v1/streaks" \
  -H "Authorization: Bearer $TOKEN"
```

**Expected:** Array of streaks

## Complete Test Flow

1. **Create account** → Get token
2. **Create goal** → Get goal ID
3. **Create post** → Get post ID
4. **View feed** → See your post
5. **Like post** → Toggle like
6. **Comment** → Add comment
7. **Create check-in** → Update goal progress
8. **View streaks** → See streak calculation

## Troubleshooting

### "Connection refused"
- Check if server is running: `lsof -i :8080`
- Check if PostgreSQL is running: `pg_isready`
- Check if Redis is running: `redis-cli ping`

### "database does not exist"
- Create database: `createdb trackr_db`
- Run migrations: `make migrate-up`

### "table does not exist"
- Run migrations: `make migrate-up`

### "invalid token"
- Sign up again or login: `POST /api/v1/auth/login`
- Use the new `access_token`

## Expected Behavior

✅ **Goals:** Create, read, update, delete goals
✅ **Posts:** Create posts with captions, images
✅ **Feed:** View global or friends-only feed
✅ **Likes:** Like/unlike posts, see like counts
✅ **Comments:** Comment on posts, see comment counts
✅ **Check-ins:** Track goal progress with check-ins
✅ **Streaks:** Automatic streak calculation
✅ **Social:** Follow users, see their posts in feed

## Next Steps

After testing, you can:
1. Integrate with iOS app (see `SWIFT_API_EXAMPLES.md`)
2. Add image upload support
3. Add notifications
4. Add more social features

Happy testing! 🚀

