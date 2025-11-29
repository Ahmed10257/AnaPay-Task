# AnaPay App

A modern Flutter application implementing clean architecture with Firebase authentication and cloud messaging for payment notifications.

**Live Demo:** https://anapay-task.web.app/

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Local Environment Configuration](#local-environment-configuration)
- [Firebase Schema](#firebase-schema)
- [Project Structure](#project-structure)
- [Features](#features)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

AnaPay is a cross-platform Flutter application that provides:
- **Email & Google OAuth Authentication** - Secure user registration and login
- **Firebase Cloud Messaging (FCM)** - Real-time push notifications for payment events
- **Cloud Firestore Integration** - User profile management and token storage
- **Responsive Design** - Works seamlessly on Web, iOS, and Android

Built with **Clean Architecture** principles for maintainability, testability, and scalability.

---

## 🏗️ Architecture

This project follows **Clean Architecture** with three distinct layers:

### 1. **Domain Layer** (`lib/features/*/domain/`)
- Pure Dart code with no external dependencies
- Contains business logic entities, repository interfaces, and use cases
- Framework-agnostic and platform-independent

### 2. **Data Layer** (`lib/features/*/data/`)
- Implements domain repositories
- Contains Firebase-specific code
- Handles data mapping and network communication
- Depends only on domain layer

### 3. **Presentation Layer** (`lib/features/*/presentation/`)
- Flutter UI components and pages
- State management and user interaction
- Depends only on domain layer

### 4. **Core Layer** (`lib/core/`)
- Shared utilities and services
- Error handling (exceptions, failures, Either type)
- Dependency injection (Service Locator)
- Firebase Messaging Service
- Notification Overlay Service

---

## 📦 Prerequisites

Before setting up the project, ensure you have:

- **Flutter SDK** (version 3.13.0 or higher)
- **Dart SDK** (bundled with Flutter)
- **Firebase Project** with:
  - Firebase Authentication enabled
  - Cloud Firestore enabled
  - Firebase Cloud Messaging enabled
  - Google OAuth credentials configured
- **Git** for version control
- **Text Editor/IDE** (VS Code recommended)

### Check Installation

```bash
flutter --version
dart --version
firebase --version
```

---

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/Ahmed10257/AnaPay-Task.git
cd AnaPay-Task/Flutter\ App
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

#### a) Install Firebase CLI (if not already installed)

```bash
npm install -g firebase-tools
```

#### b) Authenticate with Firebase

```bash
firebase login
```

#### c) Initialize Firebase for Flutter

```bash
flutterfire configure
```

This will:
- Detect your Flutter platforms (Web, iOS, Android)
- Link your Firebase project
- Generate platform-specific configuration files
- Create `lib/firebase_options.dart` with your credentials

### 4. Update Firebase Configuration Files

Ensure the following files are properly configured:

- **Android**: `android/app/google-services.json`
- **iOS**: `ios/Runner/GoogleService-Info.plist`
- **Web**: Generated automatically by `flutterfire configure`

### 5. Google OAuth Setup

#### For Web:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** → **Credentials**
4. Add authorized redirect URIs:
   - `https://anapay-task.web.app/` (Production)
   - `http://localhost:7777/` (Local development)
5. Download the OAuth 2.0 credentials (JSON)

#### For Android:

1. Get your app's SHA-1 fingerprint:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
2. Add fingerprint to Firebase Console → Project Settings → Android app

#### For iOS:

1. Configure in Firebase Console → Project Settings → iOS app
2. Add bundle identifier: `com.example.anapayApp`

### 6. Run the Application

#### Web (Recommended for quick testing)

```bash
flutter run -d chrome
```

The app will open at `http://localhost:7777/`

#### Android

```bash
flutter run -d android
```

#### iOS (macOS only)

```bash
flutter run -d ios
```

---

## 🔧 Local Environment Configuration

### Environment Variables

Create a `.env` file in the `Flutter App` directory (optional for Firebase auto-configuration):

```env
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
GOOGLE_OAUTH_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
```

### Platform-Specific Configurations

#### Web Configuration (`web/index.html`)

```html
<!-- Firebase SDK and messaging service worker are initialized here -->
<script src="https://www.gstatic.com/firebasejs/10.0.0/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging.js"></script>
```

#### Service Worker (`web/firebase-messaging-sw.js`)

Handles background notifications on the web platform:
- Listens for background FCM messages
- Displays browser notifications
- Manages notification clicks
- Provides fallback notification display

#### Flutter Configuration (`pubspec.yaml`)

Key dependencies:
```yaml
firebase_core: ^2.24.0
firebase_auth: ^4.10.0
cloud_firestore: ^4.13.0
firebase_messaging: ^14.6.0
google_sign_in: ^6.1.0
```

---

## 📊 Firebase Schema

### Firestore Collections Structure

#### **Users Collection**

Path: `users/{uid}`

```json
{
  "uid": "firebase-auth-uid",
  "email": "user@example.com",
  "displayName": "John Doe",
  "phoneNumber": "+1234567890",
  "fcmToken": "eJxyz0AW4yrAE0YWZmYWJiYWphYmlhYWJmZGhiYWJqaWJiYmpkZGhibGJiYmJqaGhoYmJhYmJhYW...",
  "fcmTokenUpdatedAt": "2025-11-29T10:30:00Z",
  "createdAt": "2025-11-20T14:25:30Z",
  "updatedAt": "2025-11-29T10:30:00Z"
}
```

#### **FCM Token Storage Details**

| Field | Type | Description |
|-------|------|-------------|
| `uid` | `string` | Firebase Authentication UID (Primary Key) |
| `email` | `string` | User's email address |
| `displayName` | `string` | User's full name |
| `phoneNumber` | `string` | User's phone number (optional) |
| `fcmToken` | `string` | Firebase Cloud Messaging token for push notifications |
| `fcmTokenUpdatedAt` | `timestamp` | Last time FCM token was refreshed |
| `createdAt` | `timestamp` | Account creation timestamp |
| `updatedAt` | `timestamp` | Last profile update timestamp |

#### **FCM Token Lifecycle**

1. **Generation**: Token is generated during `getFCMToken()` in `firebase_auth_data_source.dart`
2. **Permission**: User must grant notification permission during login
3. **Retrieval**: Token is obtained with VAPID key for web platform compatibility
4. **Storage**: Token is stored in Firestore under `users/{uid}/fcmToken`
5. **Refresh**: Token is automatically refreshed when app re-initializes
6. **Update**: Backend uses this token to send targeted push notifications

---

## 📁 Project Structure

```
Flutter App/
├── lib/
│   ├── main.dart                     # App entry point
│   ├── firebase_options.dart         # Firebase config (auto-generated)
│   ├── core/                         # Shared utilities, error handling, services, DI
│   ├── config/                       # Routes and theme configuration
│   └── features/
│       ├── authentication/           # Login, register, auth logic (clean architecture)
│       └── home/                     # Home page after login
│
├── web/
│   ├── firebase-messaging-sw.js      # Service worker for background notifications
│   ├── index.html                    # Web entry point
│   └── manifest.json                 # PWA manifest
│
├── android/ & ios/                   # Platform-specific configurations
├── pubspec.yaml                      # Dependencies & configuration
└── README.md                          # Documentation
```

---

## ✨ Features

### ✅ Implemented

- **Authentication**
  - Email/Password registration and login
  - Google OAuth sign-in
  - Secure token management
  - Auto-login on app restart

- **User Management**
  - User profile retrieval from Firestore
  - FCM token storage and refresh
  - Sign-out functionality

- **Notifications**
  - Firebase Cloud Messaging integration
  - Platform-aware notification handling:
    - **Web**: Service Worker handles background messages
    - **Mobile**: Flutter overlay for foreground messages
  - Automatic permission request during login

- **Error Handling**
  - Comprehensive exception hierarchy
  - Failure types for Result pattern
  - User-friendly error messages

- **Architecture**
  - Clean Architecture with 3 layers
  - Dependency Injection (Service Locator)
  - Functional programming (Either type)
  - Repository pattern

### 📋 Planned Features

- [ ] Transaction history
- [ ] Payment analytics
- [ ] Biometric authentication
- [ ] Offline mode with sync
- [ ] Multi-language support
- [ ] Dark mode theme

---

## 🐛 Troubleshooting

### Common Issues

#### **FCM Token Not Appearing in Firestore**

**Problem**: Token field is empty or null in Firestore user document

**Solution**:
1. Ensure user granted notification permission during login
2. Check browser console for errors (use DevTools)
3. Verify service worker is registered:
   ```javascript
   navigator.serviceWorker.getRegistrations().then(regs => console.log(regs))
   ```
4. Check `firebase-messaging-sw.js` is in `web/` directory

#### **Google Sign-In Fails**

**Problem**: "redirect_uri_mismatch" error

**Solution**:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Verify authorized redirect URIs match your app URL
3. For local testing, add: `http://localhost:7777/`
4. For production, add: `https://anapay-task.web.app/`

#### **Notifications Not Showing**

**Problem**: App receives notification but doesn't display

**Solution**:
1. Check notification permissions are granted
2. Verify FCM token is in Firestore
3. Check browser console for service worker errors
4. Clear browser cache and reinstall service worker
5. Check notification settings in browser

#### **Firebase Configuration Not Loading**

**Problem**: "Firebase app not initialized" error

**Solution**:
1. Run `flutterfire configure` again
2. Verify `lib/firebase_options.dart` exists
3. Check `pubspec.yaml` has all Firebase packages
4. Clear Flutter cache: `flutter clean && flutter pub get`

#### **Build Errors on Different Platforms**

**Problem**: Build fails on Android/iOS/Web

**Solution**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade

# Platform-specific clean
flutter pub cache repair
cd android && ./gradlew clean && cd ..
cd ios && pod deintegrate && pod install && cd ..
```

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)
- [Service Workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 👨‍💻 Author

**Ahmed** - [GitHub Profile](https://github.com/Ahmed10257)

---

## 🔗 Links

- **Live App**: https://anapay-task.web.app/
- **GitHub Repository**: https://github.com/Ahmed10257/AnaPay-Task
- **Support Tool**: Check `Support Tool/` directory for backend and admin panel

---

**Last Updated**: November 29, 2025
