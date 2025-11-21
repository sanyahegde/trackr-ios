# 🚀 START HERE - Testing Trackr Backend

## ✅ Current Status
- ✅ PostgreSQL is running
- ✅ Redis is running  
- ✅ Database `trackr_db` is created
- ❌ Go needs to be installed
- ❌ Migrations need to be run
- ❌ Server needs to be started

## 📋 Quick Start Steps

### Step 1: Install Go (Required)

**macOS (Homebrew):**
```bash
brew install go
```

**Or download manually:**
- Visit: https://golang.org/dl/
- Download macOS installer
- Install and restart terminal

**Verify installation:**
```bash
go version
# Should show: go version go1.22+ ...
```

### Step 2: Install Dependencies

```bash
cd /Users/sanyahegde/Desktop/trackr/backend-go
go mod download
```

### Step 3: Install Migration Tool

**macOS (Homebrew):**
```bash
brew install migrate
```

**Or install via Go:**
```bash
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
```

### Step 4: Run Migrations

```bash
# Make sure you're in backend-go directory
cd /Users/sanyahegde/Desktop/trackr/backend-go

# Run migrations
make migrate-up

# Or manually:
migrate -path migrations -database "postgres://$(whoami):@localhost:5432/trackr_db?sslmode=disable" up
```

**Verify migrations:**
```bash
psql -d trackr_db -c "\dt"
# Should show tables: users, goals, posts, etc.
```

### Step 5: Create .env File (if needed)

```bash
cd /Users/sanyahegde/Desktop/trackr/backend-go

cat > .env << EOF
PORT=8080
ENV=development
DB_HOST=localhost
DB_PORT=5432
DB_USER=$(whoami)
DB_PASSWORD=
DB_NAME=trackr_db
DB_SSLMODE=disable
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRY_HOURS=24
JWT_REFRESH_EXPIRY_HOURS=168
CORS_ALLOWED_ORIGINS=*
EOF
```

**Note:** Update `DB_USER` and `DB_PASSWORD` to match your PostgreSQL setup.

### Step 6: Start the Server

```bash
cd /Users/sanyahegde/Desktop/trackr/backend-go

# Option 1: Using Makefile
make run

# Option 2: Directly
go run cmd/api/main.go
```

**You should see:**
```
✅ Database connection established
✅ Database tables initialized
✅ Redis connection established (or warning if not connected)
🚀 Server starting on port 8080
```

### Step 7: Test the API

**In a new terminal window:**

```bash
cd /Users/sanyahegde/Desktop/trackr/backend-go

# Test health check
curl http://localhost:8080/health

# Run automated tests
./test_api.sh
```

## 🧪 Manual Testing

### 1. Health Check
```bash
curl http://localhost:8080/health
```
**Expected:** `{"status":"OK"}`

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
**Save the `access_token` from response**

### 3. Create Goal
```bash
TOKEN="paste_access_token_here"

curl -X POST http://localhost:8080/api/v1/goals \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Run Daily",
    "description": "Run 5km every day",
    "frequency": "daily"
  }'
```
**Save the `id` (goal_id) from response**

### 4. Create Post (Social Media)
```bash
GOAL_ID="paste_goal_id_here"

curl -X POST http://localhost:8080/api/v1/posts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"caption\": \"Just completed my daily run! 🏃💪\",
    \"goal_id\": \"$GOAL_ID\",
    \"image_url\": \"https://example.com/run.jpg\"
  }"
```
**Save the `id` (post_id) from response**

### 5. View Feed
```bash
curl http://localhost:8080/api/v1/feed \
  -H "Authorization: Bearer $TOKEN"
```

### 6. Like Post
```bash
POST_ID="paste_post_id_here"

curl -X POST "http://localhost:8080/api/v1/posts/$POST_ID/like" \
  -H "Authorization: Bearer $TOKEN"
```

### 7. Comment on Post
```bash
curl -X POST "http://localhost:8080/api/v1/posts/$POST_ID/comments" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"text": "Great job! Keep it up! 💪"}'
```

## 🎯 What We're Testing

✅ **User Authentication** - Signup, login, JWT tokens
✅ **Goals** - Create, read, update, delete goals
✅ **Posts** - Social media posts with captions
✅ **Feed** - Activity feed (global or friends-only)
✅ **Likes** - Like/unlike posts
✅ **Comments** - Comment on posts
✅ **Check-ins** - Track goal progress
✅ **Streaks** - Automatic streak calculation

## 🐛 Troubleshooting

### "go: command not found"
- Install Go: `brew install go`
- Restart terminal after installation

### "migrate: command not found"
- Install: `brew install migrate`

### "database does not exist"
- Create: `createdb trackr_db`

### "connection refused" (server)
- Check if server is running
- Check if port 8080 is free: `lsof -i :8080`

### "invalid token"
- Sign up again or login
- Use the new `access_token`

### "permission denied" (database)
- Check PostgreSQL user and password in `.env`
- Try: `psql -d trackr_db -c "SELECT 1;"`

## 📚 Documentation

- `QUICK_START.md` - Quick start guide
- `TESTING_GUIDE.md` - Detailed testing guide
- `SOCIAL_FEATURES.md` - Social media features
- `ARCHITECTURE.md` - System architecture

## 🎉 Ready to Test!

1. Install Go
2. Run migrations
3. Start server
4. Run `./test_api.sh` or test manually

**Let me know when Go is installed and I can help you run the tests!** 🚀

