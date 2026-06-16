import 'package:shared_preferences/shared_preferences.dart';
import '../services/sync_service.dart';

// ─── DEPARTMENT PROGRESS STORE ────────────────────────────────────────────────
// Persisté via SharedPreferences.
// Charger avec DeptProgress.load() au démarrage avant runApp.
class DeptProgress {
  DeptProgress._();

  static final Map<String, _DeptData> _store = {};

  static _DeptData _get(String deptId) =>
      _store.putIfAbsent(deptId, () => _DeptData());

  // ── Chargement initial ──────────────────────────────────────────────────────
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys  = prefs.getKeys().where((k) => k.startsWith('dp_'));
    for (final key in keys) {
      // Clés : dp_{id}_lessonDone | dp_{id}_testDone | dp_{id}_score | dp_{id}_maxScore
      final parts = key.split('_');
      if (parts.length < 3) continue;
      final id    = parts[1];
      final field = parts.sublist(2).join('_');
      final data  = _get(id);
      switch (field) {
        case 'lessonDone':
          data.lessonDone = prefs.getBool(key) ?? false;
        case 'testDone':
          data.testDone = prefs.getBool(key) ?? false;
        case 'score':
          data.testScore = prefs.getInt(key) ?? 0;
        case 'maxScore':
          data.testMaxScore = prefs.getInt(key) ?? 1;
      }
    }
  }

  // ── Écriture ────────────────────────────────────────────────────────────────
  static Future<void> markLessonDone(String deptId) async {
    _get(deptId).lessonDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dp_${deptId}_lessonDone', true);
    SyncService.pushToCloud();
  }

  static Future<void> setTestScore(
      String deptId, int score, int maxScore) async {
    final d = _get(deptId);
    d.testScore    = score;
    d.testMaxScore = maxScore;
    d.testDone     = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dp_${deptId}_score',    score);
    await prefs.setInt('dp_${deptId}_maxScore', maxScore);
    await prefs.setBool('dp_${deptId}_testDone', true);
    SyncService.pushToCloud();
  }

  // ── Lecture ─────────────────────────────────────────────────────────────────
  static bool isLessonDone  (String deptId) => _get(deptId).lessonDone;
  static bool isTestDone    (String deptId) => _get(deptId).testDone;
  static int  getTestScore  (String deptId) => _get(deptId).testScore;
  static int  getTestMaxScore(String deptId) => _get(deptId).testMaxScore;

  /// Retourne 0–3 étoiles.
  /// 0 → leçon ou test non complété
  /// 1 → score < 50 %
  /// 2 → 50 % ≤ score < 90 %
  /// 3 → score ≥ 90 %
  static int getStars(String deptId) {
    final d = _get(deptId);
    if (!d.lessonDone || !d.testDone) return 0;
    final max   = d.testMaxScore > 0 ? d.testMaxScore : 1;
    final ratio = d.testScore / max;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.5) return 2;
    return 1;
  }

  /// Vrai si au moins la leçon OU le test est commencé
  static bool hasStarted(String deptId) {
    final d = _get(deptId);
    return d.lessonDone || d.testDone;
  }

  // ── Pour les tests unitaires ─────────────────────────────────────────────
  static void resetForTesting() => _store.clear();
}

class _DeptData {
  bool lessonDone   = false;
  bool testDone     = false;
  int  testScore    = 0;
  int  testMaxScore = 1;
}
