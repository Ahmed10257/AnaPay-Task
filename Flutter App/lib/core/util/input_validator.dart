/// Input validation utilities for the application

class InputValidator {
  /// Validates if a string is a valid email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates if a password meets security requirements
  /// - Minimum 6 characters
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Checks if two passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Validates if a string is not empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Validates if a string meets minimum length
  static bool meetMinimumLength(String value, int minLength) {
    return value.length >= minLength;
  }
}
