import 'package:flutter/foundation.dart';
import 'package:wasupmate/config/data.dart';
import '../models/room.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/websocket_service.dart';

class RoomProvider with ChangeNotifier {
  late ApiService _apiService;
  final WebSocketService _webSocketService = WebSocketService();

  List<Room> _eventRooms = [];
  List<Room> _savedRooms = [];
  Room? _selectedRoom;
  List<Message> _messages = DummyData.messageList.toList();
  Map<String, bool> _typingUsers = {};
  // bool _isLoading = false;
  bool _isLoading = true;
  // bool _isJoining = false;
  bool _isJoining = true;
  // bool _isConnected = false;
  bool _isConnected = true;
  String? _error;

  // Constructor with token for authenticated requests
  RoomProvider({String? token}) {
    _apiService = ApiService(token: token);

    // Listen to websocket messages
    _webSocketService.messageStream.listen((message) {
      _addMessage(message);
    });

    // Listen to websocket status updates
    _webSocketService.statusStream.listen((status) {
      if (status['event'] == 'connection_status') {
        _isConnected = status['connected'];
        if (!_isConnected) {
          _error = status['message'];
        }
        notifyListeners();
      } else if (status['event'] == 'typing') {
        _updateTypingStatus(
            status['user_id'], status['username'], status['is_typing']);
      } else if (status['event'] == 'error') {
        _error = status['message'];
        notifyListeners();
      }
    });
  }

  // Getters
  List<Room> get eventRooms => _eventRooms;
  List<Room> get savedRooms => _savedRooms;
  Room? get selectedRoom => _selectedRoom;
  List<Message> get messages => _messages;
  Map<String, bool> get typingUsers => _typingUsers;
  bool get isLoading => _isLoading;
  bool get isJoining => _isJoining;
  bool get isConnected => _isConnected;
  String? get error => _error;
  WebSocketService get webSocketService => _webSocketService;

  // Set API token when authenticated
  void setToken(String token) {
    _apiService = ApiService(token: token);
  }

  // Fetch rooms for an event
  Future<bool> fetchRoomsForEvent(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getRoomsForEvent(eventId);

      _isLoading = false;
      if (result['success']) {
        _eventRooms = result['rooms'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        // Fallback to mock data for demo purposes
        setMockRoomsForEvent(eventId);
        notifyListeners();
        return true; // Return true even if API fails so UI can show mock data
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      // Fallback to mock data for demo purposes
      setMockRoomsForEvent(eventId);
      notifyListeners();
      return true; // Return true even if API fails so UI can show mock data
    }
  }

  // Fetch saved rooms
  Future<bool> fetchSavedRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getSavedRooms();

      _isLoading = false;
      if (result['success']) {
        _savedRooms = result['rooms'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get room details by ID
  Future<bool> getRoomById(String roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getRoom(roomId);

      _isLoading = false;
      if (result['success']) {
        _selectedRoom = result['room'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Create a new room
  Future<Room?> createRoom(
      String eventId, String title, String description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.createRoom(eventId, title, description);

      _isLoading = false;
      if (result['success']) {
        final newRoom = result['room'];
        _eventRooms.add(newRoom);
        _error = null;
        notifyListeners();
        return newRoom;
      } else {
        _error = result['message'];
        notifyListeners();
        return null;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Join a room
  Future<bool> joinRoom(String roomId, String token) async {
    _isJoining = true;
    _error = null;
    notifyListeners();

    try {
      // First make API call to join
      final result = await _apiService.joinRoom(roomId);

      if (!result['success']) {
        _isJoining = false;
        _error = result['message'];
        notifyListeners();
        return false;
      }

      // Then connect to WebSocket
      final connected = await _webSocketService.connectToRoom(roomId, token);

      if (connected) {
        // Load room messages
        await _loadRoomMessages(roomId);
        _isJoining = false;
        notifyListeners();
        return true;
      } else {
        _isJoining = false;
        _error = 'Failed to connect to room chat';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isJoining = false;
      notifyListeners();
      return false;
    }
  }

  // Leave a room
  Future<bool> leaveRoom(String roomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Disconnect from WebSocket first
      await _webSocketService.disconnect();

      // Then make API call to leave
      final result = await _apiService.leaveRoom(roomId);

      _isLoading = false;
      if (result['success']) {
        if (_selectedRoom?.id == roomId) {
          _selectedRoom = null;
          _messages = [];
        }
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Load room messages
  Future<bool> _loadRoomMessages(String roomId) async {
    try {
      final result = await _apiService.getRoomMessages(roomId);

      if (result['success']) {
        _messages = result['messages'];
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  // Send a message
  void sendMessage(String content) {
    if (!_isConnected) {
      _error = 'Not connected to room chat';
      notifyListeners();
      return;
    }

    _webSocketService.sendMessage(content);
  }

  // Send typing status
  void sendTypingStatus(bool isTyping) {
    if (_isConnected) {
      _webSocketService.sendTypingStatus(isTyping);
    }
  }

  // Add a new message to the list
  void _addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  // Update typing status for a user
  void _updateTypingStatus(String userId, String username, bool isTyping) {
    if (isTyping) {
      _typingUsers[username] = true;
    } else {
      _typingUsers.remove(username);
    }
    notifyListeners();
  }

  // Save a room to favorites
  Future<bool> saveRoom(String roomId) async {
    try {
      final result = await _apiService.saveRoom(roomId);

      if (result['success']) {
        // If the room is in the event rooms list, update it
        final index = _eventRooms.indexWhere((room) => room.id == roomId);
        if (index != -1) {
          final updatedRoom = await _apiService.getRoom(roomId);
          if (updatedRoom['success']) {
            _eventRooms[index] = updatedRoom['room'];
          }
        }

        // If it's the selected room, update it
        if (_selectedRoom?.id == roomId) {
          final updatedRoom = await _apiService.getRoom(roomId);
          if (updatedRoom['success']) {
            _selectedRoom = updatedRoom['room'];
          }
        }

        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  // Unsave a room from favorites
  Future<bool> unsaveRoom(String roomId) async {
    try {
      final result = await _apiService.unsaveRoom(roomId);

      if (result['success']) {
        // Remove from saved rooms if it exists
        _savedRooms.removeWhere((room) => room.id == roomId);

        // If it's the selected room, update it
        if (_selectedRoom?.id == roomId) {
          final updatedRoom = await _apiService.getRoom(roomId);
          if (updatedRoom['success']) {
            _selectedRoom = updatedRoom['room'];
          }
        }

        notifyListeners();
        return true;
      } else {
        _error = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    }
  }

  // Clear selected room
  void clearSelectedRoom() {
    _selectedRoom = null;
    _messages = [];
    _typingUsers = {};
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Dispose resources
  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }

  // For mocking rooms in development
  void setMockRoomsForEvent(String eventId) {
    final now = DateTime.now();
    final tenMinAgo = now.subtract(const Duration(minutes: 10));
    final thirtyMinAgo = now.subtract(const Duration(minutes: 30));
    final oneHourAgo = now.subtract(const Duration(hours: 1));

    _eventRooms = [
      Room(
        id: '1',
        title: 'Official Game Discussion',
        description: 'The main room for discussing the event as it happens.',
        eventId: eventId,
        captainId: 'user1',
        status: RoomStatus.active,
        participants: [
          Participant(
            userId: 'user1',
            username: 'SportsGuru',
            profileImageUrl: null,
            tier: ParticipantTier.captain,
            joinedAt: oneHourAgo,
          ),
          Participant(
            userId: 'user2',
            username: 'FanExpert',
            profileImageUrl: null,
            tier: ParticipantTier.moderator,
            joinedAt: thirtyMinAgo,
          ),
          Participant(
            userId: 'user3',
            username: 'GameAnalyst',
            profileImageUrl: null,
            tier: ParticipantTier.member,
            joinedAt: tenMinAgo,
          ),
        ],
        messageCount: 155,
        lastActivityAt: now,
        createdAt: oneHourAgo,
        updatedAt: now,
      ),
      Room(
        id: '2',
        title: 'Team A Supporters',
        description: 'A room dedicated to fans of Team A.',
        eventId: eventId,
        captainId: 'user4',
        status: RoomStatus.active,
        participants: [
          Participant(
            userId: 'user4',
            username: 'TeamAFan',
            profileImageUrl: null,
            tier: ParticipantTier.captain,
            joinedAt: oneHourAgo,
          ),
          Participant(
            userId: 'user5',
            username: 'SuperFan',
            profileImageUrl: null,
            tier: ParticipantTier.member,
            joinedAt: thirtyMinAgo,
          ),
        ],
        messageCount: 87,
        lastActivityAt: now,
        createdAt: oneHourAgo,
        updatedAt: now,
      ),
      Room(
        id: '3',
        title: 'Team B Supporters',
        description: 'A room dedicated to fans of Team B.',
        eventId: eventId,
        captainId: 'user6',
        status: RoomStatus.active,
        participants: [
          Participant(
            userId: 'user6',
            username: 'TeamBFan',
            profileImageUrl: null,
            tier: ParticipantTier.captain,
            joinedAt: oneHourAgo,
          ),
          Participant(
            userId: 'user7',
            username: 'LoyalFan',
            profileImageUrl: null,
            tier: ParticipantTier.moderator,
            joinedAt: thirtyMinAgo,
          ),
          Participant(
            userId: 'user8',
            username: 'SportsFan',
            profileImageUrl: null,
            tier: ParticipantTier.member,
            joinedAt: tenMinAgo,
          ),
        ],
        messageCount: 102,
        lastActivityAt: now,
        createdAt: oneHourAgo,
        updatedAt: now,
      ),
    ];

    notifyListeners();
  }

  // For mocking messages in development
  void setMockMessagesForRoom() {
    final now = DateTime.now();
    final oneMinAgo = now.subtract(const Duration(minutes: 1));
    final twoMinAgo = now.subtract(const Duration(minutes: 2));
    final threeMinAgo = now.subtract(const Duration(minutes: 3));
    final fiveMinAgo = now.subtract(const Duration(minutes: 5));

    _messages = [
      Message(
        id: '1',
        roomId: _selectedRoom!.id,
        senderId: 'user1',
        senderUsername: 'SportsGuru',
        content:
            'Welcome everyone to the discussion! Let\'s enjoy the game together.',
        type: MessageType.text,
        timestamp: fiveMinAgo,
        readBy: ['user1', 'user2', 'user3'],
      ),
      Message(
        id: '2',
        roomId: _selectedRoom!.id,
        senderId: 'system',
        senderUsername: 'System',
        content: 'User FanExpert has joined the room.',
        type: MessageType.system,
        timestamp: threeMinAgo,
        readBy: ['user1', 'user2', 'user3'],
      ),
      Message(
        id: '3',
        roomId: _selectedRoom!.id,
        senderId: 'user2',
        senderUsername: 'FanExpert',
        content: 'Thanks for having me! This game is going to be exciting.',
        type: MessageType.text,
        timestamp: threeMinAgo,
        readBy: ['user1', 'user2', 'user3'],
      ),
      Message(
        id: '4',
        roomId: _selectedRoom!.id,
        senderId: 'system',
        senderUsername: 'System',
        content: 'User GameAnalyst has joined the room.',
        type: MessageType.system,
        timestamp: twoMinAgo,
        readBy: ['user1', 'user2', 'user3'],
      ),
      Message(
        id: '5',
        roomId: _selectedRoom!.id,
        senderId: 'user3',
        senderUsername: 'GameAnalyst',
        content:
            'Hi everyone! I\'m looking forward to analyzing this game with you all.',
        type: MessageType.text,
        timestamp: twoMinAgo,
        readBy: ['user1', 'user2', 'user3'],
      ),
      Message(
        id: '6',
        roomId: _selectedRoom!.id,
        senderId: 'user1',
        senderUsername: 'SportsGuru',
        content: 'Did you see that amazing play? What a start to the game!',
        type: MessageType.text,
        timestamp: oneMinAgo,
        readBy: ['user1', 'user2'],
      ),
      Message(
        id: '7',
        roomId: _selectedRoom!.id,
        senderId: 'user2',
        senderUsername: 'FanExpert',
        content: 'Absolutely incredible! That\'s why this team is my favorite.',
        type: MessageType.text,
        timestamp: now,
        readBy: ['user1'],
      ),
    ];

    _isConnected = true;
    _typingUsers = {'GameAnalyst': true};

    notifyListeners();
  }
}
