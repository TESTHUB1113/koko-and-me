import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/exercise_data.dart';
import '../data/dept_progress.dart';
import 'management_test_screen.dart';

class LessonExerciseScreen extends StatefulWidget {
  final Department dept;
  const LessonExerciseScreen({super.key, required this.dept});

  @override
  State<LessonExerciseScreen> createState() => _LessonExerciseScreenState();
}

class _LessonExerciseScreenState extends State<LessonExerciseScreen>
    with TickerProviderStateMixin {
  late final List<Exo> _exos;
  int _idx = 0;
  int? _pick;
  bool _answered = false;

  late final AnimationController _panelCtrl;
  late final Animation<Offset> _panelSlide;
  late final AnimationController _cardCtrl;
  late final Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _exos = List<Exo>.from(deptExercises[widget.dept.id] ?? []);

    _panelCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _panelCtrl, curve: Curves.easeOutCubic));

    _cardCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _panelCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  Exo get _exo => _exos[_idx];
  bool get _isCorrect => _pick == _exo.correct;
  bool get _isLast => _idx == _exos.length - 1;

  void _select(int i) {
    if (_answered) return;
    setState(() {
      _pick = i;
      _answered = true;
    });
    _panelCtrl.forward();
  }

  void _next() {
    _panelCtrl.reset();
    _cardCtrl.reset();
    if (!_isLast) {
      setState(() {
        _idx++;
        _pick = null;
        _answered = false;
      });
      _cardCtrl.forward();
    } else {
      DeptProgress.markLessonDone(widget.dept.id);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, _) => ManagementTestScreen(deptId: widget.dept.id),
          transitionsBuilder: (ctx, anim, _, child) =>
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              ),
          transitionDuration: const Duration(milliseconds: 340),
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_exos.isEmpty) {
      return Scaffold(
        backgroundColor: KokoColors.night,
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: _buildExercise(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildOptions(),
                const SizedBox(height: 190),
              ],
            ),
          ),
          if (_answered)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SlideTransition(
                position: _panelSlide,
                child: _buildFeedbackPanel(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
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
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [widget.dept.color.withValues(alpha: 0.16), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final dept = widget.dept;
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
              child: const Icon(Icons.close_rounded, size: 18, color: Colors.white70),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (_idx + 1) / _exos.length,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(dept.color),
                minHeight: 9,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: dept.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: dept.color.withValues(alpha: 0.28)),
            ),
            child: Text(
              '${_idx + 1} / ${_exos.length}',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: dept.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Exercise types ─────────────────────────────────────────────────────────

  Widget _buildExercise() {
    switch (_exo.type) {
      case ExType.fillBlank:
        return _buildFillBlank();
      case ExType.dialogue:
        return _buildDialogue();
      case ExType.docFill:
        return _buildDocFill();
    }
  }

  Widget _scenarioChip(IconData icon) {
    if (_exo.scenario == null) return const SizedBox.shrink();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.38)),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _exo.scenario!,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withValues(alpha: 0.45),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFillBlank() {
    final parts = _exo.prompt.split('_____');
    final dept = widget.dept;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scenarioChip(Icons.location_on_outlined),
        Text(
          'Fill in the blank',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 11,
            letterSpacing: 0.8,
            color: dept.color.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(height: 14),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.65,
            ),
            children: [
              if (parts.isNotEmpty) TextSpan(text: parts[0]),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: _answered
                        ? (_isCorrect
                            ? const Color(0xFF14522A)
                            : const Color(0xFF521414))
                        : dept.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _answered
                          ? (_isCorrect ? Colors.green : Colors.redAccent)
                          : dept.color.withValues(alpha: 0.45),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _answered ? _exo.options[_exo.correct] : '  ?  ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: _answered
                          ? (_isCorrect ? Colors.green : Colors.redAccent)
                          : dept.color,
                    ),
                  ),
                ),
              ),
              if (parts.length > 1) TextSpan(text: parts[1]),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDialogue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scenarioChip(Icons.chat_bubble_outline_rounded),
        ...(_exo.bubbles ?? []).map((msg) => _chatBubble(msg)),
        const SizedBox(height: 10),
        Text(
          _exo.prompt,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.55),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _chatBubble(String msg) {
    final colonIdx = msg.indexOf(':');
    final speaker = colonIdx > 0 ? msg.substring(0, colonIdx).trim() : '';
    final text = colonIdx > 0 ? msg.substring(colonIdx + 1).trim() : msg;
    final isDate = speaker.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (speaker.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Text(
                speaker,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: widget.dept.color.withValues(alpha: 0.7),
                ),
              ),
            ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: isDate ? 6 : 11,
            ),
            decoration: BoxDecoration(
              color: isDate
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.white.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(
                color: isDate
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isDate) ...[
                  Icon(Icons.calendar_today_outlined,
                      size: 11, color: Colors.white.withValues(alpha: 0.35)),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: isDate ? 12 : 14,
                      color: isDate
                          ? Colors.white.withValues(alpha: 0.4)
                          : Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                      fontStyle: isDate ? FontStyle.italic : FontStyle.normal,
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

  Widget _buildDocFill() {
    final dept = widget.dept;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _scenarioChip(Icons.description_outlined),
        Text(
          _exo.prompt,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.article_outlined, size: 13, color: dept.color),
                  const SizedBox(width: 6),
                  Text(
                    _exo.docTitle ?? 'DOCUMENT',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      color: dept.color,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
              const SizedBox(height: 10),
              ...(_exo.docLines ?? []).map((line) => _docLine(line, dept)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _docLine(String line, Department dept) {
    final parts = line.split('[?]');
    if (parts.length >= 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (parts[0].isNotEmpty)
              Text(parts[0], style: const TextStyle(fontSize: 13, color: Colors.white70)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              decoration: BoxDecoration(
                color: _answered
                    ? (_isCorrect
                        ? const Color(0xFF14522A)
                        : const Color(0xFF521414))
                    : dept.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _answered
                      ? (_isCorrect ? Colors.green : Colors.redAccent)
                      : dept.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Text(
                _answered ? _exo.options[_exo.correct] : '  ?  ',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: _answered
                      ? (_isCorrect ? Colors.green : Colors.redAccent)
                      : dept.color,
                ),
              ),
            ),
            if (parts[1].isNotEmpty)
              Text(parts[1], style: const TextStyle(fontSize: 13, color: Colors.white70)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        line,
        style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
      ),
    );
  }

  // ── Options ────────────────────────────────────────────────────────────────

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(_exo.options.length, _buildOption),
      ),
    );
  }

  Widget _buildOption(int i) {
    final isSelected = _pick == i;
    final isCorrect = i == _exo.correct;

    Color border;
    Color bg;
    Color text;
    Widget? trailing;

    if (!_answered) {
      border = Colors.white.withValues(alpha: 0.12);
      bg = Colors.white.withValues(alpha: 0.05);
      text = Colors.white.withValues(alpha: 0.9);
    } else if (isCorrect) {
      border = Colors.green;
      bg = Colors.green.withValues(alpha: 0.1);
      text = Colors.green;
      trailing = const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20);
    } else if (isSelected) {
      border = Colors.redAccent;
      bg = Colors.redAccent.withValues(alpha: 0.08);
      text = Colors.redAccent;
      trailing = const Icon(Icons.cancel_rounded, color: Colors.redAccent, size: 20);
    } else {
      border = Colors.white.withValues(alpha: 0.05);
      bg = Colors.transparent;
      text = Colors.white.withValues(alpha: 0.28);
    }

    return GestureDetector(
      onTap: () => _select(i),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _exo.options[i],
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: text,
                  height: 1.35,
                ),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing],
          ],
        ),
      ),
    );
  }

  // ── Feedback panel ─────────────────────────────────────────────────────────

  Widget _buildFeedbackPanel() {
    final correct = _isCorrect;
    final accent = correct ? Colors.green : Colors.redAccent;
    final bg = correct ? const Color(0xFF091E13) : const Color(0xFF1E0909);

    return Container(
      padding: EdgeInsets.fromLTRB(20, 18, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: accent.withValues(alpha: 0.35), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                correct ? '🎉' : '💡',
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              Text(
                correct ? 'Correct!' : 'Not quite...',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _exo.tip,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.65),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: GestureDetector(
              onTap: _next,
              child: Container(
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _isLast ? 'Start the Test!' : 'Continue',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
