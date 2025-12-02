/// Firestore User Data Source
/// Handles all Firestore operations for user data

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anapay_app/core/error/exceptions.dart';
import 'package:anapay_app/core/util/logger.dart';
import '../models/user_model.dart';

abstract class FirestoreUserDataSource {
  /// Save user data to Firestore
  Future<void> saveUserData(UserModel user);

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid);

  /// Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data);

  /// Delete user data from Firestore
  Future<void> deleteUserData(String uid);

  /// Set user login status
  Future<void> setUserLoginStatus(String uid, bool isLoggedIn);
}

class FirestoreUserDataSourceImpl implements FirestoreUserDataSource {
  static const String _usersCollection = 'users';

  final FirebaseFirestore _firestore;

  FirestoreUserDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      AppLogger.info('🔔 FIRESTORE: Saving user data for UID: ${user.uid}');
      AppLogger.info('🔔 FIRESTORE: User data: ${user.toFirestoreJson()}');
      
      if (user.fcmToken != null && user.fcmToken!.isNotEmpty) {
        AppLogger.success('🔔 FIRESTORE: User has FCM token: ${user.fcmToken}');
      } else {
        AppLogger.warning('🔔 FIRESTORE: ⚠️ User has NO FCM token (null or empty)!');
      }

      final jsonData = user.toFirestoreJson();
      AppLogger.debug('🔔 FIRESTORE: Saving JSON: $jsonData');
      
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(
            jsonData,
            SetOptions(merge: true),
          );

      AppLogger.success('🔔 FIRESTORE: ✅ User data saved for UID: ${user.uid}');
    } catch (e) {
      AppLogger.error('Error saving user data', e);
      throw AppFirebaseException(
        message: 'Failed to save user data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      AppLogger.debug('Fetching user data for UID: $uid');

      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists && doc.data() != null) {
        AppLogger.success('User data retrieved for UID: $uid');
        return UserModel.fromFirestoreJson(doc.data()!);
      }

      AppLogger.warning('No user data found for UID: $uid');
      return null;
    } catch (e) {
      AppLogger.error('Error fetching user data', e);
      throw AppFirebaseException(
        message: 'Failed to fetch user data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      AppLogger.info('Updating user data for UID: $uid');

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update(data);

      AppLogger.success('User data updated for UID: $uid');
    } catch (e) {
      AppLogger.error('Error updating user data', e);
      throw AppFirebaseException(
        message: 'Failed to update user data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteUserData(String uid) async {
    try {
      AppLogger.info('Deleting user data for UID: $uid');

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .delete();

      AppLogger.success('User data deleted for UID: $uid');
    } catch (e) {
      AppLogger.error('Error deleting user data', e);
      throw AppFirebaseException(
        message: 'Failed to delete user data: $e',
        originalException: e,
      );
    }
  }

  @override
  Future<void> setUserLoginStatus(String uid, bool isLoggedIn) async {
    try {
      AppLogger.info('Setting login status for UID: $uid to $isLoggedIn');

      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .update({
            'isLoggedIn': isLoggedIn,
            'lastStatusChangeAt': DateTime.now(),
          });

      AppLogger.success('Login status updated for UID: $uid');
    } catch (e) {
      AppLogger.error('Error updating login status', e);
      throw AppFirebaseException(
        message: 'Failed to update login status: $e',
        originalException: e,
      );
    }
  }
}
