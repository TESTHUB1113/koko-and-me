import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/grammar_data.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';

class GrammarLessonScreen extends StatefulWidget {
  final Department dept;
  final int lessonIdx;
  final String lessonName;

  const GrammarLessonScreen({
    super.key,
    required this.dept,
    required this.lessonIdx,
    required this.lessonName,
  });

  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  late final List<GrammarQuestion> _questions;
  int  _cur      = 0;
  int? _picked;   // null = not answered yet
  int  _score    = 0;
  bool _allDone  = false;

  @override
  void initState() {
    super.initState();
    _questions = grammarData[widget.dept.id]?[widget.lessonIdx] ?? [];
  }

  void _pick(int idx) {
    if (_picked != null) return;
    final correct = idx == _questions[_cur].correctIdx;
    setState(() {
      _picked = idx;
      if (correct) _score++;
    });
  }

  void _next() {
    if (_picked == null) return;
    final nextIdx = _cur + 1;
    if (nextIdx >= _questions.length) {
      DeptProgress.markDialogueDone(
          widget.dept.id, LessonCategory.grammar, widget.lessonIdx);
      setState(() => _allDone = true);
    } else {
      setState(() {
        _cur    = nextIdx;
        _picked = null;
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = widget.dept.color;
    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          _bg(c),
          SafeArea(
            child: _allDone ? _buildDone(context, c) : _buildLesson(context, c),
          ),
        ],
      ),
    );
  }

  Widget _bg(Color c) => Stack(children: [
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
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [c.withValues(alpha: 0.15), Colors.transparent],
              ),
            ),
          ),
        ),
      ]);

  Widget _buildLesson(BuildContext context, Color c) {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'No questions available.',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    final q = _questions[_cur];

    const kokoLines = [
      'Which sentence is grammatically correct? Think carefully.',
      'Look for word form errors: noun, verb, or adjective?',
      'Check the verb agreement and article usage.',
      'One of these is how a native speaker would say it.',
    ];
    final kokoText = kokoLines[_cur % kokoLines.length];

    return Column(
      children: [
        // ── Top bar ───────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
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
                color: c.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: c.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Grammar · ${_cur + 1} / ${_questions.length}',
                style: TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                  fontSize: 12, color: c,
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(width: 38),
          ]),
        ),

        // ── Progress bar ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (_cur + 1) / _questions.length,
              minHeight: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(c),
            ),
          ),
        ),

        // ── Scrollable body ───────────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kokoBubble(kokoText),
                const SizedBox(height: 24),

                // ── Question ──────────────────────────────────────────────────
                Text(
                  q.question,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Options ───────────────────────────────────────────────────
                ...List.generate(q.options.length, (i) => _optionCard(q, i, c)),

                // ── Explanation ───────────────────────────────────────────────
                if (_picked != null) ...[
                  const SizedBox(height: 16),
                  _ExplanationBox(text: q.explanation, color: c),
                  const SizedBox(height: 16),
                  _NextBtn(
                    label: _cur + 1 == _questions.length ? 'Finish ✓' : 'Next →',
                    color: c,
                    onTap: _next,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionCard(GrammarQuestion q, int i, Color c) {
    final answered = _picked != null;
    final isCorrect = i == q.correctIdx;
    final isPicked  = _picked == i;

    Color bg, border, textColor;
    if (!answered) {
      bg        = Colors.white.withValues(alpha: 0.04);
      border    = Colors.white.withValues(alpha: 0.1);
      textColor = Colors.white.withValues(alpha: 0.85);
    } else if (isCorrect) {
      bg        = const Color(0xFF4ADE80).withValues(alpha: 0.10);
      border    = const Color(0xFF4ADE80).withValues(alpha: 0.55);
      textColor = const Color(0xFF4ADE80);
    } else if (isPicked) {
      bg        = const Color(0xFFFF5C5C).withValues(alpha: 0.08);
      border    = const Color(0xFFFF5C5C).withValues(alpha: 0.45);
      textColor = const Color(0xFFFF5C5C);
    } else {
      bg        = Colors.white.withValues(alpha: 0.02);
      border    = Colors.white.withValues(alpha: 0.05);
      textColor = Colors.white.withValues(alpha: 0.3);
    }

    final labels = ['A', 'B', 'C', 'D'];

    return GestureDetector(
      onTap: answered ? null : () => _pick(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: answered && isCorrect
                    ? const Color(0xFF4ADE80).withValues(alpha: 0.2)
                    : answered && isPicked
                        ? const Color(0xFFFF5C5C).withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.06),
              ),
              child: answered && (isCorrect || isPicked)
                  ? Icon(
                      isCorrect
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      size: 14,
                      color: isCorrect
                          ? const Color(0xFF4ADE80)
                          : const Color(0xFFFF5C5C),
                    )
                  : Center(
                      child: Text(
                        labels[i],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                q.options[i],
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 13.5,
                  color: textColor,
                  height: 1.55,
                  fontWeight: answered && isCorrect
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kokoBubble(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/koko.png', width: 44, height: 44,
          errorBuilder: (ctx, _, _) =>
              const Icon(Icons.pets, size: 32, color: Colors.white54),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Nunito', fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
                height: 1.55,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDone(BuildContext context, Color c) {
    final total = _questions.length;
    final pct   = total > 0 ? (_score / total * 100).round() : 0;
    final msg   = _score == total
        ? 'Perfect score! You know these rules cold.'
        : _score >= total * 0.75
            ? 'Strong result, but a couple of rules to revisit.'
            : 'Good effort. Review the explanations and try again.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84, height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c.withValues(alpha: 0.12),
                border: Border.all(color: c.withValues(alpha: 0.4), width: 2),
              ),
              child: Icon(Icons.check_rounded, size: 38, color: c),
            ),
            const SizedBox(height: 20),
            Text(
              '$_score / $total correct ($pct%)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                fontSize: 22, color: c,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito', fontSize: 13,
                color: Colors.white.withValues(alpha: 0.5),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                decoration: BoxDecoration(
                  color: c,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  '← Back to lessons',
                  style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                    fontSize: 14, color: Colors.white,
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

// ── Explanation card ───────────────────────────────────────────────────────────

class _ExplanationBox extends StatelessWidget {
  final String text;
  final Color color;
  const _ExplanationBox({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_rounded, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12.5,
                color: Colors.white.withValues(alpha: 0.72),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Next button ────────────────────────────────────────────────────────────────

class _NextBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _NextBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
              fontSize: 15, color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
