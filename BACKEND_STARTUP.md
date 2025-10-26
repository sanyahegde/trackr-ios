# 🚀 Trackr Backend - Quick Start

## ✅ What's Already Done:
- ✅ PostgreSQL database created: `trackr`
- ✅ Backend server code written: `backend/server.js`
- ✅ API client in Swift: `Trackr/Services/APIService.swift`
- ✅ Create Post integrated with API
- ✅ Postgres connection working

## 🏃 To Run the Backend:

### Terminal 1 - Start the API Server:
```bash
cd /Users/sanyahegde/Desktop/trackr/backend
npm run dev
```

You should see:
```
✅ Connected to database at [timestamp]
✅ Database tables initialized
🚀 Trackr API server running on http://localhost:3000
```

### Terminal 2 - Your Xcode Project:
The app will automatically connect to `http://localhost:3000`

## 📝 Current Status:

### ✅ Working:
- Backend API server (port 3000)
- PostgreSQL database (port 5432)
- Posts table with auto-creation
- Image upload to `/uploads/` folder

### ⚠️ TODO - Add to Xcode:
You need to add `APIService.swift` to your Xcode project:

1. Open `Trackr.xcodeproj` in Xcode
2. Right-click on the `Trackr` folder → "Add Files to Trackr"
3. Select `Trackr/Services/APIService.swift`
4. Make sure "Add to targets: Trackr" is checked
5. Click Add

Then build (Cmd+B) and run (Cmd+R)!

## 🧪 Test the API:

```bash
# Health check
curl http://localhost:3000/health

# Get all posts (currently empty)
curl http://localhost:3000/api/posts

# Create a test user
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","username":"testuser","email":"test@test.com"}'
```

## 📍 Database Location:

Your PostgreSQL database is at:
- **Host:** localhost (127.0.0.1)
- **Port:** 5432
- **Database:** trackr
- **User:** postgres
- **Password:** postgres (change this in production!)

To access the database directly:
```bash
psql -d trackr
```

Then run SQL queries:
```sql
-- See all posts
SELECT * FROM posts;

-- See all users
SELECT * FROM users;

-- See database size
\l+ trackr
```

## 🎯 What Happens When You Create a Post:

1. User taps "+" button in app
2. `CreatePostView.swift` calls `APIService.shared.createPost()`
3. Image uploaded to `backend/uploads/` folder
4. Post data saved to PostgreSQL database
5. New post appears in feed immediately

All done! 🎉

