import 'package:shared_preferences/shared_preferences.dart';
import '../services/sync_service.dart';
import 'dialogue_data.dart';

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
      // Clés : dp_{id}_lessonDone | dp_{id}_testDone | dp_{id}_score |
      //        dp_{id}_maxScore   | dp_{id}_cat_{cat}_{idx}
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
        default:
          // dp_{id}_game_{idx}  →  field = game_{idx}
          if (field.startsWith('game_')) {
            final idx = int.tryParse(field.substring(5));
            if (idx != null) {
              data.gameBestScores[idx] = prefs.getInt(key) ?? 0;
            }
          }
          // dp_{id}_cat_{catName}_{idx}  →  field = cat_{catName}_{idx}
          else if (field.startsWith('cat_') && (prefs.getBool(key) ?? false)) {
            final rest = field.substring(4); // catName_idx
            final lastUnderscore = rest.lastIndexOf('_');
            if (lastUnderscore != -1) {
              final catName = rest.substring(0, lastUnderscore);
              final idxStr  = rest.substring(lastUnderscore + 1);
              final idx     = int.tryParse(idxStr);
              if (idx != null) {
                try {
                  final cat = LessonCategory.values.firstWhere((c) => c.name == catName);
                  data.completedDialogues.putIfAbsent(cat, () => {}).add(idx);
                } catch (_) {}
              }
            }
          }
      }
    }
  }

  // ── Dialogue progress ───────────────────────────────────────────────────────
  static bool isDialogueDone(String deptId, LessonCategory cat, int idx) =>
      _get(deptId).completedDialogues[cat]?.contains(idx) ?? false;

  static Future<void> markDialogueDone(
      String deptId, LessonCategory cat, int idx) async {
    _get(deptId).completedDialogues.putIfAbsent(cat, () => {}).add(idx);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dp_${deptId}_cat_${cat.name}_$idx', true);
    SyncService.pushToCloud();
  }

  // ── Lesson / Test ───────────────────────────────────────────────────────────
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

  // ── Game best scores ─────────────────────────────────────────────────────────
  static Map<int, int> getGameBestScores(String deptId) =>
      Map.from(_get(deptId).gameBestScores);

  /// Sauvegarde le meilleur score pour un game mode.
  /// Retourne les XP gagnés (différence si amélioré, 0 sinon).
  static Future<int> recordGameScore(
      String deptId, int gameIdx, int newScore) async {
    final data    = _get(deptId);
    final oldBest = data.gameBestScores[gameIdx] ?? 0;
    if (newScore <= oldBest) return 0;

    final delta = newScore - oldBest;
    data.gameBestScores[gameIdx] = newScore;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dp_${deptId}_game_$gameIdx', newScore);
    SyncService.pushToCloud();
    return delta;
  }

  /// Chargement depuis le cloud uniquement — pas d'XP, pas de push.
  static Future<void> setGameBestScoreFromCloud(
      String deptId, int gameIdx, int score) async {
    final data = _get(deptId);
    if (score <= (data.gameBestScores[gameIdx] ?? 0)) return;
    data.gameBestScores[gameIdx] = score;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dp_${deptId}_game_$gameIdx', score);
  }

  /// Retourne 0–3 étoiles.
  static int getStars(String deptId) {
    final d = _get(deptId);
    if (!d.lessonDone || !d.testDone) return 0;
    final max   = d.testMaxScore > 0 ? d.testMaxScore : 1;
    final ratio = d.testScore / max;
    if (ratio >= 0.9) return 3;
    if (ratio >= 0.5) return 2;
    return 1;
  }

  /// Vrai si au moins la leçon OU le test est commencé.
  static bool hasStarted(String deptId) {
    final d = _get(deptId);
    return d.lessonDone || d.testDone ||
        d.completedDialogues.values.any((s) => s.isNotEmpty);
  }

  // ── Pour les tests unitaires ─────────────────────────────────────────────
  static void resetForTesting() => _store.clear();
}

class _DeptData {
  bool lessonDone   = false;
  bool testDone     = false;
  int  testScore    = 0;
  int  testMaxScore = 1;
  final Map<LessonCategory, Set<int>> completedDialogues = {};
  final Map<int, int> gameBestScores = {};
}
