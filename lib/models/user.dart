class User {
  final String id;
  final String email;
  final String username;
  final String? profileImageUrl;
  final String? bio;
  final List<String> favoriteRooms;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.profileImageUrl,
    this.bio,
    this.favoriteRooms = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isEmailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      profileImageUrl: json['profile_image_url'],
      bio: json['bio'],
      favoriteRooms: List<String>.from(json['favorite_rooms'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isEmailVerified: json['is_email_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'favorite_rooms': favoriteRooms,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? profileImageUrl,
    String? bio,
    List<String>? favoriteRooms,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      favoriteRooms: favoriteRooms ?? this.favoriteRooms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}
