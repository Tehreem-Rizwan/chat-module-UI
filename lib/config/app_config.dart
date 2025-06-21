// lib/config/app_config.dart
export 'app_config_stub.dart'
    if (dart.library.html) 'app_config_web.dart'
    if (dart.library.io) 'app_config_mobile.dart';
