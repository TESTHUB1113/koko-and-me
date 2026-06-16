import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/lesson_data.dart';
import '../games/word_catcher_game.dart';
import '../data/dept_progress.dart';
import '../data/user_progress.dart';

// ─── WORD CATCHER SCREEN (LessonType.challenge) ──────────────────────────────
class WordCatcherScreen extends StatefulWidget {
  final Lesson lesson;
  final Department dept;
  const WordCatcherScreen({super.key, required this.lesson, required this.dept});

  @override
  State<WordCatcherScreen> createState() => _WordCatcherScreenState();
}

class _WordCatcherScreenState extends State<WordCatcherScreen> {
  late WordCatcherGame _game;
  late ValueNotifier<String> _definition;
  late ValueNotifier<int>    _lives;
  late ValueNotifier<int>    _score;

  bool _gameOver = false;
  bool _started  = false;

  @override
  void initState() {
    super.initState();

    final raw = lessonVocab[widget.lesson.name] ?? fallbackVocab;
    final vocab = List<Map<String, String>>.from(raw)..shuffle(Random());

    _definition = ValueNotifier('');
    _lives      = ValueNotifier(WordCatcherGame.startingLives);
    _score      = ValueNotifier(0);

    _game = WordCatcherGame(
      vocab:              vocab,
      deptColor:          widget.dept.color,
      definitionNotifier: _definition,
      livesNotifier:      _lives,
      scoreNotifier:      _score,
      onGameOver:         _handleGameOver,
    );
  }

  void _handleGameOver() {
    // Persister le score (max arbitraire = 100 points)
    final score = _score.value.clamp(0, 100);
    DeptProgress.setTestScore(widget.dept.id, score, 100);
    UserProgress.addXp(20 + score ~/ 5);
    if (mounted) setState(() => _gameOver = true);
  }

  @override
  void dispose() {
    _definition.dispose();
    _lives.dispose();
    _score.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dept = widget.dept;

    return Scaffold(
      backgroundColor: const Color(0xFF08051A),
      body: Stack(
        children: [
          // ── Flame canvas
          if (_started)
            Positioned.fill(child: GameWidget(game: _game)),

          // ── Top HUD
          if (_started && !_gameOver)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Back
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 14, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    // Lives
                    ValueListenableBuilder<int>(
                      valueListenable: _lives,
                      builder: (ctx, v, child) => Row(
                        children: List.generate(
                          WordCatcherGame.startingLives,
                          (i) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              i < v ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: i < v ? Colors.pinkAccent : Colors.white24,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Score
                    ValueListenableBuilder<int>(
                      valueListenable: _score,
                      builder: (ctx, v, child) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: dept.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          '⭐ $v / ${WordCatcherGame.totalRounds}',
                          style: TextStyle(
                            fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                            fontSize: 12, color: dept.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Definition banner at bottom
          if (_started && !_gameOver)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [const Color(0xFF08051A), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                child: Column(
                  children: [
                    Text(
                      'FIND THE WORD FOR:',
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w700,
                        fontSize: 10, letterSpacing: 2,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: _definition,
                      builder: (ctx, def, child) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(def),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          decoration: BoxDecoration(
                            color: dept.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                                color: dept.color.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            def,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                              fontSize: 15, color: Colors.white, height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Start screen
          if (!_started)
            _StartScreen(
              dept: dept,
              lesson: widget.lesson,
              onStart: () => setState(() => _started = true),
              onBack: () => Navigator.pop(context),
            ),

          // ── Game over overlay
          if (_gameOver)
            _GameOverOverlay(
              dept: dept,
              score: _score.value,
              onContinue: () => Navigator.pop(context),
              onRetry: () {
                setState(() {
                  _gameOver = false;
                  _started  = false;
                });
                final raw = lessonVocab[widget.lesson.name] ?? fallbackVocab;
                final vocab = List<Map<String, String>>.from(raw)..shuffle(Random());
                _definition.value = '';
                _lives.value = WordCatcherGame.startingLives;
                _score.value = 0;
                _game = WordCatcherGame(
                  vocab:              vocab,
                  deptColor:          dept.color,
                  definitionNotifier: _definition,
                  livesNotifier:      _lives,
                  scoreNotifier:      _score,
                  onGameOver:         _handleGameOver,
                );
                setState(() => _started = true);
              },
            ),
        ],
      ),
    );
  }
}

// ─── START SCREEN ─────────────────────────────────────────────────────────────
class _StartScreen extends StatelessWidget {
  final Department dept;
  final Lesson lesson;
  final VoidCallback onStart;
  final VoidCallback onBack;
  const _StartScreen({
    required this.dept, required this.lesson,
    required this.onStart, required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF08051A),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 14, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Image.asset('assets/images/koko.png', width: 120,
                errorBuilder: (c, e, _) => const Icon(Icons.pets, size: 80, color: Colors.white54)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: dept.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text('Word Catcher Challenge',
                  style: TextStyle(color: dept.color, fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ),
            const SizedBox(height: 14),
            Text(
              lesson.name,
              style: const TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                fontSize: 26, color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Words float up tap the one matching the definition shown at the bottom!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14, color: Colors.white.withValues(alpha: 0.5),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InfoBadge(icon: Icons.favorite_rounded, label: '3 lives'),
                SizedBox(width: 12),
                _InfoBadge(icon: Icons.star_rounded, label: '8 rounds'),
                SizedBox(width: 12),
                _InfoBadge(icon: Icons.rocket_launch_outlined, label: '+20 XP each'),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
              child: GestureDetector(
                onTap: onStart,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [dept.color, KokoColors.purple]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: dept.color.withValues(alpha: 0.35),
                        blurRadius: 20, offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Let\'s Go!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                      fontSize: 17, color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white70),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
}

// ─── GAME OVER OVERLAY ────────────────────────────────────────────────────────
class _GameOverOverlay extends StatelessWidget {
  final Department dept;
  final int score;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  const _GameOverOverlay({
    required this.dept,
    required this.score,
    required this.onContinue,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final xp = score * 20;
    final perfect = score == WordCatcherGame.totalRounds;
    return Container(
      color: const Color(0xCC08051A),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF130D35),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: dept.color.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                score > 0
                    ? 'assets/images/koko_correct.png'
                    : 'assets/images/koko_wrong.png',
                width: 100,
                errorBuilder: (c, e, _) => Icon(
                  score > 0 ? Icons.celebration_rounded : Icons.sentiment_dissatisfied_rounded,
                  size: 60,
                  color: score > 0 ? const Color(0xFF4ECDA0) : const Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                perfect ? 'Perfect!' : score > 4 ? 'Great job!' : 'Keep practising!',
                style: const TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                  fontSize: 22, color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$score / ${WordCatcherGame.totalRounds} caught',
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: dept.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: dept.color.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '+$xp XP earned!',
                  style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                    fontSize: 16, color: dept.color,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onRetry,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Text(
                          'Retry',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                            fontSize: 14, color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onContinue,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [dept.color, KokoColors.purple]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Continue →',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                            fontSize: 14, color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
