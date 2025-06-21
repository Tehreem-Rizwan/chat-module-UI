// lib/config/app_config_mobile.dart
import 'dart:io';

class AppConfig {
  static const String appName = 'WasupMate';
  static const String appVersion = '1.0.0';

  static String get apiBaseUrl {
    // Use a fixed IP for the Android emulator
    return Platform.isAndroid
        ? 'http://10.0.2.2:8000/api'
        : 'http://localhost:8000/api';
  }

  static String get wsBaseUrl {
    // Use WebSocket based on the platform
    final protocol = 'ws:';
    return '${protocol}//${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:8000/ws';
  }

  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const bool enablePushNotifications = false;
  static const bool enableVoiceMessages = false;
  static const bool enableAnalytics = false;
  static const int maxChatHistoryItems = 50;
  static const int maxEventItems = 20;
}
