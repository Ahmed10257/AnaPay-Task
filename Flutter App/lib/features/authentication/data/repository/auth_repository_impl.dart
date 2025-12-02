/// Authentication Repository Implementation
/// Implements the domain repository interface using data sources

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import 'package:anapay_app/core/error/exceptions.dart';
import 'package:anapay_app/core/util/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/firebase_auth_data_source.dart';
import '../data_sources/firestore_user_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _firebaseAuthDataSource;
  final FirestoreUserDataSource _firestoreUserDataSource;

  AuthRepositoryImpl({
    required FirebaseAuthDataSource firebaseAuthDataSource,
    required FirestoreUserDataSource firestoreUserDataSource,
  })  : _firebaseAuthDataSource = firebaseAuthDataSource,
        _firestoreUserDataSource = firestoreUserDataSource;

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _firebaseAuthDataSource.registerWithEmail(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestoreUserDataSource.saveUserData(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during registration', e);
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on AppFirebaseException catch (e) {
      AppLogger.error('Firebase exception during registration', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      AppLogger.error('Unknown exception during registration', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during registration',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _firebaseAuthDataSource.signInWithEmail(
        email: email,
        password: password,
      );

      // Save/update user data in Firestore
      await _firestoreUserDataSource.saveUserData(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during sign in', e);
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on AppFirebaseException catch (e) {
      AppLogger.error('Firebase exception during sign in', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      AppLogger.error('Unknown exception during sign in', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during sign in',
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await _firebaseAuthDataSource.signInWithGoogle();

      // Save/update user data in Firestore
      await _firestoreUserDataSource.saveUserData(userModel);

      return Right(userModel);
    } on AuthException catch (e) {
      AppLogger.error('Auth exception during Google sign in', e);
      return Left(AuthFailure(
        message: e.message,
        code: e.code,
      ));
    } on AppFirebaseException catch (e) {
      AppLogger.error('Firebase exception during Google sign in', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      AppLogger.error('Unknown exception during Google sign in', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during Google sign in',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final currentUser = _firebaseAuthDataSource.getCurrentFirebaseUser();
      if (currentUser != null) {
        // Set user login status to false before signing out
        await _firestoreUserDataSource.setUserLoginStatus(currentUser.uid, false);
      }
      
      await _firebaseAuthDataSource.signOut();
      return const Right(null);
    } on AppFirebaseException catch (e) {
      AppLogger.error('Firebase exception during sign out', e);
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e) {
      AppLogger.error('Unknown exception during sign out', e);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred during sign out',
      ));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuthDataSource.getCurrentFirebaseUser();
      if (firebaseUser == null) return null;

      final userData = await _firestoreUserDataSource.getUserData(firebaseUser.uid);
      return userData;
    } catch (e) {
      AppLogger.error('Error getting current user', e);
      return null;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final currentUser = _firebaseAuthDataSource.getCurrentFirebaseUser();
    return currentUser != null;
  }

  @override
  Future<Either<Failure, String>> getFCMToken() async {
    try {
      final token = await _firebaseAuthDataSource.getFCMToken();
      if (token == null) {
        return Left(AuthFailure(
          message: 'Failed to get FCM token',
          code: 'FCM_TOKEN_FAILED',
        ));
      }
      return Right(token);
    } catch (e) {
      AppLogger.error('Error getting FCM token', e);
      return Left(AuthFailure(
        message: 'Error getting FCM token: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserData(UserEntity user) async {
    try {
      if (user is! UserModel) {
        throw ArgumentError('User must be a UserModel instance');
      }
      await _firestoreUserDataSource.saveUserData(user);
      return const Right(null);
    } catch (e) {
      AppLogger.error('Error saving user data', e);
      return Left(ServerFailure(
        message: 'Failed to save user data: $e',
      ));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuthDataSource.authStateChanges
        .asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final userData = await _firestoreUserDataSource.getUserData(firebaseUser.uid);
        return userData;
      } catch (e) {
        AppLogger.error('Error mapping auth state', e);
        return UserModel.fromFirebaseUser(firebaseUser);
      }
    });
  }
}
