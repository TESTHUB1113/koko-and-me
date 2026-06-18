import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/writing_data.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';

class WritingLessonScreen extends StatefulWidget {
  final Department dept;
  final int lessonIdx;
  final String lessonName;

  const WritingLessonScreen({
    super.key,
    required this.dept,
    required this.lessonIdx,
    required this.lessonName,
  });

  @override
  State<WritingLessonScreen> createState() => _WritingLessonScreenState();
}

class _WritingLessonScreenState extends State<WritingLessonScreen> {
  late final List<WritingExercise> _exercises;
  int  _cur       = 0;
  bool _submitted = false;
  bool _correct   = false;
  bool _allDone   = false;

  late final TextEditingController _ctrl;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _exercises = writingData[widget.dept.id]?[widget.lessonIdx] ?? [];
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool _wordFound(String input) {
    final lower = input.toLowerCase();
    final word  = _exercises[_cur].word.toLowerCase();
    return lower.contains(word);
  }

  void _submit() {
    if (_submitted) return;
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    final found = _wordFound(text);
    setState(() {
      _submitted = true;
      _correct   = found;
    });
    _focusNode.unfocus();
  }

  void _next() {
    if (!_submitted) return;
    final nextIdx = _cur + 1;
    if (nextIdx >= _exercises.length) {
      DeptProgress.markDialogueDone(
          widget.dept.id, LessonCategory.writing, widget.lessonIdx);
      setState(() => _allDone = true);
    } else {
      setState(() {
        _cur       = nextIdx;
        _submitted = false;
        _correct   = false;
        _ctrl.clear();
      });
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = widget.dept.color;
    return Scaffold(
      backgroundColor: KokoColors.night,
      resizeToAvoidBottomInset: true,
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
    if (_exercises.isEmpty) {
      return Center(
        child: Text(
          'No exercises available.',
          style: TextStyle(
            fontFamily: 'Nunito', color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    final ex = _exercises[_cur];

    const kokoLines = [
      "Write a sentence using the word exactly as it appears.",
      "Use it naturally, like you'd say it in a real meeting.",
      "Context matters. Show me you know how to use this word.",
      "One sentence is enough. Make it count.",
      "Think of a real situation where you'd use this word.",
      "Business writing is about clarity. Keep it clean.",
    ];
    final kokoText = kokoLines[_cur % kokoLines.length];

    return Column(
      children: [
        // ── Top bar ──────────────────────────────────────────────────────────
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
                'Writing · ${_cur + 1} / ${_exercises.length}',
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

        // ── Progress bar ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (_cur + 1) / _exercises.length,
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

                // ── Word chip ─────────────────────────────────────────────────
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: c.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note_rounded, size: 18, color: c),
                      const SizedBox(width: 8),
                      Text(
                        ex.word,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: c,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ── Prompt ─────────────────────────────────────────────────────
                Text(
                  ex.prompt,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.75),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),

                // ── Text field ─────────────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _submitted
                          ? _correct
                              ? const Color(0xFF4ADE80).withValues(alpha: 0.55)
                              : const Color(0xFFFF5C5C).withValues(alpha: 0.55)
                          : _focusNode.hasFocus
                              ? c.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _ctrl,
                    focusNode: _focusNode,
                    enabled: !_submitted,
                    maxLines: 4,
                    minLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Write your sentence here using "${ex.word}"…',
                      hintStyle: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Submit / feedback ─────────────────────────────────────────
                if (!_submitted)
                  _ActionBtn(
                    label: 'Submit',
                    enabled: _ctrl.text.trim().isNotEmpty,
                    color: c,
                    onTap: _submit,
                  )
                else ...[
                  _FeedbackBox(
                    correct: _correct,
                    word: ex.word,
                    example: ex.example,
                    color: c,
                  ),
                  const SizedBox(height: 16),
                  _ActionBtn(
                    label: _cur + 1 == _exercises.length
                        ? 'Complete ✓'
                        : 'Next →',
                    enabled: true,
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
            const Text(
              'Writing done!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                fontSize: 22, color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You wrote ${_exercises.length} sentences. The more you use these words, the more naturally they will come.',
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

// ── Feedback card ──────────────────────────────────────────────────────────────

class _FeedbackBox extends StatelessWidget {
  final bool correct;
  final String word;
  final String example;
  final Color color;

  const _FeedbackBox({
    required this.correct,
    required this.word,
    required this.example,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4ADE80);
    const red   = Color(0xFFFF5C5C);
    final accent = correct ? green : red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(
              correct
                  ? Icons.check_circle_rounded
                  : Icons.info_outline_rounded,
              size: 18,
              color: accent,
            ),
            const SizedBox(width: 8),
            Text(
              correct
                  ? 'Nice work! You used "$word".'
                  : 'Your sentence didn\'t include "$word".',
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 13, color: accent,
              ),
            ),
          ]),
          const SizedBox(height: 12),
          Text(
            'Koko\'s example:',
            style: TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w700,
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.38),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '"$example"',
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action button ──────────────────────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: enabled ? color : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: enabled ? Colors.transparent : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
              fontSize: 15,
              color:
                  enabled ? Colors.white : Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }
}
