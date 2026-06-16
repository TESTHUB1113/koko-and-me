import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/lesson_data.dart';
import 'word_match_screen.dart';
import 'game_quiz_screen.dart';
import 'word_catcher_screen.dart';
import '../data/dept_progress.dart';

// ─── LESSON SCREEN ────────────────────────────────────────────────────────────
// Visual flashcard scene Koko walks you through the vocabulary before the test.
// Flow: Department Screen → LessonScreen → game screen (WordMatch / Quiz / WordCatcher)
class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Department dept;

  const LessonScreen({super.key, required this.lesson, required this.dept});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  late final List<Map<String, String>> _vocab;
  int _current = 0;

  late AnimationController _cardCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Koko dialogue lines rotate through them
  static const List<String> _kokoLines = [
    "Let me walk you through the key words. No rush one at a time!",
    "People use this one a lot in meetings. Good to know!",
    "You'll hear this one on your first week. Trust me.",
    "Classic workplace word. Once you know it, you'll spot it everywhere.",
    "Almost there! These words open doors in the room.",
    "Last one! Once you've got this, you're ready. You've got this!",
  ];

  @override
  void initState() {
    super.initState();
    final raw = lessonVocab[widget.lesson.name] ?? fallbackVocab;
    _vocab = List<Map<String, String>>.from(raw);

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut),
    );
    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (_current < _vocab.length - 1) {
      _cardCtrl.reverse().then((_) {
        if (!mounted) return;
        setState(() => _current++);
        _cardCtrl.forward();
      });
    } else {
      _goToTest();
    }
  }

  void _goToTest() {
    final lesson = widget.lesson;
    final dept   = widget.dept;
    // L'utilisateur a vu toutes les cartes → leçon marquée comme vue
    DeptProgress.markLessonDone(dept.id);
    Widget screen;
    switch (lesson.type) {
      case LessonType.lesson:
        screen = WordMatchScreen(lesson: lesson, dept: dept);
        break;
      case LessonType.quiz:
        screen = GameQuizScreen(lesson: lesson, dept: dept);
        break;
      case LessonType.challenge:
        screen = WordCatcherScreen(lesson: lesson, dept: dept);
        break;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  String get _kokoLine {
    if (_current == 0) return _kokoLines[0];
    if (_current == _vocab.length - 1) return _kokoLines[5];
    final idx = (_current % (_kokoLines.length - 2)) + 1;
    return _kokoLines[idx];
  }

  @override
  Widget build(BuildContext context) {
    final dept = widget.dept;
    final vocab = _vocab[_current];
    final isLast = _current == _vocab.length - 1;

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
              height: 240,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    dept.color.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
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
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      // Dept badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: dept.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                              color: dept.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(dept.icon, size: 13, color: dept.color),
                            const SizedBox(width: 6),
                            Text(
                              'Lesson',
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
                      // Skip to test
                      GestureDetector(
                        onTap: _goToTest,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Text(
                            'Skip →',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Progress bar (segmented)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: List.generate(_vocab.length, (i) {
                      final done = i < _current;
                      final active = i == _current;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: done
                                ? dept.color
                                : active
                                    ? dept.color.withValues(alpha: 0.55)
                                    : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Lesson title + counter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.lesson.name,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${_current + 1} / ${_vocab.length}',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ── Koko speech bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/koko.png',
                        width: 42, height: 42,
                        errorBuilder: (c, e, _) =>
                            const Icon(Icons.pets, size: 30, color: Colors.white54),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(14),
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _kokoLine,
                              key: ValueKey(_current),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.6),
                                height: 1.55,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ── Main vocabulary card
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedBuilder(
                      animation: _cardCtrl,
                      builder: (ctx, child) => FadeTransition(
                        opacity: _fadeAnim,
                        child: ScaleTransition(
                          scale: _scaleAnim,
                          child: child,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              dept.color.withValues(alpha: 0.14),
                              dept.color.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: dept.color.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: dept.color.withValues(alpha: 0.1),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Word
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                vocab['word']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 38,
                                  color: dept.color,
                                  letterSpacing: -0.5,
                                  height: 1.1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Divider
                            Container(
                              width: 44,
                              height: 2,
                              decoration: BoxDecoration(
                                color: dept.color.withValues(alpha: 0.45),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Definition
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                vocab['def']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  height: 1.55,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Dept badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 7),
                              decoration: BoxDecoration(
                                color: dept.color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(99),
                                border: Border.all(
                                    color: dept.color.withValues(alpha: 0.22)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(dept.icon, size: 12, color: dept.color.withValues(alpha: 0.75)),
                                  const SizedBox(width: 5),
                                  Text(
                                    dept.label,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: dept.color.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── CTA button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: GestureDetector(
                      onTap: _nextCard,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [dept.color, KokoColors.purple],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: dept.color.withValues(alpha: 0.32),
                              blurRadius: 18,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isLast ? '🎯  Start the Test!' : 'Got it  →',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
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
