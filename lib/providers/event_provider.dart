// import 'package:flutter/foundation.dart';
// import '../models/event.dart';
// import '../services/api_service.dart';

// class EventProvider with ChangeNotifier {
//   late ApiService _apiService;

//   List<Event> _trendingEvents = [];
//   List<Event> _recentEvents = [];
//   Event? _selectedEvent;
//   bool _isLoading = false;
//   String? _error;

//   // Constructor with token for authenticated requests
//   EventProvider({String? token}) {
//     _apiService = ApiService(token: token);
//   }

//   // Getters
//   List<Event> get trendingEvents => _trendingEvents;
//   List<Event> get recentEvents => _recentEvents;
//   Event? get selectedEvent => _selectedEvent;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   // Set API token when authenticated
//   void setToken(String token) {
//     _apiService = ApiService(token: token);
//   }

//   // Fetch trending events
//   Future<bool> fetchTrendingEvents({int limit = 10}) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final result = await _apiService.getTrendingEvents(limit: limit);

//       _isLoading = false;
//       if (result['success']) {
//         _trendingEvents = result['events'];
//         _error = null;
//         notifyListeners();
//         return true;
//       } else {
//         _error = result['message'];
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'An unexpected error occurred: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Fetch recent events
//   Future<bool> fetchRecentEvents({int limit = 10}) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final result = await _apiService.getRecentEvents(limit: limit);

//       _isLoading = false;
//       if (result['success']) {
//         _recentEvents = result['events'];
//         _error = null;
//         notifyListeners();
//         return true;
//       } else {
//         _error = result['message'];
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'An unexpected error occurred: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Get event details by ID
//   Future<bool> getEventById(String eventId) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final result = await _apiService.getEvent(eventId);

//       _isLoading = false;
//       if (result['success']) {
//         _selectedEvent = result['event'];
//         _error = null;
//         notifyListeners();
//         return true;
//       } else {
//         _error = result['message'];
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = 'An unexpected error occurred: $e';
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Clear selected event
//   void clearSelectedEvent() {
//     _selectedEvent = null;
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // For mocking events in development
//   void setMockEvents() {
//     final now = DateTime.now();
//     final yesterday = now.subtract(const Duration(days: 1));
//     final tomorrow = now.add(const Duration(days: 1));

//     _trendingEvents = [
//       Event(
//         id: '1',
//         title: 'NBA Finals 2023',
//         description: 'The championship series of the National Basketball Association.',
//         imageUrl: 'https://pixabay.com/get/g617fe0247ff7b38ee94d926876de692eaff636efa2702efdb79ea245f5a6598494e662604208ebe303dbb8d0d7c18ffa02f245596f7508e67b9e7f242b89feb8_1280.jpg',
//         startTime: yesterday,
//         endTime: tomorrow,
//         status: EventStatus.live,
//         category: 'Basketball',
//         trendscore: 98,
//         roomCount: 24,
//         participantCount: 1287,
//         createdAt: yesterday,
//         updatedAt: now,
//       ),
//       Event(
//         id: '2',
//         title: 'UEFA Champions League Final',
//         description: 'The annual football club competition organized by UEFA.',
//         imageUrl: 'https://pixabay.com/get/g0ca9039b2661a2b6dd4efb8aaaebc391cb87d76a9d89b65b4591c94d952779b3fc49c59d42a3d0c8d2cc8aa93af44471314633a1a07c722e0f404fdede0f7c52_1280.jpg',
//         startTime: tomorrow,
//         status: EventStatus.upcoming,
//         category: 'Football',
//         trendscore: 92,
//         roomCount: 18,
//         participantCount: 945,
//         createdAt: yesterday,
//         updatedAt: now,
//       ),
//       Event(
//         id: '3',
//         title: 'Wimbledon 2023',
//         description: 'The oldest tennis tournament in the world.',
//         imageUrl: 'https://pixabay.com/get/g872e13da7c5631236492b71b04c2afbffbd400d224da93b7ff8968761edbded77002623545a98ef3983ac9fd37eeff341329cb7fe9f5543f807c9f8d39d4a52d_1280.jpg',
//         startTime: now.add(const Duration(days: 7)),
//         status: EventStatus.upcoming,
//         category: 'Tennis',
//         trendscore: 85,
//         roomCount: 12,
//         participantCount: 634,
//         createdAt: yesterday,
//         updatedAt: now,
//       ),
//     ];

//     _recentEvents = [
//       Event(
//         id: '4',
//         title: 'Formula 1 Monaco Grand Prix',
//         description: 'The most prestigious automobile race in the world.',
//         imageUrl: 'https://pixabay.com/get/gdb7563f0099fa841655a5d97970325721e90e2910845d8a7b628aac23a63c99a703cff55cf341d7775f9827d3abec4667d52409ba850bd7a791269cd59d4d3f2_1280.jpg',
//         startTime: yesterday.subtract(const Duration(days: 1)),
//         endTime: yesterday,
//         status: EventStatus.completed,
//         category: 'Racing',
//         trendscore: 78,
//         roomCount: 9,
//         participantCount: 524,
//         createdAt: yesterday.subtract(const Duration(days: 7)),
//         updatedAt: yesterday,
//       ),
//       Event(
//         id: '5',
//         title: 'NFL Draft 2023',
//         description: 'The annual event where NFL teams select new players.',
//         imageUrl: 'https://pixabay.com/get/g856ad7b1487218b167c7667ade39fe0708735373578c705dcc0dc11b1077e91f4aaf424da67a37b7e737c6cefbd89916dd0c6fb5b01017c454d786f551ba29d5_1280.jpg',
//         startTime: yesterday.subtract(const Duration(days: 3)),
//         endTime: yesterday.subtract(const Duration(days: 1)),
//         status: EventStatus.completed,
//         category: 'American Football',
//         trendscore: 72,
//         roomCount: 15,
//         participantCount: 892,
//         createdAt: yesterday.subtract(const Duration(days: 10)),
//         updatedAt: yesterday.subtract(const Duration(days: 1)),
//       ),
//       Event(
//         id: '6',
//         title: 'UFC 290',
//         description: 'Ultimate Fighting Championship mixed martial arts event.',
//         imageUrl: 'https://pixabay.com/get/g7f1d472e68f8333f1af4c242404f4c51302f590ccf2d34f812b71ec189fc350f336e8f63213569ea7cdeacabc502d9f31ba2c79cdff3989d7ef65519691eaf0f_1280.jpg',
//         startTime: now.add(const Duration(days: 14)),
//         status: EventStatus.upcoming,
//         category: 'MMA',
//         trendscore: 68,
//         roomCount: 7,
//         participantCount: 412,
//         createdAt: yesterday.subtract(const Duration(days: 14)),
//         updatedAt: now,
//       ),
//     ];

//     notifyListeners();
//   }
// }
import 'package:flutter/foundation.dart';
import 'package:wasupmate/config/data.dart';
import '../models/event.dart';
// import '../services/api_service.dart';

class EventProvider with ChangeNotifier {
  // late ApiService _apiService;

  List<Event> _trendingEvents = [];
  List<Event> _recentEvents = [];
  Event? _selectedEvent;
  bool _isLoading = false;
  String? _error;

  // Constructor with token for authenticated requests
  EventProvider({String? token}) {
    // _apiService = ApiService(token: token);
    setMockEvents(); // Initialize with mock data
  }

  // Getters
  List<Event> get trendingEvents => _trendingEvents;
  List<Event> get recentEvents => _recentEvents;
  Event? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set API token when authenticated
  void setToken(String token) {
    // _apiService = ApiService(token: token);
  }

  // Fetch trending events (using dummy data for now)
  Future<bool> fetchTrendingEvents({int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulating data fetch using dummy data
      await Future.delayed(const Duration(seconds: 1));
      _trendingEvents = _generateTrendingEvents();
      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Fetch recent events (using dummy data for now)
  Future<bool> fetchRecentEvents({int limit = 10}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulating data fetch using dummy data
      await Future.delayed(const Duration(seconds: 1));
      _recentEvents = _generateRecentEvents();
      _isLoading = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get event details by ID (using dummy data for now)
  Future<bool> getEventById(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulating data fetch using dummy data
      await Future.delayed(const Duration(seconds: 1));
      _selectedEvent = _trendingEvents.firstWhere(
        (event) => event.id == eventId,
        orElse: () => _recentEvents.firstWhere(
          (event) => event.id == eventId,
          orElse: () => throw Exception('Event not found'),
        ),
      );
      _isLoading = false;
      notifyListeners();
      return _selectedEvent != null;
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear selected event
  void clearSelectedEvent() {
    _selectedEvent = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Generate dummy trending events
  List<Event> _generateTrendingEvents() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));
    return DummyData.eventList;
    //   return [
    //     Event(
    //       id: '1',
    //       title: 'NBA Finals 2023',
    //       description:
    //           'The championship series of the National Basketball Association.',
    //       imageUrl:
    //           'https://cdn.nba.com/manage/2022/06/stephen-curry-finals-mvp-iso.jpg',
    //       startTime: yesterday,
    //       endTime: tomorrow,
    //       status: EventStatus.live,
    //       category: 'Basketball',
    //       trendscore: 98,
    //       roomCount: 24,
    //       participantCount: 1287,
    //       createdAt: yesterday,
    //       updatedAt: now,
    //     ),
    //     Event(
    //       id: '2',
    //       title: 'UEFA Champions League Final',
    //       description: 'The annual football club competition organized by UEFA.',
    //       imageUrl:
    //           'https://thephysiocompany.co.uk/wp-content/uploads/football.jpg',
    //       startTime: tomorrow,
    //       status: EventStatus.upcoming,
    //       category: 'Football',
    //       trendscore: 92,
    //       roomCount: 18,
    //       participantCount: 945,
    //       createdAt: yesterday,
    //       updatedAt: now,
    //     ),
    //   ];
  }

  // Generate dummy recent events
  List<Event> _generateRecentEvents() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    return [
      Event(
        id: '4',
        title: 'Formula 1 Monaco Grand Prix',
        description: 'The most prestigious automobile race in the world.',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/c/cf/2012_WTCC_Race_of_Japan_%28Race_1%29_opening_lap.jpg',
        startTime: yesterday.subtract(const Duration(days: 1)),
        endTime: yesterday,
        status: EventStatus.completed,
        category: 'Racing',
        trendscore: 78,
        roomCount: 9,
        participantCount: 524,
        createdAt: yesterday.subtract(const Duration(days: 7)),
        updatedAt: yesterday,
      ),
    ];
  }

  // Set mock events initially
  void setMockEvents() {
    _trendingEvents = _generateTrendingEvents();
    _recentEvents = _generateRecentEvents();
    notifyListeners();
  }
}
