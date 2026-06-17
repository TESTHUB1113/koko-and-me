import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/user_profile.dart';
import '../data/user_progress.dart';
import '../data/dept_progress.dart';

// ─── SYNC SERVICE ─────────────────────────────────────────────────────────────
// Stratégie offline-first :
//   • Les données vivent localement dans SharedPreferences (lecture rapide,
//     fonctionne sans réseau).
//   • Firestore est la source de vérité côté cloud (sync à la connexion et
//     après chaque gain de XP / fin de test).
//   • En cas d'erreur réseau, les appels sont silencieusement ignorés 
//     l'app continue de fonctionner en mode local.
//
// Schéma Firestore :
//   users/{uid}
//     name:             string
//     email:            string
//     createdAt:        Timestamp
//     updatedAt:        Timestamp
//     xp:               number
//     streak:           number
//     lastActivityDate: string  (YYYY-MM-DD)
//     departments:      map
//       {deptId}:
//         lessonDone:   boolean
//         testDone:     boolean
//         testScore:    number
//         testMaxScore: number
class SyncService {
  SyncService._();

  static const _deptIds = [
    'management', 'rh', 'finance', 'marketing', 'tech', 'legal',
  ];

  static FirebaseFirestore? get _db {
    try { return FirebaseFirestore.instance; } catch (_) { return null; }
  }

  static DocumentReference<Map<String, dynamic>>? get _userDoc {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;
      return _db?.collection('users').doc(uid);
    } catch (_) { return null; }
  }

  // ── Lecture cloud → local ─────────────────────────────────────────────────
  /// Appelé juste après la connexion.
  /// Si le document n'existe pas (nouveau compte), pousse les données locales.
  static Future<void> pullFromCloud() async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      final snap = await doc.get();

      if (!snap.exists || snap.data() == null) {
        // Nouveau compte enregistrer les données locales dans le cloud
        await pushToCloud();
        return;
      }

      final data = snap.data()!;

      // Profil
      await UserProfile.save(
        newName:  data['name']  as String? ?? '',
        newEmail: data['email'] as String? ?? '',
      );

      // Progression XP / streak
      await UserProgress.setFromCloud(
        cloudXp:           (data['xp']               as int?)    ?? 0,
        cloudStreak:       (data['streak']            as int?)    ?? 0,
        cloudLastDate:     (data['lastActivityDate']  as String?) ?? '',
      );

      // Progression par département
      final depts = data['departments'] as Map<String, dynamic>? ?? {};
      for (final id in _deptIds) {
        final d = depts[id] as Map<String, dynamic>?;
        if (d == null) continue;
        if (d['lessonDone'] == true) {
          await DeptProgress.markLessonDone(id);
        }
        if (d['testDone'] == true) {
          await DeptProgress.setTestScore(
            id,
            (d['testScore']    as int?) ?? 0,
            (d['testMaxScore'] as int?) ?? 1,
          );
        }
        final gameBestScores =
            d['gameBestScores'] as Map<String, dynamic>? ?? {};
        for (final entry in gameBestScores.entries) {
          final idx = int.tryParse(entry.key);
          if (idx != null) {
            await DeptProgress.setGameBestScoreFromCloud(
                id, idx, (entry.value as int?) ?? 0);
          }
        }
      }
    } catch (_) {
      // Pas de réseau ou Firebase non configuré → on continue en local
    }
  }

  // ── Écriture local → cloud ────────────────────────────────────────────────
  /// Pousse l'état local vers Firestore.
  /// Utilise SetOptions(merge: true) pour ne pas écraser les champs absents.
  static Future<void> pushToCloud() async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      final departments = <String, Map<String, dynamic>>{};
      for (final id in _deptIds) {
        if (!DeptProgress.hasStarted(id)) continue;
        final gameBestScores = DeptProgress.getGameBestScores(id);
        departments[id] = {
          'lessonDone':    DeptProgress.isLessonDone(id),
          'testDone':      DeptProgress.isTestDone(id),
          'testScore':     DeptProgress.getTestScore(id),
          'testMaxScore':  DeptProgress.getTestMaxScore(id),
          if (gameBestScores.isNotEmpty)
            'gameBestScores': gameBestScores.map((k, v) => MapEntry('$k', v)),
        };
      }

      await doc.set(
        {
          'name':             UserProfile.name,
          'email':            UserProfile.email,
          'updatedAt':        FieldValue.serverTimestamp(),
          'xp':               UserProgress.xp,
          'streak':           UserProgress.streak,
          'lastActivityDate': UserProgress.lastActivityDate,
          'departments':      departments,
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Pas de réseau → les données restent en local, seront sync au prochain push
    }
  }

  // ── Suppression du document utilisateur (RGPD) ───────────────────────────
  static Future<void> deleteUserDocument() async {
    final doc = _userDoc;
    if (doc == null) return;
    try {
      await doc.delete();
    } catch (_) {}
  }

  // ── Initialisation du document utilisateur ────────────────────────────────
  /// Crée le document Firestore avec createdAt si c'est un nouveau compte.
  static Future<void> createUserDocument({
    required String name,
    required String email,
  }) async {
    final doc = _userDoc;
    if (doc == null) return;

    try {
      await doc.set(
        {
          'name':             name,
          'email':            email,
          'createdAt':        FieldValue.serverTimestamp(),
          'updatedAt':        FieldValue.serverTimestamp(),
          'xp':               0,
          'streak':           0,
          'lastActivityDate': '',
          'departments':      <String, dynamic>{},
        },
        SetOptions(merge: true), // idempotent si appelé plusieurs fois
      );
    } catch (_) {
      // silencieux
    }
  }
}
