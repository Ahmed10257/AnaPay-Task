# AnaPay Support Tool

A comprehensive support dashboard for managing users and sending push notifications. Features a dual-interface design with both GUI and CLI capabilities.

## 🌟 Features

### Dual Interface Architecture
- **GUI Interface** - Visual form-based interface for user management and notifications
- **CLI Interface** - Terminal-style interface for power users and automation
- **Seamless Navigation** - Easy switching between interfaces via navbar

### Core Capabilities

#### User Management
- Search and retrieve user Firebase authentication status
- View user FCM tokens for push notification delivery
- Real-time user data from Firestore database
- Instant user verification

#### Push Notifications
- Send customizable push notifications to specific users
- Support for title and body customization
- Real-time notification delivery tracking
- Test notifications for debugging

---

## 🎨 GUI Interface

### Overview
The GUI provides an intuitive, form-based interface for support staff to manage users and send notifications.

### Features
- **User Search Tab** - Quick user lookup with status display
- **Notification Sender Tab** - Custom notification composition
- **Real-time Status** - Live feedback on operations
- **Error Handling** - Clear error messages and guidance
- **Responsive Design** - Works on desktop and tablet

### User Interface Elements
```
┌─────────────────────────────────────────────────────┐
│  User ID Check    |    Send Notification            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Enter User ID:  [_____________________]  [Search]  │
│                                                     │
│  Status: ✓ User found                              │
│  Token: abc123xyz...                               │
│  Auth Status: Verified                             │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Tab Descriptions

**User ID Check Tab**
- Input user ID or email
- View authentication status
- Display FCM token
- Verify user exists in system

**Send Notification Tab**
- Select recipient user ID
- Customize notification title
- Customize notification body
- Preview before sending
- Track delivery status

---

## 💻 CLI Interface

### Overview
The CLI provides a powerful terminal-style interface for advanced users, automation scripts, and batch operations.

### Command Structure
```
> [command] [arguments] [options]
```

### Available Commands

#### 1. Check User Status
```bash
check <user_id>
```

Retrieves user information from Firebase including authentication status and FCM token.

**Example:**
```bash
> check user_12345
✓ User found
├─ UID: user_12345
├─ FCM Token: dh7hsd8h_asd8h7...
├─ Auth Status: Verified
└─ Last Active: 2025-11-29 10:30:45
```

**Response:**
- User authentication status
- Firebase Cloud Messaging token
- Account verification status
- Last activity timestamp

#### 2. Send Notification
```bash
push <user_id> --message "<title>|<body>"
```

Sends a push notification to the specified user. Use pipe character `|` to separate title from body.

**Example:**
```bash
> push user_12345 --message "Welcome Back|Your account is ready"
⏳ Sending notification...
✓ Notification sent successfully
├─ Recipient: user_12345
├─ Message ID: msg_987654
├─ Delivery Status: Delivered
└─ Timestamp: 2025-11-29 10:35:22
```

**Response:**
- Delivery confirmation
- Message ID for tracking
- Timestamp of delivery
- Status confirmation

#### 3. Help
```bash
help
```

Displays all available commands with descriptions.

**Example:**
```bash
> help
╔════════════════════════════════════════════════════╗
║            CLI COMMANDS REFERENCE                  ║
╠════════════════════════════════════════════════════╣
║ check <uid>         - Get user status & FCM token  ║
║ push <uid> --message "title|body" - Send notif    ║
║ help                - Show this help menu          ║
║ clear               - Clear terminal output        ║
╚════════════════════════════════════════════════════╝
```

#### 4. Clear Terminal
```bash
clear
```

Clears all command history and output from the terminal.

**Example:**
```bash
> clear
[Terminal cleared]
```

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Angular CLI
- NestJS backend running on `localhost:3000`

### Installation

1. **Install dependencies**
   ```bash
   cd frontend
   npm install
   ```

2. **Start the development server**
   ```bash
   ng serve
   ```

3. **Access the application**
   ```
   http://localhost:4200
   ```

### Using the GUI

1. Navigate to the **GUI** tab using the navbar
2. Enter a user ID in the "User ID Check" tab
3. Click **Search** to retrieve user information
4. Switch to "Send Notification" tab to send messages
5. Enter notification title and body
6. Click **Send** to deliver

### Using the CLI

1. Navigate to the **CLI** tab using the navbar
2. Type commands in the terminal input
3. Press **Execute** or Enter to run

**Example Workflow:**
```bash
> check user_abc123
[User information displays]

> push user_abc123 --message "Alert|Important update pending"
[Notification sent confirmation]
```

---

## 🔧 Technical Stack

### Frontend
- **Framework:** Angular (Standalone Components)
- **Styling:** Tailwind CSS + SCSS
- **Icons:** Lucide Angular
- **HTTP:** Axios/Fetch API
- **Routing:** Angular Router

### Backend
- **Framework:** NestJS
- **Database:** Firestore
- **Messaging:** Firebase Cloud Messaging (FCM)
- **Auth:** Firebase Authentication

### API Endpoints

#### Get User Information
```
GET /firestore/user/:uid
```

**Response:**
```json
{
  "uid": "user_12345",
  "email": "user@example.com",
  "fcmToken": "abc123xyz...",
  "authStatus": "verified",
  "lastActive": "2025-11-29T10:30:45Z"
}
```

#### Send Notification
```
POST /notifications/send
```

**Request Body:**
```json
{
  "uid": "user_12345",
  "title": "Notification Title",
  "body": "Notification body text"
}
```

**Response:**
```json
{
  "success": true,
  "messageId": "msg_987654",
  "deliveryStatus": "delivered",
  "timestamp": "2025-11-29T10:35:22Z"
}
```

---

## 📋 Command Examples

### Checking Multiple Users

**GUI Method:**
1. Enter first user ID
2. Note the token
3. Clear and repeat

**CLI Method:**
```bash
> check user_001
> check user_002
> check user_003
[All results displayed in history]
```

### Sending Batch Notifications

**GUI Method:**
- Send individually using the form

**CLI Method:**
```bash
> push user_001 --message "Promotion|New offer available"
> push user_002 --message "Promotion|New offer available"
> push user_003 --message "Promotion|New offer available"
[All delivery confirmations logged]
```

### Debugging User Issues

**GUI Method:**
1. Search for user
2. Verify token exists
3. Check auth status

**CLI Method:**
```bash
> check problem_user
> help
[View all available options]
```

---

## 🎯 Interface Comparison

| Feature | GUI | CLI |
|---------|-----|-----|
| **User-Friendly** | ✓ | Limited |
| **Bulk Operations** | ✗ | ✓ |
| **Script Integration** | ✗ | ✓ |
| **Visual Feedback** | ✓ | ✓ |
| **Fast Lookups** | ✓ | ✓ |
| **Learning Curve** | Minimal | Moderate |
| **Mobile Support** | ✓ | Limited |
| **Automation** | ✗ | ✓ |

---

## 📸 Live Testing Screenshots

### Real-World FCM Token Lifecycle Test

This section demonstrates the FCM token management system in action. The test shows how the system handles FCM tokens when a user deletes their token and re-authenticates.

#### Scenario: Token Deletion and Re-authentication

**Test Steps:**
1. User has FCM token registered in Firestore
2. Admin deletes the FCM token from Firestore
3. User logs out and logs back into the mobile app
4. System automatically generates and registers new FCM token
5. Support tool CLI verifies token was updated

#### Screenshot 1: Token Missing State (CLI)

```
$ check goNUaT0aFzXtPijCD7zarJnoqaH3
Fetching user data for: goNUaT0aFzXtPijCD7zarJnoqaH3...

User Information:
─────────────────────────────────────────────────
UID:                  goNUaT0aFzXtPijCD7zarJnoqaH3
Email:                ahmed.mansour10257@gmail.com
Display Name:         Ahmed Mansour
Phone:                N/A
─────────────────────────────────────────────────
Login Status:         🟢 Logged In
─────────────────────────────────────────────────
Created:              11/27/2025, 11:36:25 PM
Last Active:          12/2/2025, 3:09:41 AM
─────────────────────────────────────────────────
FCM Token Status:     ⚠️ Missing
Token Updated:        N/A
─────────────────────────────────────────────────
❌ No FCM token found - User may not have installed app or granted notification permissions
```

**What this shows:**
- User is **logged in** (🟢 Logged In)
- But FCM token is **missing** (⚠️ Missing)
- Last active timestamp shows recent activity
- Red error message explains the token is not available
- This state would occur after token deletion from Firestore

#### Screenshot 2: Token Recovered After Re-authentication (CLI)

```
$ check goNUaT0aFzXtPijCD7zarJnoqaH3
Fetching user data for: goNUaT0aFzXtPijCD7zarJnoqaH3...

User Information:
─────────────────────────────────────────────────
UID:                  goNUaT0aFzXtPijCD7zarJnoqaH3
Email:                ahmed.mansour10257@gmail.com
Display Name:         Ahmed Mansour
Phone:                N/A
─────────────────────────────────────────────────
Login Status:         🟢 Logged In
─────────────────────────────────────────────────
Created:              11/27/2025, 11:36:25 PM
Last Active:          12/2/2025, 6:27:01 AM
─────────────────────────────────────────────────
FCM Token Status:     ✅ Available
Token Updated:        N/A
─────────────────────────────────────────────────
Token (truncated): fOiQKtmiZpbCOQt7eL8fm:-APA91bGc8WI7gyDiPc5aEiS-4...
```

**What this shows:**
- User is still **logged in** (🟢 Logged In)
- FCM token is now **available** (✅ Available)
- Last Active timestamp updated to 6:27:01 AM (re-authentication event)
- Token is displayed (truncated for security)
- System successfully generated new token during re-authentication
- Notifications can now be sent to this user

#### Firestore Verification

The Firestore database shows the updated token details:

```
fcmToken: "fOiQKtmiZpbCOQt7eL8fm:-APA91bGc8WI7gyDiPc5aEiS-4SA47FHIpmj8pFrHiBiQ..."
isLoggedIn: true
LastLoginAt: December 2, 2025 at 6:27:02 AM UTC+2
lastStatusChangeAt: December 2, 2025 at 6:26:48 AM UTC+2
photoUrl: "https://lh3.googleusercontent.com/a/ACg8oclJh2WKji3K6AF70aWMCVQkudZQypAt3r5_HDiAc"
uid: "goNUaT0aFzXtPijCD7zarJnoqaH3"
updatedAt: December 2, 2025 at 6:27:01 AM UTC+2
```

**Key Observations:**
- `isLoggedIn` field is `true`
- `fcmToken` contains the new token value
- `updatedAt` timestamp reflects the re-authentication
- Token refresh occurs automatically on login

#### What This Test Proves

✅ **FCM Token Auto-Recovery:**
- System automatically generates FCM tokens on user login
- No manual intervention needed from users

✅ **Accurate Status Tracking:**
- Support tool correctly shows missing tokens
- After re-auth, token status updates automatically

✅ **Real-time Updates:**
- Firestore reflects changes immediately
- CLI commands show current accurate state

✅ **Production Readiness:**
- System handles token lifecycle properly
- Users don't lose notification capability when tokens are deleted
- Support team can monitor and verify token status

---

## 🛠️ Development

### Project Structure
```
Support Tool/
├── frontend/
│   ├── src/
│   │   └── app/
│   │       ├── Components/
│   │       │   ├── navbar/           # Navigation component
│   │       │   ├── uid-check/        # GUI interface
│   │       │   └── cli-interface/    # CLI interface
│   │       ├── Pages/
│   │       │   ├── gui-page/         # GUI wrapper
│   │       │   └── cli-page/         # CLI wrapper
│   │       ├── app.ts                # Main app component
│   │       └── app.routes.ts         # Route configuration
│   └── package.json
├── backend/
│   └── [NestJS application]
└── README.md
```

### Running in Development

**Terminal 1 - Frontend:**
```bash
cd frontend
npm install
ng serve --open
```

**Terminal 2 - Backend:**
```bash
cd backend
npm install
npm run start:dev
```

Both services will start and the application will be accessible at `http://localhost:4200`

---

## 📝 Terminal Output Styling

The CLI uses color-coded output for better readability:

- **🟢 Green** (`#00ff00`) - Success messages and confirmations
- **🔴 Red** (`#ff6b6b`) - Error messages
- **🔵 Blue** (`#87ceeb`) - Information messages
- **⚪ Default** - Regular command output

Example:
```
✓ Success: Operation completed      [Green background]
✗ Error: User not found             [Red background]
ℹ Info: Processing request...       [Blue background]
```

---

## 🔒 Security Notes

- All API calls require proper CORS headers
- User IDs are case-sensitive
- FCM tokens are sensitive - handle with care
- Commands are logged for audit purposes
- Rate limiting recommended for production

---

## 📞 Support

For issues or questions:
1. Check the **help** command in CLI
2. Review error messages in GUI
3. Check browser console for detailed errors
4. Verify backend connectivity

---

## 📄 License

This project is part of the AnaPay ecosystem.

---

## 🚀 Roadmap

- [ ] Export user data functionality
- [ ] Batch notification templates
- [ ] User analytics dashboard
- [ ] Advanced search filters
- [ ] Notification scheduling
- [ ] User segmentation by status
- [ ] CLI configuration file support
- [ ] Multi-language support

---

**Last Updated:** November 29, 2025  
**Version:** 1.0.0
