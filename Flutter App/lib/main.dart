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
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_app_check/firebase_app_check.dart'
    show AndroidProvider, AppleProvider, ReCaptchaV3Provider;

// Global key to access Navigator context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppLogger.success('Firebase initialized successfully');

    // Initialize Service Locator for Dependency Injection
    await ServiceLocator.initialize();
    AppLogger.success('Service Locator initialized');

    // Note: Firebase Messaging permission request moved to login flow
    // because on web, it requires user interaction (click)
  } catch (e) {
    AppLogger.error('Initialization error', e);
  }

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
    webProvider: ReCaptchaV3Provider('TooXUi'), // only for web
  );

  runApp(DevicePreview(builder: (context) => const MyApp()));
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
    // Initialize messaging service with proper context after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagingService = FirebaseMessagingService();
      final context = navigatorKey.currentContext;
      if (context != null && context.mounted) {
        messagingService.initialize(context: context);
        AppLogger.info(
          '🔔 Firebase Messaging Service initialized with Navigator context',
        );
      } else {
        AppLogger.warning('🔔 Navigator context not available yet');
      }
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
      navigatorKey: navigatorKey,
      home: const RegisterPage(),
      routes: {
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const home.HomePage(),
      },
    );
  }
}
