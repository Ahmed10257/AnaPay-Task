/// Core failure classes for the application
/// Represents a failure in the application using Either pattern

abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class FirebaseFailure extends Failure {
  FirebaseFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class AuthFailure extends Failure {
  AuthFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  ValidationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  NetworkFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  CacheFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  UnknownFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
