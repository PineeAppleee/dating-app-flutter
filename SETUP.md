# Dating App Flutter - Setup Instructions

## Prerequisites

- Flutter 3.x or higher
- Dart 3.x or higher
- Firebase Account (for authentication and Firestore)
- iOS/Android development environment configured

## Initial Setup

### 1. Install Dependencies

```bash
# Get Flutter dependencies
flutter pub get

# Install iOS/macOS pods
cd ios && pod install && cd ..
# or for macOS
cd macos && pod install && cd ..
```

### 2. Firebase Configuration

#### Android
- Download `google-services.json` from Firebase Console
- Place it at: `android/app/google-services.json`

#### iOS
- Download `GoogleService-Info.plist` from Firebase Console
- Place it at: `ios/Runner/GoogleService-Info.plist`
- Add it to Xcode project (Target: Runner)

#### macOS
- Download `GoogleService-Info.plist` from Firebase Console
- Place it at: `macos/Runner/GoogleService-Info.plist`

### 3. Environment Variables

Create `.env` file in project root if needed:

```
FIREBASE_PROJECT_ID=your-project-id
```

## Building and Running

### Development Mode

```bash
# For Android
flutter run -d android

# For iOS
flutter run -d iphone

# For macOS
flutter run -d macos
```

### Production Build

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release

# macOS DMG
flutter build macos --release
```

## Project Structure

```
lib/
├── core/
│   ├── providers/        # State management (AuthNotifier)
│   ├── repositories/     # Firebase & API repositories
│   ├── router/          # GoRouter configuration
│   ├── theme/           # App theming
│   └── utils/           # Utilities
├── features/            # Feature modules
│   ├── auth/            # Authentication screens
│   ├── onboarding/      # Profile setup flow
│   ├── home/            # Main app screens
│   ├── discover/        # Discovery screens
│   ├── matches/         # Matches feature
│   ├── likes/           # Likes feature
│   ├── chat/            # Messaging feature
│   └── profile/         # Profile management
└── main.dart            # App entry point
```

## Key Features Implemented

- ✅ Centralized Auth Routing with GoRouter
- ✅ Real-time Firestore listener for profile updates
- ✅ Firebase Authentication (Google, Apple, Phone)
- ✅ Automatic route redirection based on auth state
- ✅ Profile completion detection
- ✅ Session persistence

## Architecture

The app uses a centralized authentication routing system:

1. **AuthNotifier** (`lib/core/providers/auth_notifier.dart`)
   - Listens to Firebase Auth state changes
   - Monitors Firestore profile completion
   - Triggers router updates via ChangeNotifier

2. **AppRouter** (`lib/core/router/app_router.dart`)
   - Uses GoRouter's `redirect` for centralized routing
   - Routes based on three states:
     - **Loading**: Show splash screen
     - **Unauthenticated**: Show onboarding/login
     - **Authenticated (Profile incomplete)**: Show profile setup
     - **Authenticated (Profile complete)**: Show main app

## Troubleshooting

### App Freezes on Splash Screen
- Ensure Firestore rules allow read access to user documents
- Check network connectivity
- Verify Firebase configuration files are in place

### Build Errors
- Run `flutter clean`
- Run `flutter pub get`
- Delete build directories: `rm -rf build/ ios/Pods/ macos/Pods/`
- Rebuild: `flutter run`

### iOS/macOS Specific
```bash
# Clear CocoaPods
rm -rf ios/Pods/ ios/Podfile.lock
cd ios && pod install && cd ..

# Clear Xcode build cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

## Development Notes

### Removing Print Statements (Production)
Replace debug `print()` calls with `debugPrint()` for production builds.

### Deprecated APIs
- Replace `.withOpacity()` with `.withValues()` for color opacity

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Commit changes: `git commit -m "feat: description"`
3. Push to branch: `git push origin feature/your-feature`
4. Create Pull Request

## License

Proprietary - Serious Dating App
