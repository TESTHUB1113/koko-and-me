import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
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

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Caught platform error: $error');
    return true;
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase is not initialized on Windows: its native SDK fires auth-state
  // callbacks on a C++ background thread, which crashes Flutter immediately.
  // All Firebase calls are guarded with null-checks so the app runs locally.
  final isWindows = !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  if (!isWindows) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (_) {}
  }
  // Load all persisted data before the app starts.
  // Notifications are Android/iOS only — skip on Windows (no Windows settings
  // were provided to InitializationSettings so it would throw).
  await Future.wait([
    UserProgress.load(),
    DeptProgress.load(),
    UserProfile.load(),
    if (!isWindows) NotificationService.init(),
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
