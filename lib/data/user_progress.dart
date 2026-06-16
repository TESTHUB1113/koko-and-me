import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/sync_service.dart';

// ─── USER PROGRESS ────────────────────────────────────────────────────────────
// Singleton statique. Persisté via SharedPreferences.
// Charger avec UserProgress.load() au démarrage avant runApp.
class UserProgress {
  UserProgress._();

  static int    xp      = 0;
  static int    streak  = 0;
  static String _lastActivityDate = '';

  // ── Chargement initial ──────────────────────────────────────────────────────
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    xp     = prefs.getInt('up_xp')     ?? 0;
    streak = prefs.getInt('up_streak') ?? 0;
    _lastActivityDate = prefs.getString('up_last_date') ?? '';
    _validateStreak();
  }

  // Vérifie si le streak est toujours valide (pas de jour sauté)
  static void _validateStreak() {
    if (_lastActivityDate.isEmpty) return;
    final today     = _today();
    final lastDate  = DateTime.parse(_lastActivityDate);
    final diff      = DateTime.now().difference(lastDate).inDays;
    // Si plus d'un jour s'est écoulé depuis la dernière activité, streak = 0
    if (diff > 1 && _lastActivityDate != today) {
      streak = 0;
    }
  }

  // ── Ajout de XP (appelé après chaque jeu/leçon complété) ───────────────────
  static Future<void> addXp(int amount) async {
    xp += amount;
    _updateStreak();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('up_xp',      xp);
    await prefs.setInt('up_streak',  streak);
    await prefs.setString('up_last_date', _lastActivityDate);
    // Replanifier le rappel streak pour demain (no-op si notifications non initialisées)
    await NotificationService.scheduleStreakReminder();
    // Sync cloud (silencieux si Firebase non configuré ou pas de réseau)
    SyncService.pushToCloud();
  }

  // Met à jour le streak si c'est le premier XP de la journée
  static void _updateStreak() {
    final today = _today();
    if (_lastActivityDate == today) return; // déjà compté aujourd'hui

    final yesterday = DateTime.now()
        .subtract(const Duration(days: 1))
        .toIso8601String()
        .substring(0, 10);

    if (_lastActivityDate == yesterday || _lastActivityDate.isEmpty) {
      streak++; // jour consécutif (ou premier jour)
    } else {
      streak = 1; // jour sauté → reset
    }
    _lastActivityDate = today;
  }

  static String _today() =>
      DateTime.now().toIso8601String().substring(0, 10);

  // ── Sync cloud ───────────────────────────────────────────────────────────────
  /// Écrase l'état local avec les données venant de Firestore.
  /// Utilisé par SyncService.pullFromCloud() uniquement.
  static Future<void> setFromCloud({
    required int    cloudXp,
    required int    cloudStreak,
    required String cloudLastDate,
  }) async {
    xp                 = cloudXp;
    streak             = cloudStreak;
    _lastActivityDate  = cloudLastDate;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('up_xp',         xp);
    await prefs.setInt('up_streak',     streak);
    await prefs.setString('up_last_date', _lastActivityDate);
  }

  /// Exposé pour SyncService (lecture seule).
  static String get lastActivityDate => _lastActivityDate;

  // ── Formatage pour affichage ────────────────────────────────────────────────
  static String get xpLabel => '$xp XP';
  static String get streakLabel => '$streak';

  // ── Pour les tests unitaires ─────────────────────────────────────────────
  static void resetForTesting() {
    xp = 0;
    streak = 0;
    _lastActivityDate = '';
  }
}
