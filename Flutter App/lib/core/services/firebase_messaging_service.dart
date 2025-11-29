import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
      AppLogger.info('🔔 INIT STEP 1: Initializing Firebase Messaging Service');
      AppLogger.info('🔔 INIT STEP 1: Running on ${kIsWeb ? "WEB" : "MOBILE"} platform');

      // Handle foreground messages (skip on web - service worker will handle it)
      if (!kIsWeb) {
        AppLogger.info('🔔 INIT STEP 2: Setting up foreground message listener...');
        FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
            AppLogger.success(
                '🔔 ✅ FOREGROUND MESSAGE RECEIVED: ${message.notification?.title}');
            _handleMessage(message);
          },
          onError: (error) {
            AppLogger.error('🔔 Error in foreground message listener', error);
          },
        );
        AppLogger.success('🔔 INIT STEP 2: Foreground listener registered ✅');
      } else {
        AppLogger.info('🔔 INIT STEP 2: SKIPPED - Web uses service worker for foreground messages');
      }

      // Handle background messages (when app is terminated or in background)
      AppLogger.info('🔔 INIT STEP 3: Setting up background message listener...');
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          AppLogger.success(
              '🔔 App opened from notification: ${message.notification?.title}');
          _handleMessageOpenedApp(message);
        },
        onError: (error) {
          AppLogger.error('🔔 Error in background message listener', error);
        },
      );
      AppLogger.success('🔔 INIT STEP 3: Background listener registered ✅');

      // Handle background messages via static function
      AppLogger.info('🔔 INIT STEP 4: Setting up static background message handler...');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      AppLogger.success('🔔 INIT STEP 4: Background handler registered ✅');

      AppLogger.success(
          '🔔 ✅ Firebase Messaging Service initialized successfully');
    } catch (e) {
      AppLogger.error('🔔 ❌ Error initializing Firebase Messaging Service', e);
    }
  }

  /// Handle foreground messages
  void _handleMessage(RemoteMessage message) {
    AppLogger.info(
      '🔔 FOREGROUND MESSAGE RECEIVED:\n'
      'Title: ${message.notification?.title}\n'
      'Body: ${message.notification?.body}\n'
      'Data: ${message.data}',
    );

    // Platform-specific handling
    if (kIsWeb) {
      AppLogger.info('🔔 Platform: WEB - Using browser notifications');
      // On web, the service worker will handle this automatically
      // But we can also show a snackbar or browser notification API
      _showWebNotification(message);
    } else {
      AppLogger.info('🔔 Platform: MOBILE - Using Flutter overlay');
      _showMobileNotification(message);
    }

    // TODO: Update UI, or navigate based on message data
  }

  /// Show notification on web platform using browser API
  void _showWebNotification(RemoteMessage message) {
    try {
      AppLogger.info('🔔 Attempting to show web notification');
      // On web, the service worker already shows notifications
      // This is a fallback if needed - browser API could be used here
      AppLogger.success('🔔 Web notification should be shown by service worker');
    } catch (e) {
      AppLogger.error('Error showing web notification', e);
    }
  }

  /// Show notification on mobile platforms
  void _showMobileNotification(RemoteMessage message) {
    if (_appContext != null && _appContext!.mounted) {
      try {
        AppLogger.info('🔔 Mobile context available, showing Flutter overlay');
        _overlayService.showNotification(
          context: _appContext!,
          title: message.notification?.title ?? 'Notification',
          message: message.notification?.body ?? 'You have a new message',
          duration: const Duration(seconds: 5),
          icon: Icons.notifications_active,
        );
        AppLogger.success('🔔 Flutter overlay notification shown');
      } catch (e) {
        AppLogger.error('🔔 Error displaying Flutter overlay notification', e);
      }
    } else {
      AppLogger.warning(
          '🔔 Mobile context not available or not mounted');
    }
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
      AppLogger.info('🔔 TOKEN: Requesting FCM token from ${kIsWeb ? "web" : "mobile"}...');
      final token = await _messaging.getToken();
      
      if (token != null && token.isNotEmpty) {
        AppLogger.success('🔔 TOKEN: ✅ FCM Token retrieved: $token');
        return token;
      } else {
        AppLogger.warning('🔔 TOKEN: ⚠️ FCM Token is null or empty');
        return null;
      }
    } catch (e) {
      AppLogger.error('🔔 TOKEN: ❌ Error getting FCM token', e);
      return null;
    }
  }

  /// Request user permission for notifications (iOS)
  Future<NotificationSettings> requestPermission() async {
    try {
      AppLogger.info('🔔 PERMISSION: Requesting notification permission on ${kIsWeb ? "web" : "mobile"}...');
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      AppLogger.info(
          '🔔 PERMISSION: Status = ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        AppLogger.success('🔔 PERMISSION: ✅ Notifications AUTHORIZED');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        AppLogger.info('🔔 PERMISSION: ⚠️ Notifications PROVISIONAL');
      } else {
        AppLogger.warning('🔔 PERMISSION: ❌ Notifications NOT AUTHORIZED');
      }
      
      return settings;
    } catch (e) {
      AppLogger.error('🔔 PERMISSION: ❌ Error requesting notification permission', e);
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
