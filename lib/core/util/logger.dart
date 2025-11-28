/// Logger utility for debugging and monitoring

class AppLogger {
  static const String _prefix = '[AnaPay]';

  /// Log an info message
  static void info(String message) {
    print('$_prefix ℹ️ $message');
  }

  /// Log a success message
  static void success(String message) {
    print('$_prefix ✅ $message');
  }

  /// Log a warning message
  static void warning(String message) {
    print('$_prefix ⚠️ $message');
  }

  /// Log an error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('$_prefix ❌ $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }

  /// Log a debug message
  static void debug(String message) {
    print('$_prefix 🔍 $message');
  }
}
