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
├── TrackrApp.swift          # App entry point
├── Models/
│   ├── Goal.swift           # Goal data model
│   ├── User.swift           # User data model
│   └── GoalStore.swift      # Data management
├── Views/
│   ├── ContentView.swift     # Main view
│   ├── GoalListView.swift   # List of goals
│   ├── GoalDetailView.swift # Goal details
│   └── AddGoalView.swift    # Add new goal
├── Package.swift            # Swift Package Manager config
└── README.md
```

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- macOS (for development)

### Setup Instructions

1. **Open in Xcode**
   ```bash
   cd /path/to/trackr
   open Package.swift
   ```

2. **Or create an Xcode project** (recommended for full iOS development):
   - Open Xcode
   - Create a new project
   - Choose "iOS" -> "App"
   - Name it "Trackr"
   - Choose SwiftUI interface
   - Copy all the Swift files from this repository into your Xcode project

3. **Run the app**
   - Select a simulator or device
   - Press Cmd+R to build and run

## Current Features

### Goal Management
- Create new goals with title, description, category, and target date
- View all goals in a beautiful list
- Edit goal progress and completion status
- Delete goals by swiping

### UI Components
- **Empty State**: Friendly message when no goals exist
- **Goal Cards**: Display key information at a glance
- **Progress Bars**: Visual progress indicators
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

