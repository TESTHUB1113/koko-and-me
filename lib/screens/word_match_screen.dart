import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/lesson_data.dart';
import '../data/dept_progress.dart';
import '../data/user_progress.dart';

// ─── WORD MATCH GAME (LessonType.lesson) ─────────────────────────────────────
// Tap a word on the left, then tap its matching definition on the right.
class WordMatchScreen extends StatefulWidget {
  final Lesson lesson;
  final Department dept;
  const WordMatchScreen({super.key, required this.lesson, required this.dept});

  @override
  State<WordMatchScreen> createState() => _WordMatchScreenState();
}

class _WordMatchScreenState extends State<WordMatchScreen>
    with TickerProviderStateMixin {

  late List<Map<String, String>> _vocab;  // [{word, def}]
  late List<String> _words;               // shuffled word column
  late List<String> _defs;                // shuffled def column

  int? _selectedWordIdx;
  final Set<String> _matched = {};        // matched word strings
  int  _errorCount = 0;                   // nombre de mauvaises tentatives
  int? _flashWordWrong;
  int? _flashDefWrong;
  bool _showResult = false;

  late AnimationController _resultCtrl;

  @override
  void initState() {
    super.initState();
    final raw = lessonVocab[widget.lesson.name] ?? fallbackVocab;
    _vocab = List<Map<String, String>>.from(raw)..shuffle(Random());
    _vocab = _vocab.take(4).toList();
    _words = _vocab.map((p) => p['word']!).toList()..shuffle(Random());
    _defs  = _vocab.map((p) => p['def']!).toList()..shuffle(Random());

    _resultCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _resultCtrl.dispose();
    super.dispose();
  }

  void _onWordTap(int idx) {
    if (_matched.contains(_words[idx])) return;
    setState(() => _selectedWordIdx = idx);
  }

  void _onDefTap(int idx) {
    if (_selectedWordIdx == null) return;
    final word = _words[_selectedWordIdx!];
    final def  = _defs[idx];
    final pair = _vocab.firstWhere(
      (p) => p['word'] == word,
      orElse: () => {},
    );

    if (pair['def'] == def) {
      setState(() {
        _matched.add(word);
        _selectedWordIdx = null;
      });
      if (_matched.length == _vocab.length) {
        // Score : nombre de paires réussies moins les erreurs (min 1)
        final score    = (_vocab.length - (_errorCount ~/ 2)).clamp(1, _vocab.length);
        final xp       = (40 - _errorCount * 5).clamp(10, 40);
        DeptProgress.setTestScore(widget.dept.id, score, _vocab.length);
        UserProgress.addXp(xp);
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            setState(() => _showResult = true);
            _resultCtrl.forward();
          }
        });
      }
    } else {
      final sw = _selectedWordIdx!;
      setState(() {
        _errorCount++;
        _flashWordWrong = sw;
        _flashDefWrong  = idx;
        _selectedWordIdx = null;
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) setState(() { _flashWordWrong = null; _flashDefWrong = null; });
      });
    }
  }

  // Colour state for a word chip
  _ChipState _wordState(int idx) {
    final w = _words[idx];
    if (_matched.contains(w))       return _ChipState.matched;
    if (_flashWordWrong == idx)     return _ChipState.wrong;
    if (_selectedWordIdx == idx)    return _ChipState.selected;
    return _ChipState.idle;
  }

  // Colour state for a def chip
  _ChipState _defState(int idx) {
    final d = _defs[idx];
    if (_matched.any((w) {
      final p = _vocab.firstWhere((p) => p['word'] == w, orElse: () => {});
      return p['def'] == d;
    })) {
      return _ChipState.matched;
    }
    if (_flashDefWrong == idx) { return _ChipState.wrong; }
    return _ChipState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final dept = widget.dept;

    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08051A), Color(0xFF0D0A2A)],
              ),
            ),
          ),
          // Dept glow
          Positioned(
            top: -60, left: 0, right: 0,
            child: Container(height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter, radius: 1.2,
                  colors: [dept.color.withValues(alpha: 0.15), Colors.transparent],
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
                      Column(
                        children: [
                          Text(
                            widget.lesson.name,
                            style: const TextStyle(
                              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                              fontSize: 15, color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: dept.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              '🃏 Word Match',
                              style: TextStyle(fontSize: 10, color: dept.color,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Progress indicator
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: dept.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${_matched.length}/${_vocab.length}',
                            style: TextStyle(
                              fontSize: 11, color: dept.color,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // ── Instruction
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Image.asset('assets/images/koko.png', width: 32,
                          errorBuilder: (c, e, _) => const Text('🐨')),
                      const SizedBox(width: 10),
                      Text(
                        'Tap a word, then its definition!',
                        style: TextStyle(
                          fontSize: 13, color: Colors.white.withValues(alpha: 0.55),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Match grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(4, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            // Word chip
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onWordTap(i),
                                child: _MatchChip(
                                  label: _words[i],
                                  state: _wordState(i),
                                  color: dept.color,
                                  isWord: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Connector dot
                            Column(
                              children: [
                                Container(
                                  width: 8, height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _matched.contains(_words[i])
                                        ? dept.color
                                        : Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            // Definition chip (show in same row order as words for UX)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onDefTap(i),
                                child: _MatchChip(
                                  label: _defs[i],
                                  state: _defState(i),
                                  color: dept.color,
                                  isWord: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ),
                ),

                // ── Progress dots
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _matched.length
                            ? dept.color
                            : Colors.white.withValues(alpha: 0.15),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),

          // ── Result overlay
          if (_showResult)
            _ResultOverlay(
              dept: dept,
              score: _matched.length,
              total: _vocab.length,
              controller: _resultCtrl,
              onContinue: () => Navigator.pop(context),
            ),
        ],
      ),
    );
  }
}

// ─── CHIP STATES ─────────────────────────────────────────────────────────────
enum _ChipState { idle, selected, matched, wrong }

class _MatchChip extends StatelessWidget {
  final String label;
  final _ChipState state;
  final Color color;
  final bool isWord;

  const _MatchChip({
    required this.label,
    required this.state,
    required this.color,
    required this.isWord,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, border, textColor;
    switch (state) {
      case _ChipState.selected:
        bg = color.withValues(alpha: 0.25);
        border = color;
        textColor = Colors.white;
        break;
      case _ChipState.matched:
        bg = color.withValues(alpha: 0.15);
        border = color.withValues(alpha: 0.6);
        textColor = color;
        break;
      case _ChipState.wrong:
        bg = Colors.red.withValues(alpha: 0.15);
        border = Colors.red.withValues(alpha: 0.6);
        textColor = Colors.red.shade300;
        break;
      case _ChipState.idle:
        bg = Colors.white.withValues(alpha: 0.04);
        border = Colors.white.withValues(alpha: 0.12);
        textColor = Colors.white.withValues(alpha: 0.85);
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: state == _ChipState.selected ? 1.8 : 1),
      ),
      child: Row(
        children: [
          if (state == _ChipState.matched)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(Icons.check_circle_rounded, size: 14, color: color),
            ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: isWord ? 13 : 12,
                color: textColor,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── RESULT OVERLAY ──────────────────────────────────────────────────────────
class _ResultOverlay extends StatelessWidget {
  final Department dept;
  final int score;
  final int total;
  final AnimationController controller;
  final VoidCallback onContinue;

  const _ResultOverlay({
    required this.dept,
    required this.score,
    required this.total,
    required this.controller,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final xp = score * 20;
    return FadeTransition(
      opacity: controller,
      child: Container(
        color: const Color(0xCC0B0820),
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
                Image.asset('assets/images/koko_correct.png', width: 100,
                    errorBuilder: (c, e, _) => const Text('🎉', style: TextStyle(fontSize: 60))),
                const SizedBox(height: 16),
                Text(
                  score == total ? 'Perfect Match! 🎉' : 'Well done! 🌟',
                  style: const TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                    fontSize: 22, color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score / $total pairs matched',
                  style: TextStyle(
                    fontSize: 14, color: Colors.white.withValues(alpha: 0.6),
                  ),
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
                GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [dept.color, KokoColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Continue →',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                        fontSize: 16, color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
