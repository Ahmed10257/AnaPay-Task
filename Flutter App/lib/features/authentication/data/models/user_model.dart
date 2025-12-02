/// User Model
/// Maps Firebase/API data to domain entities and vice versa

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isLoggedIn = false,
  }) : super(
    uid: uid,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
    fcmToken: fcmToken,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isLoggedIn: isLoggedIn,
  );

  /// Create from Firebase User
  factory UserModel.fromFirebaseUser(User firebaseUser, {String? fcmToken, bool isLoggedIn = true}) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      fcmToken: fcmToken,
      createdAt: firebaseUser.metadata.creationTime,
      updatedAt: firebaseUser.metadata.lastSignInTime,
      isLoggedIn: isLoggedIn,
    );
  }

  /// Create from Firestore JSON
  factory UserModel.fromFirestoreJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      fcmToken: json['fcmToken'] as String?,
      createdAt: (json['createdAt'] as dynamic)?.toDate() as DateTime?,
      updatedAt: (json['updatedAt'] as dynamic)?.toDate() as DateTime?,
      isLoggedIn: json['isLoggedIn'] as bool? ?? false,
    );
  }

  /// Convert to Firestore JSON
  Map<String, dynamic> toFirestoreJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isLoggedIn': isLoggedIn,
      'lastLoginAt': DateTime.now(),
    };
  }

  /// Create a copy with modifications
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLoggedIn,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
