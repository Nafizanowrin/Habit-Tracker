# Firebase Setup Guide for Habit Tracker

This guide will help you set up Firebase for your Habit Tracker app.

## 🔥 Firebase Project Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `habit-tracker-bc361`
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2. Enable Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Enable "Email/Password" provider
5. Click "Save"

### 3. Create Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (we'll add security rules later)
4. Select a location (choose closest to your users)
5. Click "Done"

### 4. Enable Storage (Optional)
1. In Firebase Console, go to "Storage"
2. Click "Get started"
3. Choose "Start in test mode"
4. Select a location
5. Click "Done"

## 📱 Flutter Configuration

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase for Flutter
```bash
cd habit_tracker
dart pub global run flutterfire_cli:flutterfire configure --project=habit-tracker-bc361
```

This will:
- Generate `lib/firebase_options.dart`
- Configure all platforms (Android, iOS, Web, Windows, macOS)
- Register your app with Firebase

## 🔒 Security Rules

### Firestore Rules
Copy the contents of `firestore.rules` to Firebase Console:
1. Go to Firestore Database
2. Click "Rules" tab
3. Replace the rules with the content from `firestore.rules`
4. Click "Publish"

### Storage Rules (if using Storage)
Copy the contents of `storage.rules` to Firebase Console:
1. Go to Storage
2. Click "Rules" tab
3. Replace the rules with the content from `storage.rules`
4. Click "Publish"

## 📊 Database Structure

Your Firestore database will have this structure:

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

## 🚀 Testing the Setup

### 1. Run the App
```bash
flutter run -d chrome
```

### 2. Test Authentication
1. Try creating a new account
2. Try signing in
3. Check if user data appears in Firestore

### 3. Test Habits
1. Create a new habit
2. Mark it as completed
3. Check if data appears in Firestore

### 4. Test Quotes
1. Add a quote to favorites
2. Check if it appears in Firestore

## 🔧 Troubleshooting

### Common Issues

1. **"Firebase not initialized"**
   - Make sure `firebase_options.dart` exists
   - Check that Firebase is initialized in `main.dart`

2. **"Permission denied"**
   - Check Firestore security rules
   - Make sure user is authenticated

3. **"Project not found"**
   - Verify project ID in `firebase_options.dart`
   - Check Firebase Console for correct project

4. **"Authentication failed"**
   - Enable Email/Password in Firebase Console
   - Check authentication rules

### Debug Mode
Enable debug mode in Firebase Console:
1. Go to Project Settings
2. Add your app's debug SHA-1 (Android)
3. Add your app's bundle ID (iOS)

## 📱 Platform-Specific Setup

### Android
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/`
3. Add Google Services plugin to `android/build.gradle`

### iOS
1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to your iOS project
3. Add Firebase pods to `ios/Podfile`

### Web
1. No additional setup needed
2. Firebase is configured via `firebase_options.dart`

## 🔐 Security Best Practices

1. **Never commit API keys to version control**
   - Use environment variables
   - Add `firebase_options.dart` to `.gitignore`

2. **Use proper security rules**
   - Always validate user authentication
   - Restrict access to user's own data

3. **Enable App Check** (recommended)
   - Go to Firebase Console
   - Enable App Check for your app

4. **Monitor usage**
   - Set up billing alerts
   - Monitor Firebase Console for unusual activity

## 📈 Next Steps

1. **Enable Analytics** (optional)
   - Go to Firebase Console
   - Enable Google Analytics

2. **Set up Notifications** (optional)
   - Go to Firebase Console
   - Enable Cloud Messaging

3. **Add Crashlytics** (optional)
   - Go to Firebase Console
   - Enable Crashlytics

4. **Production Deployment**
   - Update security rules for production
   - Set up proper authentication flows
   - Configure domain verification

## 📞 Support

If you encounter issues:
1. Check Firebase Console for errors
2. Review Flutter Firebase documentation
3. Check Firebase status page
4. Contact Firebase support

---

**Note**: This setup is for development. For production, ensure you:
- Set up proper security rules
- Enable App Check
- Configure domain verification
- Set up monitoring and alerts
