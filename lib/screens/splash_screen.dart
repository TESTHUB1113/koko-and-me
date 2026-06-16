import 'package:flutter/material.dart';
import 'intro_screen.dart';
import 'jungle_map_screen.dart';
import '../data/user_profile.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  late AnimationController _dotCtrl;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    )..forward();
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _dotCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    )..repeat();

    // Navigate after 3.5 s (let the GIF play through).
    // Always show the main intro screen — let the user decide where to go.
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      final isReturning = AuthService.isSignedIn || UserProfile.name.isNotEmpty;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (ctx, anim, _) =>
              IntroScreen(isReturning: isReturning),
          transitionsBuilder: (ctx, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 700),
        ),
      );
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _dotCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0820),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Dark gradient background ──────────────────────
          _buildBackground(),

          // ── Content ──────────────────────────────────────
          FadeTransition(
            opacity: _fade,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Animated GIF ────────────────────────
                  Image.asset(
                    'assets/images/splash.gif',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, e, _) =>
                        const Icon(Icons.pets, size: 100, color: Colors.white54),
                  ),

                  const SizedBox(height: 28),

                  // ── Logo ────────────────────────────────
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 38,
                        letterSpacing: 1,
                      ),
                      children: [
                        TextSpan(
                          text: 'koko',
                          style: TextStyle(color: Color(0xFF1BC6C6)),
                        ),
                        TextSpan(
                          text: '&',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'me',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ── Tagline ─────────────────────────────
                  Text(
                    'Business English, made fun.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.5),
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Loading dots ─────────────────────────
                  _LoadingDots(controller: _dotCtrl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1B3E), Color(0xFF0B0820), Color(0xFF1A0A3A)],
            ),
          ),
        ),
        Positioned(
          top: -80, left: -80,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF1BC6C6).withValues(alpha: 0.10),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -60, right: -60,
          child: Container(
            width: 280, height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                const Color(0xFF7B5EA7).withValues(alpha: 0.12),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── THREE BOUNCING DOTS ─────────────────────────────────────────────────────
class _LoadingDots extends StatelessWidget {
  final AnimationController controller;
  const _LoadingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (ctx, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final phase = (controller.value - i * 0.2).clamp(0.0, 1.0);
            final bounce = (1 - (phase * 2 - 1).abs()).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.translate(
                offset: Offset(0, -10 * bounce),
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      const Color(0xFF1BC6C6).withValues(alpha: 0.3),
                      const Color(0xFF1BC6C6),
                      bounce,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
