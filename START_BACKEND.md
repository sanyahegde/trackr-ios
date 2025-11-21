# Starting the Trackr Backend

## Quick Start

1. **Navigate to backend directory:**
   ```bash
   cd backend-go
   ```

2. **Start PostgreSQL and Redis with Docker:**
   ```bash
   docker-compose up -d postgres redis
   ```

3. **Wait for services to be healthy:**
   ```bash
   docker-compose ps
   ```
   Wait until both `postgres` and `redis` show `Up (healthy)`

4. **Run database migrations:**
   ```bash
   # Install migrate tool if needed
   brew install migrate
   
   # Run migrations
   cd migrations
   migrate -path . -database "postgres://trackr_user:trackr_password@localhost:5432/trackr_db?sslmode=disable" up
   cd ..
   ```

5. **Set environment variables:**
   ```bash
   export PORT=8080
   export ENV=development
   export DB_HOST=localhost
   export DB_PORT=5432
   export DB_USER=trackr_user
   export DB_PASSWORD=trackr_password
   export DB_NAME=trackr_db
   export DB_SSLMODE=disable
   export REDIS_HOST=localhost
   export REDIS_PORT=6379
   export JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
   export JWT_EXPIRY_HOURS=24
   export JWT_REFRESH_EXPIRY_HOURS=168
   export CORS_ALLOWED_ORIGINS=*
   ```

6. **Start the Go server:**
   ```bash
   go run cmd/api/main.go
   ```

   You should see:
   ```
   ✅ Database connection established
   ✅ Redis connection established (if Redis is running)
   🚀 Server starting on port 8080
   ```

## Verify Backend is Running

Open in browser or use curl:
```bash
curl http://localhost:8080/health
```

You should get:
```json
{"status":"ok","message":"API is running"}
```

## Troubleshooting

**Port 8080 already in use:**
- Change PORT in environment variables or kill the process using port 8080

**Database connection failed:**
- Make sure Docker containers are running: `docker-compose ps`
- Check PostgreSQL logs: `docker-compose logs postgres`

**Redis connection failed:**
- Backend will continue without Redis, but some features may not work
- Check Redis logs: `docker-compose logs redis`

