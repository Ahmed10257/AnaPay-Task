import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:anapay_app/core/util/logger.dart';
import 'notification_overlay_service.dart';

/// Firebase Cloud Messaging Service
/// Handles foreground and background message receiving

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();

  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationOverlayService _overlayService =
      NotificationOverlayService();
  BuildContext? _appContext;

  /// Initialize Firebase Messaging and set up message handlers
  Future<void> initialize({BuildContext? context}) async {
    try {
      _appContext = context;
      AppLogger.info('Initializing Firebase Messaging Service');

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.success(
            'Received foreground message: ${message.notification?.title}');
        _handleMessage(message);
      });

      // Handle background messages (when app is terminated or in background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.success(
            'App opened from notification: ${message.notification?.title}');
        _handleMessageOpenedApp(message);
      });

      // Handle background messages via static function
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      AppLogger.success(
          'Firebase Messaging Service initialized successfully');
    } catch (e) {
      AppLogger.error('Error initializing Firebase Messaging Service', e);
    }
  }

  /// Handle foreground messages
  void _handleMessage(RemoteMessage message) {
    AppLogger.info(
      'Message Details:\n'
      'Title: ${message.notification?.title}\n'
      'Body: ${message.notification?.body}\n'
      'Data: ${message.data}',
    );

    // Show notification overlay if context is available and valid
    if (_appContext != null && _appContext!.mounted) {
      try {
        _overlayService.showNotification(
          context: _appContext!,
          title: message.notification?.title ?? 'Notification',
          message: message.notification?.body ?? 'You have a new message',
          duration: const Duration(seconds: 5),
          icon: Icons.notifications_active,
        );
      } catch (e) {
        AppLogger.error('Error displaying notification', e);
      }
    } else {
      AppLogger.warning(
          'App context not available or not mounted for notification display');
    }

    // TODO: Update UI, or navigate based on message data
  }

  /// Handle message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    AppLogger.info(
      'Message opened app:\n'
      'Title: ${message.notification?.title}\n'
      'Body: ${message.notification?.body}\n'
      'Data: ${message.data}',
    );

    // TODO: Navigate to specific screen based on message data
    // Example: navigatorKey.currentState?.pushNamed(message.data['screen'] ?? '/');
  }

  /// Get device FCM token
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      AppLogger.success('FCM Token retrieved: $token');
      return token;
    } catch (e) {
      AppLogger.error('Error getting FCM token', e);
      return null;
    }
  }

  /// Request user permission for notifications (iOS)
  Future<NotificationSettings> requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.info(
          'Notification permission status: ${settings.authorizationStatus}');
      return settings;
    } catch (e) {
      AppLogger.error('Error requesting notification permission', e);
      rethrow;
    }
  }
}

/// Background message handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.success(
      'Background message received: ${message.notification?.title}');
  AppLogger.info(
    'Background Message Details:\n'
    'Title: ${message.notification?.title}\n'
    'Body: ${message.notification?.body}\n'
    'Data: ${message.data}',
  );

  // TODO: Handle background message
  // Example: Save notification to local database or show local notification
}
