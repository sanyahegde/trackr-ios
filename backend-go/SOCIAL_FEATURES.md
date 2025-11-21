# 🎉 Social Media Features - Trackr Backend

## Overview

Trackr is now a **full social media application** similar to Instagram/Strava! Users can:
- Create social media posts with images and captions
- Like posts
- Comment on posts
- Follow/unfollow other users
- View activity feed (friends-only or global)
- Share goal progress as posts

## 📸 New Features

### 1. **Posts** (Social Media Posts)
- Create posts with captions
- Optional image uploads
- Link posts to goals
- View posts by user
- Delete your own posts

### 2. **Likes**
- Like/unlike posts
- See who liked a post
- Like count on each post

### 3. **Comments**
- Comment on posts
- View all comments for a post
- Comment count on each post

### 4. **Feed**
- Global feed (all posts)
- Friends-only feed (posts from people you follow + your own)
- Sorted by newest first

## 🚀 API Endpoints

### Posts

**Create Post:**
```bash
POST /api/v1/posts
Authorization: Bearer <token>
{
  "caption": "Just completed my daily run! 🏃",
  "goal_id": "uuid-optional",
  "image_url": "https://..."
}
```

**Get Post:**
```bash
GET /api/v1/posts/:id
```

**Get Feed:**
```bash
GET /api/v1/feed?friends_only=true&limit=50
Authorization: Bearer <token>
```

**Get User Posts:**
```bash
GET /api/v1/users/:id/posts?limit=50
```

**Delete Post:**
```bash
DELETE /api/v1/posts/:id
Authorization: Bearer <token>
```

### Likes

**Toggle Like:**
```bash
POST /api/v1/posts/:id/like
Authorization: Bearer <token>

# Response:
{
  "liked": true  // or false if unliked
}
```

### Comments

**Create Comment:**
```bash
POST /api/v1/posts/:id/comments
Authorization: Bearer <token>
{
  "text": "Great job! Keep it up! 💪"
}

# Response:
{
  "id": "...",
  "post_id": "...",
  "user_id": "...",
  "text": "Great job! Keep it up! 💪",
  "user": {
    "id": "...",
    "name": "...",
    "username": "..."
  },
  "created_at": "..."
}
```

**Get Comments:**
```bash
GET /api/v1/posts/:id/comments?limit=50
```

## 📊 Response Format

### Post Response
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "goal_id": "uuid-or-null",
  "caption": "Just completed my daily run! 🏃",
  "image_url": "https://...",
  "likes_count": 42,
  "comments_count": 5,
  "created_at": "2024-01-01T12:00:00Z",
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "username": "johndoe"
  },
  "goal": {
    "id": "uuid",
    "title": "Run Daily"
  }
}
```

### Feed Response
```json
[
  {
    "id": "uuid",
    "user_id": "uuid",
    "caption": "...",
    "image_url": "...",
    "likes_count": 42,
    "comments_count": 5,
    "created_at": "...",
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "username": "johndoe"
    }
  },
  ...
]
```

## 🔥 Use Cases

### 1. Share Goal Progress
User completes a check-in and wants to share it:
```bash
# Create a post linked to their goal
POST /api/v1/posts
{
  "caption": "Day 7 of running streak! 💪",
  "goal_id": "goal-uuid"
}
```

### 2. Social Interaction
Users can now:
- Like each other's progress posts
- Comment with encouragement
- Follow users with similar goals
- See friends' activity in feed

### 3. Activity Feed
- View all posts from people you follow
- See your own posts
- Option for global feed (all users)

## 🎨 Design Philosophy

**Instagram + Strava = Trackr**
- **Instagram-style**: Posts, likes, comments, feed
- **Strava-style**: Goal tracking, progress sharing, social motivation
- **Unique**: Goal-based habit tracking with social features

## 📱 iOS Integration

### Create Post
```swift
func createPost(caption: String, goalId: UUID?, imageURL: String?) async throws -> Post {
    var body: [String: Any] = ["caption": caption]
    if let goalId = goalId { body["goal_id"] = goalId.uuidString }
    if let imageURL = imageURL { body["image_url"] = imageURL }
    
    return try await makeRequest(
        endpoint: "/posts",
        method: "POST",
        body: body
    )
}
```

### Like Post
```swift
func likePost(postId: UUID) async throws -> Bool {
    let response: [String: Bool] = try await makeRequest(
        endpoint: "/posts/\(postId.uuidString)/like",
        method: "POST"
    )
    return response["liked"] ?? false
}
```

### Get Feed
```swift
func getFeed(friendsOnly: Bool = false) async throws -> [Post] {
    let endpoint = friendsOnly ? "/feed?friends_only=true" : "/feed"
    return try await makeRequest(endpoint: endpoint)
}
```

## 🔧 Fixed Issues

1. ✅ **Goal Creation Error Fixed** - UUID handling improved
2. ✅ **Better Error Messages** - More descriptive errors
3. ✅ **Social Media Features** - Posts, likes, comments added
4. ✅ **Activity Feed** - Proper feed with posts

## 🚀 Next Steps

1. **Image Upload** - Add multipart form upload for images
2. **Notifications** - Notify users when their posts are liked/commented
3. **Hashtags** - Support #hashtags in captions
4. **Stories** - 24-hour stories feature
5. **Explore** - Discovery feed based on interests
6. **Direct Messages** - Private messaging between users

## 📝 Example Workflow

1. User creates a goal: "Run 5km daily"
2. User does a check-in: Completes the run
3. User creates a post: Shares progress with photo
4. Friends see post in feed and like/comment
5. User feels motivated to continue!

**Trackr is now a complete social habit-tracking platform! 🎉**

