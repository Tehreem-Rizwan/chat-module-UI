enum RoomStatus { active, inactive, archived }

enum ParticipantTier { captain, permanentSpeaker, guestSpeaker, member }

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
      userId: json['user_id'] as String,
      username: json['username'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      tier: ParticipantTier.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['tier'] as String?)?.toLowerCase(),
        orElse: () => ParticipantTier.member,
      ),
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'profile_image_url': profileImageUrl,
      'tier': tier.name,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  Participant copyWith({
    String? userId,
    String? username,
    String? profileImageUrl,
    ParticipantTier? tier,
    DateTime? joinedAt,
  }) {
    return Participant(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      tier: tier ?? this.tier,
      joinedAt: joinedAt ?? this.joinedAt,
    );
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
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventId: json['event_id'] as String,
      captainId: json['captain_id'] as String,
      status: RoomStatus.values.firstWhere(
        (e) =>
            e.name.toLowerCase() == (json['status'] as String?)?.toLowerCase(),
        orElse: () => RoomStatus.inactive,
      ),
      participants: (json['participants'] as List<dynamic>?)
              ?.map((p) => Participant.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      messageCount: json['message_count'] as int? ?? 0,
      lastActivityAt: json['last_activity_at'] != null
          ? DateTime.parse(json['last_activity_at'] as String)
          : null,
      parentRoomId: json['parent_room_id'] as String?,
      recordingUrl: json['recording_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'event_id': eventId,
      'captain_id': captainId,
      'status': status.name,
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

  List<Participant> get permanentSpeakers => participants
      .where((p) => p.tier == ParticipantTier.permanentSpeaker)
      .toList();

  List<Participant> get guestSpeakers => participants
      .where((p) => p.tier == ParticipantTier.guestSpeaker)
      .toList();

  List<Participant> get members =>
      participants.where((p) => p.tier == ParticipantTier.member).toList();

  Participant? getParticipant(String userId) {
    for (final p in participants) {
      if (p.userId == userId) return p;
    }
    return null;
  }

  bool get hasPermanentSpeakerSlot => permanentSpeakers.length < 3;

  bool isCaptain(String userId) => captainId == userId;

  bool isPermanentSpeaker(String userId) => participants.any(
      (p) => p.userId == userId && p.tier == ParticipantTier.permanentSpeaker);

  bool isGuestSpeaker(String userId) => participants
      .any((p) => p.userId == userId && p.tier == ParticipantTier.guestSpeaker);

  bool isMember(String userId) => participants
      .any((p) => p.userId == userId && p.tier == ParticipantTier.member);

  Room promoteToPermanentSpeaker(String userId) {
    if (!hasPermanentSpeakerSlot) return this;
    return copyWith(
      participants: participants.map((p) {
        if (p.userId == userId) {
          return p.copyWith(tier: ParticipantTier.permanentSpeaker);
        }
        return p;
      }).toList(),
    );
  }

  Room demotePermanentSpeaker(String userId) {
    return copyWith(
      participants: participants.map((p) {
        if (p.userId == userId && p.tier == ParticipantTier.permanentSpeaker) {
          return p.copyWith(tier: ParticipantTier.member);
        }
        return p;
      }).toList(),
    );
  }

  Room addToGuestSpeakerQueue(String userId) {
    return copyWith(
      participants: participants.map((p) {
        if (p.userId == userId) {
          return p.copyWith(tier: ParticipantTier.guestSpeaker);
        }
        return p;
      }).toList(),
    );
  }

  Room removeFromGuestSpeakerQueue(String userId) {
    return copyWith(
      participants: participants.map((p) {
        if (p.userId == userId && p.tier == ParticipantTier.guestSpeaker) {
          return p.copyWith(tier: ParticipantTier.member);
        }
        return p;
      }).toList(),
    );
  }
}
