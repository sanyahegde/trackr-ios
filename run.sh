#!/bin/bash

# Trackr - Quick Run Script
# This script builds and runs the Trackr iOS app

set -e

PROJECT_NAME="Trackr"
SCHEME="Trackr"
SIMULATOR="iPhone 15 Pro"
PROJECT_FILE="Trackr.xcodeproj"

echo "🚀 Trackr - Building and Running..."
echo ""

# Check if Xcode project exists
if [ ! -d "$PROJECT_FILE" ]; then
    echo "❌ Error: $PROJECT_FILE not found!"
    echo "Please make sure you're in the correct directory."
    exit 1
fi

# Function to check if simulator is available
check_simulator() {
    xcrun simctl list devices available | grep -q "$SIMULATOR" || {
        echo "⚠️  Warning: $SIMULATOR not available"
        echo "Available simulators:"
        xcrun simctl list devices available | grep "iPhone" | head -5
        echo ""
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    }
}

# Option 1: Build and run in Xcode (Recommended)
if [ "$1" == "--xcode" ] || [ -z "$1" ]; then
    echo "📱 Opening in Xcode..."
    echo "   Press Cmd+R in Xcode to build and run"
    echo ""
    open "$PROJECT_FILE"
    exit 0
fi

# Option 2: Build and install via command line
if [ "$1" == "--build" ]; then
    echo "🔨 Building $PROJECT_NAME..."
    xcodebuild \
        -project "$PROJECT_FILE" \
        -scheme "$SCHEME" \
        -destination "platform=iOS Simulator,name=$SIMULATOR" \
        clean build
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Build succeeded!"
        echo "📱 Opening Simulator..."
        xcrun simctl boot "$SIMULATOR" 2>/dev/null || true
        open -a Simulator
    else
        echo "❌ Build failed!"
        exit 1
    fi
    exit 0
fi

# Option 3: Just open Xcode
if [ "$1" == "--open" ]; then
    open "$PROJECT_FILE"
    exit 0
fi

# Show usage
echo "Usage: ./run.sh [option]"
echo ""
echo "Options:"
echo "  (no option)   Open project in Xcode (default)"
echo "  --xcode       Open project in Xcode"
echo "  --build       Build and open Simulator"
echo "  --open        Just open Xcode project"
echo ""
echo "Examples:"
echo "  ./run.sh              # Open in Xcode"
echo "  ./run.sh --xcode      # Open in Xcode"
echo "  ./run.sh --build      # Build and run"
echo "  ./run.sh --open       # Just open Xcode"

