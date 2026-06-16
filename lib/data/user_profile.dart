import 'package:shared_preferences/shared_preferences.dart';
import 'user_progress.dart';
import 'dept_progress.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';

// ─── USER PROFILE ─────────────────────────────────────────────────────────────
// Nom, email, initiale persistés via SharedPreferences.
class UserProfile {
  UserProfile._();

  static String name       = '';
  static String email      = '';
  static String focusDept  = '';
  static String avatarPath = '';

  // ── Chargement ──────────────────────────────────────────────────────────────
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    name       = prefs.getString('profile_name')        ?? '';
    email      = prefs.getString('profile_email')       ?? '';
    focusDept  = prefs.getString('profile_focus_dept')  ?? '';
    avatarPath = prefs.getString('profile_avatar_path') ?? '';
  }

  // ── Sauvegarde partielle ────────────────────────────────────────────────────
  static Future<void> save({
    String? newName,
    String? newEmail,
    String? newFocusDept,
    String? newAvatarPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (newName != null) {
      name = newName.trim();
      await prefs.setString('profile_name', name);
    }
    if (newEmail != null) {
      email = newEmail.trim();
      await prefs.setString('profile_email', email);
    }
    if (newFocusDept != null) {
      focusDept = newFocusDept;
      await prefs.setString('profile_focus_dept', focusDept);
    }
    if (newAvatarPath != null) {
      avatarPath = newAvatarPath;
      await prefs.setString('profile_avatar_path', avatarPath);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  /// Première lettre du prénom, ou 'A' par défaut
  static String get initial =>
      name.isNotEmpty ? name[0].toUpperCase() : 'A';

  /// Prénom affiché (premier mot du nom complet)
  static String get displayName =>
      name.isNotEmpty ? name : 'Learner';

  /// Nombre de départements dont le test est complété
  static int get completedDepts {
    const ids = [
      'management', 'rh', 'finance', 'marketing', 'tech', 'legal'
    ];
    return ids.where((id) => DeptProgress.isTestDone(id)).length;
  }

  // ── Pour les tests unitaires ─────────────────────────────────────────────
  static void resetForTesting() {
    name      = '';
    email     = '';
    focusDept = '';
  }

  // ── Déconnexion ──────────────────────────────────────────────────────────────
  // Local progress is kept so it syncs back on next login.
  static Future<void> signOut() async {
    try {
      await AuthService.signOut();
    } catch (_) {
      // Sign out locally even if Firebase is unreachable
    }
    name  = '';
    email = '';
  }

  // ── Suppression de compte (RGPD) ─────────────────────────────────────────
  static Future<void> deleteAccount() async {
    await SyncService.deleteUserDocument();  // supprime Firestore
    await AuthService.deleteAccount();       // supprime Firebase Auth
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    name       = '';
    email      = '';
    focusDept  = '';
    avatarPath = '';
    UserProgress.xp     = 0;
    UserProgress.streak = 0;
    DeptProgress.resetForTesting();
  }
}
