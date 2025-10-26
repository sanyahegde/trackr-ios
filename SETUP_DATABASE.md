# Setup PostgreSQL Database for Trackr

## Quick Setup (MacOS with Homebrew)

### 1. Install PostgreSQL
```bash
brew install postgresql@14
brew services start postgresql@14
```

### 2. Create Database
```bash
createdb trackr
```

### 3. Verify it works
```bash
psql -d trackr -c "SELECT version();"
```

## Alternative: Use Docker

If you don't want to install PostgreSQL directly:

```bash
# Start PostgreSQL in Docker
docker run --name trackr-db \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=trackr \
  -p 5432:5432 \
  -d postgres:14

# Access the database
docker exec -it trackr-db psql -U postgres -d trackr
```

## Configure Backend

Create a `.env` file in the `backend` folder:

```bash
cd backend
cat > .env << EOF
DB_USER=postgres
DB_HOST=localhost
DB_NAME=trackr
DB_PASSWORD=postgres
DB_PORT=5432
PORT=3000
EOF
```

## Start the Backend Server

```bash
cd backend
npm install
npm run dev
```

You should see:
```
✅ Connected to database at [timestamp]
✅ Database tables initialized
🚀 Trackr API server running on http://localhost:3000
```

## Test the API

```bash
# Health check
curl http://localhost:3000/health

# Get posts (should return empty array initially)
curl http://localhost:3000/api/posts

# Create a test user
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","username":"testuser","email":"test@test.com"}'
```

## Database Tables

Once you start the server, these tables will be automatically created:

- **users** - User accounts
- **posts** - Posts shared by users
- **comments** - Comments on posts
- **post_likes** - Like tracking

## Troubleshooting

If you get connection errors:
1. Make sure PostgreSQL is running: `brew services list | grep postgresql`
2. Check if port 5432 is available: `lsof -i :5432`
3. Verify database exists: `psql -l | grep trackr`

