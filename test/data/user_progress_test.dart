import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koko_and_me/data/user_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    UserProgress.resetForTesting();
  });

  group('UserProgress —', () {
    // ── État initial ─────────────────────────────────────────────────────────

    test('xp and streak start at 0', () {
      expect(UserProgress.xp, 0);
      expect(UserProgress.streak, 0);
    });

    test('xpLabel shows "0 XP" initially', () {
      expect(UserProgress.xpLabel, '0 XP');
    });

    test('streakLabel shows "0" initially', () {
      expect(UserProgress.streakLabel, '0');
    });

    // ── addXp ────────────────────────────────────────────────────────────────

    test('addXp increments xp by given amount', () async {
      await UserProgress.addXp(40);
      expect(UserProgress.xp, 40);
    });

    test('addXp accumulates across calls', () async {
      await UserProgress.addXp(40);
      await UserProgress.addXp(60);
      expect(UserProgress.xp, 100);
    });

    test('xpLabel formats correctly after XP gain', () async {
      await UserProgress.addXp(620);
      expect(UserProgress.xpLabel, '620 XP');
    });

    // ── Streak ───────────────────────────────────────────────────────────────

    test('first addXp of the day sets streak to 1', () async {
      await UserProgress.addXp(10);
      expect(UserProgress.streak, 1);
    });

    test('second addXp on the same day keeps streak at 1', () async {
      await UserProgress.addXp(10);
      await UserProgress.addXp(10);
      expect(UserProgress.streak, 1);
    });

    test('streakLabel returns streak count as string', () async {
      await UserProgress.addXp(10);
      expect(UserProgress.streakLabel, '1');
    });

    // ── Persistance via SharedPreferences ────────────────────────────────────

    test('load() restores xp and streak from SharedPreferences', () async {
      final today = DateTime.now().toIso8601String().substring(0, 10);
      SharedPreferences.setMockInitialValues({
        'up_xp':        300,
        'up_streak':    5,
        'up_last_date': today,
      });
      await UserProgress.load();
      expect(UserProgress.xp,     300);
      expect(UserProgress.streak, 5);
    });

    test('load() resets streak to 0 when activity was 3 days ago', () async {
      final threeDaysAgo = DateTime.now()
          .subtract(const Duration(days: 3))
          .toIso8601String()
          .substring(0, 10);
      SharedPreferences.setMockInitialValues({
        'up_xp':        200,
        'up_streak':    10,
        'up_last_date': threeDaysAgo,
      });
      await UserProgress.load();
      expect(UserProgress.streak, 0);
      expect(UserProgress.xp, 200); // xp is never reset by streak validation
    });

    test('load() preserves streak when last activity was yesterday', () async {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10);
      SharedPreferences.setMockInitialValues({
        'up_xp':        50,
        'up_streak':    4,
        'up_last_date': yesterday,
      });
      await UserProgress.load();
      expect(UserProgress.streak, 4); // still valid streak
    });
  });
}
