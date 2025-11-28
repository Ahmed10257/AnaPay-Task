/// Sign In with Google UseCase
/// Encapsulates the business logic for Google authentication

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository authRepository;

  SignInWithGoogleUsecase({required this.authRepository});

  /// Execute the Google sign-in use case
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> call() async {
    return await authRepository.signInWithGoogle();
  }
}
