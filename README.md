# 🎯 Habit Tracker App

[![Flutter](https://img.shields.io/badge/Flutter-3.16.9-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.2.6-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Cloud-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS-lightgrey.svg)](https://flutter.dev/)

A modern, cross-platform Flutter application to help users **build and maintain habits** with real-time sync powered by Firebase.

---

## ✨ Features

- 🔐 **Authentication**: Secure login with Firebase Auth  
- 📝 **Habit Management**: Create, edit, delete, and track habits  
- 📊 **Progress Tracking**: Streaks, history, and visual analytics  
- 📂 **Categories**: Organize habits (Health, Fitness, Study, etc.)  
- 💬 **Motivational Quotes**: Daily quotes with favorites  
- 👤 **User Profiles**: Customizable user profiles  
- ⚙️ **Settings**: Themes, notifications, preferences  
- 🌙 **Dark Mode** & responsive Material Design 3 UI  

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Frontend | Flutter 3.16.9, Dart 3.2.6 |
| Backend | Firebase (Auth, Firestore, Storage) |
| State Management | Riverpod |
| Charts | fl_chart |
| Local Storage | SharedPreferences |

---

### 🔥 Firebase Integration
- **🔐 Authentication**: Firebase Auth with email/password and secure session management
- **🗄️ Database**: Cloud Firestore for real-time data synchronization
- **📁 Storage**: Firebase Storage for profile pictures and media
- **🛡️ Security**: Comprehensive security rules and data protection


## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- [Firebase CLI](https://firebase.google.com/docs/cli) (optional)
- IDE: [VS Code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio), or [IntelliJ IDEA](https://www.jetbrains.com/idea/)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/Nafizanowrin/Habit-Tracker.git
cd Habit-Tracker
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (e.g., `habit-tracker-app`)
3. Enable Authentication → Email/Password
4. Create Firestore Database → Start in test mode
5. Enable Storage (optional)

#### Configure FlutterFire
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
dart pub global run flutterfire_cli:flutterfire configure --project=YOUR_PROJECT_ID
```

#### Set Up Security Rules
1. Copy `firestore.rules` to Firebase Console → Firestore → Rules
2. Copy `storage.rules` to Firebase Console → Storage → Rules (if using Storage)

### 4. Run the Application
```bash
# Web
flutter run -d chrome
```

## 📸 Screenshots

### 1. Splash & Register Page  
<p float="left">
  <img src="Splash.jpg" alt="Splash" width="300"/>
  <img src="Register page.jpg" alt="Register Page" width="300"/>
</p>

### 2. Login & Home Screen 
<p float="left">
  <img src="Sign up page.jpg" alt="Login Page" width="300"/>
  <img src="home page.jpg" alt="Home Page" width="300"/>
</p>

### 3. Home Screen 
<p float="left">
  <img src="home page1.jpg" alt="Home Screen 1" width="300"/>
  <img src="smart reminders.jpg" alt="Home Screen 2" width="300"/>
</p>

<p float="left">
  <img src="categories.jpg" alt="Home Screen 3" width="300"/>
  <img src="habit cart1.jpg" alt="Home Screen 4" width="300"/>
</p>

<p float="left">
  <img src="habit cart2.jpg" alt="Home Screen 5" width="300"/>
  <img src="habit cart3.jpg" alt="Home Screen 6" width="300"/>
</p>

### 4. Quotes & Favorites  
<p float="left">
  <img src="Quotes.jpg" alt="Cart Screen" width="300"/>
  <img src="Quotes fav.jpg" alt="Favorites" width="300"/>
</p>

### 5. Profile & Edit Option
<p float="left">
  <img src="Profile.jpg" alt="Profile" width="300"/>
  <img src="edit Profile.jpg" alt="Drawer" width="300"/>
</p>

### 6. Settings & Theme  
<p float="left">
  <img src="light mode.jpg" alt="Setting" width="300"/>
  <img src="theme.jpg" alt="Light Mode" width="300"/>
  <img src="dark mode.jpg" alt="Dark Mode" width="300"/>
</p>


---
## 📥 Download

You can download and try the latest APK version of the Habit Tracker app here:

[![Download APK](https://img.shields.io/badge/⬇️%20Download-APK-brightgreen?style=for-the-badge)](./f6d7a361-8ba9-48b1-873e-b3bf8a09dbe2.apk)

---
## 📊 Database Structure

```json
{
  "users": {
    "{userId}": {
      "email": "string",
      "displayName": "string",
      "createdAt": "timestamp",
      "lastLoginAt": "timestamp",
      "gender": "string (optional)",
      "dateOfBirth": "timestamp (optional)",
      "height": "number (optional)",
      "habits": {
        "{habitId}": {
          "title": "string",
          "description": "string",
          "category": "string",
          "frequency": "string",
          "createdAt": "timestamp",
          "lastCompletedAt": "timestamp",
          "streakCount": "number",
          "completionHistory": "array"
        }
      },
      "favorites": {
        "quotes": {
          "items": {
            "{quoteId}": {
              "text": "string",
              "author": "string",
              "category": "string",
              "createdAt": "timestamp"
            }
          }
        }
      }
    }
  }
}
```

## 🏗️ Architecture

The app follows Clean Architecture principles with feature-based organization:

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Main app widget
├── firebase_options.dart        # Firebase configuration
├── features/
│   ├── auth/                   # Authentication
│   │   ├── data/
│   │   │   ├── auth_repository.dart
│   │   │   └── session_service.dart
│   │   ├── domain/
│   │   │   └── user.dart
│   │   └── presentation/
│   │       ├── auth_provider.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── habits/                 # Habit management
│   │   ├── data/
│   │   │   └── habits_repository.dart
│   │   ├── domain/
│   │   │   └── habit.dart
│   │   └── presentation/
│   │       ├── habits_provider.dart
│   │       ├── habits_screen.dart
│   │       ├── create_habit_screen.dart
│   │       └── habit_details_screen.dart
│   ├── quotes/                 # Motivational quotes
│   │   ├── data/
│   │   │   └── quotes_repository.dart
│   │   ├── domain/
│   │   │   └── quote.dart
│   │   └── presentation/
│   │       ├── quotes_provider.dart
│   │       └── quotes_screen.dart
│   ├── profile/                # User profile
│   │   └── presentation/
│   │       ├── profile_screen.dart
│   │       └── edit_profile_screen.dart
│   ├── settings/               # App settings
│   │   └── presentation/
│   │       └── settings_screen.dart
│   └── splash/                 # Splash screen
│       └── splash_screen.dart
└── common/
    ├── providers/
    │   ├── notification_provider.dart
    │   ├── theme_provider.dart
    │   └── user_profile_provider.dart
    ├── theme/
    │   └── app_theme.dart
    └── utils/
        └── helpers.dart
```

## 🎨 UI/UX Features

- **🎨 Material Design 3**: Modern, beautiful interface with dynamic color
- **🌙 Dark Mode**: Complete theme support with automatic switching
- **📱 Responsive Design**: Optimized for all screen sizes and orientations
- **⏳ Loading States**: Smooth loading indicators and skeleton screens
- **❌ Error Handling**: User-friendly error messages and recovery options
- **🎭 Animations**: Smooth transitions, micro-interactions, and feedback

## 📈 Performance Features

- **⚡ Real-time Updates**: Live data synchronization across devices
- **📴 Offline Support**: Basic offline functionality with local caching
- **💾 Caching**: Intelligent local data caching for better performance
- **🔍 Optimized Queries**: Efficient Firestore queries with pagination
- **🔄 Lazy Loading**: Progressive data loading for better UX

#
## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID= habit-tracker-bc361
FIREBASE_API_KEY= AIzaSyDFE82jBNAykT7XSfI6PcscwME8TIuyo3s
```

### Firebase Configuration
The app uses `firebase_options.dart` for Firebase configuration. This file is automatically generated by FlutterFire CLI.

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Firebase not initialized** | Ensure `firebase_options.dart` exists and check Firebase initialization in `main.dart` |
| **Permission denied** | Verify Firestore security rules and check user authentication status |
| **Build errors** | Run `flutter clean` and `flutter pub get`, check Flutter and Dart versions |
| **Authentication issues** | Enable Email/Password in Firebase Console and verify project configuration |
| **Network errors** | Check internet connection and Firebase project status |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/amazing-feature`)
3. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 📤 Push to the branch (`git push origin feature/amazing-feature`)
5. 🔄 Open a Pull Request


