class Constants {
  // App Information
  static const String appName = 'WasupMate';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Real-time social platform for live sports discussions';
  
  // Default Image URLs
  static const String defaultProfileImage = 'https://via.placeholder.com/150';
  static const String defaultEventImage = 'https://via.placeholder.com/600x400';
  
  // Navigation Routes
  static const String routeHome = '/home';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeEventFeed = '/events';
  static const String routeRoomList = '/rooms';
  static const String routeRoomDetail = '/room';
  static const String routeProfile = '/profile';
  static const String routeForgotPassword = '/forgot-password';
  
  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUsername = 'username';
  static const String keyRememberMe = 'remember_me';
  static const String keyThemeMode = 'theme_mode';
  
  // Sports Categories
  static const List<String> sportsCategories = [
    'Basketball',
    'Football',
    'Soccer',
    'Tennis',
    'Cricket',
    'Baseball',
    'Rugby',
    'Golf',
    'Boxing',
    'MMA',
    'Volleyball',
    'Ice Hockey',
    'Formula 1',
    'eSports',
    'Other',
  ];
  
  // Room Categories
  static const List<String> roomCategories = [
    'Game Discussion',
    'Fan Zone',
    'Analysis',
    'News',
    'Predictions',
    'Off-Topic',
  ];
  
  // Maximum Values
  static const int maxRoomTitleLength = 50;
  static const int maxRoomDescriptionLength = 200;
  static const int maxBioLength = 150;
  static const int maxMessageLength = 500;
  static const int maxRoomsPerEvent = 20;
  static const int maxParticipantsPerRoom = 100;
  
  // Timing Constants
  static const int typingTimeout = 3000; // milliseconds
  static const int chatRefreshInterval = 10000; // milliseconds
  static const int connectionTimeout = 30000; // milliseconds
  
  // Validation Regexes
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String usernameRegex = r'^[a-zA-Z0-9_]{3,20}$';
  static const String passwordRegex = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$';
}
