/// Service Locator / Dependency Injection Setup
/// Centralizes all dependency instantiation using get_it pattern

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../features/authentication/data/data_sources/firebase_auth_data_source.dart';
import '../features/authentication/data/data_sources/firestore_user_data_source.dart';
import '../features/authentication/data/repository/auth_repository_impl.dart';
import '../features/authentication/domain/repository/auth_repository.dart';
import '../features/authentication/domain/usecases/register_with_email_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_email_usecase.dart';
import '../features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import '../features/authentication/domain/usecases/sign_out_usecase.dart';

/// Service Locator class for managing dependencies
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  /// Initialize all dependencies
  /// Call this in main() before running the app
  static Future<void> initialize() async {
    // Firebase instances
    final firebaseAuth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final firebaseMessaging = FirebaseMessaging.instance;
    final googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );

    // Data sources
    _registerFirebaseAuthDataSource(
      firebaseAuth,
      googleSignIn,
      firebaseMessaging,
    );
    _registerFirestoreUserDataSource(firestore);

    // Repository
    _registerAuthRepository();

    // Use cases
    _registerUseCases();
  }
//----------------------------------------------------------------------------------------
  static void _registerFirebaseAuthDataSource(
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FirebaseMessaging firebaseMessaging,
  ) {
    final dataSource = FirebaseAuthDataSourceImpl(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
      firebaseMessaging: firebaseMessaging,
    );
    _instances['FirebaseAuthDataSource'] = dataSource;
  }
//---------------------------------------------------------------------------------------
  static void _registerFirestoreUserDataSource(FirebaseFirestore firestore) {
    final dataSource = FirestoreUserDataSourceImpl(firestore: firestore);
    _instances['FirestoreUserDataSource'] = dataSource;
  }

  static void _registerAuthRepository() {
    final repository = AuthRepositoryImpl(
      firebaseAuthDataSource:
          _instances['FirebaseAuthDataSource'] as FirebaseAuthDataSource,
      firestoreUserDataSource:
          _instances['FirestoreUserDataSource'] as FirestoreUserDataSource,
    );
    _instances['AuthRepository'] = repository;
  }
//---------------------------------------------------------------------------------------
  static void _registerUseCases() {
    final authRepository = _instances['AuthRepository'] as AuthRepository;

    _instances['RegisterWithEmailUsecase'] =
        RegisterWithEmailUsecase(authRepository: authRepository);
    _instances['SignInWithEmailUsecase'] =
        SignInWithEmailUsecase(authRepository: authRepository);
    _instances['SignInWithGoogleUsecase'] =
        SignInWithGoogleUsecase(authRepository: authRepository);
    _instances['SignOutUsecase'] =
        SignOutUsecase(authRepository: authRepository);
  }

  // Instance storage
  static final Map<String, dynamic> _instances = {};

  /// Get an instance of type T by key
  static T get<T>(String key) {
    if (!_instances.containsKey(key)) {
      throw Exception('Instance not found for key: $key');
    }
    return _instances[key] as T;
  }

  /// Register a new instance
  static void register<T>(String key, T instance) {
    _instances[key] = instance;
  }
}
