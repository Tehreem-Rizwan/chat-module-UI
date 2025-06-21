enum RoomStatus {
  active,
  inactive,
  archived,
}

enum ParticipantTier {
  captain,
  moderator,
  member,
  guest,
}

class Participant {
  final String userId;
  final String username;
  final String? profileImageUrl;
  final ParticipantTier tier;
  final DateTime joinedAt;

  Participant({
    required this.userId,
    required this.username,
    this.profileImageUrl,
    required this.tier,
    required this.joinedAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      userId: json['user_id'],
      username: json['username'],
      profileImageUrl: json['profile_image_url'],
      tier: ParticipantTier.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == json['tier'].toLowerCase(),
        orElse: () => ParticipantTier.guest,
      ),
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'profile_image_url': profileImageUrl,
      'tier': tier.toString().split('.').last.toLowerCase(),
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}

class Room {
  final String id;
  final String title;
  final String description;
  final String eventId;
  final String captainId;
  final RoomStatus status;
  final List<Participant> participants;
  final int messageCount;
  final DateTime? lastActivityAt;
  final String? parentRoomId;
  final String? recordingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.title,
    required this.description,
    required this.eventId,
    required this.captainId,
    required this.status,
    this.participants = const [],
    this.messageCount = 0,
    this.lastActivityAt,
    this.parentRoomId,
    this.recordingUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      eventId: json['event_id'],
      captainId: json['captain_id'],
      status: RoomStatus.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == json['status'].toLowerCase(),
        orElse: () => RoomStatus.inactive,
      ),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((p) => Participant.fromJson(p))
          .toList() ??
          [],
      messageCount: json['message_count'] ?? 0,
      lastActivityAt: json['last_activity_at'] != null
          ? DateTime.parse(json['last_activity_at'])
          : null,
      parentRoomId: json['parent_room_id'],
      recordingUrl: json['recording_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_id': eventId,
      'captain_id': captainId,
      'status': status.toString().split('.').last.toLowerCase(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'message_count': messageCount,
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'parent_room_id': parentRoomId,
      'recording_url': recordingUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Room copyWith({
    String? id,
    String? title,
    String? description,
    String? eventId,
    String? captainId,
    RoomStatus? status,
    List<Participant>? participants,
    int? messageCount,
    DateTime? lastActivityAt,
    String? parentRoomId,
    String? recordingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Room(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventId: eventId ?? this.eventId,
      captainId: captainId ?? this.captainId,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      messageCount: messageCount ?? this.messageCount,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      parentRoomId: parentRoomId ?? this.parentRoomId,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get participantCount => participants.length;

  bool isCaptain(String userId) => captainId == userId;

  bool isModerator(String userId) {
    final participant = participants.firstWhere(
      (p) => p.userId == userId,
      orElse: () => Participant(
        userId: '',
        username: '',
        tier: ParticipantTier.guest,
        joinedAt: DateTime.now(),
      ),
    );
    return participant.tier == ParticipantTier.moderator;
  }
}
