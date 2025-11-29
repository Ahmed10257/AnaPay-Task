import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'firebase_options.dart';
import 'core/service_locator.dart';
import 'core/util/logger.dart';
import 'core/services/firebase_messaging_service.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_routes.dart';
import 'features/authentication/presentation/pages/register_page.dart';
import 'features/authentication/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart' as home;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.success('Firebase initialized successfully');

    // Initialize Firebase Messaging
    final messagingService = FirebaseMessagingService();
    await messagingService.requestPermission();
    AppLogger.success('Firebase Messaging initialized');

    // Initialize Service Locator for Dependency Injection
    await ServiceLocator.initialize();
    AppLogger.success('Service Locator initialized');
  } catch (e) {
    AppLogger.error('Initialization error', e);
  }

  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize messaging service with app context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagingService = FirebaseMessagingService();
      messagingService.initialize(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnaPay App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const RegisterPage(),
      routes: {
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const home.HomePage(),
      },
    );
  }
}
