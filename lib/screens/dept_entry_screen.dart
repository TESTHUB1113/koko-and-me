import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';
import '../data/grammar_data.dart';
import '../data/writing_data.dart';
import 'category_lessons_screen.dart';
import 'management_test_screen.dart';

class DeptEntryScreen extends StatefulWidget {
  final Department dept;

  const DeptEntryScreen({super.key, required this.dept});

  @override
  State<DeptEntryScreen> createState() => _DeptEntryScreenState();
}

class _DeptEntryScreenState extends State<DeptEntryScreen> {
  Department get dept => widget.dept;

  bool _hasData(LessonCategory cat) {
    switch (cat) {
      case LessonCategory.vocabulary:
        return dialogueData[dept.id]?.containsKey(cat) ?? false;
      case LessonCategory.speaking:
        // Speaking pulls vocab from the vocabulary lessons
        return dialogueData[dept.id]?.containsKey(LessonCategory.vocabulary) ?? false;
      case LessonCategory.writing:
        return writingData.containsKey(dept.id);
      case LessonCategory.grammar:
        return grammarData.containsKey(dept.id);
    }
  }

  bool _isAvailable(LessonCategory cat) {
    if (!_hasData(cat)) return false;
    if (cat == LessonCategory.vocabulary) return true;
    // Grammar / Writing / Speaking unlock once lesson 0 of vocabulary is done
    return DeptProgress.isDialogueDone(dept.id, LessonCategory.vocabulary, 0);
  }

  @override
  Widget build(BuildContext context) {
    final intro = deptKokoIntro[dept.id] ?? "Welcome! Pick a category to get started.";

    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08051A), Color(0xFF0D0A2A), Color(0xFF130D35)],
              ),
            ),
          ),
          // Dept colour glow
          Positioned(
            top: -40, left: 0, right: 0,
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter, radius: 1.2,
                  colors: [dept.color.withValues(alpha: 0.18), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _kokoBubble(intro),
                        const SizedBox(height: 28),
                        Text(
                          'Choose a lesson',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.45),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _categoryGrid(context),
                        const SizedBox(height: 24),
                        _testButton(context),
                        const SizedBox(height: 24),
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

  Widget _topBar(BuildContext context) {
    return Padding(
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
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
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
                    fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                    fontSize: 12, color: dept.color,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _kokoBubble(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/koko.png', width: 48, height: 48,
          errorBuilder: (ctx, err, st) => const Icon(Icons.pets, size: 36, color: Colors.white54),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Nunito', fontSize: 13,
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryGrid(BuildContext context) {
    const cats = LessonCategory.values;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cats.map((cat) => _catCard(context, cat)).toList(),
    );
  }

  Widget _catCard(BuildContext context, LessonCategory cat) {
    final available = _isAvailable(cat);

    final icons = {
      LessonCategory.vocabulary: Icons.menu_book_rounded,
      LessonCategory.writing:    Icons.edit_note_rounded,
      LessonCategory.grammar:    Icons.rule_rounded,
      LessonCategory.speaking:   Icons.mic_rounded,
    };

    final icon = icons[cat]!;
    final c    = available ? dept.color : Colors.white;
    final ca   = available ? 1.0 : 0.3;

    return GestureDetector(
      onTap: available
          ? () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (ctx, anim, sec) =>
                      CategoryLessonsScreen(dept: dept, category: cat),
                  transitionsBuilder: (ctx, anim, sec, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
              if (mounted) setState(() {});
            }
          : null,
      child: Opacity(
        opacity: ca,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.withValues(alpha: available ? 0.07 : 0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: c.withValues(alpha: available ? 0.25 : 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(icon, size: 20, color: c),
                  ),
                  const Spacer(),
                  if (!available)
                    Icon(Icons.lock_outline_rounded,
                        size: 14, color: Colors.white.withValues(alpha: 0.3)),
                ],
              ),
              const Spacer(),
              Text(
                cat.label,
                style: TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                  fontSize: 15, color: available ? Colors.white : Colors.white60,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                available
                    ? cat.subtitle
                    : _hasData(cat)
                        ? 'Complete Vocabulary first'
                        : 'Coming soon',
                style: TextStyle(
                  fontFamily: 'Nunito', fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.38),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _testButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, sec) => ManagementTestScreen(deptId: dept.id),
          transitionsBuilder: (ctx, anim, sec, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gps_fixed_rounded, size: 15, color: Colors.white.withValues(alpha: 0.55)),
            const SizedBox(width: 8),
            Text(
              'Test your skills',
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 14, color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 11, color: Colors.white.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }
}
