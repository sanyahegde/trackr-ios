# Trackr - Xcode Setup Instructions

## Step 1: Create New Xcode Project

1. Open Xcode (already launched)
2. **File → New → Project** (or press `Shift+Cmd+N`)
3. Select **iOS → App** and click **Next**
4. Configure:
   - Product Name: `Trackr`
   - Team: (Select your team or leave None)
   - Organization Identifier: `com.yourname`
   - Bundle Identifier: `com.yourname.Trackr`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - ☐ Uncheck "Use Core Data"
5. Click **Next** and choose a location outside the current trackr folder
   - Suggest: `/Users/sanyahegde/Desktop/trackr-xcode/`
6. Click **Create**

## Step 2: Delete Default Files

1. In the Project Navigator, delete:
   - `ContentView.swift` (we have our own)
   - Keep `TrackrApp.swift` but we'll replace it

## Step 3: Import Our Files

1. Right-click on the project folder in Project Navigator
2. Select **Add Files to "Trackr"...**
3. Navigate to `/Users/sanyahegde/Desktop/trackr/`
4. Select these folders:
   - `Models/`
   - `Views/`
5. Check **"Copy items if needed"**
6. Click **Add**

## Step 4: Update App Entry Point

Replace the default `TrackrApp.swift` with our version (it's the same, so you can skip this if the import worked)

## Step 5: Set Build Target

1. Select your project in the Project Navigator
2. Under **TARGETS**, select **Trackr**
3. In **General** tab:
   - Set **iOS Deployment Target** to **17.0**
   - Set **Minimum** version to **iOS 17.0**

## Step 6: Run the App

1. Select a simulator (iPhone 15 Pro recommended)
2. Press `Cmd+R` or click the **Play** button
3. The app should build and launch!

## Troubleshooting

- If you get build errors, make sure all files are added to the target
- Check that Swift version is 5.9+
- Verify iOS 17.0+ deployment target

## What to See

When you run the app, you'll see:
- A "Trackr" title with a + button
- 3 sample goals with progress bars
- Tap a goal to see details
- Tap + to add a new goal
- Swipe left on a goal to delete it

