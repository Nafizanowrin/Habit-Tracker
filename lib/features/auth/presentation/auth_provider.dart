import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/user.dart';

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Auth state provider (loading, authenticated, unauthenticated)
final authStateProvider = Provider<AuthState>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) => user != null ? AuthState.authenticated : AuthState.unauthenticated,
    loading: () => AuthState.loading,
    error: (error, stack) => AuthState.error,
  );
});

// Auth controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

enum AuthState {
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  Future<User> signIn(String email, String password) async {
    return await _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<User> signUp(
    String email, 
    String password, 
    String displayName, {
    String? gender,
    DateTime? dateOfBirth,
    double? height,
  }) async {
    return await _authRepository.createUserWithEmailAndPassword(
      email, 
      password, 
      displayName,
      gender,
      dateOfBirth,
      height,
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }
}
