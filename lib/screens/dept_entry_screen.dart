import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/vn_data.dart';
import 'management_test_screen.dart';
import 'visual_novel_screen.dart';

// ─── DEPT ENTRY SCREEN ────────────────────────────────────────────────────────
// Appears when the user taps a department node on the jungle map.
// Lets them choose: Leçon (interactive VN) or Tester (existing word games).
class DeptEntryScreen extends StatelessWidget {
  final Department dept;

  const DeptEntryScreen({super.key, required this.dept});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          // ── Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08051A), Color(0xFF0D0A2A), Color(0xFF130D35)],
              ),
            ),
          ),
          // ── Dept colour glow
          Positioned(
            top: -40, left: 0, right: 0,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [dept.color.withValues(alpha: 0.2), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: dept.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: dept.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(dept.icon, size: 13, color: dept.color),
                            const SizedBox(width: 6),
                            Text(
                              dept.label,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: dept.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 38),
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Koko speech bubble
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/koko.png',
                              width: 50, height: 50,
                              errorBuilder: (c, e, _) =>
                                  const Icon(Icons.pets, size: 36, color: Colors.white54),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.08)),
                                ),
                                child: Text(
                                  'Welcome to ${dept.label}!\n\nDo you want me to guide you first or are you jumping straight into the test?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.7),
                                    height: 1.55,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 36),

                        // ── Leçon card
                        _EntryCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Leçon',
                          subtitle:
                              'Koko vous guide scène par scène. Découvrez le vocabulaire du ${dept.label} comme dans un RPG.',
                          accentColor: dept.color,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (ctx, anim, _) => VisualNovelScreen(
                                  dept: dept,
                                  scenes: getScenesForDept(dept.id),
                                ),
                                transitionsBuilder: (ctx, anim, _, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration: const Duration(milliseconds: 320),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // ── Test card
                        _EntryCard(
                          icon: Icons.gps_fixed,
                          title: 'Tester tes compétences',
                          subtitle:
                              'Partez directement dans les exercices word match, quiz, word catcher.',
                          accentColor: Colors.white,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (ctx, anim, _) =>
                                    ManagementTestScreen(deptId: dept.id),
                                transitionsBuilder: (ctx, anim, _, child) =>
                                    SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(CurvedAnimation(
                                      parent: anim, curve: Curves.easeOutCubic)),
                                  child: child,
                                ),
                                transitionDuration: const Duration(milliseconds: 350),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ENTRY CARD ───────────────────────────────────────────────────────────────
class _EntryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _EntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isWhite = accentColor == Colors.white;
    final displayColor = isWhite ? Colors.white : accentColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: displayColor.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: displayColor.withValues(alpha: 0.22), width: 1.5),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: displayColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: Icon(icon, size: 26, color: displayColor)),
            ),
            const SizedBox(width: 16),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: displayColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.42),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: displayColor.withValues(alpha: 0.45)),
          ],
        ),
      ),
    );
  }
}
