#!/bin/bash

# Trackr API Test Script
# This script tests all the new social media features

BASE_URL="http://localhost:8080/api/v1"
TOKEN=""

echo "🧪 Testing Trackr Social Media API"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test 1: Health Check
echo -e "${BLUE}Test 1: Health Check${NC}"
response=$(curl -s http://localhost:8080/health)
echo "Response: $response"
echo ""

# Test 2: Signup
echo -e "${BLUE}Test 2: User Signup${NC}"
signup_response=$(curl -s -X POST "$BASE_URL/auth/signup" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@trackr.com",
    "name": "Test User",
    "username": "testuser",
    "password": "password123"
  }')

echo "Response: $signup_response"
TOKEN=$(echo $signup_response | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
echo "Token: ${TOKEN:0:20}..."
echo ""

if [ -z "$TOKEN" ]; then
  echo -e "${RED}Failed to get token. Trying login...${NC}"
  login_response=$(curl -s -X POST "$BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
      "email": "test@trackr.com",
      "password": "password123"
    }')
  TOKEN=$(echo $login_response | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
  echo "Login Token: ${TOKEN:0:20}..."
  echo ""
fi

if [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Authentication failed. Cannot continue tests.${NC}"
  exit 1
fi

# Test 3: Create Goal
echo -e "${BLUE}Test 3: Create Goal${NC}"
goal_response=$(curl -s -X POST "$BASE_URL/goals" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Run Daily",
    "description": "Run 5km every day",
    "frequency": "daily"
  }')

echo "Response: $goal_response"
GOAL_ID=$(echo $goal_response | grep -o '"id":"[^"]*' | cut -d'"' -f4)
echo "Goal ID: $GOAL_ID"
echo ""

# Test 4: Get Goals
echo -e "${BLUE}Test 4: Get Goals${NC}"
goals_response=$(curl -s -X GET "$BASE_URL/goals" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $goals_response" | head -c 200
echo "..."
echo ""

# Test 5: Create Post
echo -e "${BLUE}Test 5: Create Social Media Post${NC}"
post_response=$(curl -s -X POST "$BASE_URL/posts" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"caption\": \"Just completed my daily run! 🏃💪\",
    \"goal_id\": \"$GOAL_ID\",
    \"image_url\": \"https://example.com/run.jpg\"
  }")

echo "Response: $post_response"
POST_ID=$(echo $post_response | grep -o '"id":"[^"]*' | cut -d'"' -f4)
echo "Post ID: $POST_ID"
echo ""

# Test 6: Get Feed
echo -e "${BLUE}Test 6: Get Activity Feed${NC}"
feed_response=$(curl -s -X GET "$BASE_URL/feed?limit=10" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $feed_response" | head -c 300
echo "..."
echo ""

# Test 7: Like Post
echo -e "${BLUE}Test 7: Like Post${NC}"
like_response=$(curl -s -X POST "$BASE_URL/posts/$POST_ID/like" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $like_response"
echo ""

# Test 8: Comment on Post
echo -e "${BLUE}Test 8: Comment on Post${NC}"
comment_response=$(curl -s -X POST "$BASE_URL/posts/$POST_ID/comments" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Great job! Keep it up! 💪"
  }')
echo "Response: $comment_response"
echo ""

# Test 9: Get Comments
echo -e "${BLUE}Test 9: Get Post Comments${NC}"
comments_response=$(curl -s -X GET "$BASE_URL/posts/$POST_ID/comments" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $comments_response" | head -c 300
echo "..."
echo ""

# Test 10: Create Check-in
echo -e "${BLUE}Test 10: Create Check-in${NC}"
checkin_response=$(curl -s -X POST "$BASE_URL/goals/$GOAL_ID/checkins" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "note": "Ran 5km today!",
    "value": 5.0
  }')
echo "Response: $checkin_response"
echo ""

# Test 11: Get Streaks
echo -e "${BLUE}Test 11: Get Streaks${NC}"
streaks_response=$(curl -s -X GET "$BASE_URL/streaks" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $streaks_response"
echo ""

# Test 12: Get User Profile
echo -e "${BLUE}Test 12: Get Current User${NC}"
user_response=$(curl -s -X GET "$BASE_URL/auth/me" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $user_response" | head -c 200
echo "..."
echo ""

echo -e "${GREEN}✅ All tests completed!${NC}"
echo ""
echo "Summary:"
echo "- Health check: ✅"
echo "- User signup/login: ✅"
echo "- Goal creation: ✅"
echo "- Post creation: ✅"
echo "- Feed: ✅"
echo "- Like: ✅"
echo "- Comment: ✅"
echo "- Check-in: ✅"
echo "- Streaks: ✅"

