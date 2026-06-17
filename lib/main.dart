import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'data/user_progress.dart';
import 'data/dept_progress.dart';
import 'data/user_profile.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch all unhandled Flutter/Dart errors so the app doesn't crash
  // (needed on Windows where Firebase auth fires callbacks off the main thread)
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Caught platform error: $error');
    return true; // handled — don't crash
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Firebase graceful fallback si pas encore configuré (placeholder keys)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase non configuré l'app démarre en mode local uniquement.
    // Exécuter `flutterfire configure` pour activer l'authentification.
  }
  // Charger toutes les données persistées avant le démarrage de l'app
  await Future.wait([
    UserProgress.load(),
    DeptProgress.load(),
    UserProfile.load(),
    NotificationService.init(),
  ]);
  runZonedGuarded(
    () => runApp(const KokoMeApp()),
    (error, stack) {
      debugPrint('Caught zone error: $error');
    },
  );
}

class KokoMeApp extends StatelessWidget {
  const KokoMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koko&me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: KokoColors.night,
        colorScheme: ColorScheme.dark(
          primary: KokoColors.teal,
          secondary: KokoColors.purple,
          surface: KokoColors.deep,
        ),
      ),
      home: const SelectionArea(child: SplashScreen()),
    );
  }
}

// ─── GLOBAL COLORS ───────────────────────────────────
class KokoColors {
  static const Color teal       = Color(0xFF1BC6C6);
  static const Color tealDark   = Color(0xFF0DA8A8);
  static const Color purple     = Color(0xFF7B5EA7);
  static const Color purpleDark = Color(0xFF5B3D9A);
  static const Color deep       = Color(0xFF2D1B69);
  static const Color night      = Color(0xFF0E0920);
  static const Color dark       = Color(0xFF1A1035);
  static const Color gold       = Color(0xFFF5C842);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color muted      = Color(0xFF9090A0);
  static const Color green1     = Color(0xFF0a1a0a);
  static const Color green2     = Color(0xFF1a3a1a);
}
