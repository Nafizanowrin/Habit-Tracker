# Habit Tracker App

A comprehensive Flutter application for tracking daily habits, managing goals, and staying motivated with inspirational quotes. Built with Firebase backend for real-time data synchronization.

## 🚀 Features

### ✅ Core Functionality
- **User Authentication**: Email/password registration and login
- **Habit Management**: Create, edit, delete, and track habits
- **Progress Tracking**: Visual progress indicators and streak counting
- **Category System**: Organize habits by categories (Health, Study, Fitness, etc.)
- **Inspirational Quotes**: Motivational quotes with favorites system
- **User Profiles**: Complete profile management with editable fields
- **Settings**: App preferences and theme customization

### 🔥 Firebase Integration
- **Authentication**: Firebase Auth with email/password
- **Database**: Firestore for real-time data synchronization
- **Storage**: Firebase Storage for profile pictures (optional)
- **Security**: Comprehensive security rules for data protection

### 📱 Cross-Platform Support
- **Web**: Full web application
- **Android**: Native Android app
- **iOS**: Native iOS app
- **Windows**: Desktop Windows app
- **macOS**: Desktop macOS app

## 🛠️ Technology Stack

- **Frontend**: Flutter 3.x
- **Backend**: Firebase
- **State Management**: Riverpod
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **Charts**: fl_chart
- **Local Storage**: SharedPreferences

## 📋 Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Firebase project
- IDE (VS Code, Android Studio, or IntelliJ)

## 🔧 Installation & Setup

### 1. Clone the Repository
```bash
git clone <repository-url>
cd habit_tracker
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Setup

#### Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named `habit-tracker-bc361`
3. Enable Authentication (Email/Password)
4. Create Firestore Database
5. Enable Storage (optional)

#### Configure FlutterFire
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
dart pub global run flutterfire_cli:flutterfire configure --project=habit-tracker-bc361
```

#### Set Up Security Rules
1. Copy `firestore.rules` to Firebase Console → Firestore → Rules
2. Copy `storage.rules` to Firebase Console → Storage → Rules (if using Storage)

### 4. Run the Application
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📊 Database Structure

```
users/
├── {userId}/
│   ├── email: string
│   ├── displayName: string
│   ├── createdAt: timestamp
│   ├── lastLoginAt: timestamp
│   ├── gender: string (optional)
│   ├── dateOfBirth: timestamp (optional)
│   ├── height: number (optional)
│   ├── habits/
│   │   ├── {habitId}/
│   │   │   ├── title: string
│   │   │   ├── description: string
│   │   │   ├── category: string
│   │   │   ├── frequency: string
│   │   │   ├── createdAt: timestamp
│   │   │   ├── lastCompletedAt: timestamp
│   │   │   ├── streakCount: number
│   │   │   └── completionHistory: array
│   └── favorites/
│       └── quotes/
│           └── items/
│               ├── {quoteId}/
│               │   ├── text: string
│               │   ├── author: string
│               │   ├── category: string
│               │   └── createdAt: timestamp
```

## 🏗️ Architecture

The app follows Clean Architecture principles:

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # Main app widget
├── firebase_options.dart        # Firebase configuration
├── features/
│   ├── auth/                   # Authentication
│   │   ├── data/
│   │   │   └── auth_repository.dart
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
│   │       └── create_habit_screen.dart
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
│   │       └── profile_screen.dart
│   └── settings/               # App settings
│       └── presentation/
│           └── settings_screen.dart
└── common/
    ├── theme/                  # App theming
    │   └── app_theme.dart
    ├── widgets/                # Reusable widgets
    └── utils/                  # Utility functions
```

## 🔒 Security Features

- **Authentication**: Firebase Auth with email/password
- **Authorization**: User-based access control
- **Data Validation**: Input validation and sanitization
- **Security Rules**: Firestore and Storage security rules
- **Error Handling**: Comprehensive error handling

## 🎨 UI/UX Features

- **Material Design 3**: Modern, beautiful interface
- **Dark Mode**: Complete theme support
- **Responsive Design**: Works on all screen sizes
- **Loading States**: Proper loading indicators
- **Error Handling**: User-friendly error messages
- **Animations**: Smooth transitions and animations

## 📈 Performance Features

- **Real-time Updates**: Live data synchronization
- **Offline Support**: Basic offline functionality
- **Caching**: Local data caching
- **Optimized Queries**: Efficient Firestore queries
- **Lazy Loading**: Progressive data loading

## 🧪 Testing

```bash
# Run tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📦 Building for Production

```bash
# Web
flutter build web

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:
```env
FIREBASE_PROJECT_ID=habit-tracker-bc361
```

### Firebase Configuration
The app uses `firebase_options.dart` for Firebase configuration. This file is automatically generated by FlutterFire CLI.

## 🐛 Troubleshooting

### Common Issues

1. **Firebase not initialized**
   - Ensure `firebase_options.dart` exists
   - Check Firebase initialization in `main.dart`

2. **Permission denied**
   - Verify Firestore security rules
   - Check user authentication status

3. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Check Flutter and Dart versions

4. **Authentication issues**
   - Enable Email/Password in Firebase Console
   - Check Firebase project configuration

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📞 Support

For support and questions:
- Check the [Firebase Setup Guide](FIREBASE_SETUP.md)
- Review Firebase documentation
- Open an issue on GitHub

## 🚀 Deployment

### Web Deployment
```bash
flutter build web
# Deploy to Firebase Hosting, Netlify, or Vercel
```

### Mobile Deployment
```bash
# Android
flutter build appbundle
# Upload to Google Play Console

# iOS
flutter build ios
# Upload to App Store Connect
```

---

**Note**: This is a development setup. For production deployment, ensure you:
- Set up proper security rules
- Enable App Check
- Configure domain verification
- Set up monitoring and alerts
- Test thoroughly on all platforms
#   H a b i t - T r a c k e r  
 