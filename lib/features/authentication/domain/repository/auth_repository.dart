/// Authentication Repository Interface
/// Defines the contract for authentication operations
/// No Firebase dependencies - pure Dart/domain layer

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Register a new user with email and password
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with email and password
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign out the current user
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> signOut();

  /// Get the current logged-in user
  /// Returns UserEntity if logged in, null otherwise
  Future<UserEntity?> getCurrentUser();

  /// Check if a user is currently logged in
  Future<bool> isUserLoggedIn();

  /// Get FCM token for the current user
  /// Returns Either<Failure, String>
  Future<Either<Failure, String>> getFCMToken();

  /// Save user data to persistent storage
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> saveUserData(UserEntity user);

  /// Stream of authentication state changes
  Stream<UserEntity?> get authStateChanges;
}
