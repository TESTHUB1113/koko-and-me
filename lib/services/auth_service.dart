import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';

// ─── AUTH SERVICE ─────────────────────────────────────────────────────────────
// Wrappeur autour de Firebase Auth.
// Toutes les méthodes lèvent une [AuthException] en cas d'erreur jamais une
// FirebaseAuthException brute ce qui simplifie le code UI.
class AuthService {
  AuthService._();

  static final _googleSignIn = GoogleSignIn();

  // Lazy getter évite le crash si Firebase n'est pas initialisé
  static FirebaseAuth? get _auth {
    try { return FirebaseAuth.instance; } catch (_) { return null; }
  }

  // ── État ──────────────────────────────────────────────────────────────────
  static User?   get currentUser  => _auth?.currentUser;
  static bool    get isSignedIn   => currentUser != null;
  static String? get uid          => currentUser?.uid;
  static String? get displayName  => currentUser?.displayName;
  static String? get photoUrl     => currentUser?.photoURL;

  /// Stream qui émet à chaque changement d'état d'authentification.
  static Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? const Stream.empty();

  // ── Inscription email / mot de passe ─────────────────────────────────────
  static Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (_auth == null) throw const AuthException(code: 'firebase-unavailable', message: 'Firebase non configuré.');
    try {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email:    email,
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    }
  }

  // ── Connexion email / mot de passe ────────────────────────────────────────
  static Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_auth == null) throw const AuthException(code: 'firebase-unavailable', message: 'Firebase non configuré.');
    try {
      return await _auth!.signInWithEmailAndPassword(
        email:    email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    }
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  /// Retourne null si l'utilisateur annule.
  /// Sur Windows : ouvre le navigateur système via Firebase signInWithProvider.
  /// Sur Android/iOS/macOS/Web : utilise le SDK google_sign_in natif.
  static Future<UserCredential?> signInWithGoogle() async {
    if (_auth == null) throw const AuthException(code: 'firebase-unavailable', message: 'Firebase non configuré.');
    try {
      final isDesktopWindows = !kIsWeb &&
          defaultTargetPlatform == TargetPlatform.windows;

      if (isDesktopWindows) {
        // Opens the system browser for OAuth then returns to the app.
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');
        return await _auth!.signInWithProvider(provider);
      }

      // Android / iOS / macOS / Web — native Google Sign-In sheet.
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );
      return await _auth!.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    } catch (e) {
      throw AuthException(
        code:    'google-sign-in-failed',
        message: 'La connexion Google a échoué. Réessayez.',
      );
    }
  }

  // ── Réinitialisation mot de passe ─────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    if (_auth == null) throw const AuthException(code: 'firebase-unavailable', message: 'Firebase non configuré.');
    try {
      await _auth!.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    }
  }

  // ── Déconnexion ───────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await Future.wait([
      if (_auth != null) _auth!.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ── Suppression de compte (RGPD) ──────────────────────────────────────────
  static Future<void> deleteAccount() async {
    if (_auth == null) return;
    try {
      await _auth!.currentUser?.delete();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebase(e);
    }
  }
}

// ─── EXCEPTION AUTH ───────────────────────────────────────────────────────────
class AuthException implements Exception {
  final String code;
  final String message;

  const AuthException({required this.code, required this.message});

  factory AuthException.fromFirebase(FirebaseAuthException e) {
    final msg = switch (e.code) {
      'user-not-found'         => 'Aucun compte trouvé pour cet email.',
      'wrong-password'         => 'Mot de passe incorrect.',
      'invalid-credential'     => 'Email ou mot de passe incorrect.',
      'email-already-in-use'   => 'Cet email est déjà utilisé.',
      'weak-password'          => 'Mot de passe trop faible (6 caractères min.).',
      'invalid-email'          => 'Adresse email invalide.',
      'network-request-failed' => 'Erreur réseau. Vérifiez votre connexion.',
      'too-many-requests'      => 'Trop de tentatives. Réessayez dans quelques minutes.',
      'user-disabled'          => 'Ce compte a été désactivé.',
      _                        => 'Erreur : ${e.message ?? e.code}',
    };
    return AuthException(code: e.code, message: msg);
  }

  @override
  String toString() => message;
}
