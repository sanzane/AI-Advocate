/// Non-secret client configuration. Never put API keys here: all provider
/// credentials live on the backend only.
///
/// Override at build/run time, e.g.
///   flutter run --dart-define=USE_BACKEND=true --dart-define=API_BASE_URL=http://10.0.2.2:8000
class AppConfig {
  AppConfig._();

  /// Single source of truth for the backend URL.
  /// Default is localhost:8000 for Windows/web/desktop development.
  /// For Android emulator, pass --dart-define=API_BASE_URL=http://10.0.2.2:8000
  /// For a physical phone, use adb reverse tcp:8000 tcp:8000 and localhost:8000,
  /// or pass the computer's LAN IP via --dart-define=API_BASE_URL=http://<LAN_IP>:8000.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.31.98.41:8000',
  );

  /// When false the app uses a built-in, clearly labelled demo responder so it
  /// works without a backend. When true it calls POST {apiBaseUrl}/api/chat.
  static const bool useBackend = true;

  static const Duration requestTimeout = Duration(seconds: 180);
  static const int maxMessageLength = 4000;

  static const String disclaimer =
      'This is general legal information, not a substitute for advice from a qualified advocate.';
}
