/// Sign In with Email UseCase
/// Encapsulates the business logic for user login

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import 'package:anapay_app/core/util/input_validator.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInWithEmailUsecase {
  final AuthRepository authRepository;

  SignInWithEmailUsecase({required this.authRepository});

  /// Execute the sign-in use case
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validate inputs
    if (!InputValidator.isNotEmpty(email)) {
      return Left(ValidationFailure(
        message: 'Email is required',
        code: 'EMPTY_EMAIL',
      ));
    }

    if (!InputValidator.isValidEmail(email)) {
      return Left(ValidationFailure(
        message: 'Please enter a valid email',
        code: 'INVALID_EMAIL',
      ));
    }

    if (!InputValidator.isNotEmpty(password)) {
      return Left(ValidationFailure(
        message: 'Password is required',
        code: 'EMPTY_PASSWORD',
      ));
    }

    // Call repository to sign in
    return await authRepository.signInWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
