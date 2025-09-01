import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user.dart' as app_user;
import 'session_service.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SessionService _sessionService = SessionService();

  
  app_user.User? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    return app_user.User(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: user.metadata.lastSignInTime,
    );
  }

  // Stream of auth state changes
  Stream<app_user.User?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      
      return app_user.User(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: user.metadata.lastSignInTime,
      );
    });
  }

  // Sign in with email and password
  Future<app_user.User> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) {
        throw AuthException('Sign in failed');
      }

      // Ensure user document exists in Firestore
      await _ensureUserDocument(user.uid, email, user.displayName);

    
      await _sessionService.saveLoginSession(user.uid, email);

      return app_user.User(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: user.metadata.lastSignInTime,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw AuthException('Sign in failed: $e');
    }
  }

  // Create user with email and password
  Future<app_user.User> createUserWithEmailAndPassword(
    String email, 
    String password,
    String displayName,
    String? gender,
    DateTime? dateOfBirth,
    double? height,
  ) async {
    UserCredential? credential;
    
    try {
      
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = credential.user;
      if (user == null) {
        throw AuthException('User creation failed');
      }

      
      if (displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }

      
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'displayName': displayName,
          'gender': gender,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
          'height': height,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'termsAccepted': true,
        });
      } catch (firestoreError) {
      
        print('Firestore write failed (continuing): $firestoreError');
      }

      return app_user.User(
        id: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: user.metadata.lastSignInTime,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('User creation failed: $e');
    }
  }

  // Ensure user document exists in Firestore
  Future<void> _ensureUserDocument(String uid, String email, String? displayName) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        // Create minimal user document if it doesn't exist
        await _firestore.collection('users').doc(uid).set({
          'email': email,
          'displayName': displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
       
        await _firestore.collection('users').doc(uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
     
      print('Warning: Could not ensure user document: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _sessionService.clearLoginSession();
  }

 
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

 
  Future<app_user.User?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        return app_user.User.fromMap({
          'id': userId,
          ...data,
        });
      }
      return null;
    } catch (e) {
      throw AuthException('Could not fetch user data: $e');
    }
  }

 
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw AuthException('Could not update profile: $e');
    }
  }

 
  AuthException _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException('Email already in use.');
      case 'invalid-email':
        return AuthException('Invalid email.');
      case 'weak-password':
        return AuthException('Password must be 8+ chars incl. upper, lower, number.');
      case 'wrong-password':
      case 'user-not-found':
        return AuthException('Email or password is incorrect.');
      case 'permission-denied':
        return AuthException('App database rules rejected this action.');
      case 'too-many-requests':
        return AuthException('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return AuthException('Network error. Please check your connection.');
      case 'invalid-credential':
        return AuthException('Email or password is incorrect.');
      default:
        return AuthException('Authentication failed: ${e.message}');
    }
  }
}


class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  
  @override
  String toString() => message;
}
