// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/app_config.dart';
// import '../models/event.dart';
// import '../models/room.dart';
// import '../models/message.dart';

// class ApiService {
//   final String baseUrl = AppConfig.apiBaseUrl;
//   final String? token;

//   ApiService({this.token});

//   // Headers with authorization
//   Map<String, String> get _headers => {
//         'Content-Type': 'application/json',
//         if (token != null) 'Authorization': 'Bearer $token',
//       };

//   // Get trending events
//   // Future<Map<String, dynamic>> getTrendingEvents({int limit = 10}) async {
//   //   try {
//   //     final response = await http.get(
//   //       Uri.parse('$baseUrl/events/trending?limit=$limit'),
//   //       headers: _headers,
//   //     );

//   //     final data = json.decode(response.body);

//   //     if (response.statusCode == 200) {
//   //       return {
//   //         'success': true,
//   //         'events': (data['events'] as List)
//   //             .map((event) => Event.fromJson(event))
//   //             .toList(),
//   //       };
//   //     } else {
//   //       return {
//   //         'success': false,
//   //         'message': data['message'] ?? 'Failed to get trending events',
//   //       };
//   //     }
//   //   } catch (e) {
//   //     return {
//   //       'success': false,
//   //       'message': 'An error occurred: $e',
//   //     };
//   //   }
//   // }

//   Future<Map<String, dynamic>> getTrendingEvents({int limit = 10}) async {
//     try {
//       // Dummy/mock events
//       final now = DateTime.now();
//       final dummyEvents = List.generate(limit, (index) {
//         return Event(
//           id: 'event_${index + 1}',
//           title: 'Trending Event ${index + 1}',
//           description: 'Description for Trending Event ${index + 1}',
//           imageUrl: 'https://via.placeholder.com/150',
//           startTime: now.subtract(Duration(days: index)),
//           endTime: now.add(Duration(days: index + 1)),
//           status: index % 2 == 0 ? EventStatus.live : EventStatus.upcoming,
//           category: index % 2 == 0 ? 'Sports' : 'Music',
//           trendscore: 80 - index * 5,
//           roomCount: 3 + index,
//           participantCount: 100 * (index + 1),
//           createdAt: now.subtract(Duration(days: index + 5)),
//           updatedAt: now,
//         );
//       });

//       await Future.delayed(
//           const Duration(milliseconds: 300)); // Simulate network delay

//       return {
//         'success': true,
//         'events': dummyEvents,
//       };
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get recent events
//   Future<Map<String, dynamic>> getRecentEvents({int limit = 10}) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/events/recent?limit=$limit'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'events': (data['events'] as List)
//               .map((event) => Event.fromJson(event))
//               .toList(),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get recent events',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get event by ID
//   Future<Map<String, dynamic>> getEvent(String eventId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/events/$eventId'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'event': Event.fromJson(data),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get event',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get rooms for an event
//   Future<Map<String, dynamic>> getRoomsForEvent(String eventId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/events/$eventId/rooms'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'rooms': (data['rooms'] as List)
//               .map((room) => Room.fromJson(room))
//               .toList(),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get rooms for event',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get room by ID
//   Future<Map<String, dynamic>> getRoom(String roomId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/rooms/$roomId'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'room': Room.fromJson(data),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Create a new room
//   Future<Map<String, dynamic>> createRoom(
//       String eventId, String title, String description) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms'),
//         headers: _headers,
//         body: json.encode({
//           'event_id': eventId,
//           'title': title,
//           'description': description,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 201) {
//         return {
//           'success': true,
//           'room': Room.fromJson(data),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to create room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Update a room
//   Future<Map<String, dynamic>> updateRoom(
//       String roomId, String title, String description) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/rooms/$roomId'),
//         headers: _headers,
//         body: json.encode({
//           'title': title,
//           'description': description,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'room': Room.fromJson(data),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to update room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Join a room
//   Future<Map<String, dynamic>> joinRoom(String roomId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms/$roomId/join'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Joined room successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to join room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Leave a room
//   Future<Map<String, dynamic>> leaveRoom(String roomId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms/$roomId/leave'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Left room successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to leave room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get messages for a room
//   Future<Map<String, dynamic>> getRoomMessages(String roomId,
//       {int limit = 50, String? before}) async {
//     try {
//       String url = '$baseUrl/rooms/$roomId/messages?limit=$limit';
//       if (before != null) {
//         url += '&before=$before';
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'messages': (data['messages'] as List)
//               .map((message) => Message.fromJson(message))
//               .toList(),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get room messages',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Save room (add to favorites)
//   Future<Map<String, dynamic>> saveRoom(String roomId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms/$roomId/save'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Room saved successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to save room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Unsave room (remove from favorites)
//   Future<Map<String, dynamic>> unsaveRoom(String roomId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms/$roomId/unsave'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': data['message'] ?? 'Room unsaved successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to unsave room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Fork a room (create a new room based on an existing one)
//   Future<Map<String, dynamic>> forkRoom(
//       String roomId, String title, String description) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/rooms/$roomId/fork'),
//         headers: _headers,
//         body: json.encode({
//           'title': title,
//           'description': description,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 201) {
//         return {
//           'success': true,
//           'room': Room.fromJson(data),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to fork room',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }

//   // Get saved rooms for the current user
//   Future<Map<String, dynamic>> getSavedRooms() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/users/me/saved-rooms'),
//         headers: _headers,
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'rooms': (data['rooms'] as List)
//               .map((room) => Room.fromJson(room))
//               .toList(),
//         };
//       } else {
//         return {
//           'success': false,
//           'message': data['message'] ?? 'Failed to get saved rooms',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'An error occurred: $e',
//       };
//     }
//   }
// }

import 'dart:convert';
import 'package:wasupmate/config/data.dart';
import 'package:wasupmate/models/event.dart';
import 'package:wasupmate/models/message.dart';
import 'package:wasupmate/models/room.dart';

class ApiService {
  final String? token;

  ApiService({this.token});

  // Get trending events (dummy)
  Future<Map<String, dynamic>> getTrendingEvents({int limit = 10}) async {
    try {
      // Limit the number of events returned based on the specified limit
      final events = DummyData.eventList.take(limit).toList();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'events': events.map((event) => event.toJson()).toList(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get recent events (dummy)
  Future<Map<String, dynamic>> getRecentEvents({int limit = 10}) async {
    try {
      // Return the most recent events based on the createdAt date
      final events = DummyData.eventList
          .where((event) => event.status == EventStatus.upcoming)
          .take(limit)
          .toList();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'events': events.map((event) => event.toJson()).toList(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get event by ID (dummy)
  Future<Map<String, dynamic>> getEvent(String eventId) async {
    try {
      final event = DummyData.eventList.firstWhere(
        (event) => event.id == eventId,
        orElse: () => throw Exception("Event not found"),
      );

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'event': event.toJson(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get messages for a room (dummy)
  Future<Map<String, dynamic>> getRoomMessages(String roomId,
      {int limit = 50}) async {
    try {
      final messages = DummyData.messageList
          .where((message) => message.roomId == roomId)
          .take(limit)
          .toList();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'messages': messages.map((message) => message.toJson()).toList(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Join a room (dummy)
  Future<Map<String, dynamic>> joinRoom(String roomId) async {
    try {
      // Simulate a successful join response
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'message': 'Joined room successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Leave a room (dummy)
  Future<Map<String, dynamic>> leaveRoom(String roomId) async {
    try {
      // Simulate a successful leave response
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'message': 'Left room successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Save room (dummy)
  Future<Map<String, dynamic>> saveRoom(String roomId) async {
    try {
      // Simulate a successful save response
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'message': 'Room saved successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Unsave room (dummy)
  Future<Map<String, dynamic>> unsaveRoom(String roomId) async {
    try {
      // Simulate a successful unsave response
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'message': 'Room unsaved successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get room by ID (dummy)
  Future<Map<String, dynamic>> getRoom(String roomId) async {
    try {
      // Generate some dummy rooms
      final dummyRooms = [
        Room(
          id: "room_1",
          title: "Sports Fans",
          description: "A room for all sports enthusiasts.",
          eventId: "event_1",
          captainId: "user_1",
          status: RoomStatus.active,
          participants: [
            Participant(
              userId: "user_1",
              username: "JohnDoe",
              profileImageUrl: "https://via.placeholder.com/150",
              tier: ParticipantTier.captain,
              joinedAt: DateTime.parse("2025-05-01T10:00:00.000Z"),
            ),
            Participant(
              userId: "user_2",
              username: "JaneDoe",
              profileImageUrl: "https://via.placeholder.com/150",
              tier: ParticipantTier.moderator,
              joinedAt: DateTime.parse("2025-05-01T11:00:00.000Z"),
            ),
            Participant(
              userId: "user_3",
              username: "AlexSmith",
              profileImageUrl: "https://via.placeholder.com/150",
              tier: ParticipantTier.member,
              joinedAt: DateTime.parse("2025-05-01T12:00:00.000Z"),
            ),
          ],
          messageCount: 15,
          lastActivityAt: DateTime.parse("2025-05-12T10:00:00.000Z"),
          createdAt: DateTime.parse("2025-05-01T10:00:00.000Z"),
          updatedAt: DateTime.parse("2025-05-12T10:00:00.000Z"),
        ),
        Room(
          id: "room_2",
          title: "Tech Talk",
          description: "A room for all tech enthusiasts.",
          eventId: "event_2",
          captainId: "user_2",
          status: RoomStatus.active,
          participants: [
            Participant(
              userId: "user_2",
              username: "JaneDoe",
              profileImageUrl: "https://via.placeholder.com/150",
              tier: ParticipantTier.captain,
              joinedAt: DateTime.parse("2025-05-02T10:00:00.000Z"),
            ),
            Participant(
              userId: "user_4",
              username: "ChrisLee",
              profileImageUrl: "https://via.placeholder.com/150",
              tier: ParticipantTier.member,
              joinedAt: DateTime.parse("2025-05-02T11:00:00.000Z"),
            ),
          ],
          messageCount: 25,
          lastActivityAt: DateTime.parse("2025-05-12T11:00:00.000Z"),
          createdAt: DateTime.parse("2025-05-02T10:00:00.000Z"),
          updatedAt: DateTime.parse("2025-05-12T11:00:00.000Z"),
        ),
      ];

      // Find the room by ID
      final room = dummyRooms.firstWhere(
        (room) => room.id == roomId,
        orElse: () => throw Exception("Room not found"),
      );

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'room': room.toJson(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Create a new room (dummy)
  Future<Map<String, dynamic>> createRoom(
      String eventId, String title, String description) async {
    try {
      // Create a new room
      final now = DateTime.now();
      final newRoom = Room(
        id: "room_${DummyData.roomList.length + 1}",
        title: title,
        description: description,
        eventId: eventId,
        captainId: "user_1",
        status: RoomStatus.active,
        participants: [
          Participant(
            userId: "user_1",
            username: "JohnDoe",
            profileImageUrl: "https://via.placeholder.com/150",
            tier: ParticipantTier.captain,
            joinedAt: now,
          ),
        ],
        messageCount: 0,
        lastActivityAt: now,
        createdAt: now,
        updatedAt: now,
      );

      // Add the new room to the dummy data
      DummyData.roomList.add(newRoom);

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'room': newRoom.toJson(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Get rooms for a specific event
  // Future<Map<String, dynamic>> getRoomsForEvent(String eventId) async {
  //   try {
  //     // Filter rooms that match the given eventId
  //     final rooms =
  //         DummyData.roomList.where((room) => room.eventId == eventId).toList();

  //     // Simulate network delay
  //     await Future.delayed(const Duration(milliseconds: 300));

  //     return {
  //       'success': true,
  //       'rooms': rooms.map((room) => room.toJson()).toList(),
  //     };
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'An error occurred: $e',
  //     };
  //   }
  // }
  Future<Map<String, dynamic>> getRoomsForEvent(String eventId) async {
    try {
      // Filter rooms for the specific event
      final rooms =
          DummyData.roomList.where((room) => room.eventId == eventId).toList();

      await Future.delayed(
          const Duration(milliseconds: 300)); // Simulate network delay

      return {
        'success': true,
        'rooms': rooms,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    }
  }

// Get saved rooms (dummy)
  Future<Map<String, dynamic>> getSavedRooms() async {
    try {
      // Assume the first 3 rooms are saved for the current user
      // final savedRooms = DummyData.roomList.take(3).toList();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      return {'success': true, 'rooms': DummyData.roomList.toList()};
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
