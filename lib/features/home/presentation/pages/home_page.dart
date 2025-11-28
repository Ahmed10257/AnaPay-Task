/// Home Page - Presentation Layer
/// Main app page after login

import 'package:flutter/material.dart';
import 'package:anapay_app/config/routes/app_routes.dart';
import 'package:anapay_app/core/service_locator.dart';
import 'package:anapay_app/core/util/logger.dart';
import 'package:anapay_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:anapay_app/features/authentication/domain/repository/auth_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SignOutUsecase _signOutUsecase;
  late AuthRepository _authRepository;

  String _displayName = 'Guest';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _signOutUsecase = ServiceLocator.get<SignOutUsecase>('SignOutUsecase');
    _authRepository = ServiceLocator.get<AuthRepository>('AuthRepository');
    _loadUserData();
  }
//---------------------------------------------------------------------------------------
  Future<void> _loadUserData() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        setState(() {
          _displayName = user.displayName ?? 'Guest';
          _userEmail = user.email;
        });
      }
    } catch (error) {
      AppLogger.error('Error loading user data', error);
    }
  }
//---------------------------------------------------------------------------------------
  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _signOutUsecase();
      result.fold(
        (failure) {
          AppLogger.error('Sign out failed: ${failure.message}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign out failed: ${failure.message}')),
            );
          }
        },
        (_) {
          AppLogger.success('User signed out');
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        },
      );
    }
  }
//---------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleSignOut,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $_displayName!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _userEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        Text(
                          'Logged in successfully',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
