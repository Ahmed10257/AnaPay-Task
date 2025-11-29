import 'package:flutter/material.dart';
import 'package:anapay_app/core/util/logger.dart';

/// Notification Overlay Service
/// Displays floating notifications that appear and disappear automatically

class NotificationOverlayService {
  static final NotificationOverlayService _instance =
      NotificationOverlayService._internal();

  factory NotificationOverlayService() {
    return _instance;
  }

  NotificationOverlayService._internal();

  OverlayEntry? _overlayEntry;

  /// Show a notification overlay
  void showNotification({
    required BuildContext context,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    Color backgroundColor = const Color(0xFF2196F3),
    Color textColor = Colors.white,
    IconData icon = Icons.notifications_active,
  }) {
    AppLogger.info('Showing notification: $title - $message');

    try {
      // Check if overlay is available
      final overlay = Overlay.of(context, rootOverlay: true);
      if (overlay == null) {
        AppLogger.warning('Overlay not available, skipping notification');
        return;
      }

      // Remove existing notification safely
      if (_overlayEntry != null) {
        try {
          _overlayEntry!.remove();
        } catch (e) {
          AppLogger.debug('Previous overlay entry already removed: $e');
        }
        _overlayEntry = null;
      }

      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: _NotificationWidget(
            title: title,
            message: message,
            backgroundColor: backgroundColor,
            textColor: textColor,
            icon: icon,
          ),
        ),
      );

      overlay.insert(_overlayEntry!);

      // Auto-dismiss after duration
      Future.delayed(duration, () {
        _removeNotification();
      });
    } catch (e) {
      AppLogger.error('Error showing notification overlay', e);
    }
  }

  /// Remove notification safely
  void _removeNotification() {
    try {
      if (_overlayEntry != null) {
        _overlayEntry!.remove();
        _overlayEntry = null;
      }
    } catch (e) {
      AppLogger.debug('Error removing overlay (may already be removed): $e');
      _overlayEntry = null;
    }
  }

  /// Dismiss current notification
  void dismissNotification() {
    _removeNotification();
  }
}

/// Notification Widget
class _NotificationWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _NotificationWidget({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(76),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.textColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: widget.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.textColor.withAlpha(230),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
