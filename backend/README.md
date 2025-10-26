# Trackr Backend API

Node.js + Express + PostgreSQL backend for Trackr goal-tracking app.

## Setup

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Install PostgreSQL:**
   ```bash
   # macOS
   brew install postgresql@14
   brew services start postgresql@14
   
   # Or use Docker
   docker run --name trackr-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:14
   ```

3. **Create database:**
   ```bash
   createdb trackr
   ```

4. **Configure environment:**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

5. **Start the server:**
   ```bash
   npm run dev
   ```

The API will be available at `http://localhost:3000`

## Endpoints

- `GET /health` - Health check
- `GET /api/posts` - Get all posts
- `POST /api/posts` - Create a new post (multipart/form-data with image)
- `POST /api/posts/:postId/like` - Toggle like on a post
- `POST /api/posts/:postId/comments` - Add a comment
- `GET /api/users?search=query` - Search for users
- `POST /api/users` - Create a user (for testing)

## Database Schema

### users
- id (UUID)
- email (VARCHAR)
- name (VARCHAR)
- username (VARCHAR)
- profile_image_url (TEXT)
- followers_count (INTEGER)
- following_count (INTEGER)
- created_at (TIMESTAMP)

### posts
- id (UUID)
- user_id (UUID, FK to users)
- goal_id (UUID, optional)
- goal_title (VARCHAR)
- caption (TEXT)
- image_url (TEXT)
- location (JSONB)
- likes_count (INTEGER)
- created_at (TIMESTAMP)

### comments
- id (UUID)
- post_id (UUID, FK to posts)
- user_id (UUID, FK to users)
- text (TEXT)
- likes_count (INTEGER)
- created_at (TIMESTAMP)

### post_likes
- id (UUID)
- post_id (UUID, FK to posts)
- user_id (UUID, FK to users)
- created_at (TIMESTAMP)

