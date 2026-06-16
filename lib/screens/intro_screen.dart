import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'jungle_map_screen.dart';
import 'onboarding_screen.dart';

class IntroScreen extends StatefulWidget {
  final bool isReturning;
  const IntroScreen({super.key, this.isReturning = false});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {

  late AnimationController _kokoCtrl;
  late Animation<double>   _kokoFloat;

  // Staggered entry controllers
  late AnimationController _entryCtrl;
  late Animation<double>   _fadeTxt;
  late Animation<double>   _fadeKoko;
  late Animation<Offset>   _slideTxt;

  // Bubble pulse
  late AnimationController _bubbleCtrl;

  @override
  void initState() {
    super.initState();

    _kokoCtrl = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _kokoFloat = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _kokoCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeTxt = CurvedAnimation(
      parent: _entryCtrl, curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideTxt = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    _fadeKoko = CurvedAnimation(
      parent: _entryCtrl, curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );

    _bubbleCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _kokoCtrl.dispose();
    _entryCtrl.dispose();
    _bubbleCtrl.dispose();
    super.dispose();
  }

  /// "Get Started" → Onboarding (choix de département) → Auth
  void _goToAuth() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const OnboardingScreen(),
        transitionsBuilder: (ctx, anim, sec, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Returning user → go straight to the map
  void _goToMap() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const JungleMapScreen(),
        transitionsBuilder: (ctx, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0820),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeroSection(),
            _buildWhyKoko(),
            _buildDepartments(),
            _buildBottomCta(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  HERO SECTION  mimics LingoDeer's warm full-bleed
  //  left text + right mascot + floating word bubbles
  // ═══════════════════════════════════════════════════
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      // Rich gradient background (replaces LingoDeer's orange)
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A0A3A), Color(0xFF0B2030)],
        ),
      ),
      child: Stack(
        children: [
          // Background city-like silhouette glow
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF1BC6C6).withValues(alpha: 0.04),
                  ],
                ),
              ),
            ),
          ),
          // Subtle radial behind mascot
          Positioned(
            right: -30, top: 40,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF7B5EA7).withValues(alpha: 0.20),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  // ── NAV
                  _buildNav(),

                  // ── HERO BODY: left text | right Koko
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 16, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // LEFT text
                        Expanded(
                          flex: 55,
                          child: FadeTransition(
                            opacity: _fadeTxt,
                            child: SlideTransition(
                              position: _slideTxt,
                              child: _buildHeroText(),
                            ),
                          ),
                        ),
                        // RIGHT Koko + bubbles
                        Expanded(
                          flex: 45,
                          child: FadeTransition(
                            opacity: _fadeKoko,
                            child: _buildKokoWithBubbles(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          // Logo text
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
              children: [
                TextSpan(text: 'koko', style: TextStyle(color: Color(0xFF1BC6C6))),
                TextSpan(text: '&me', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (ctx, anim, _) => const AuthScreen(),
                transitionsBuilder: (ctx, anim, sec, child) =>
                    FadeTransition(opacity: anim, child: child),
                transitionDuration: const Duration(milliseconds: 350),
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white.withValues(alpha: 0.6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Log in',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headline two-line like LingoDeer
        const Text(
          'Sound like you\nbelong in the\nroom.',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: 28,
            height: 1.2,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'Business English, one\ndepartment at a time.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.55),
            height: 1.5,
          ),
        ),

        const SizedBox(height: 24),

        // CTA button white pill like LingoDeer's "Learn now"
        GestureDetector(
          onTap: _goToAuth,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1BC6C6),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1BC6C6).withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Text(
              'Start for free →',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Color(0xFF06202A),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Sub-line like "It's easy and fun!"
        Text(
          'It\'s fun. Koko guarantees it.',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.35),
            fontFamily: 'Nunito',
          ),
        ),
      ],
    );
  }

  Widget _buildKokoWithBubbles() {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Koko mascot
          AnimatedBuilder(
            animation: _kokoFloat,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, _kokoFloat.value),
              child: child,
            ),
            child: Image.asset(
              'assets/images/koko.png',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              errorBuilder: (ctx, e, stack) =>
                  const Icon(Icons.pets, size: 110, color: Colors.white54),
            ),
          ),

          // Floating word bubbles (like LingoDeer's "Hello", "こんにちは")
          ..._buildWordBubbles(),
        ],
      ),
    );
  }

  List<Widget> _buildWordBubbles() {
    final bubbles = [
      _BubbleData('KPI', const Offset(-60, -110), const Color(0xFF1BC6C6)),
      _BubbleData('Stakeholder', const Offset(55, -90), const Color(0xFF9B7ED4)),
      _BubbleData('ROI', const Offset(-75, 60), const Color(0xFFF5C842)),
      _BubbleData('Budget', const Offset(60, 80), const Color(0xFFFF6B9D)),
      _BubbleData('Synergy', const Offset(-20, 130), const Color(0xFF4ECDA0)),
    ];

    return bubbles.asMap().entries.map((entry) {
      final i = entry.key;
      final b = entry.value;
      // Stagger the pulse for each bubble
      return AnimatedBuilder(
        animation: _bubbleCtrl,
        builder: (_, child) {
          final t = (_bubbleCtrl.value + i * 0.18) % 1.0;
          final scale = 0.93 + 0.07 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
          return Transform.translate(
            offset: b.offset,
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: b.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: b.color.withValues(alpha: 0.5), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: b.color.withValues(alpha: 0.2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            b.word,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 11,
              color: b.color,
            ),
          ),
        ),
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════
  //  "WHY KOKO?" SECTION mimics LingoDeer's features grid
  // ═══════════════════════════════════════════════════
  Widget _buildWhyKoko() {
    final features = [
      _FeatureData(Icons.business_rounded, const Color(0xFF1BC6C6), 'Real company context',
          'Every lesson lives inside a department. Finance talks money. HR talks people. Tech talks sprints.'),
      _FeatureData(Icons.sports_esports_rounded, const Color(0xFF9B7ED4), 'Lessons = games',
          'Quizzes, puzzles, crosswords & image matching. Zero boring drills.'),
      _FeatureData(null, Colors.transparent, 'Koko never rushes',
          'Your pace, always. Koko guides you like a friend who already works there.'),
      _FeatureData(Icons.star_rounded, const Color(0xFFF5C842), 'XP & streaks',
          'Earn points, unlock departments, keep your streak alive. Progress feels real.'),
    ];

    return Container(
      color: const Color(0xFFF7F5FF), // light section like LingoDeer's white
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          // Section title
          const Text(
            'Why Koko&me?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: Color(0xFF1A0A3A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Most of us spent years surviving English...From school, exams, presentations to cover letters : We got through it. Then we stepped into the workplace and discovered a whole new language hiding inside the one we thought we knew. Gross margin. Net revenue. Stakeholder alignment. Strategic headcount. Suddenly fluent isn\'t enough...you need to sound like you belong in the room. And nobody hands you a guide for that.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF1A0A3A).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),

          // 2×2 grid like LingoDeer's icon strip
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.0,
            children: features.map((f) => _FeatureCard(data: f)).toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  DEPARTMENTS ROW scrollable chips
  // ═══════════════════════════════════════════════════
  Widget _buildDepartments() {
    const depts = [
      (Icons.bar_chart_rounded,                'Management', Color(0xFF1BC6C6)),
      (Icons.account_balance_wallet_outlined,  'Finance',    Color(0xFFF5C842)),
      (Icons.group_outlined,                   'HR',         Color(0xFF7B5EA7)),
      (Icons.campaign_outlined,                'Marketing',  Color(0xFFFF6B9D)),
      (Icons.laptop_outlined,                  'Tech & IT',  Color(0xFF4ECDA0)),
      (Icons.balance,                          'Legal',      Color(0xFF9B8EC4)),
    ];

    return Container(
      color: const Color(0xFF0B0820),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  '6 DEPARTMENTS · 1 JUNGLE',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 2.5,
                    color: const Color(0xFF1BC6C6).withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'One complete\nbusiness vocabulary.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: depts.length,
              separatorBuilder: (_, i) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final d = depts[i];
                return Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: d.$3.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: d.$3.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(d.$1, size: 28, color: d.$3),
                      const SizedBox(height: 6),
                      Text(
                        d.$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                          color: d.$3,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 36),

          // Stats row like LingoDeer's press logos row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatNum('6', 'Depts'),
                  _Divider(),
                  _StatNum('40+', 'Lessons'),
                  _Divider(),
                  _StatNum('4', 'Game types'),
                  _Divider(),
                  _StatNum('100%', 'Free'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  //  BOTTOM CTA
  // ═══════════════════════════════════════════════════
  Widget _buildBottomCta() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D1B3E), Color(0xFF1A0A3A)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 56),
      child: Column(
        children: [
          // Koko small
          Image.asset(
            'assets/images/koko.png',
            width: 80, height: 80,
            errorBuilder: (ctx, e, _) =>
                const Icon(Icons.pets, size: 60, color: Colors.white54),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ready to sound like\nyou belong in the room?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 24,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Koko\'s waiting for you.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 32),

          // Big CTA — returning users see "Continue", new users see "Join"
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: widget.isReturning ? _goToMap : _goToAuth,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xFF06202A),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 0,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  color: const Color(0xFF1BC6C6),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1BC6C6).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.isReturning ? 'Continue →' : 'Join the corporate jungle',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xFF06202A),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.isReturning) ...[
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _goToAuth,
              child: Text(
                'Not you? Start fresh',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.35),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────────────
class _BubbleData {
  final String word;
  final Offset offset;
  final Color color;
  const _BubbleData(this.word, this.offset, this.color);
}

class _FeatureData {
  final IconData? icon; // null → show koko mascot image
  final Color iconColor;
  final String title;
  final String body;
  const _FeatureData(this.icon, this.iconColor, this.title, this.body);
}

// ─────────────────────────────────────────────────────
//  FEATURE CARD  (grid item)
// ─────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A0A3A).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.icon != null
              ? Icon(data.icon!, size: 30, color: data.iconColor)
              : Image.asset('assets/images/koko.png', width: 30, height: 30,
                  errorBuilder: (ctx2, e2, st2) =>
                      Icon(Icons.pets, size: 30, color: data.iconColor)),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 13,
              color: Color(0xFF1A0A3A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              data.body,
              style: TextStyle(
                fontSize: 11,
                color: const Color(0xFF1A0A3A).withValues(alpha: 0.5),
                height: 1.5,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  SMALL WIDGETS
// ─────────────────────────────────────────────────────
class _StatNum extends StatelessWidget {
  final String value;
  final String label;
  const _StatNum(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: Color(0xFF1BC6C6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.4),
              fontFamily: 'Nunito',
            ),
          ),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 30,
        color: Colors.white.withValues(alpha: 0.07),
      );
}
