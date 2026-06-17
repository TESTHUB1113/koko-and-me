import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';

class SpeakingLessonScreen extends StatefulWidget {
  final Department dept;
  final int lessonIdx;
  final String lessonName;

  const SpeakingLessonScreen({
    super.key,
    required this.dept,
    required this.lessonIdx,
    required this.lessonName,
  });

  @override
  State<SpeakingLessonScreen> createState() => _SpeakingLessonScreenState();
}

class _SpeakingLessonScreenState extends State<SpeakingLessonScreen>
    with TickerProviderStateMixin {
  late final List<MapEntry<String, String>> _words;
  int  _cur       = 0;
  bool _revealed  = false;
  bool _practiced = false;
  bool _allDone   = false;

  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    // Pull vocab from the matching Vocabulary lesson (same index)
    final vocab = dialogueData[widget.dept.id]
            ?[LessonCategory.vocabulary]
            ?[widget.lessonIdx]
            .vocab ??
        {};
    _words = vocab.entries.toList();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _tapSpeak() {
    setState(() => _revealed = true);
    _waveCtrl.repeat(reverse: true);
  }

  void _tapMic() {
    if (!_revealed) return;
    setState(() => _practiced = true);
    _waveCtrl.stop();
    _waveCtrl.reset();
  }

  void _next() {
    if (!_practiced) return;
    if (_cur + 1 >= _words.length) {
      DeptProgress.markDialogueDone(
          widget.dept.id, LessonCategory.speaking, widget.lessonIdx);
      setState(() => _allDone = true);
    } else {
      setState(() {
        _cur++;
        _revealed  = false;
        _practiced = false;
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
    final word = _words[_cur].key;
    final def  = _words[_cur].value;

    const kokoLines = [
      "Say this word out loud. That's how it sticks.",
      "Tap Listen, then repeat it clearly.",
      "Say it like you mean it. Confidence is half the battle.",
      "One word at a time. You've got this.",
      "Hear it, say it, own it.",
      "Out loud, not just in your head.",
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
                'Speaking · ${_cur + 1} / ${_words.length}',
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
              value: (_cur + 1) / _words.length,
              minHeight: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(c),
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              children: [
                // Koko bubble
                _kokoBubble(kokoText),
                const SizedBox(height: 28),

                // ── Word card ─────────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: _revealed
                          ? c.withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.08),
                      width: 1.5,
                    ),
                  ),
                  child: Column(children: [
                    Text(
                      word,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 34,
                        color: _revealed ? c : Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 16),
                      _WaveBars(controller: _waveCtrl, color: c),
                      const SizedBox(height: 16),
                      Text(
                        def,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),
                    ] else
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Tap Listen to reveal the word',
                          style: TextStyle(
                            fontFamily: 'Nunito', fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.28),
                          ),
                        ),
                      ),
                  ]),
                ),

                const SizedBox(height: 32),

                // ── Speaker + Mic buttons ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _RoundButton(
                      icon: Icons.volume_up_rounded,
                      label: 'Listen',
                      state: _revealed ? _BtnState.done : _BtnState.idle,
                      color: c,
                      onTap: _tapSpeak,
                    ),
                    const SizedBox(width: 32),
                    _RoundButton(
                      icon: Icons.mic_rounded,
                      label: 'Say it',
                      state: _practiced
                          ? _BtnState.done
                          : _revealed
                              ? _BtnState.active
                              : _BtnState.idle,
                      color: c,
                      onTap: _tapMic,
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // ── Next / Complete ───────────────────────────────────────
                GestureDetector(
                  onTap: _practiced ? _next : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: _practiced
                          ? c
                          : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _practiced
                            ? Colors.transparent
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _cur + 1 == _words.length ? 'Complete ✓' : 'Next →',
                        style: TextStyle(
                          fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: _practiced
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
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
                topLeft: Radius.circular(4), topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14), bottomRight: Radius.circular(14),
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
              'Pronunciation done!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                fontSize: 22, color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You practised ${_words.length} words. Keep saying them out loud. That\'s how they become yours.',
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
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
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

// ── Animated sound-wave bars ───────────────────────────────────────────────────

class _WaveBars extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  const _WaveBars({required this.controller, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(9, (i) {
            final phase = (controller.value + i / 9) % 1.0;
            final h = 5.0 + 20.0 * sin(phase * pi).abs();
            return Container(
              width: 3, height: h,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Round action button ────────────────────────────────────────────────────────

enum _BtnState { idle, active, done }

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final _BtnState state;
  final Color color;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.label,
    required this.state,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg, border, iconColor;
    switch (state) {
      case _BtnState.done:
        bg = color.withValues(alpha: 0.18);
        border = color;
        iconColor = color;
      case _BtnState.active:
        bg = color.withValues(alpha: 0.10);
        border = color.withValues(alpha: 0.55);
        iconColor = color;
      case _BtnState.idle:
        bg = Colors.white.withValues(alpha: 0.04);
        border = Colors.white.withValues(alpha: 0.12);
        iconColor = Colors.white.withValues(alpha: 0.25);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 76, height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bg,
              border: Border.all(color: border, width: 1.8),
            ),
            child: Icon(
              state == _BtnState.done ? Icons.check_rounded : icon,
              size: 30,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Nunito', fontSize: 11,
              color: state == _BtnState.done
                  ? color
                  : Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
