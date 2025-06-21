// lib/config/app_config_stub.dart
class AppConfig {
  static const String appName = 'WasupMate';
  static const String appVersion = '1.0.0';

  static String get apiBaseUrl => 'http://localhost:8000/api';
  static String get wsBaseUrl => 'ws://localhost:8000/ws';

  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const bool enablePushNotifications = false;
  static const bool enableVoiceMessages = false;
  static const bool enableAnalytics = false;
  static const int maxChatHistoryItems = 50;
  static const int maxEventItems = 20;
}
