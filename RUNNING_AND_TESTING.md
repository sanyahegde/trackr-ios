# Trackr - Running and Testing Guide

## ✅ Build Status
**BUILD SUCCEEDED** - The project is ready to run!

## 🚀 Running the App

### Option 1: Run in Xcode (Recommended)
1. Open `Trackr.xcodeproj` in Xcode
2. Select a simulator (e.g., iPhone 15 Pro) or your physical device
3. Press `Cmd + R` or click the ▶️ Run button
4. The app will build and launch automatically

### Option 2: Run via Command Line
```bash
cd /Users/sanyahegde/Desktop/trackr
xcodebuild -project Trackr.xcodeproj -scheme Trackr -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build
xcrun simctl boot "iPhone 15 Pro" 2>/dev/null || true
open -a Simulator
```

## 🧪 Testing the App

### 1. **Home Tab** (`HomeView`)
- ✅ View social feed
- ✅ Create new posts
- ✅ Like and comment on posts
- ✅ Refresh feed with pull-to-refresh

### 2. **Search Tab** (`SearchView`)
- ✅ Search for users
- ✅ View user profiles
- ✅ Follow/unfollow users

### 3. **Goals Tab** (`ContentView`)
- ✅ View all goals
- ✅ Add new goals
- ✅ Edit goals
- ✅ Track progress
- ✅ Complete goals

### 4. **Stats Tab** (`DashboardView`)
- ✅ View dashboard analytics
- ✅ See completion charts
- ✅ View category distribution
- ✅ Check overall progress

### 5. **Profile Tab** (`ProfileView`)
- ✅ View your profile
- ✅ Edit settings
- ✅ View your goals and posts
- ✅ Check achievements

## 🎨 Key Features to Test

### Authentication
- The app is currently set to **skip authentication for testing** (`skipAuthForTesting = true`)
- To enable auth, change `skipAuthForTesting` to `false` in `TrackrApp.swift`

### Social Features
- **Posts**: Create posts with captions and optional images
- **Likes**: Like/unlike posts
- **Comments**: Add comments to posts
- **Feed**: View activity feed with posts from followed users

### Goal Tracking
- Create goals with:
  - Title and description
  - Target date
  - Category
  - Privacy level (Private/Friends/Public)
- Track progress (0-100%)
- Mark goals as completed
- View analytics and statistics

### Leaderboard
- View rankings by:
  - Friends
  - Global
  - Weekly
- See podium view for top 3
- View all rankings

### Vintage Theme
- Dark mode support
- Vintage color palette
- Smooth animations
- Haptic feedback

## 📱 Simulator Testing

### Recommended Simulators
- **iPhone 15 Pro** (Latest, recommended)
- **iPhone 14 Pro** (Good for testing)
- **iPad Pro** (Test tablet layout)

### Quick Simulator Commands
```bash
# List available simulators
xcrun simctl list devices

# Boot a specific simulator
xcrun simctl boot "iPhone 15 Pro"

# Install and run app
xcodebuild -project Trackr.xcodeproj -scheme Trackr -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build install
```

## 🔍 Testing Checklist

### Core Functionality
- [ ] App launches without crashes
- [ ] All tabs are accessible
- [ ] Navigation works smoothly
- [ ] Dark mode works correctly
- [ ] Haptic feedback works on interactions

### Goals
- [ ] Create a new goal
- [ ] Edit an existing goal
- [ ] Delete a goal
- [ ] Update goal progress
- [ ] Complete a goal
- [ ] View goal details

### Social Features
- [ ] Create a post
- [ ] View posts in feed
- [ ] Like a post
- [ ] Unlike a post
- [ ] Add a comment
- [ ] View comments

### Analytics
- [ ] Dashboard loads correctly
- [ ] Charts display properly
- [ ] Statistics are accurate
- [ ] Leaderboard updates

### Profile
- [ ] View profile information
- [ ] Edit settings
- [ ] View user's goals
- [ ] View user's posts

## 🐛 Common Issues & Solutions

### Issue: Build fails with "Cannot find X"
**Solution**: Clean build folder (`Cmd + Shift + K`) and rebuild (`Cmd + B`)

### Issue: Simulator won't launch
**Solution**: 
```bash
xcrun simctl shutdown all
xcrun simctl boot "iPhone 15 Pro"
```

### Issue: App crashes on launch
**Solution**: 
1. Check console logs in Xcode
2. Verify all required files are in the project
3. Clean build folder and rebuild

### Issue: Dark mode not working
**Solution**: Check `TrackrApp.swift` - `preferredColorScheme` setting

## 📊 Performance Testing

### Check Performance
1. Open Instruments in Xcode (`Cmd + I`)
2. Select **Time Profiler** or **Leaks**
3. Run the app and interact with features
4. Analyze performance metrics

### Memory Usage
- Monitor memory in Xcode Debug Navigator
- Check for memory leaks
- Ensure proper cleanup of views

## 🔄 Updating Test Data

### Mock Data Locations
- **Users**: `MainTabView.swift` and `LeaderboardView.swift`
- **Goals**: `GoalStore.swift`
- **Posts**: `HomeFeedViewModel.swift`

### Adding Test Users
Edit the `mockFriends` array in:
- `MainTabView.swift`
- `LeaderboardView.swift`
- `DashboardLeaderboardView.swift`

## ✨ Next Steps for Full Testing

1. **Backend Integration**: Connect to Go backend API
2. **Authentication**: Enable Auth0 integration
3. **Real Data**: Replace mock data with API calls
4. **Notifications**: Test push notifications
5. **Offline Mode**: Test offline functionality

## 📝 Notes

- All UI is responsive and works in both light and dark mode
- Haptic feedback is enabled on key interactions
- The app uses a vintage color theme throughout
- Navigation uses SwiftUI's native navigation stack

## 🎯 Quick Test Commands

```bash
# Build only
xcodebuild -project Trackr.xcodeproj -scheme Trackr build

# Build and run tests (if tests exist)
xcodebuild test -project Trackr.xcodeproj -scheme Trackr -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Clean build
xcodebuild clean -project Trackr.xcodeproj -scheme Trackr
```

---

**Happy Testing! 🚀**

