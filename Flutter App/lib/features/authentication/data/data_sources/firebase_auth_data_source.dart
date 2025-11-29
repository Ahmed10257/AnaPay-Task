/// Firebase Authentication Data Source
/// Handles all Firebase Authentication operations

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:anapay_app/core/error/exceptions.dart';
import 'package:anapay_app/core/util/logger.dart';
import '../models/user_model.dart';

abstract class FirebaseAuthDataSource {
  /// Register user with email and password
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign out
  Future<void> signOut();

  /// Get current Firebase user
  User? getCurrentFirebaseUser();

  /// Get FCM token
  Future<String?> getFCMToken();

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseMessaging _firebaseMessaging;

  FirebaseAuthDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseMessaging firebaseMessaging,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firebaseMessaging = firebaseMessaging;

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Registering user with email: $email');

      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to create user',
          code: 'USER_CREATION_FAILED',
        );
      }

      AppLogger.success('User registered: ${userCredential.user!.uid}');

      final fcmToken = await getFCMToken();
      return UserModel.fromFirebaseUser(
        userCredential.user!,
        fcmToken: fcmToken,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during registration', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during registration', e);
      throw AuthException(
        message: 'Registration failed: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Signing in with email: $email');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to sign in',
          code: 'SIGN_IN_FAILED',
        );
      }

      AppLogger.success('User signed in: ${userCredential.user!.uid}');

      final fcmToken = await getFCMToken();
      return UserModel.fromFirebaseUser(
        userCredential.user!,
        fcmToken: fcmToken,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during sign in', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during sign in', e);
      throw AuthException(
        message: 'Sign in failed: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      AppLogger.info('Starting Google sign-in');

      // Ensure clean state
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException(
          message: 'Google sign-in cancelled',
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to sign in with Google',
          code: 'GOOGLE_SIGN_IN_FAILED',
        );
      }

      AppLogger.success('Google sign-in successful: ${userCredential.user!.uid}');

      final fcmToken = await getFCMToken();
      return UserModel.fromFirebaseUser(
        userCredential.user!,
        fcmToken: fcmToken,
      );
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during Google sign-in', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during Google sign-in', e);
      throw AuthException(
        message: 'Google sign-in failed: $e',
        code: 'GOOGLE_SIGN_IN_ERROR',
        originalException: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      AppLogger.info('Signing out user');
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
      AppLogger.success('User signed out');
    } catch (e) {
      AppLogger.error('Error during sign out', e);
      throw AppFirebaseException(
        message: 'Sign out failed: $e',
        originalException: e,
      );
    }
  }

  @override
  User? getCurrentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<String?> getFCMToken() async {
    try {
      AppLogger.info('🔔 TOKEN STEP 1: Requesting FCM permission...');

      NotificationSettings? settings;
      try {
        settings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          criticalAlert: false,
          provisional: false,
          sound: true,
        ).timeout(const Duration(seconds: 5));
      } catch (e) {
        AppLogger.warning('🔔 TOKEN STEP 1: Permission request timed out or failed: $e');
        return null;
      }

      AppLogger.info('🔔 TOKEN STEP 2: FCM permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.info('🔔 TOKEN STEP 3: Permission authorized, requesting token...');
        
        final token = await _firebaseMessaging.getToken(
          vapidKey: 'BMp0hJzR817YbVQH3F7vggxfMDmGxGN15Gd0TlVtKgT7CrXnuldBrMyhOKHisxU7wCixhNVkEFMhKYHoXpoT_Wo',
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            AppLogger.warning('🔔 TOKEN STEP 3: FCM token request timed out');
            return null;
          },
        );

        if (token != null && token.isNotEmpty) {
          AppLogger.success('🔔 TOKEN STEP 4: ✅ FCM token obtained: $token');
          return token;
        } else {
          AppLogger.warning('🔔 TOKEN STEP 4: ⚠️ Token is null or empty');
          return null;
        }
      } else {
        AppLogger.warning('🔔 TOKEN STEP 2: ⚠️ FCM permission NOT authorized. Status: ${settings.authorizationStatus}');
        return null;
      }
    } catch (e) {
      AppLogger.error('🔔 TOKEN ERROR: Error getting FCM token: $e');
      return null;
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  /// Handle Firebase Auth exceptions and convert to app exceptions
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return AuthException(
          message: 'The password provided is too weak.',
          code: e.code,
          originalException: e,
        );
      case 'email-already-in-use':
        return AuthException(
          message: 'The account already exists for that email.',
          code: e.code,
          originalException: e,
        );
      case 'invalid-email':
        return AuthException(
          message: 'The email address is not valid.',
          code: e.code,
          originalException: e,
        );
      case 'user-disabled':
        return AuthException(
          message: 'The user account has been disabled.',
          code: e.code,
          originalException: e,
        );
      case 'user-not-found':
        return AuthException(
          message: 'There is no user corresponding to this email address.',
          code: e.code,
          originalException: e,
        );
      case 'wrong-password':
        return AuthException(
          message: 'The password is invalid.',
          code: e.code,
          originalException: e,
        );
      default:
        return AuthException(
          message: e.message ?? 'An authentication error occurred',
          code: e.code,
          originalException: e,
        );
    }
  }
}
