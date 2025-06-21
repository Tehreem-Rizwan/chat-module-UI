import 'dart:html' as html;

class AppConfig {
  static const String appName = 'WasupMate';
  static const String appVersion = '1.0.0';

  // API Configuration - dynamically determine base URLs based on window location
  static String get apiBaseUrl {
    // In a web environment, use the same host/port as the page
    return 'http://${html.window.location.hostname}:8000/api';
  }

  static String get wsBaseUrl {
    // For WebSocket, determine the protocol based on HTTP/HTTPS
    final protocol = html.window.location.protocol == 'https:' ? 'wss:' : 'ws:';
    return '${protocol}//${html.window.location.hostname}:8000/ws';
  }

  // Timeout durations in seconds
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Feature flags
  static const bool enablePushNotifications = false;
  static const bool enableVoiceMessages = false;
  static const bool enableAnalytics = false;

  // Misc
  static const int maxChatHistoryItems = 50;
  static const int maxEventItems = 20;
}
