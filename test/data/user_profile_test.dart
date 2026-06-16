import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:koko_and_me/data/user_profile.dart';
import 'package:koko_and_me/data/user_progress.dart';
import 'package:koko_and_me/data/dept_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    UserProfile.resetForTesting();
    UserProgress.resetForTesting();
    DeptProgress.resetForTesting();
  });

  group('UserProfile —', () {
    // ── État initial ─────────────────────────────────────────────────────────

    test('name and email are empty initially', () {
      expect(UserProfile.name,  '');
      expect(UserProfile.email, '');
    });

    test('initial getter returns "A" when name is empty', () {
      expect(UserProfile.initial, 'A');
    });

    test('displayName returns "Learner" when name is empty', () {
      expect(UserProfile.displayName, 'Learner');
    });

    test('completedDepts is 0 when no test done', () {
      expect(UserProfile.completedDepts, 0);
    });

    // ── save() ───────────────────────────────────────────────────────────────

    test('save() sets name', () async {
      await UserProfile.save(newName: 'Sophie');
      expect(UserProfile.name, 'Sophie');
    });

    test('save() sets email', () async {
      await UserProfile.save(newEmail: 'sophie@test.com');
      expect(UserProfile.email, 'sophie@test.com');
    });

    test('save() trims whitespace from name', () async {
      await UserProfile.save(newName: '  Alex  ');
      expect(UserProfile.name, 'Alex');
    });

    test('save() trims whitespace from email', () async {
      await UserProfile.save(newEmail: ' alice@test.com ');
      expect(UserProfile.email, 'alice@test.com');
    });

    test('save() partial update: name-only preserves existing email', () async {
      await UserProfile.save(newName: 'Bob', newEmail: 'bob@test.com');
      await UserProfile.save(newName: 'Alice');
      expect(UserProfile.name,  'Alice');
      expect(UserProfile.email, 'bob@test.com');
    });

    // ── Helpers ──────────────────────────────────────────────────────────────

    test('initial getter returns uppercase first letter', () async {
      await UserProfile.save(newName: 'sophie');
      expect(UserProfile.initial, 'S');
    });

    test('initial getter works with multi-word names', () async {
      await UserProfile.save(newName: 'Pierre Dupont');
      expect(UserProfile.initial, 'P');
    });

    test('displayName returns full saved name', () async {
      await UserProfile.save(newName: 'Sophie Martin');
      expect(UserProfile.displayName, 'Sophie Martin');
    });

    // ── completedDepts ───────────────────────────────────────────────────────

    test('completedDepts counts only completed tests', () async {
      await DeptProgress.markLessonDone('management');
      await DeptProgress.setTestScore('management', 10, 10);
      await DeptProgress.markLessonDone('rh');
      await DeptProgress.setTestScore('rh', 5, 10);
      expect(UserProfile.completedDepts, 2);
    });

    test('completedDepts ignores lesson-only completions', () async {
      await DeptProgress.markLessonDone('finance');
      // No setTestScore → test not done
      expect(UserProfile.completedDepts, 0);
    });

    // ── Persistance via SharedPreferences ────────────────────────────────────

    test('load() restores name and email', () async {
      SharedPreferences.setMockInitialValues({
        'profile_name':  'Alice',
        'profile_email': 'alice@test.com',
      });
      await UserProfile.load();
      expect(UserProfile.name,  'Alice');
      expect(UserProfile.email, 'alice@test.com');
    });

    test('load() sets empty strings when nothing persisted', () async {
      await UserProfile.load();
      expect(UserProfile.name,  '');
      expect(UserProfile.email, '');
    });

    // ── signOut() ────────────────────────────────────────────────────────────

    test('signOut() clears name and email', () async {
      await UserProfile.save(newName: 'Bob', newEmail: 'b@b.com');
      await UserProfile.signOut();
      expect(UserProfile.name,  '');
      expect(UserProfile.email, '');
    });

    test('signOut() resets XP and streak', () async {
      UserProgress.xp     = 500;
      UserProgress.streak = 7;
      await UserProfile.signOut();
      expect(UserProgress.xp,     0);
      expect(UserProgress.streak, 0);
    });
  });
}
