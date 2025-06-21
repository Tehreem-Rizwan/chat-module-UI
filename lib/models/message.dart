enum MessageType {
  text,
  image,
  voice,
  system,
}

class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String senderUsername;
  final String? senderProfileImageUrl;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String> readBy;
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderUsername,
    this.senderProfileImageUrl,
    required this.content,
    required this.type,
    required this.timestamp,
    this.readBy = const [],
    this.metadata,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['room_id'],
      senderId: json['sender_id'],
      senderUsername: json['sender_username'],
      senderProfileImageUrl: json['sender_profile_image_url'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() == json['type'].toLowerCase(),
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      readBy: List<String>.from(json['read_by'] ?? []),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_username': senderUsername,
      'sender_profile_image_url': senderProfileImageUrl,
      'content': content,
      'type': type.toString().split('.').last.toLowerCase(),
      'timestamp': timestamp.toIso8601String(),
      'read_by': readBy,
      'metadata': metadata,
    };
  }

  Message copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? senderUsername,
    String? senderProfileImageUrl,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    List<String>? readBy,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderProfileImageUrl: senderProfileImageUrl ?? this.senderProfileImageUrl,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      metadata: metadata ?? this.metadata,
    );
  }

  bool isRead(String userId) => readBy.contains(userId);
  
  bool get isSystemMessage => type == MessageType.system;
}
