# MyTimecard+ Mobile App

[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017.5+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Xcode](https://img.shields.io/badge/Xcode-16.1+-red.svg)](https://developer.apple.com/xcode/)
[![Firebase](https://img.shields.io/badge/Firebase-11.5.0-yellow.svg)](https://firebase.google.com)

MyTimecard+ is an iOS mobile application designed to make time tracking easier for employees and managers. Our innovative solution simplifies the timecard lifecycle—from creation and submission to approval and reporting—offering a comprehensive, user-friendly, and efficient experience.

## Table of Contents
- [Purpose](#purpose)
- [Core Functionality](#core-functionality)
- [System Requirements](#system-requirements)
- [Installation Guide](#installation-guide)
- [Firebase Setup](#firebase-setup)
- [Development Setup](#development-setup)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Purpose
The MyTimecard+ app aims to:
1. Reduce the time spent creating and managing timecards
2. Enhance the user experience through intuitive and modern interfaces
3. Provide customizable notifications to keep users informed
4. Streamline the timecard approval process
5. Enable efficient job code management and tracking

## Core Functionality

### Authentication & Profile Management
- Secure login system with Firebase authentication
- Password reset
- User profile editing capabilities

### Timecard Management
- Create and edit daily timecards
- Weekly timecard submission and tracking
- Historical timecard view

### Job Code System
- Detailed job code descriptions and categories
- Quick selection of job codes

### Manager Features
- Employee timecard review interface
- Batch approval capabilities
- Management dashboard

### Notification System
- Custom notification scheduling
- Timecard submission reminders
- Approval status notifications

### Weekly Planning
- Weekly schedule view
- Work hour summaries and statistics
- Weekly status reports

## System Requirements

Before starting the installation, ensure you have:

- macOS Ventura (13.0) or later
- Xcode 16.1 or later
- iOS 17.5 or later for deployment
- [Cocoapods](https://cocoapods.org) (optional, if using pod dependencies)
- Git
- A Firebase account (free tier works for development)
- Apple Developer account (free or paid, depending on your deployment needs)

## Installation Guide

### 1. Clone the Repository

```bash
git clone https://github.com/DamiansPortfolio/Timecard_Tracker.git
cd Timecard_Tracker
```

### 2. Set Up Development Environment

1. Open the project in Xcode:
```bash
open Timecard_Tracker.xcodeproj
```

2. Install development tools (if needed):
```bash
xcode-select --install
```

### 3. Firebase SDK Integration

Add the Firebase iOS SDK using Swift Package Manager:

1. In Xcode:
   - Navigate to File > Add Packages
   - Paste the Firebase SDK URL: `https://github.com/firebase/firebase-ios-sdk.git`
   - Set Dependency Rule: Up to Next Major Version (11.5.0 < 12.0.0)

2. Select required Firebase products:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseAnalytics
   - FirebaseStorage
   - FirebaseMessaging

## Firebase Setup

Since this app requires a database, you'll need to set up your own Firebase project and database. Don't worry - Firebase has a generous free tier that's perfect for development and small deployments.

### 1. Create Your Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Create Project" (don't try to request access to existing projects)
3. Name your project (e.g., "my-timecard-tracker")
4. Choose whether to enable Google Analytics (recommended)
5. Accept the terms and create your project

### 2. Set Up Your Firestore Database

1. In your new Firebase project:
   - Click "Firestore Database" in the left sidebar
   - Click "Create Database"
   - Choose "Start in test mode" for development (you can update security rules later)
   - Select your preferred region
   - Click "Enable"

2. Your database is now ready to use with the app! Since Firebase Firestore is a NoSQL database:
   - Collections and documents will be created dynamically as you use the app
   - You don't need to define any structure beforehand
   - The app expects these main collections (they'll be created automatically):
     - `users` - For user profiles
     - `timecards` - For timecard entries
     - `jobCodes` - For job code references

3. That's it! Unlike SQL databases, there's no need to:
   - Define schemas
   - Create tables
   - Set up relationships
   - Define fields in advance

The flexible nature of Firestore means the database structure will form organically as the app writes data.

### 2. Configure iOS App in Firebase

1. In Firebase Console:
   - Click "Add app" and select iOS
   - Enter your bundle identifier (found in Xcode target settings)
   - Download `GoogleService-Info.plist`
   - Follow the setup wizard steps

2. Add Firebase configuration to your project:
   - Drag `GoogleService-Info.plist` into your Xcode project
   - Ensure "Copy items if needed" is checked
   - Add to your main target
   - **Important**: Add `GoogleService-Info.plist` to your `.gitignore`

### 3. Update Project Configuration

Add Firebase initialization to your `App.swift`:

```swift
import Firebase

@main
struct MyTimecardPlusApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

## Development Setup

### 1. Configure Xcode Project

1. Update signing configuration:
   - Select project in navigator
   - Select your target
   - Under "Signing & Capabilities":
     - Choose your development team
     - Update bundle identifier if needed

2. Configure your `.gitignore`:
```bash
# Project-specific
GoogleService-Info.plist
*.xcuserstate
*.xcworkspace/
xcuserdata/

# macOS
.DS_Store

# Swift Package Manager
.build/
.swiftpm/

# Firebase
GoogleService-Info.plist

# Xcode
build/
DerivedData/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
```

### 2. Additional Configuration

1. Enable Push Notifications (if needed):
   - In Xcode, select your target
   - Click "+ Capability"
   - Add "Push Notifications"
   - Add "Background Modes"
   - Check "Remote notifications"

2. Configure Firebase Authentication:
   - In Firebase Console, enable desired auth methods
   - Add required configuration to Info.plist

## Troubleshooting

### Common Issues and Solutions

1. Build Errors
```bash
# Clean build folder
cmd + shift + k

# Clean build cache
cmd + shift + k (twice)

# Delete derived data
rm -rf ~/Library/Developer/Xcode/DerivedData
```

2. Firebase Integration Issues
   - Verify `GoogleService-Info.plist` is in the correct target
   - Ensure bundle identifier matches Firebase Console
   - Check `FirebaseApp.configure()` is called at app launch

3. Signing Issues
   - Verify Apple Developer account status
   - Check provisioning profile settings
   - Update team and bundle identifier settings

### Support Channels

- Create an issue in the GitHub repository
- Contact the development team
- Check Firebase documentation for specific Firebase-related issues

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Submit a pull request

### Before Contributing

1. Set up your own Firebase project (see [Firebase Setup](#firebase-setup) section)
2. Generate your own `GoogleService-Info.plist` from your Firebase project
3. Never commit Firebase configuration files to the repository
4. Follow the project's coding standards
5. Include tests for new features
6. Make sure all existing tests pass before submitting a PR

## License

MIT License
