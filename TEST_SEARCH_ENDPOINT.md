# Testing the User Search Endpoint

## Prerequisites
Make sure the backend server is running:
```bash
cd /Users/sanyahegde/Desktop/trackr/backend
npm run dev
```

## Test Cases

### 1. Search for "john" (should show ranking priority)
```bash
curl "http://localhost:3000/api/users?search=john" | python3 -m json.tool
```
**Expected:** `johnny` first (starts with), then `johnsmith` (contains)

### 2. Exact username match
```bash
curl "http://localhost:3000/api/users?search=johnny" | python3 -m json.tool
```
**Expected:** Only `johnny` returned

### 3. Name search
```bash
curl "http://localhost:3000/api/users?search=smith" | python3 -m json.tool
```
**Expected:** Users with "Smith" in their name

### 4. Empty search (returns all users)
```bash
curl "http://localhost:3000/api/users" | python3 -m json.tool
```
**Expected:** All users, ordered by created_at DESC

### 5. Case-insensitive search
```bash
curl "http://localhost:3000/api/users?search=JANE" | python3 -m json.tool
```
**Expected:** Works regardless of case

### 6. Partial matches
```bash
curl "http://localhost:3000/api/users?search=jo" | python3 -m json.tool
```
**Expected:** Users with "jo" in username or name

## Browser Testing
You can also test in your browser:
- http://localhost:3000/api/users?search=john
- http://localhost:3000/api/users?search=jane
- http://localhost:3000/api/users (no search term)

## iOS App Testing
1. Open the Trackr app in Xcode
2. Run the app (Cmd+R)
3. Navigate to the Search tab (magnifying glass icon)
4. Type in the search box and watch results update in real-time
5. Try these searches:
   - "john" → Check ranking
   - "johnny" → Exact match
   - "jane" → Username search
   - "smith" → Name search
   - Clear search → Should show all users

## What to Verify
✅ Results are ranked by relevance (exact matches first)
✅ Username matches prioritized over name matches
✅ Case-insensitive search works
✅ Empty search returns all users
✅ Real-time search updates as you type (iOS app)
✅ Loading states work correctly
✅ Error handling works if backend is down

