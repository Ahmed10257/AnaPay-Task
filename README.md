# AnaPay Task

A comprehensive payment ecosystem consisting of a Flutter mobile/web application and a support management tool. This repository contains the complete AnaPay infrastructure with user authentication, push notifications, and admin support capabilities.

---

## 📦 Projects Overview

### 🚀 [AnaPay App](./Flutter%20App/README.md)

A modern Flutter application implementing clean architecture with Firebase authentication and cloud messaging for payment notifications.

**Key Features:**

- ✅ Email & Google OAuth Authentication
- ✅ Firebase Cloud Messaging (FCM) for real-time notifications
- ✅ Cloud Firestore user profile management
- ✅ Cross-platform support (Web, iOS, Android)
- ✅ Clean Architecture with dependency injection

**Live Demo:** https://anapay-task.web.app/

**Quick Start:**

```bash
cd "Flutter App"
flutter pub get
flutterfire configure
flutter run -d chrome
```

[📖 View Detailed Documentation](./Flutter%20App/README.md)

---

### 🛠️ [AnaPay Support Tool](./Support%20Tool/README.md)

A comprehensive support dashboard for managing users and sending push notifications. Features a dual-interface design with both GUI and CLI capabilities.

**Key Features:**

- ✅ Dual Interface (GUI + CLI)
- ✅ User search and verification
- ✅ Firebase authentication status checking
- ✅ FCM token retrieval
- ✅ Push notification delivery
- ✅ Real-time status tracking

**Quick Start:**

```bash
# Frontend (Angular)
cd "Support Tool/frontend"
npm install
ng serve

# Backend (NestJS)
cd "Support Tool/backend"
npm install
npm run start:dev
```

[📖 View Detailed Documentation](./Support%20Tool/README.md)

---

## 🏗️ Repository Structure

```
AnaPay-Task/
├── Flutter App/
│   ├── lib/                          # Flutter source code (clean architecture)
│   ├── android/                      # Android configuration
│   ├── ios/                          # iOS configuration
│   ├── web/                          # Web platform files
│   ├── pubspec.yaml                  # Flutter dependencies
│   └── README.md                     # Flutter app documentation
│
├── Support Tool/
│   ├── frontend/                     # Angular admin dashboard
│   │   ├── src/
│   │   ├── package.json
│   │   └── README.md
│   ├── backend/                      # NestJS backend server
│   │   ├── src/
│   │   ├── package.json
│   │   └── README.md
│   └── README.md                     # Support tool documentation
│
├── firebase.json                     # Firebase configuration
└── README.md                         # This file
```

---

## 🔗 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      Firebase Platform                           │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Authentication  │  Firestore  │  Cloud Messaging (FCM) │   │
│  └─────────────────────────────────────────────────────────┘   │
└──────────┬──────────────────────────────┬──────────────────────┘
           │                              │
    ┌──────▼────────┐            ┌───────▼─────────┐
    │  Flutter App  │            │ Support Tool    │
    │               │            │                 │
    │ • Web         │            │ • Backend(Node) │
    │ • iOS         │            │ • Frontend(Ang) │
    │ • Android     │            │ • CLI Interface │
    └───────────────┘            └─────────────────┘
```

---

## 🎯 Use Cases

### For End Users (Flutter App)

- Sign up and authenticate securely
- Receive real-time payment notifications
- Manage profile and preferences
- Cross-platform access (web, mobile)

### For Support Team (Support Tool)

- Search and verify users in the system
- Retrieve FCM tokens for targeted notifications
- Send custom push notifications to users
- Track notification delivery status
- Use GUI for visual interface or CLI for batch operations

---

## 🔐 Security Features

- ✅ Firebase Authentication with OAuth 2.0
- ✅ Secure FCM token management
- ✅ Environment-based configuration
- ✅ Error handling and validation
- ✅ CORS protection
- ✅ Rate limiting ready

---

## 📋 Prerequisites

### For Flutter App

- Flutter SDK 3.10.1+
- Dart SDK (bundled with Flutter)
- Firebase Project setup
- Google OAuth credentials

### For Support Tool

- Node.js 18+
- Angular CLI
- NestJS setup
- Firebase Admin credentials

---

## 🚀 Quick Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Ahmed10257/AnaPay-Task.git
cd AnaPay-Task
```

### 2. Setup Firebase

```bash
npm install -g firebase-tools
firebase login
```

### 3. Deploy Flutter App

```bash
cd "Flutter App"
flutter pub get
flutterfire configure
flutter run -d chrome
```

### 4. Start Support Tool

```bash
# Terminal 1 - Backend
cd "Support Tool/backend"
npm install
npm run start:dev

# Terminal 2 - Frontend
cd "Support Tool/frontend"
npm install
ng serve
```

---

## 📊 Key Features Comparison

| Feature               | Flutter App | Support Tool |
| --------------------- | ----------- | ------------ |
| User Authentication   | ✓           | ✓            |
| FCM Integration       | ✓           | ✓            |
| Firestore Integration | ✓           | ✓            |
| Push Notifications    | ✓ (Receive) | ✓ (Send)     |
| Web Support           | ✓           | ✓            |
| Mobile Support        | ✓           | Limited      |
| CLI Interface         | ✗           | ✓            |
| Batch Operations      | ✗           | ✓            |
| User-Friendly GUI     | ✓           | ✓            |

---

## 📚 Documentation

- **[Flutter App Documentation](./Flutter%20App/README.md)** - Complete setup, architecture, and troubleshooting
- **[Support Tool Documentation](./Support%20Tool/README.md)** - GUI/CLI usage, API endpoints, and features

---

## 🔧 Common Tasks

### Check User Status

**Using Support Tool CLI:**

```bash
> check user_12345
✓ User found
├─ UID: user_12345
├─ FCM Token: dh7hsd8h_asd8h7...
├─ Auth Status: Verified
└─ Last Active: 2025-11-29 10:30:45
```

### Send Push Notification

**Using Support Tool CLI:**

```bash
> push user_12345 --message "Welcome Back|Your account is ready"
✓ Notification sent successfully
```

### View App Logs

```bash
cd "Flutter App"
flutter logs
```

### Debug Backend

```bash
cd "Support Tool/backend"
npm run start:debug
```

---

## 🐛 Troubleshooting

### Firebase Configuration Issues

- Run `flutterfire configure` to regenerate Firebase config
- Check `firebase.json` is properly configured
- Verify Google credentials in Console

### FCM Token Not Appearing

- Grant notification permissions during login
- Check service worker registration in browser
- Verify `firebase-messaging-sw.js` exists in web/

### Backend Connection Errors

- Ensure backend is running on `localhost:3000`
- Check `.env` file for correct Firebase credentials
- Verify Firestore permissions

For detailed troubleshooting, see individual project READMEs.

---

## 🚀 Deployment

### Flutter App

```bash
cd "Flutter App"
flutter build web --release
firebase deploy --only hosting
```

### Support Tool

```bash
# Backend
cd "Support Tool/backend"
npm run build
# Deploy to your hosting

# Frontend
cd "Support Tool/frontend"
ng build --configuration production
# Deploy to your hosting
```

---

## 📞 Support

For issues or questions:

1. Check the relevant project README
2. Review troubleshooting sections
3. Check browser/server console for errors
4. Verify Firebase configuration

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Ahmed** - [GitHub Profile](https://github.com/Ahmed10257)

---

## 🔗 Quick Links

| Link                                                           | Purpose                   |
| -------------------------------------------------------------- | ------------------------- |
| [Flutter App Live Demo](https://anapay-task.web.app/)          | View the live application |
| [GitHub Repository](https://github.com/Ahmed10257/AnaPay-Task) | Source code               |
| [Flutter Documentation](https://docs.flutter.dev/)             | Flutter framework docs    |
| [Firebase Documentation](https://firebase.google.com/docs)     | Firebase services         |
| [NestJS Documentation](https://docs.nestjs.com/)               | Backend framework         |
| [Angular Documentation](https://angular.io/docs)               | Frontend framework        |

---

## 📈 Project Status

- **Flutter App**: ✅ Production Ready
- **Support Tool**: ✅ Production Ready
- **Documentation**: ✅ Complete
- **Firebase Integration**: ✅ Fully Configured

---

**Last Updated:** December 1, 2025  
**Version:** 1.0.0
