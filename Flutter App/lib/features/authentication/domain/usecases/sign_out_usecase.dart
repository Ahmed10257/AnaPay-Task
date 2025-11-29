/// Sign Out UseCase
/// Encapsulates the business logic for signing out

import 'package:anapay_app/core/error/either.dart';
import 'package:anapay_app/core/error/failures.dart';
import '../repository/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository authRepository;

  SignOutUsecase({required this.authRepository});

  /// Execute the sign-out use case
  /// Returns Either<Failure, void>
  Future<Either<Failure, void>> call() async {
    return await authRepository.signOut();
  }
}
