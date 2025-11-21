# 🧪 How to Test User Search

## ✅ Step 1: Verify Backend is Running

The backend is already running! ✅

If you need to start it manually:
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

---

## 🔍 Step 2: Test via API (Quick Check)

Open Terminal and run:

### Test Search Ranking
```bash
curl "http://localhost:3000/api/users?search=john" | python3 -m json.tool
```
**Expected:** `johnny` appears before `johnsmith` (better ranking!)

### Test Exact Match
```bash
curl "http://localhost:3000/api/users?search=johnny" | python3 -m json.tool
```
**Expected:** Only `johnny` returned

### Test All Users
```bash
curl "http://localhost:3000/api/users" | python3 -m json.tool
```
**Expected:** All users returned

### Test in Browser
Open in Safari/Chrome:
- http://localhost:3000/api/users?search=john
- http://localhost:3000/api/users?search=jane
- http://localhost:3000/api/users

---

## 📱 Step 3: Test in iOS App

### Prerequisites
1. **Make sure backend is running** (Step 1)
2. **Open your Xcode project** (Trackr.xcodeproj)
3. **Ensure APIService.swift is added** to your Xcode target

### Run the App
1. Press `Cmd+R` or click the ▶️ Play button
2. Wait for the app to launch in the simulator

### Test Search Feature
1. **Navigate to Search tab** (tap the magnifying glass icon at the bottom)
2. **Test these scenarios:**

   **a) Initial Load**
   - When Search tab opens, you should see all users listed
   
   **b) Search for "john"**
   - Type "john" in the search box
   - Watch results update in real-time
   - ✅ **Verify:** `johnny` appears BEFORE `johnsmith` (ranking works!)
   - ✅ **Verify:** Loading spinner appears briefly
   
   **c) Search for "johnny"**
   - Type "johnny" (exact match)
   - ✅ **Verify:** Only `johnny` appears
   
   **d) Search for "jane"**
   - Type "jane"
   - ✅ **Verify:** Only `jane` appears (exact username match)
   
   **e) Search for "smith"**
   - Type "smith" (name search)
   - ✅ **Verify:** "John Smith" appears
   
   **f) Clear Search**
   - Delete all text in search box
   - ✅ **Verify:** All users appear again
   
   **g) No Results**
   - Type "xyz123" (doesn't exist)
   - ✅ **Verify:** "No users found" message appears

### Test User Interaction
1. **Tap a user** from search results
   - ✅ Should navigate to User Profile Detail view
   - ✅ Shows user's name, username, and profile info

2. **Follow button** (in search results or profile)
   - ✅ Button toggles between "Follow" and "Following"
   - ✅ Haptic feedback should work

---

## ✅ What to Verify

### API Endpoint
- ✅ Results ranked by relevance (exact → prefix → contains)
- ✅ Username matches prioritized over name matches
- ✅ Case-insensitive search works
- ✅ Empty search returns all users

### iOS App
- ✅ Real-time search updates as you type
- ✅ Results display correctly (name + username)
- ✅ Loading spinner shows during search
- ✅ "No users found" shows when appropriate
- ✅ Navigation to user profile works
- ✅ All users show when search is empty

### Performance
- ✅ Search is fast (no noticeable delay)
- ✅ Results update smoothly
- ✅ No crashes or errors

---

## 🐛 Troubleshooting

### "Failed to search users" error
- **Fix:** Make sure backend is running on port 3000
- **Check:** `lsof -ti:3000` should return a process ID

### No results showing
- **Fix:** Create test users first:
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","username":"testuser","email":"test@test.com"}'
```

### App can't connect to backend
- **Fix:** In Xcode, make sure APIService.swift uses `http://localhost:3000/api`
- **Note:** For physical iPhone, change `localhost` to your Mac's IP address

### Search not updating in real-time
- **Fix:** Make sure `SearchView.swift` has the `onChange` handler on the search TextField
- **Check:** Look for `.onChange(of: searchText)` in SearchView.swift

---

## 📊 Test Checklist

- [ ] Backend running on port 3000
- [ ] API returns ranked results for "john"
- [ ] API returns exact match for "johnny"
- [ ] iOS app shows Search tab
- [ ] Search updates in real-time as you type
- [ ] Results ranked correctly (johnny before johnsmith)
- [ ] "No users found" shows for invalid search
- [ ] Tapping user navigates to profile
- [ ] All users show when search is empty

---

## 🎉 Success Indicators

You'll know it's working when:
1. Typing "john" shows `johnny` first (better ranking!)
2. Search updates instantly as you type
3. Exact matches appear immediately
4. No errors or crashes
5. Smooth user experience

Happy testing! 🚀

