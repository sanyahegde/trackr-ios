# Trackr - Goal Tracking App

A modern iOS application built with SwiftUI for tracking goals amongst friends.

## Features

- 📱 Clean and intuitive user interface
- 🎯 Create and manage multiple goals
- 📊 Track progress with visual indicators
- 🏷️ Categorize goals by type (Work, Fitness, Learning, etc.)
- 📅 Set target dates
- ✅ Mark goals as completed
- 👥 Social features (coming soon)

## Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **Platform**: iOS 17+
- **Architecture**: MVVM pattern

## Project Structure

```
trackr/
├── Trackr.xcodeproj         # Xcode project file
├── Trackr/                   # Main app folder
│   ├── TrackrApp.swift      # App entry point
│   ├── Models/
│   │   ├── Goal.swift        # Goal data model
│   │   ├── User.swift        # User data model
│   │   └── GoalStore.swift  # Data management
│   ├── Views/
│   │   ├── ContentView.swift      # Main view
│   │   ├── GoalListView.swift    # List of goals
│   │   ├── GoalDetailView.swift   # Goal details
│   │   └── AddGoalView.swift     # Add new goal
│   ├── Theme/
│   │   ├── VintageColors.swift   # Vintage color palette
│   │   └── VintageStyle.swift    # Custom styling
│   ├── Assets.xcassets       # Images and colors
│   └── Info.plist           # iOS configuration
└── README.md
```

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS (for development)

### Quick Start

**Just open the project in Xcode!**

```bash
cd /path/to/trackr
open Trackr.xcodeproj
```

Or simply double-click `Trackr.xcodeproj` in Finder.

Then:
1. Select a simulator (iPhone 15 Pro recommended)
2. Press `Cmd+R` to build and run
3. That's it! The app will launch with sample goals

The project is already configured and ready to run!

## Current Features

### Goal Management
- Create new goals with title, description, category, and target date
- View all goals in a beautiful list
- Edit goal progress and completion status
- Delete goals by swiping

### UI Components
- **Vintage Design**: Warm, hand-drawn aesthetic with earthy colors
- **Georgia Font**: Classic serif typography throughout
- **Card-Based Layout**: Elegant cards with subtle shadows
- **Empty State**: Friendly message when no goals exist
- **Goal Cards**: Display key information at a glance
- **Progress Bars**: Visual progress indicators with gradients
- **Category Tags**: Color-coded category labels
- **Navigation**: Smooth transitions between screens

### Sample Data
The app includes sample goals to demonstrate functionality.

## Next Steps

To integrate with PostgreSQL:

1. **Backend API**: Create a backend server (Node.js, Python, etc.) that connects to PostgreSQL
2. **API Service**: Add an API service layer in the iOS app
3. **Networking**: Use URLSession or async/await for API calls
4. **Authentication**: Add user login and authentication
5. **Social Features**: Implement friend connections and shared goals

## Future Enhancements

- [ ] Backend integration with PostgreSQL
- [ ] User authentication
- [ ] Friend connections
- [ ] Shared goals
- [ ] Push notifications
- [ ] Achievements and rewards
- [ ] Dark mode support
- [ ] iCloud sync

## License

MIT License - feel free to use this project for your own purposes.

## Contact

Created by Sanya Hegde

