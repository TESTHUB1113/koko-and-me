import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

// ─── NOTIFICATION SERVICE ─────────────────────────────────────────────────────
// Gère les rappels quotidiens de streak.
// • Initialiser via init() au démarrage (dans main()).
// • Appeler scheduleStreakReminder() après chaque gain de XP.
// • Toutes les méthodes sont des no-ops si init() n'a pas encore été appelé
//   → les tests unitaires n'ont pas besoin de mocker ce service.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId   = 'koko_streak';
  static const _channelName = 'Streak Reminders';
  static const _notifId     = 0;

  // ── Initialisation ─────────────────────────────────────────────────────────
  static Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      // Demande la permission dès l'init sur iOS (moment conventionnel)
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    _initialized = true;
  }

  // ── Permission runtime (Android 13+ / nécessaire pour le toggle Settings) ──
  static Future<bool> requestPermission() async {
    if (!_initialized) return false;

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true, badge: true, sound: true,
          ) ??
          false;
    }
    return false;
  }

  // ── Planifier un rappel quotidien ──────────────────────────────────────────
  /// Replanifie chaque jour à [hour]:[minute] (format 24h, heure locale).
  /// Annule le rappel existant avant d'en créer un nouveau.
  static Future<void> scheduleStreakReminder({
    int hour   = 19,
    int minute = 0,
  }) async {
    if (!_initialized) return;
    await _plugin.cancel(_notifId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, hour, minute,
    );
    // Si l'heure est déjà passée aujourd'hui, planifier pour demain
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _notifId,
      '🔥 Ton streak est en danger !',
      'Koko t\'attend. Une leçon suffit pour garder ta flamme.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription:
              'Rappels quotidiens pour maintenir votre streak',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // se répète chaque jour
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ── Annuler le rappel ──────────────────────────────────────────────────────
  /// Appeler quand l'utilisateur a déjà obtenu des XP aujourd'hui.
  static Future<void> cancelTodayReminder() async {
    if (!_initialized) return;
    await _plugin.cancel(_notifId);
  }

  // ── Pour les tests unitaires ───────────────────────────────────────────────
  // ignore: invalid_use_of_visible_for_testing_member
  static bool get isInitialized => _initialized;
}
