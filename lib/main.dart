import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'firebase_options.dart';
import 'core/repositories/auth_repository.dart';
import 'core/theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/registration_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Налаштування Firebase Crashlytics (для мобільних та macOS платформ)
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://2946a1bedb2484ab7c916134d01d421c@o4512356552278016.ingest.de.sentry.io/4512356556275792';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(const MyApp());
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    // Перевіряємо, чи збережено активний сеанс користувача
    final bool isLoggedIn = AuthRepository.instance.currentUser != null;

    return MaterialApp(
      title: 'Менеджер гарантій',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorObservers: <NavigatorObserver>[observer],
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegistrationScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/home': (_) => const DashboardScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}