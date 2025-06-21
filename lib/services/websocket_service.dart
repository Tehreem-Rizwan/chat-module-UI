import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../config/app_config.dart';
import '../models/message.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Message> _messageController = StreamController<Message>.broadcast();
  final StreamController<Map<String, dynamic>> _statusController = StreamController<Map<String, dynamic>>.broadcast();
  
  String? _token;
  String? _roomId;
  bool _isConnected = false;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  // Stream getters
  Stream<Message> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get statusStream => _statusController.stream;

  // Status getters
  bool get isConnected => _isConnected;
  String? get currentRoomId => _roomId;

  // Connect to websocket for a specific room
  Future<bool> connectToRoom(String roomId, String token) async {
    if (_isConnected) {
      await disconnect();
    }

    _token = token;
    _roomId = roomId;
    _reconnectAttempts = 0;

    return await _connect();
  }

  // Internal connect method with reconnect support
  Future<bool> _connect() async {
    try {
      final uri = Uri.parse('${AppConfig.wsBaseUrl}/chat/$_roomId');
      _logInfo('Connecting to WebSocket: $uri');
      
      _channel = WebSocketChannel.connect(uri);
      
      // Send auth message
      _channel!.sink.add(json.encode({
        'type': 'auth',
        'token': _token,
      }));
      
      _logInfo('Auth message sent, waiting for response...');

      // Listen for messages
      _channel!.stream.listen(
        (dynamic data) {
          try {
            final jsonData = json.decode(data as String);
            _logInfo('Received WebSocket message: ${jsonData['type']}');
            
            if (jsonData['type'] == 'auth_response') {
              _isConnected = jsonData['success'] == true;
              _statusController.add({
                'event': 'connection_status',
                'connected': _isConnected,
                'message': jsonData['message'],
              });
              
              if (_isConnected) {
                _logInfo('Successfully connected to room $_roomId');
                // Reset reconnect attempts on successful connection
                _reconnectAttempts = 0;
                // Start ping timer to keep connection alive
                _startPingTimer();
              } else {
                _logError('Auth failed: ${jsonData['message']}');
              }
            } 
            else if (jsonData['type'] == 'message') {
              _logInfo('Received message: ${jsonData['data']['content'].toString().substring(0, min(20, jsonData['data']['content'].toString().length))}...');
              _messageController.add(Message.fromJson(jsonData['data']));
            }
            else if (jsonData['type'] == 'room_status') {
              _statusController.add({
                'event': 'room_status',
                'status': jsonData['status'],
                'participants': jsonData['participants'],
              });
            }
            else if (jsonData['type'] == 'typing') {
              _statusController.add({
                'event': 'typing',
                'user_id': jsonData['user_id'],
                'username': jsonData['username'],
                'is_typing': jsonData['is_typing'],
              });
            }
            else if (jsonData['type'] == 'pong') {
              _logInfo('Received pong from server');
            }
          } catch (e) {
            _logError('Failed to parse message: $e');
            _statusController.add({
              'event': 'error',
              'message': 'Failed to parse message: $e',
            });
          }
        },
        onError: (error) {
          _logError('WebSocket error: $error');
          _isConnected = false;
          _statusController.add({
            'event': 'error',
            'message': 'WebSocket error: $error',
          });
          
          // Try to reconnect
          _scheduleReconnect();
        },
        onDone: () {
          _logInfo('WebSocket connection closed');
          _isConnected = false;
          _statusController.add({
            'event': 'connection_status',
            'connected': false,
            'message': 'Connection closed',
          });
          _stopPingTimer();
          
          // Try to reconnect if not explicitly disconnected
          if (_roomId != null) {
            _scheduleReconnect();
          }
        },
      );

      return true;
    } catch (e) {
      _logError('Failed to connect: $e');
      _isConnected = false;
      _statusController.add({
        'event': 'error',
        'message': 'Failed to connect: $e',
      });
      
      // Try to reconnect
      _scheduleReconnect();
      return false;
    }
  }

  // Schedule a reconnect attempt
  void _scheduleReconnect() {
    if (_reconnectTimer != null || _reconnectAttempts >= _maxReconnectAttempts) {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        _logError('Maximum reconnect attempts reached');
        _statusController.add({
          'event': 'connection_status',
          'connected': false,
          'message': 'Failed to reconnect after multiple attempts',
        });
      }
      return;
    }
    
    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2); // Exponential backoff
    
    _logInfo('Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');
    
    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      if (_roomId != null && _token != null) {
        _logInfo('Attempting to reconnect...');
        _connect();
      }
    });
  }

  // Send a text message
  void sendMessage(String content) {
    if (!_isConnected || _channel == null) {
      _logError('Cannot send message: not connected');
      _statusController.add({
        'event': 'error',
        'message': 'Not connected to any room',
      });
      return;
    }

    _logInfo('Sending text message: ${content.substring(0, min(20, content.length))}...');
    
    _channel!.sink.add(json.encode({
      'type': 'message',
      'content': content,
      'message_type': 'text',
    }));
  }

  // Send a voice message
  void sendVoiceMessage(String audioUrl) {
    if (!_isConnected || _channel == null) {
      _logError('Cannot send voice message: not connected');
      _statusController.add({
        'event': 'error',
        'message': 'Not connected to any room',
      });
      return;
    }

    _logInfo('Sending voice message URL');
    
    _channel!.sink.add(json.encode({
      'type': 'message',
      'content': audioUrl,
      'message_type': 'voice',
    }));
  }

  // Send typing status
  void sendTypingStatus(bool isTyping) {
    if (!_isConnected || _channel == null) {
      return;
    }

    _logInfo('Sending typing status: $isTyping');
    
    _channel!.sink.add(json.encode({
      'type': 'typing',
      'is_typing': isTyping,
    }));
  }

  // Disconnect from websocket
  Future<void> disconnect() async {
    _logInfo('Disconnecting from WebSocket');
    
    _stopPingTimer();
    _stopReconnectTimer();
    
    if (_channel != null) {
      await _channel!.sink.close(status.normalClosure);
      _channel = null;
    }
    
    _isConnected = false;
    _roomId = null;
  }

  // Start ping timer
  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        _logInfo('Sending ping');
        _channel!.sink.add(json.encode({
          'type': 'ping',
        }));
      }
    });
  }

  // Stop ping timer
  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  // Stop reconnect timer
  void _stopReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  // Logging helpers
  void _logInfo(String message) {
    if (kDebugMode) {
      developer.log('WebSocketService: $message', name: 'websocket');
    }
  }

  void _logError(String message) {
    if (kDebugMode) {
      developer.log('WebSocketService ERROR: $message', name: 'websocket', error: message);
    }
  }

  // Helper for string substring
  int min(int a, int b) => a < b ? a : b;

  // Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _statusController.close();
  }
}
