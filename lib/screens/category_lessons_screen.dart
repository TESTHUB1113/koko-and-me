import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';
import 'dialogue_lesson_screen.dart';
import 'speaking_lesson_screen.dart';
import 'grammar_lesson_screen.dart';
import 'writing_lesson_screen.dart';

class CategoryLessonsScreen extends StatefulWidget {
  final Department dept;
  final LessonCategory category;

  const CategoryLessonsScreen({
    super.key,
    required this.dept,
    required this.category,
  });

  @override
  State<CategoryLessonsScreen> createState() => _CategoryLessonsScreenState();
}

class _CategoryLessonsScreenState extends State<CategoryLessonsScreen> {
  Department get dept => widget.dept;
  LessonCategory get cat => widget.category;

  List<CategoryDialogue> get _lessons =>
      dialogueData[dept.id]?[cat] ?? [];

  bool _isDone(int idx) =>
      DeptProgress.isDialogueDone(dept.id, cat, idx);

  bool _isAvailable(int idx) {
    final lessons = _lessons;
    if (lessons.isEmpty) return false;
    if (cat == LessonCategory.vocabulary) {
      // L0 always open; Ln requires L(n-1) vocab done
      return idx == 0 || DeptProgress.isDialogueDone(dept.id, LessonCategory.vocabulary, idx - 1);
    }
    // Grammar / Writing / Speaking: sequential within the category.
    // The category card itself is already gated on vocab lesson 1 in DeptEntryScreen.
    return idx == 0 || DeptProgress.isDialogueDone(dept.id, cat, idx - 1);
  }

  @override
  Widget build(BuildContext context) {
    final c = dept.color;
    final lessons = _lessons;

    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          _bg(c),
          SafeArea(
            child: Column(
              children: [
                _topBar(context, c),
                Expanded(
                  child: lessons.isEmpty
                      ? _comingSoon(c)
                      : _lessonList(context, lessons, c),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bg(Color c) => Stack(
    children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF08051A), Color(0xFF0D0A2A), Color(0xFF130D35)],
          ),
        ),
      ),
      Positioned(
        top: -40, left: 0, right: 0,
        child: Container(
          height: 260,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter, radius: 1.2,
              colors: [c.withValues(alpha: 0.15), Colors.transparent],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _topBar(BuildContext context, Color c) {
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
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: c.withValues(alpha: 0.3)),
            ),
            child: Text(
              cat.label,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 12, color: c,
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _lessonList(BuildContext context, List<CategoryDialogue> lessons, Color c) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        _kokoBubble(cat.kokoIntro),
        const SizedBox(height: 24),
        Text(
          'Lessons',
          style: TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.w900,
            fontSize: 13, color: Colors.white.withValues(alpha: 0.45),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),
        ...lessons.asMap().entries.map((e) => _lessonRow(context, e.key, e.value, c)),
      ],
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

  Widget _lessonRow(BuildContext context, int idx, CategoryDialogue lesson, Color c) {
    final done      = _isDone(idx);
    final available = _isAvailable(idx);
    final locked    = !available && !done;

    final rowColor = done ? c : available ? Colors.white : Colors.white;
    final opacity  = locked ? 0.35 : 1.0;

    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: (available || done)
            ? () async {
                await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (ctx, anim, sec) {
                      if (cat == LessonCategory.speaking) {
                        return SpeakingLessonScreen(
                          dept: dept,
                          lessonIdx: idx,
                          lessonName: _lessons[idx].name,
                        );
                      }
                      if (cat == LessonCategory.writing) {
                        return WritingLessonScreen(
                          dept: dept,
                          lessonIdx: idx,
                          lessonName: _lessons[idx].name,
                        );
                      }
                      if (cat == LessonCategory.grammar) {
                        return GrammarLessonScreen(
                          dept: dept,
                          lessonIdx: idx,
                          lessonName: _lessons[idx].name,
                        );
                      }
                      return DialogueLessonScreen(
                        dept: dept,
                        category: cat,
                        lessonIdx: idx,
                      );
                    },
                    transitionsBuilder: (ctx, anim, sec, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                );
                if (mounted) setState(() {});
              }
            : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: done
                ? c.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: done
                  ? c.withValues(alpha: 0.35)
                  : Colors.white.withValues(alpha: locked ? 0.07 : 0.12),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Index badge
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: done
                      ? c.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: done
                    ? Icon(Icons.check_rounded, size: 18, color: c)
                    : locked
                        ? Icon(Icons.lock_outline_rounded,
                            size: 16, color: Colors.white.withValues(alpha: 0.4))
                        : Center(
                            child: Text(
                              '${idx + 1}',
                              style: const TextStyle(
                                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                                fontSize: 14, color: Colors.white,
                              ),
                            ),
                          ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.name,
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: done ? rowColor : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _rowSubtitle(idx, done, locked),
                      style: TextStyle(
                        fontFamily: 'Nunito', fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.38),
                      ),
                    ),
                  ],
                ),
              ),
              if (!locked)
                Icon(
                  done ? Icons.replay_rounded : Icons.arrow_forward_ios_rounded,
                  size: done ? 16 : 13,
                  color: done ? c.withValues(alpha: 0.7) : Colors.white.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _rowSubtitle(int idx, bool done, bool locked) {
    if (done) return 'Completed';
    if (locked) {
      if (cat == LessonCategory.vocabulary) {
        return 'Complete lesson $idx first';
      }
      return 'Complete lesson $idx first';
    }
    final count = _lessons[idx].vocab.length;
    if (cat == LessonCategory.vocabulary) return '$count words to learn';
    if (cat == LessonCategory.speaking)   return '$count words to pronounce';
    if (cat == LessonCategory.writing)    return '$count sentences to write';
    if (cat == LessonCategory.grammar)    return '4 grammar questions';
    return '$count words to practise';
  }

  Widget _comingSoon(Color c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_clock_rounded, size: 48, color: c.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            const Text(
              'Coming soon',
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                fontSize: 20, color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'These lessons are being prepared.',
              style: TextStyle(
                fontFamily: 'Nunito', fontSize: 13,
                color: Colors.white.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
