import 'package:flutter/material.dart';
import 'jungle_map_screen.dart';
import '../data/user_profile.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';

// ─── COULEURS ─────────────────────────────────────────────────────────────────
const _kBg        = Color(0xFF232337);
const _kInputBg   = Color(0xFF3B2063);
const _kInputDeep = Color(0xFF190733);
const _kGrad1     = Color(0xFF501794);
const _kGrad2     = Color(0xFF3E70A1);
const _kTeal      = Color(0xFF52EBE9);
const _kGray1     = Color(0xFFB6B6B6);
const _kGray2     = Color(0xFFA4A4A4);
const _kFbBlue    = Color(0xFF1877F2);
const _kLiBlue    = Color(0xFF0A66C2);

// ─── AUTH SCREEN ──────────────────────────────────────────────────────────────
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool   _isSignUp         = true;
  bool   _obscurePassword  = true;
  bool   _loading          = false;
  String _errorMessage     = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Après une authentification réussie ────────────────────────────────────
  Future<void> _onAuthSuccess() async {
    // Sauvegarder le profil localement (nom saisi ou displayName Firebase)
    final name  = _nameCtrl.text.trim().isNotEmpty
        ? _nameCtrl.text.trim()
        : (AuthService.displayName ?? '');
    final email = _emailCtrl.text.trim();

    await UserProfile.save(
      newName:  name.isNotEmpty  ? name  : null,
      newEmail: email.isNotEmpty ? email : null,
    );

    // Pull depuis Firestore (nouveau compte → push, compte existant → pull)
    await SyncService.pullFromCloud();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const JungleMapScreen(),
        transitionsBuilder: (ctx, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Soumission email / mot de passe ───────────────────────────────────────
  Future<void> _submit() async {
    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    final name     = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs.');
      return;
    }
    if (_isSignUp && name.isEmpty) {
      setState(() => _errorMessage = 'Veuillez entrer votre nom.');
      return;
    }

    setState(() { _loading = true; _errorMessage = ''; });

    try {
      if (_isSignUp) {
        await AuthService.signUpWithEmail(
          name:     name,
          email:    email,
          password: password,
        );
        await SyncService.createUserDocument(name: name, email: email);
      } else {
        await AuthService.signInWithEmail(email: email, password: password);
      }
      await _onAuthSuccess();
    } on AuthException catch (e) {
      if (mounted) setState(() { _errorMessage = e.message; _loading = false; });
    }
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  Future<void> _googleSignIn() async {
    setState(() { _loading = true; _errorMessage = ''; });
    try {
      final credential = await AuthService.signInWithGoogle();
      if (credential == null) {
        // L'utilisateur a annulé
        if (mounted) setState(() => _loading = false);
        return;
      }
      // Créer le document si c'est un nouveau compte Google
      if (credential.additionalUserInfo?.isNewUser == true) {
        await SyncService.createUserDocument(
          name:  AuthService.displayName ?? '',
          email: credential.user?.email ?? '',
        );
      }
      await _onAuthSuccess();
    } on AuthException catch (e) {
      if (mounted) setState(() { _errorMessage = e.message; _loading = false; });
    }
  }

  // ── Placeholder réseaux sociaux ───────────────────────────────────────────
  void _socialComingSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$provider disponible prochainement'),
        backgroundColor: const Color(0xFF3B2063),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Continuer sans compte (mode invité) ──────────────────────────────────
  Future<void> _continueAsGuest() async {
    // Guests don't get a personalised path — clear any dept chosen on onboarding
    await UserProfile.save(newFocusDept: '');
    final name = _nameCtrl.text.trim();
    if (name.isNotEmpty) {
      await UserProfile.save(newName: name);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const JungleMapScreen(),
        transitionsBuilder: (ctx, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  // ── Toggle Sign Up / Log In ───────────────────────────────────────────────
  void _toggleMode() {
    setState(() {
      _isSignUp     = !_isSignUp;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 28),

              // ── Mascotte ────────────────────────────────────────────────
              Center(
                child: Image.asset(
                  'assets/images/koko.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, e, _) =>
                      const Icon(Icons.pets, size: 80, color: Colors.white24),
                ),
              ),
              const SizedBox(height: 24),

              // ── Titre ───────────────────────────────────────────────────
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                      height: 1.15,
                    ),
                    children: [
                      if (_isSignUp) ...[
                        const TextSpan(
                            text: 'Join ', style: TextStyle(color: Colors.white)),
                        const TextSpan(
                            text: 'koko', style: TextStyle(color: _kTeal)),
                        const TextSpan(
                            text: '&me', style: TextStyle(color: Colors.white)),
                      ] else ...[
                        const TextSpan(
                            text: 'Welcome ',
                            style: TextStyle(color: Colors.white)),
                        const TextSpan(
                            text: 'back', style: TextStyle(color: _kTeal)),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Sous-titre ──────────────────────────────────────────────
              const SizedBox(height: 12),
              Text(
                _isSignUp
                    ? 'Créez votre compte'
                    : 'Connectez-vous pour continuer',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _kGray1,
                ),
              ),

              // ── Champ nom (Sign Up uniquement) ──────────────────────────
              const SizedBox(height: 20),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isSignUp
                    ? Column(
                        children: [
                          _AuthField(
                            controller: _nameCtrl,
                            hint: 'Votre prénom et nom',
                            icon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 12),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              // ── Champ email ─────────────────────────────────────────────
              _AuthField(
                controller: _emailCtrl,
                hint: 'Adresse email',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // ── Champ mot de passe ──────────────────────────────────────
              _PasswordField(
                controller: _passwordCtrl,
                obscure: _obscurePassword,
                onToggle: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),

              // ── Message d'erreur ────────────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _errorMessage.isEmpty
                    ? const SizedBox(height: 18)
                    : Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4757).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFFFF4757).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  size: 15, color: Color(0xFFFF6B7A)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Color(0xFFFF6B7A),
                                    fontFamily: 'Nunito',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              // ── Bouton principal ────────────────────────────────────────
              const SizedBox(height: 8),
              _loading
                  ? const Center(
                      child: SizedBox(
                        width: 28, height: 28,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: _kTeal),
                      ),
                    )
                  : _SignUpButton(
                      label: _isSignUp ? 'Créer mon compte' : 'Se connecter',
                      onTap: _submit,
                    ),

              // ── Mot de passe oublié (Log In uniquement) ─────────────────
              if (!_isSignUp) ...[
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () => _sendPasswordReset(),
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: _kTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              // ── Séparateur ──────────────────────────────────────────────
              const SizedBox(height: 32),
              Container(height: 0.5, color: _kTeal.withValues(alpha: 0.55)),
              const SizedBox(height: 20),
              const Text(
                'ou continuer avec',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: _kGray2,
                ),
              ),

              // ── Boutons sociaux ─────────────────────────────────────────
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    _SocialButton(
                      icon: const _GoogleIcon(),
                      label: 'Continuer avec Google',
                      onTap: _loading ? null : _googleSignIn,
                    ),
                    const SizedBox(height: 13),
                    _SocialButton(
                      icon: _SocialBadge(
                        color: _kFbBlue,
                        child: const Text('f',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                height: 1)),
                      ),
                      label: 'Continuer avec Facebook',
                      onTap: () => _socialComingSoon('Facebook'),
                    ),
                    const SizedBox(height: 13),
                    _SocialButton(
                      icon: _SocialBadge(
                        color: _kLiBlue,
                        child: const Text('in',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 8,
                                height: 1,
                                letterSpacing: -0.5)),
                      ),
                      label: 'Continuer avec LinkedIn',
                      onTap: () => _socialComingSoon('LinkedIn'),
                    ),
                  ],
                ),
              ),

              // ── CGU ─────────────────────────────────────────────────────
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      height: 1.6,
                      color: _kGray1,
                    ),
                    children: [
                      TextSpan(text: 'En vous inscrivant, vous acceptez nos '),
                      TextSpan(
                        text: 'Conditions d\'utilisation',
                        style: TextStyle(
                            color: _kTeal,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: _kTeal),
                      ),
                      TextSpan(text: ' et notre '),
                      TextSpan(
                        text: 'Politique de confidentialité',
                        style: TextStyle(
                            color: _kTeal,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor: _kTeal),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),

              // ── Toggle Sign Up / Log In ──────────────────────────────────
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isSignUp
                        ? 'Déjà un compte ? '
                        : 'Pas encore de compte ? ',
                    style: const TextStyle(
                        fontFamily: 'Nunito', fontSize: 12, color: _kGray1),
                  ),
                  GestureDetector(
                    onTap: _toggleMode,
                    child: Text(
                      _isSignUp ? 'Se connecter' : 'Créer un compte',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: _kTeal,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Continuer sans compte ────────────────────────────────────
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: _loading ? null : _continueAsGuest,
                  child: Text(
                    'Continuer sans compte',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.28),
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendPasswordReset() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Entrez votre email pour réinitialiser le mot de passe.');
      return;
    }
    try {
      await AuthService.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email de réinitialisation envoyé !'),
          backgroundColor: const Color(0xFF3B2063),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    }
  }
}

// ─── CHAMP GÉNÉRIQUE ──────────────────────────────────────────────────────────
class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: _kInputBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _kInputDeep.withValues(alpha: 0.16),
            blurRadius: 9,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.35)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.30),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

// ─── CHAMP MOT DE PASSE ───────────────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: _kInputBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: _kInputDeep.withValues(alpha: 0.16), blurRadius: 9),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.lock_outline_rounded,
              size: 18, color: Colors.white.withValues(alpha: 0.35)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.30),
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: Colors.white.withValues(alpha: 0.40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── BOUTON PRINCIPAL ─────────────────────────────────────────────────────────
class _SignUpButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SignUpButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kGrad1, _kGrad2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _kGrad1.withValues(alpha: 0.38),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}

// ─── BOUTON SOCIAL ────────────────────────────────────────────────────────────
class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const _SocialButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1.0,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: _kInputBg,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              icon,
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── HELPERS ICÔNES SOCIALES ──────────────────────────────────────────────────
class _SocialBadge extends StatelessWidget {
  final Color color;
  final Widget child;
  const _SocialBadge({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18, height: 18,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18, height: 18,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  static const _red    = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green  = Color(0xFF34A853);
  static const _blue   = Color(0xFF4285F4);

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r  = s.width * 0.44;
    final sw = s.width * 0.17;
    final arcRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    void arc(Color c, double start, double sweep) {
      canvas.drawArc(
        arcRect, start, sweep, false,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..strokeCap = StrokeCap.butt,
      );
    }

    arc(_red,    -1.40, -1.75);
    arc(_yellow,  2.19,  0.90);
    arc(_green,  -0.52,  1.65);
    arc(_blue,    1.10, -0.68);

    canvas.drawLine(
      Offset(cx, cy), Offset(cx + r + sw * 0.5, cy),
      Paint()..color = _blue..strokeWidth = sw..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
