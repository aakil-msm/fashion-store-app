import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Wraps Firebase Authentication so the UI doesn't deal with
/// FirebaseAuth directly. Also creates a `users/{uid}` document
/// on registration so we have a place to store profile info.
class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  /// Currently signed-in user (null if signed out).
  static User? get currentUser => _auth.currentUser;

  /// Stream that fires whenever the auth state changes.
  static Stream<User?> get authState => _auth.authStateChanges();

  /// Register a new account with email + password,
  /// and create the user's profile document.
  static Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = cred.user;
    if (user != null) {
      // Save display name on the Auth user
      await user.updateDisplayName(name);

      // Create profile doc in Firestore
      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email.trim(),
        'phone': '',
        'address': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return user;
  }

  /// Sign in with email + password.
  static Future<User?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return cred.user;
  }

  /// Sign out.
  static Future<void> logout() async {
    await _auth.signOut();
  }

  /// Convert a FirebaseAuthException into a user-friendly message.
  static String describeError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'user-not-found':
          return 'No account found for that email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account already exists for that email.';
        case 'weak-password':
          return 'Password must be at least 6 characters.';
        case 'network-request-failed':
          return 'No internet connection. Please try again.';
        default:
          return error.message ?? 'Authentication failed.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}