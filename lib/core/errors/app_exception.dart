/// A user-presentable error. [message] is safe to show in the UI.
class AppException implements Exception {
  const AppException(this.message, {this.retryable = true});

  final String message;
  final bool retryable;

  @override
  String toString() => 'AppException: $message';
}
