import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koko_and_me/data/dept_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    DeptProgress.resetForTesting();
  });

  group('DeptProgress —', () {
    // ── État initial ─────────────────────────────────────────────────────────

    test('isLessonDone returns false for unknown dept', () {
      expect(DeptProgress.isLessonDone('management'), false);
    });

    test('isTestDone returns false for unknown dept', () {
      expect(DeptProgress.isTestDone('management'), false);
    });

    test('getStars returns 0 for untouched dept', () {
      expect(DeptProgress.getStars('management'), 0);
    });

    test('hasStarted returns false initially', () {
      expect(DeptProgress.hasStarted('rh'), false);
    });

    // ── markLessonDone ───────────────────────────────────────────────────────

    test('markLessonDone sets isLessonDone to true', () async {
      await DeptProgress.markLessonDone('management');
      expect(DeptProgress.isLessonDone('management'), true);
    });

    test('markLessonDone sets hasStarted to true', () async {
      await DeptProgress.markLessonDone('rh');
      expect(DeptProgress.hasStarted('rh'), true);
    });

    test('lesson done but test not done → 0 stars', () async {
      await DeptProgress.markLessonDone('management');
      expect(DeptProgress.getStars('management'), 0);
    });

    // ── Calcul des étoiles ───────────────────────────────────────────────────

    test('score ≥ 90% → 3 stars', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 9, 10); // 90 %
      expect(DeptProgress.getStars('management'), 3);
    });

    test('100% score → 3 stars', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 10, 10);
      expect(DeptProgress.getStars('management'), 3);
    });

    test('score 50–89% → 2 stars', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 7, 10); // 70 %
      expect(DeptProgress.getStars('management'), 2);
    });

    test('score exactly 50% → 2 stars', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 5, 10); // 50 %
      expect(DeptProgress.getStars('management'), 2);
    });

    test('score < 50% → 1 star', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 3, 10); // 30 %
      expect(DeptProgress.getStars('management'), 1);
    });

    test('test done but lesson not done → 0 stars', () async {
      await DeptProgress.setTestScore('management', 10, 10);
      expect(DeptProgress.getStars('management'), 0);
    });

    // ── Indépendance entre départements ──────────────────────────────────────

    test('progress on one dept does not affect another', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 10, 10);
      expect(DeptProgress.getStars('management'), 3);
      expect(DeptProgress.getStars('rh'),         0);
    });

    test('multiple depts can be tracked independently', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 10, 10);
      await DeptProgress.markLessonDone('rh');
      await DeptProgress.setTestScore('rh', 5, 10);
      expect(DeptProgress.getStars('management'), 3);
      expect(DeptProgress.getStars('rh'),         2);
    });

    // ── Persistance via SharedPreferences ────────────────────────────────────

    test('load() restores persisted progress', () async {
      SharedPreferences.setMockInitialValues({
        'dp_finance_lessonDone': true,
        'dp_finance_testDone':   true,
        'dp_finance_score':      8,
        'dp_finance_maxScore':   10,
      });
      await DeptProgress.load();
      expect(DeptProgress.isLessonDone('finance'), true);
      expect(DeptProgress.isTestDone('finance'),   true);
      expect(DeptProgress.getStars('finance'),     2); // 80 %
    });

    test('load() leaves unknown depts untouched', () async {
      SharedPreferences.setMockInitialValues({
        'dp_marketing_lessonDone': true,
        'dp_marketing_testDone':   true,
        'dp_marketing_score':      9,
        'dp_marketing_maxScore':   10,
      });
      await DeptProgress.load();
      expect(DeptProgress.getStars('management'), 0);
    });
  });
}
