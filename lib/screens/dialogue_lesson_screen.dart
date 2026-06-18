import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/dialogue_data.dart';
import '../data/dept_progress.dart';

class DialogueLessonScreen extends StatefulWidget {
  final Department dept;
  final LessonCategory category;
  final int lessonIdx;

  const DialogueLessonScreen({
    super.key,
    required this.dept,
    required this.category,
    required this.lessonIdx,
  });

  @override
  State<DialogueLessonScreen> createState() => _DialogueLessonScreenState();
}

enum _Stage { typing, waitContinue, waitChoice, done }

class _ChatMsg {
  final String text;
  final bool isKoko;
  const _ChatMsg(this.text, {required this.isKoko});
}

class _DialogueLessonScreenState extends State<DialogueLessonScreen> {
  late final CategoryDialogue _cat;
  late final String _kokoTitle;

  final List<_ChatMsg> _msgs = [];
  final ScrollController _scroll = ScrollController();

  int _nodeIdx = 0;
  _Stage _stage = _Stage.typing;
  String? _opt1, _opt2, _rep1, _rep2;

  @override
  void initState() {
    super.initState();
    final deptMap = dialogueData[widget.dept.id];
    _cat = deptMap![widget.category]![widget.lessonIdx];
    _kokoTitle = deptKokoTitles[widget.dept.id] ?? '';
    _advance();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _advance() {
    if (_nodeIdx >= _cat.script.length) {
      DeptProgress.markDialogueDone(widget.dept.id, widget.category, widget.lessonIdx);
      setState(() => _stage = _Stage.done);
      return;
    }
    final node = _cat.script[_nodeIdx];
    if (node is KokoLine) {
      setState(() => _stage = _Stage.typing);
      _scrollDown();
      Future.delayed(const Duration(milliseconds: 850), () {
        if (!mounted) return;
        setState(() {
          _msgs.add(_ChatMsg(node.text, isKoko: true));
          _nodeIdx++;
          _stage = _Stage.waitContinue;
        });
        _scrollDown();
      });
    } else if (node is UserTurn) {
      setState(() {
        _opt1 = node.option1;
        _opt2 = node.option2;
        _rep1 = node.reply1;
        _rep2 = node.reply2;
        _stage = _Stage.waitChoice;
        _nodeIdx++;
      });
    }
  }

  void _pick(bool first) {
    final text  = first ? _opt1! : _opt2!;
    final reply = first ? _rep1! : _rep2!;
    setState(() {
      _msgs.add(_ChatMsg(text, isKoko: false));
      _stage = _Stage.typing;
    });
    _scrollDown();
    Future.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        _msgs.add(_ChatMsg(reply, isKoko: true));
        _stage = _Stage.waitContinue;
      });
      _scrollDown();
    });
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          _bg(),
          SafeArea(
            child: Column(
              children: [
                _header(),
                Expanded(child: _stage == _Stage.done ? _completionView() : _chatList()),
                if (_stage != _Stage.done) _bottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bg() => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF08051A), Color(0xFF0D0A2A), Color(0xFF130D35)],
      ),
    ),
  );

  Widget _header() {
    final c = widget.dept.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0920),
        border: Border(bottom: BorderSide(color: c.withValues(alpha: 0.2))),
      ),
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
          const SizedBox(width: 12),
          Image.asset(
            'assets/images/koko.png',
            width: 36, height: 36,
            errorBuilder: (ctx, err, st) => const Icon(Icons.pets, size: 28, color: Colors.white54),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Koko',
                  style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                    fontSize: 15, color: Colors.white,
                  ),
                ),
                Text(
                  _kokoTitle,
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 11, color: c),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: c.withValues(alpha: 0.3)),
            ),
            child: Text(
              widget.category.label,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 11, color: c,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatList() {
    final showTyping = _stage == _Stage.typing;
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: _msgs.length + (showTyping ? 1 : 0),
      itemBuilder: (_, i) {
        if (showTyping && i == _msgs.length) return _typingBubble();
        final m = _msgs[i];
        return m.isKoko ? _kokoBubble(m.text) : _userBubble(m.text);
      },
    );
  }

  Widget _kokoBubble(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/koko.png', width: 30, height: 30,
            errorBuilder: (ctx, err, st) => const Icon(Icons.pets, size: 22, color: Colors.white54),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: _richText(text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userBubble(String text) {
    final c = widget.dept.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 60),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),
            ),
            border: Border.all(color: c.withValues(alpha: 0.3)),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Nunito', fontSize: 14, color: Colors.white, height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 60),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/koko.png', width: 30, height: 30,
            errorBuilder: (ctx, err, st) => const Icon(Icons.pets, size: 22, color: Colors.white54),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4), topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(delay: 0),
                SizedBox(width: 5),
                _Dot(delay: 200),
                SizedBox(width: 5),
                _Dot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _richText(String text) {
    final c = widget.dept.color;
    final spans = <InlineSpan>[];
    final re = RegExp(r'\*\*(.+?)\*\*');
    int last = 0;

    for (final m in re.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(
          text: text.substring(last, m.start),
          style: const TextStyle(
            fontFamily: 'Nunito', fontSize: 14, color: Colors.white, height: 1.5,
          ),
        ));
      }
      final word = m.group(1)!;
      final lw = word.toLowerCase();
      final def = _cat.vocab.entries
          .firstWhere((e) => e.key.toLowerCase() == lw, orElse: () => MapEntry('', ''))
          .value;
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: GestureDetector(
          onTap: def.isNotEmpty ? () => _showDef(word, def) : null,
          child: Text(
            word,
            style: TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w800,
              fontSize: 14, color: c, height: 1.5,
              decoration: TextDecoration.underline, decorationColor: c,
            ),
          ),
        ),
      ));
      last = m.end;
    }

    if (last < text.length) {
      spans.add(TextSpan(
        text: text.substring(last),
        style: const TextStyle(
          fontFamily: 'Nunito', fontSize: 14, color: Colors.white, height: 1.5,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  void _showDef(String word, String def) {
    final c = widget.dept.color;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: KokoColors.deep,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.withValues(alpha: 0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                word,
                style: TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                  fontSize: 18, color: c,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                def,
                style: const TextStyle(
                  fontFamily: 'Nunito', fontSize: 14,
                  color: Colors.white70, height: 1.55,
                ),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: c.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'Got it',
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                        fontSize: 13, color: c,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    final c = widget.dept.color;

    if (_stage == _Stage.typing) {
      return const SizedBox(height: 68);
    }

    if (_stage == _Stage.waitChoice) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
        decoration: BoxDecoration(
          color: const Color(0xEE0E0920),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _choiceBtn(_opt1!, () => _pick(true), c),
            const SizedBox(height: 8),
            _choiceBtn(_opt2!, () => _pick(false), c),
          ],
        ),
      );
    }

    // waitContinue
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0920),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: GestureDetector(
        onTap: _advance,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: c.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                  fontSize: 15, color: c,
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios_rounded, size: 13, color: c),
            ],
          ),
        ),
      ),
    );
  }

  Widget _choiceBtn(String text, VoidCallback onTap, Color c) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.withValues(alpha: 0.24)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Nunito', fontSize: 14, color: Colors.white, height: 1.4,
          ),
        ),
      ),
    );
  }

  // ── completion ─────────────────────────────────────────────────────────────

  Widget _completionView() {
    final c = widget.dept.color;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(color: c.withValues(alpha: 0.5), width: 2),
            ),
            child: Icon(Icons.star_rounded, size: 42, color: c),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lesson complete!',
            style: TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w900,
              fontSize: 22, color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.category.label} · ${_cat.name}',
            style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: c),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.category == LessonCategory.vocabulary
                  ? 'Words learned'
                  : 'Words practiced',
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 13, color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ..._cat.vocab.entries.map((e) => _vocabCard(e.key, e.value, c)),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Back to lessons',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                  fontSize: 15, color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vocabCard(String word, String def, Color c) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              word,
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 13, color: c,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              def,
              style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 12,
                color: Colors.white60, height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated typing dot ────────────────────────────────────────────────────────
class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _anim = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (ctx, child) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 7, height: 7,
          decoration: const BoxDecoration(color: Colors.white54, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
