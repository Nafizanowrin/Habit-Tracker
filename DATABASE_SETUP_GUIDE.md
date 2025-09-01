# 🔥 Firebase Database Setup Guide

## Current Status
Your Flutter app is configured to use Firebase Firestore, but the database needs to be created in the Firebase Console.

## 📋 Step-by-Step Setup

### 1. Create Firestore Database

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Select your project**: `habit-tracker-bc361`
3. **Navigate to Firestore Database**:
   - Click "Firestore Database" in the left sidebar
   - Click "Create database"
4. **Choose security mode**:
   - Select "Start in test mode" (for development)
   - Click "Next"
5. **Choose location**:
   - Select a location (e.g., "us-central1" or closest to you)
   - Click "Done"

### 2. Set Up Security Rules

Once the database is created:

1. **Go to Firestore Rules**:
   - In Firestore Database, click the "Rules" tab
2. **Replace the rules** with this content:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own habits
    match /users/{userId}/habits/{habitId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own favorite quotes
    match /users/{userId}/favorites/quotes/{quoteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own settings
    match /users/{userId}/settings/{settingId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. **Click "Publish"**

### 3. Enable Authentication

1. **Go to Authentication**:
   - Click "Authentication" in the left sidebar
   - Click "Get started"
2. **Enable Email/Password**:
   - Go to "Sign-in method" tab
   - Enable "Email/Password" provider
   - Click "Save"

### 4. Test Your Setup

After completing the setup:

1. **Run your app**:
   ```bash
   flutter run -d chrome
   ```

2. **Test the connection**:
   - Sign up or sign in to your app
   - Create a new habit
   - Check Firebase Console to see if data appears

## 📊 Expected Database Structure

Your Firestore database will have this structure:

```
users/
├── {userId}/
│   ├── email: string
│   ├── displayName: string
│   ├── createdAt: timestamp
│   ├── habits/
│   │   ├── {habitId}/
│   │   │   ├── title: string
│   │   │   ├── description: string
│   │   │   ├── frequency: string
│   │   │   ├── createdAt: timestamp
│   │   │   ├── lastCompletedAt: timestamp
│   │   │   ├── streakCount: number
│   │   │   └── isActive: boolean
│   └── favorites/
│       └── quotes/
│           └── {quoteId}/
│               ├── text: string
│               ├── author: string
│               └── createdAt: timestamp
```

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

4. **"Database doesn't exist"**
   - Create the Firestore database in Firebase Console
   - Follow the setup steps above

### Verification Steps

1. **Check Firebase Console**:
   - Go to https://console.firebase.google.com/
   - Select project: `habit-tracker-bc361`
   - Go to Firestore Database
   - You should see "No documents yet" if database is created

2. **Test with your app**:
   - Run the app and try to create a habit
   - Check if data appears in Firestore

## 🎯 Next Steps

Once the database is set up:

1. **Test user registration/login**
2. **Create your first habit**
3. **Test habit completion tracking**
4. **Verify data appears in Firebase Console**

## 📞 Support

If you encounter issues:
1. Check Firebase Console for errors
2. Review the setup steps above
3. Check Firebase status page
4. Contact Firebase support

---

**Note**: This setup is for development. For production, ensure you:
- Set up proper security rules
- Enable App Check
- Configure domain verification
- Set up monitoring and alerts
