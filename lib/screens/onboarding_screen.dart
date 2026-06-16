import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/user_profile.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {

  String? selectedId;
  late AnimationController _kokoController;
  late Animation<double> _kokoFloat;

  @override
  void initState() {
    super.initState();
    _kokoController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _kokoFloat = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _kokoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _kokoController.dispose();
    super.dispose();
  }

  Future<void> _launch({bool skip = false}) async {
    // Persister le département choisi (vide si skip)
    if (!skip && selectedId != null) {
      await UserProfile.save(newFocusDept: selectedId);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const AuthScreen(),
        transitionsBuilder: (ctx, anim, sec, child) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(anim),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = selectedId != null
        ? allDepartments.firstWhere((d) => d.id == selectedId)
        : null;

    return Scaffold(
      backgroundColor: KokoColors.night,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Koko floating
              AnimatedBuilder(
                animation: _kokoFloat,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _kokoFloat.value), child: child,
                ),
                child: Image.asset(
                  'assets/images/koko.png',
                  width: 140, height: 140, fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.pets, size: 90, color: Colors.white54),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'WELCOME TO',
                style: TextStyle(
                  fontSize: 10, letterSpacing: 3,
                  color: KokoColors.teal, fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Nunito', fontSize: 36,
                    fontWeight: FontWeight.w900, height: 1.15,
                  ),
                  children: [
                    TextSpan(text: 'Koko', style: TextStyle(color: Colors.white)),
                    TextSpan(text: '&', style: TextStyle(color: Color(0xFF1BC6C6))),
                    TextSpan(text: 'me', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text(
                'Choose your department \nKoko will build your personalised path!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, color: Colors.white.withValues(alpha: 0.45), height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // Department grid
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.9,
                children: allDepartments.map((dept) {
                  final isSelected = selectedId == dept.id;
                  return _DeptCard(
                    dept: dept,
                    isSelected: isSelected,
                    onTap: () => setState(() => selectedId = dept.id),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedId != null ? () => _launch() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selected?.color ?? KokoColors.teal,
                    foregroundColor: const Color(0xFF063030),
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.08),
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    selected != null
                        ? 'Start with ${selected.label} →'
                        : 'Choose your department',
                    style: const TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () => _launch(skip: true),
                child: Text(
                  'Explore without a path',
                  style: TextStyle(
                    fontSize: 12, color: Colors.white.withValues(alpha: 0.3),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeptCard extends StatelessWidget {
  final Department dept;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeptCard({required this.dept, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0),
        decoration: BoxDecoration(
          color: isSelected
              ? dept.color.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? dept.color : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (isSelected)
              Positioned(
                top: 6, right: 8,
                child: Icon(Icons.check_rounded, size: 12, color: dept.color),
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(dept.icon, size: 32, color: dept.color),
                  const SizedBox(height: 6),
                  Text(
                    dept.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                      fontSize: 9.5,
                      color: isSelected ? dept.color : Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
