/// Register with Email UseCase
/// Encapsulates the business logic for user registration

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import 'package:anapay_app/core/util/input_validator.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class RegisterWithEmailUsecase {
  final AuthRepository authRepository;

  RegisterWithEmailUsecase({required this.authRepository});

  /// Execute the registration use case
  /// Returns Either<Failure, UserEntity>
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String confirmPassword,
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

    if (!InputValidator.isValidPassword(password)) {
      return Left(ValidationFailure(
        message: 'Password must be at least 6 characters',
        code: 'WEAK_PASSWORD',
      ));
    }

    if (!InputValidator.passwordsMatch(password, confirmPassword)) {
      return Left(ValidationFailure(
        message: 'Passwords do not match',
        code: 'PASSWORD_MISMATCH',
      ));
    }

    // Call repository to register
    return await authRepository.registerWithEmail(
      email: email.trim(),
      password: password,
    );
  }
}
