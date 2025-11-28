/// User entity - Core domain object with no Firebase dependencies
/// Represents a user in the business logic layer

class UserEntity {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with modified fields
  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'UserEntity(uid: $uid, email: $email, displayName: $displayName)';
}
