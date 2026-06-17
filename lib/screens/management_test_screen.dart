import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/dept_progress.dart';
import '../data/four_pics_data.dart';
import '../data/user_progress.dart';
import '../data/word_craft_data.dart';

// ─── PALETTE ──────────────────────────────────────────────────────────────────
const _kBg2   = Color(0xFF0E0E20);
const _kBg3   = Color(0xFF131128);
const _kBg4   = Color(0xFF1A1A35);
const _kBdr2  = Color(0xFF3C3489);
const _kBdr3  = Color(0xFF534AB7);
const _kText2 = Color(0xFFAFA9EC);
const _kHint  = Color(0xFF7F77DD);
const _kOk    = Color(0xFF5DCAA5);
const _kOkBg  = Color(0xFF04342C);
const _kOkBdr = Color(0xFF0F6E56);
const _kOk2   = Color(0xFF9FE1CB);
const _kNo    = Color(0xFFF7C1C1);
const _kNoBg  = Color(0xFF1A0808);
const _kNoBdr = Color(0xFF791F1F);
const _kBrand = Color(0xFF3C3489);
const _kWarn    = Color(0xFFE8A84C);
const _kWarnBg  = Color(0xFF221500);
const _kWarnBdr = Color(0xFF6B4200);

// ─── MAIN SCREEN ──────────────────────────────────────────────────────────────
class ManagementTestScreen extends StatefulWidget {
  final String deptId;
  const ManagementTestScreen({super.key, this.deptId = 'management'});
  @override
  State<ManagementTestScreen> createState() => _ManagementTestScreenState();
}

class _ManagementTestScreenState extends State<ManagementTestScreen> {
  final Map<int, int> _scores = {};
  bool _showFinalEnd = false;

  @override
  void initState() {
    super.initState();
    // Load best scores from previous sessions
    _scores.addAll(DeptProgress.getGameBestScores(widget.deptId));
  }

  static const int _maxScore = 585;

  static const _modes = [
    (icon: '🧠', label: 'Quick Fire Quiz', desc: 'Answer 6 situational questions correctly.',      maxPts: 90),
    (icon: '📝', label: 'Crossword',       desc: 'Fill the grid, every letter counts.',           maxPts: 75),
    (icon: '🔗', label: 'Word Match',      desc: 'Connect each term to its exact meaning.',        maxPts: 90),
    (icon: '🔀', label: 'Word Order',      desc: 'Rearrange the words into the right sentence.',   maxPts: 60),
    (icon: '✏️', label: 'Fill the Gap',   desc: 'Pick the word that belongs in the blank.',       maxPts: 80),
    (icon: '⚗️', label: 'Word Craft',     desc: 'Combine concepts to discover real vocabulary.',  maxPts: 60),
    (icon: '🎭', label: 'Scenario',        desc: 'Navigate a real-world workplace situation.',     maxPts: 50),
    (icon: '🖼️', label: '4 Pics 1 Word',  desc: 'Find the business word linking all 4 images.',  maxPts: 80),
  ];

  int get _totalScore => _scores.values.fold(0, (a, b) => a + b);

  Future<void> _openGame(BuildContext context, int idx) async {
    final score = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => _GamePage(
          gameIdx: idx,
          deptId: widget.deptId,
          modeIcon: _modes[idx].icon,
          modeName: _modes[idx].label,
          maxPts: _modes[idx].maxPts,
        ),
      ),
    );
    if (score == null || !mounted) return;

    final wasNew  = !_scores.containsKey(idx);
    final oldBest = _scores[idx] ?? 0;

    // Award XP only for improvement; save best score
    final delta = await DeptProgress.recordGameScore(widget.deptId, idx, score);
    if (delta > 0) await UserProgress.addXp(delta);

    setState(() => _scores[idx] = score > oldBest ? score : oldBest);

    // Mark dept fully done when all game slots are filled for the first time
    if (wasNew && _scores.length == _modes.length && mounted) {
      await DeptProgress.setTestScore(widget.deptId, _totalScore, _maxScore);
      if (mounted) setState(() => _showFinalEnd = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06060F),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: _showFinalEnd ? _buildFinalEnd() : _buildHub(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _kBdr2)),
                child: const Icon(Icons.arrow_back_rounded,
                    size: 15, color: _kHint),
              ),
            ),
            Expanded(
              child: Column(children: [
                Text('Test Floor · ${widget.deptId.toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 9, letterSpacing: 1.8, color: _kBdr3)),
                const SizedBox(height: 2),
                const Text('Game Modes',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: _kText2)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _kOkBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kOkBdr),
              ),
              child: Text('$_totalScore pts',
                  style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: _kOk)),
            ),
          ],
        ),
      );

  Widget _buildHub() => SingleChildScrollView(
        key: const ValueKey('hub'),
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(7, (i) => Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 3,
                  margin: EdgeInsets.only(right: i < 6 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: _scores.containsKey(i) ? _kOk : _kBg4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 12),
            Text('${_scores.length} / 7 completed',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.35),
                    letterSpacing: 0.6)),
            const SizedBox(height: 14),
            ...List.generate(_modes.length, (i) => _buildModeCard(context, i)),
            if (_scores.length == 7) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => setState(() => _showFinalEnd = true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: _kBrand,
                      borderRadius: BorderRadius.circular(14)),
                  child: const Text('See final score →',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _kText2)),
                ),
              ),
            ],
          ],
        ),
      );

  // 0=not played  1=0pts(red+X)  2=1–10pts(red)  3=11–<half(orange)  4=≥half(green)
  int _modeStatusLevel(int i) {
    if (!_scores.containsKey(i)) return 0;
    final score = _scores[i]!;
    final half = _modes[i].maxPts / 2;
    if (score == 0) return 1;
    if (score <= 10) return 2;
    if (score < half) return 3;
    return 4;
  }

  Widget _buildModeCard(BuildContext context, int i) {
    if (i == 7) {
      final mode = _modes[i];
      return Opacity(
        opacity: 0.38,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _kBg2,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E1B3A)),
          ),
          child: Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kBg4,
                  border: Border.all(color: _kBdr2),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    size: 20, color: _kHint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mode.label,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _kText2)),
                    const SizedBox(height: 2),
                    const Text('Coming soon',
                        style: TextStyle(
                            fontSize: 11, color: _kHint)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final mode  = _modes[i];
    final level = _modeStatusLevel(i);
    final score = _scores[i];

    final Color cardBg, cardBdr, circleBg, circleBdr, labelColor;
    switch (level) {
      case 1:
      case 2:
        cardBg     = _kNoBg;
        cardBdr    = _kNoBdr;
        circleBg   = const Color(0xFF2B0808);
        circleBdr  = _kNoBdr;
        labelColor = _kNo;
      case 3:
        cardBg     = _kWarnBg;
        cardBdr    = _kWarnBdr;
        circleBg   = const Color(0xFF2A1800);
        circleBdr  = _kWarnBdr;
        labelColor = _kWarn;
      case 4:
        cardBg     = const Color(0xFF05201A);
        cardBdr    = _kOkBdr;
        circleBg   = _kOkBg;
        circleBdr  = _kOkBdr;
        labelColor = _kOk;
      default:
        cardBg     = _kBg2;
        cardBdr    = const Color(0xFF1E1B3A);
        circleBg   = _kBg4;
        circleBdr  = _kBdr2;
        labelColor = _kText2;
    }

    final Widget trailing;
    if (level == 0) {
      trailing = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.play_arrow_rounded, size: 20, color: _kHint),
          Text('${mode.maxPts} pts',
              style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.28))),
        ],
      );
    } else if (level == 1) {
      trailing = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.cancel_rounded, size: 16, color: _kNo),
          const SizedBox(height: 2),
          Text('$score pts', style: const TextStyle(fontSize: 10, color: _kNo)),
        ],
      );
    } else {
      final Color tc   = level == 4 ? _kOk : (level == 3 ? _kWarn : _kNo);
      final IconData ic = level == 4
          ? Icons.check_circle_outline_rounded
          : Icons.radio_button_unchecked;
      trailing = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(ic, size: 16, color: tc),
          const SizedBox(height: 2),
          Text('$score pts', style: TextStyle(fontSize: 10, color: tc)),
        ],
      );
    }

    return GestureDetector(
      onTap: () => _openGame(context, i),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBdr),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleBg,
                border: Border.all(color: circleBdr),
              ),
              child: Center(child: Text(mode.icon, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mode.label,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: labelColor)),
                  const SizedBox(height: 2),
                  Text(mode.desc,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.38))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildFinalEnd() {
    final total = _totalScore;
    final String title, sub;
    if (total >= 240) {
      title = 'Floor cleared brilliantly';
      sub = 'You walked in not knowing the language. You leave fluent. Koko would just nod.';
    } else if (total >= 160) {
      title = 'Floor cleared';
      sub = 'The words are yours now. Use them in the room. That\'s when they become real.';
    } else {
      title = 'Good effort';
      sub = 'The vocabulary is yours. The instinct sharpens with time. Koko never rushes.';
    }
    return SingleChildScrollView(
      key: const ValueKey('finalEnd'),
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 60),
      child: Column(
        children: [
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _kOk, width: 2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: total),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOut,
                  builder: (_, val, __) => Text('$val',
                      style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          color: _kOk)),
                ),
                const Text('pts',
                    style: TextStyle(
                        fontSize: 10, color: _kOk, letterSpacing: 0.8)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: _kText2)),
          const SizedBox(height: 8),
          Text(sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.5),
                  height: 1.7)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: _kBg2,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E1B3A))),
            child: Column(
              children: List.generate(7, (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: [
                  Text(_modes[i].icon, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(_modes[i].label,
                          style: const TextStyle(fontSize: 12, color: _kText2))),
                  Text('${_scores[i] ?? 0} / ${_modes[i].maxPts} pts',
                      style: const TextStyle(fontSize: 11, color: _kHint)),
                ]),
              )),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                  color: _kBrand, borderRadius: BorderRadius.circular(11)),
              child: const Text('← Back to map',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _kText2)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── GAME 1: QUIZ ─────────────────────────────────────────────────────────────
class _QuizGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _QuizGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<_QuizGame> {
  static const _qs = [
    (
      q: 'Your team\'s OKR attainment rate this quarter is 68%. Your manager\'s reaction should be:',
      bold: 'OKR attainment rate',
      hint: 'OKRs are designed to be ambitious. Hitting 100% every quarter means your goals were too easy.',
      opts: [
        'Concerned targets should hit 100%',
        'Satisfied 70% is the healthy benchmark for ambitious goals',
        'Neutral OKRs don\'t really matter',
        'Disappointed anything below 80% is a fail',
      ],
      ans: 1,
      fb:
          'Koko: 70% is the standard benchmark. If you hit 100% every quarter, your goals weren\'t ambitious enough. 68% is a healthy stretch.',
    ),
    (
      q: 'A KPI is different from an OKR because:',
      bold: 'KPI',
      hint: 'Think of one as a speedometer (always on), the other as a destination on a map (for a set period).',
      opts: [
        'KPIs are set yearly; OKRs are set daily',
        'KPIs track ongoing health; OKRs drive a specific direction for a period',
        'KPIs are only for executives',
        'OKRs measure the past; KPIs set future goals',
      ],
      ans: 1,
      fb:
          'Koko: KPIs are your dashboard always on. OKRs are your compass for a quarter. One monitors, one directs.',
    ),
    (
      q: 'The board deck goes out tomorrow. You discover the CFO hasn\'t been briefed. You:',
      bold: 'board deck',
      hint: 'A surprised CFO in front of the board is the worst outcome. Five minutes of alignment now beats an hour of public escalation.',
      opts: [
        'Send it anyway the CFO will read it',
        'Delay the deck and brief the CFO now',
        'Email the CFO and CC the whole C-suite',
        'Flag it to the CEO and let them decide',
      ],
      ans: 1,
      fb:
          'Koko: A surprised CFO can pull the deck in front of the board. Brief them now 5 minutes of alignment prevents an hour of escalation.',
    ),
  ];

  int _cur = 0;
  int _pts = 0;
  int? _picked;
  int    _hintPenalty = 0;
  String _hintText    = '';

  void _useHint() {
    if (_picked != null) return;
    setState(() {
      _hintPenalty += 20;
      _hintText = _qs[_cur].hint;
    });
  }

  void _pick(int i) {
    if (_picked != null) return;
    final ok = i == _qs[_cur].ans;
    setState(() {
      _picked = i;
      if (ok) _pts += 30;
    });
    Future.delayed(const Duration(milliseconds: 950), () {
      if (!mounted) return;
      final next = _cur + 1;
      if (next >= _qs.length) {
        widget.onDone((_pts - _hintPenalty).clamp(0, 999));
      } else {
        setState(() {
          _cur    = next;
          _picked = null;
          _hintText = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _qs[_cur];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Quiz',
        name: 'Quick fire',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _picked == null ? _useHint : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_hintText.isNotEmpty) ...[
            _HintBanner('${_hintText} (−20 pts)'),
            const SizedBox(height: 10),
          ],
          _CardQ(
              text: 'Q${_cur + 1}/${_qs.length}: ${q.q}',
              boldWord: q.bold),
          const SizedBox(height: 14),
          ...List.generate(q.opts.length, (i) {
            final picked = _picked;
            final isCorrect = i == q.ans;
            final isPicked = picked == i;
            Color border, bg;
            Color textC = _kText2;
            if (picked != null) {
              if (isCorrect) {
                border = _kOkBdr; bg = _kOkBg; textC = _kOk2;
              } else if (isPicked) {
                border = _kNoBdr; bg = _kNoBg; textC = _kNo;
              } else {
                border = _kBdr2; bg = _kBg3;
              }
            } else {
              border = _kBdr2; bg = _kBg3;
            }
            return GestureDetector(
              onTap: () => _pick(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 7),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: border),
                ),
                child: Row(children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: picked != null && isCorrect
                          ? _kOkBdr
                          : picked != null && isPicked
                              ? _kNoBdr
                              : _kBg4,
                      border: Border.all(
                          color: picked != null && isCorrect
                              ? _kOkBdr
                              : _kBdr2),
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(65 + i),
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: picked != null &&
                                    (isCorrect || isPicked)
                                ? Colors.white
                                : _kHint),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(q.opts[i],
                        style: TextStyle(fontSize: 12, color: textC, height: 1.5)),
                  ),
                ]),
              ),
            );
          }),
          if (_picked != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 6),
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: _picked == q.ans ? _kOkBg : _kNoBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _picked == q.ans ? _kOkBdr : _kNoBdr),
              ),
              child: Text(q.fb,
                  style: TextStyle(
                      fontSize: 11.5,
                      color: _picked == q.ans ? _kOk2 : _kNo,
                      height: 1.65)),
            ),
        ]),
      ),
    );
  }
}

// ─── GAME 2: CROSSWORD (interactive grid) ────────────────────────────────────

typedef _CWWord = ({
  int num,
  bool across,
  int r,
  int c,
  String answer,
  String clue,
});

class _CrosswordGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _CrosswordGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_CrosswordGame> createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<_CrosswordGame> {
  // 5 rows × 6 cols; '.' = black cell
  // Verified intersections:
  //   MEMO(0,0–3) × OKR-down(col3): O at (0,3)
  //   OKR-down(col3) × KPI(1,3–5):  K at (1,3)
  //   KPI(1,3–5)   × PLAN-down(col4): P at (1,4)
  //   OKR-down(col3) × YEAR(2,0–3):  R at (2,3)
  //   PLAN-down(col4) × YEAR(2,0–3)? — no overlap (YEAR ends at col3, PLAN at col4) ✓
  static const _gridAnswer = [
    ['M', 'E', 'M', 'O', '.', '.'],
    ['.', '.', '.', 'K', 'P', 'I'],
    ['Y', 'E', 'A', 'R', 'L', '.'],
    ['.', '.', '.', '.', 'A', '.'],
    ['.', '.', '.', '.', 'N', '.'],
  ];

  static const _cellNums = [
    [1, 0, 0, 2, 0, 0],
    [0, 0, 0, 3, 4, 0],
    [5, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0],
  ];

  static const List<_CWWord> _words = [
    (num: 1, across: true,  r: 0, c: 0, answer: 'MEMO', clue: 'A short written message sent internally'),
    (num: 2, across: false, r: 0, c: 3, answer: 'OKR',  clue: 'Objectives and Key ___ (abbr.)'),
    (num: 3, across: true,  r: 1, c: 3, answer: 'KPI',  clue: 'Key Performance ___ (abbr.)'),
    (num: 4, across: false, r: 1, c: 4, answer: 'PLAN', clue: 'Strategic ___: a roadmap of goals and actions'),
    (num: 5, across: true,  r: 2, c: 0, answer: 'YEAR', clue: 'Fiscal ___: the 12-month reporting period'),
  ];

  static const _cellSize = 40.0;
  static const _gap      = 3.0;

  // Per-word typed input and done state
  final List<String> _inputs = List.filled(5, '');
  final List<bool?>  _done   = List.filled(5, null); // null=untouched, true=✓, false=✗
  int    _curWord     = 0;
  int    _pts         = 0;
  int    _hintPenalty = 0;
  String _hintText    = '';
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  List<(int, int)> _cells(int wi) {
    final w = _words[wi];
    return List.generate(
      w.answer.length,
      (i) => w.across ? (w.r, w.c + i) : (w.r + i, w.c),
    );
  }

  bool _inWord(int wi, int r, int c) =>
      _cells(wi).any((cell) => cell.$1 == r && cell.$2 == c);

  String _displayLetter(int r, int c) {
    // Confirmed words take priority
    for (int wi = 0; wi < _words.length; wi++) {
      if (_done[wi] != true) continue;
      final cells = _cells(wi);
      for (int ci = 0; ci < cells.length; ci++) {
        if (cells[ci].$1 == r && cells[ci].$2 == c) return _words[wi].answer[ci];
      }
    }
    // Current word's input
    final cur = _cells(_curWord);
    for (int ci = 0; ci < cur.length; ci++) {
      if (cur[ci].$1 == r && cur[ci].$2 == c) {
        return ci < _inputs[_curWord].length ? _inputs[_curWord][ci] : '';
      }
    }
    // Other words' partial inputs
    for (int wi = 0; wi < _words.length; wi++) {
      if (wi == _curWord || _done[wi] == true) continue;
      final cells = _cells(wi);
      for (int ci = 0; ci < cells.length; ci++) {
        if (cells[ci].$1 == r && cells[ci].$2 == c && ci < _inputs[wi].length) {
          return _inputs[wi][ci];
        }
      }
    }
    return '';
  }

  // ── Input handling ────────────────────────────────────────────────────────

  void _onChange(String val) {
    final cleaned = val.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    final maxLen  = _words[_curWord].answer.length;
    final capped  = cleaned.length > maxLen ? cleaned.substring(0, maxLen) : cleaned;

    if (_ctrl.text != capped) {
      _ctrl.value = _ctrl.value.copyWith(
        text: capped,
        selection: TextSelection.collapsed(offset: capped.length),
      );
    }
    setState(() => _inputs[_curWord] = capped);

    if (capped.length == maxLen) _checkAnswer(capped);
  }

  void _checkAnswer(String typed) {
    final ok = typed == _words[_curWord].answer;
    setState(() {
      _done[_curWord] = ok;
      if (ok) _pts += 15;
    });

    if (ok) {
      // Auto-advance after brief green flash
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _advance();
      });
    }
    // Wrong: stay on this word, user must tap Continue
  }

  void _dismissWrong() {
    setState(() {
      _done[_curWord] = null;
      _inputs[_curWord] = '';
      _ctrl.clear();
    });
    _advance();
  }

  void _advance() {
    // Find next incomplete word
    for (int i = 1; i <= _words.length; i++) {
      final next = (_curWord + i) % _words.length;
      if (_done[next] != true) {
        setState(() {
          _curWord = next;
          _ctrl.text = _inputs[next];
        });
        _focus.requestFocus();
        return;
      }
    }
    // All done
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) widget.onDone((_pts - _hintPenalty).clamp(0, 999));
    });
  }

  // ── Hint ─────────────────────────────────────────────────────────────────

  void _useHint() {
    // If current word is already done, switch to next incomplete word first
    if (_done[_curWord] == true) {
      for (int i = 1; i <= _words.length; i++) {
        final next = (_curWord + i) % _words.length;
        if (_done[next] != true) {
          setState(() => _curWord = next);
          break;
        }
      }
    }
    if (_done[_curWord] == true) return; // all done
    setState(() {
      _hintPenalty += 20;
      _hintText = 'Next letter revealed (−20 pts)';
    });
    _revealNextLetter();
  }

  void _revealNextLetter() {
    final answer = _words[_curWord].answer;
    final typed  = _inputs[_curWord];
    if (typed.length >= answer.length) return;
    final revealed = answer.substring(0, typed.length + 1);
    setState(() => _inputs[_curWord] = revealed);
    _ctrl.value = _ctrl.value.copyWith(
      text: revealed,
      selection: TextSelection.collapsed(offset: revealed.length),
    );
    if (revealed.length == answer.length) {
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) _checkAnswer(revealed);
      });
    }
  }

  void _tapCell(int r, int c) {
    if (_gridAnswer[r][c] == '.') return;
    // Find a word through this cell that isn't done
    for (int i = 0; i < _words.length; i++) {
      final wi = (_curWord + 1 + i) % _words.length; // start from next to allow toggle
      if (_done[wi] == true) continue;
      if (_inWord(wi, r, c)) {
        setState(() {
          _curWord = wi;
          _ctrl.text = _inputs[wi];
        });
        _focus.requestFocus();
        return;
      }
    }
    // Fallback: pick any word through this cell
    for (int wi = 0; wi < _words.length; wi++) {
      if (_inWord(wi, r, c)) {
        setState(() {
          _curWord = wi;
          _ctrl.text = _inputs[wi];
        });
        _focus.requestFocus();
        return;
      }
    }
  }

  // ── Grid ─────────────────────────────────────────────────────────────────

  Widget _buildGrid() {
    const stride = _cellSize + _gap;
    return GestureDetector(
      onTapDown: (d) {
        final c = (d.localPosition.dx / stride).floor();
        final r = (d.localPosition.dy / stride).floor();
        if (r >= 0 && r < 5 && c >= 0 && c < 6) _tapCell(r, c);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (r) => Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (c) => _buildCell(r, c)),
        )),
      ),
    );
  }

  Widget _buildCell(int r, int c) {
    const stride = _cellSize + _gap;
    if (_gridAnswer[r][c] == '.') {
      return SizedBox(width: stride, height: stride);
    }

    final inCur   = _inWord(_curWord, r, c);
    final curDone = _done[_curWord];
    final letter  = _displayLetter(r, c);
    final num     = _cellNums[r][c];

    // Determine if this cell belongs to any confirmed word
    bool isConfirmed = false;
    for (int wi = 0; wi < _words.length; wi++) {
      if (_done[wi] == true && _inWord(wi, r, c)) { isConfirmed = true; break; }
    }

    Color bg, borderColor;
    Color textColor = Colors.white;

    if (inCur) {
      if (curDone == true)       { bg = _kOkBg;           borderColor = _kOkBdr; textColor = _kOk2; }
      else if (curDone == false) { bg = _kNoBg;           borderColor = _kNoBdr; textColor = _kNo; }
      else                       { bg = const Color(0xFF23205A); borderColor = _kHint; }
    } else if (isConfirmed) {
      bg = const Color(0xFF072B1F); borderColor = _kOkBdr; textColor = _kOk2;
    } else {
      bg = _kBg4; borderColor = _kBdr2;
    }

    return Container(
      width: _cellSize,
      height: _cellSize,
      margin: const EdgeInsets.all(_gap / 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderColor, width: inCur ? 2 : 1.5),
      ),
      child: Stack(
        children: [
          if (num > 0)
            Positioned(
              top: 2, left: 3,
              child: Text('$num',
                style: const TextStyle(
                  fontSize: 7.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                )),
            ),
          Center(
            child: Text(letter,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 15,
                color: textColor,
              )),
          ),
        ],
      ),
    );
  }

  // ── Letter boxes (input preview) ──────────────────────────────────────────

  Widget _buildLetterBoxes() {
    final w      = _words[_curWord];
    final typed  = _inputs[_curWord];
    final state  = _done[_curWord];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(w.answer.length, (i) {
        final letter = i < typed.length ? typed[i] : '';
        final isActive = i == typed.length && state == null;
        Color bg, border;
        Color tc = _kText2;

        if (state == true)  { bg = _kOkBg; border = _kOkBdr; tc = _kOk2; }
        else if (state == false) { bg = _kNoBg; border = _kNoBdr; tc = _kNo; }
        else if (isActive)  { bg = _kBg3;  border = _kHint; }
        else                { bg = _kBg3;  border = _kBdr2; }

        return Container(
          width: 36, height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: border, width: isActive ? 2 : 1.5),
          ),
          child: Center(
            child: Text(letter,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 17,
                color: tc,
              )),
          ),
        );
      }),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final w   = _words[_curWord];
    final dir = w.across ? 'Across' : 'Down';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Crossword',
        name: 'Management vocabulary',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _useHint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hintText.isNotEmpty) ...[
              _HintBanner(_hintText),
              const SizedBox(height: 10),
            ],
            // Progress dots
            Row(
              children: List.generate(_words.length, (i) => Container(
                width: 6, height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _done[i] == true ? _kOk
                       : i == _curWord     ? _kHint
                       : _kBg4,
                ),
              )),
            ),
            const SizedBox(height: 16),

            // Grid
            Center(child: _buildGrid()),
            const SizedBox(height: 16),

            // Current clue
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _kBg4,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: _kBdr2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _kHint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('${w.num} $dir',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        color: _kHint,
                      )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(w.clue,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: _kText2,
                        height: 1.45,
                      )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text('${w.answer.length} letters',
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.35))),
            ),
            const SizedBox(height: 14),

            if (_done[_curWord] == false) ...[
              // Wrong — show answer and wait for manual Continue
              _FeedbackBox(
                ok: false,
                text: 'Not quite. The answer is: ${_words[_curWord].answer}',
              ),
              const SizedBox(height: 10),
              _ActionButton(label: 'Continue', enabled: true, onTap: _dismissWrong),
            ] else ...[
              // Ready to type (or just confirmed correct)
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildLetterBoxes(),
                  SizedBox(
                    width: 1, height: 1,
                    child: TextField(
                      controller: _ctrl,
                      focusNode: _focus,
                      enableSuggestions: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(color: Colors.transparent, fontSize: 1),
                      cursorColor: Colors.transparent,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                      onChanged: _onChange,
                      enabled: _done[_curWord] == null,
                    ),
                  ),
                ],
              ),
              if (_done[_curWord] == true) ...[
                const SizedBox(height: 10),
                _FeedbackBox(ok: true, text: 'Correct! +15 pts'),
              ],
            ],

            const SizedBox(height: 14),
            // Clue list for reference
            _ClueList(words: _words, done: _done, curWord: _curWord),
          ],
        ),
      ),
    );
  }
}

class _ClueList extends StatelessWidget {
  final List<_CWWord> words;
  final List<bool?> done;
  final int curWord;
  const _ClueList({required this.words, required this.done, required this.curWord});

  @override
  Widget build(BuildContext context) {
    final across = words.where((w) => w.across).toList();
    final down   = words.where((w) => !w.across).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFF2A2550), height: 20),
        _section('Across', across),
        const SizedBox(height: 6),
        _section('Down', down),
      ],
    );
  }

  Widget _section(String label, List<_CWWord> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.w800,
            fontSize: 11, color: _kHint, letterSpacing: 0.5,
          )),
        const SizedBox(height: 4),
        ...list.map((w) {
          final idx = words.indexOf(w);
          final isDone   = done[idx] == true;
          final isCur    = idx == curWord;
          return Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              '${w.num}. ${w.clue}',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: isDone  ? _kOk2
                     : isCur   ? _kText2
                     : Colors.white.withValues(alpha: 0.32),
                decoration: isDone ? TextDecoration.lineThrough : null,
                decorationColor: _kOk2,
              )),
          );
        }),
      ],
    );
  }
}

// ─── GAME 3: MATCHING ─────────────────────────────────────────────────────────
class _MatchingGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _MatchingGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_MatchingGame> createState() => _MatchingGameState();
}

class _MatchingGameState extends State<_MatchingGame> {
  static const _pairs = [
    ('OKR', 'Goal with a direction + measurable outcomes'),
    ('KPI', 'Number showing if a part of the business is healthy'),
    ('Board deck', 'Quarterly strategy slides sent to directors'),
    ('Stakeholder', 'Person who can block or approve a decision'),
    ('Strategic headcount', 'Hiring plan tied to specific business goals'),
    ('Attainment', 'Percentage of goals actually achieved'),
  ];

  late final List<String> _shuffledDefs;
  String? _selTerm;
  String? _selDef;
  final Map<String, bool> _matched = {};
  int    _pts         = 0;
  int    _hintPenalty = 0;
  String _hintText    = '';
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    _shuffledDefs = _pairs.map((p) => p.$2).toList()..shuffle();
  }

  void _useHint() {
    if (_allDone) return;
    for (final p in _pairs) {
      if (!_matched.containsKey(p.$1)) {
        setState(() {
          _hintPenalty += 20;
          _matched[p.$1] = true;
          _pts += 15;
          _hintText = 'Matched: ${p.$1} → ${p.$2} (−20 pts)';
          _selTerm = null;
          _selDef  = null;
        });
        _checkDone();
        return;
      }
    }
  }

  String? _correctDefFor(String term) {
    try {
      return _pairs.firstWhere((p) => p.$1 == term).$2;
    } catch (_) {
      return null;
    }
  }

  String? _termForDef(String def) {
    try {
      return _pairs.firstWhere((p) => p.$2 == def).$1;
    } catch (_) {
      return null;
    }
  }

  void _tapTerm(String term) {
    if (_matched.containsKey(term) || _allDone) return;
    if (_selDef != null) {
      // Match now
      final ok = _correctDefFor(term) == _selDef;
      setState(() {
        _matched[term] = ok;
        _pts += ok ? 15 : 0;
        _selTerm = null;
        _selDef = null;
      });
      _checkDone();
    } else {
      setState(() { _selTerm = _selTerm == term ? null : term; });
    }
  }

  void _tapDef(String def) {
    if (_allDone) return;
    final term = _termForDef(def);
    if (term != null && _matched.containsKey(term)) return;
    if (_selTerm != null) {
      // Match now
      final ok = _correctDefFor(_selTerm!) == def;
      setState(() {
        _matched[_selTerm!] = ok;
        _pts += ok ? 15 : 0;
        _selTerm = null;
        _selDef = null;
      });
      _checkDone();
    } else {
      setState(() { _selDef = _selDef == def ? null : def; });
    }
  }

  void _checkDone() {
    if (_matched.length == _pairs.length) {
      setState(() { _allDone = true; });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) widget.onDone((_pts - _hintPenalty).clamp(0, 999));
      });
    }
  }

  // null=normal, true=ok, false=no
  bool? _termState(String term) =>
      _matched.containsKey(term) ? _matched[term] : null;

  bool? _defState(String def) {
    final term = _termForDef(def);
    if (term != null && _matched.containsKey(term)) return _matched[term];
    return null;
  }

  Widget _chip(String label, bool? state, bool isSelected, VoidCallback onTap) {
    Color border, bg;
    Color textC = _kText2;
    if (state == true) { border = _kOkBdr; bg = _kOkBg; textC = _kOk2; }
    else if (state == false) { border = _kNoBdr; bg = _kNoBg; textC = _kNo; }
    else if (isSelected) { border = _kHint; bg = _kBg4; textC = _kText2; }
    else { border = _kBdr2; bg = _kBg3; }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        constraints: const BoxConstraints(minHeight: 44),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.5, color: textC, height: 1.4)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Matching',
        name: 'Connect the concepts',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _allDone ? null : _useHint,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_hintText.isNotEmpty) ...[
            _HintBanner(_hintText),
            const SizedBox(height: 10),
          ],
          const Text('Tap a term, then tap its definition.',
              style: TextStyle(fontSize: 13, color: _kText2, height: 1.65)),
          const SizedBox(height: 12),
          if (_allDone)
            _FeedbackBox(ok: true, text: '+$_pts pts All matched!'),
          if (!_allDone)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: _pairs
                        .map((p) => _chip(
                              p.$1,
                              _termState(p.$1),
                              _selTerm == p.$1,
                              () => _tapTerm(p.$1),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    children: _shuffledDefs
                        .map((d) => _chip(
                              d,
                              _defState(d),
                              _selDef == d,
                              () => _tapDef(d),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
        ]),
      ),
    );
  }
}

// ─── GAME 4: WORD ORDER ───────────────────────────────────────────────────────
class _WordOrderGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _WordOrderGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_WordOrderGame> createState() => _WordOrderGameState();
}

class _WordOrderGameState extends State<_WordOrderGame> {
  static const _sentences = [
    (
      words: ['Stakeholder', 'alignment', 'happens', 'before', 'the', 'meeting,', 'not', 'during', 'it.'],
      hint: 'Koko\'s napkin rule'
    ),
    (
      words: ['Every', 'hire', 'in', 'a', 'strategic', 'headcount', 'plan', 'is', 'an', 'argument.'],
      hint: 'Management bets on people'
    ),
    (
      words: ['A', 'surprised', 'CFO', 'is', 'a', 'blocked', 'project.'],
      hint: 'The alignment principle'
    ),
  ];

  int    _cur         = 0;
  int    _pts         = 0;
  int    _hintPenalty = 0;
  String _hintText    = '';
  late List<String> _shuffled;
  late List<bool> _inBank;
  List<int> _zoneIndices = [];
  bool _checked = false;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    _initSentence();
  }

  void _initSentence() {
    _shuffled = List.from(_sentences[_cur].words)..shuffle();
    _inBank = List.filled(_shuffled.length, true);
    _zoneIndices = [];
    _checked  = false;
    _correct  = false;
    _hintText = '';
  }

  void _useHint() {
    if (_checked) return;
    final correctWords = _sentences[_cur].words;
    final nextPos = _zoneIndices.length;
    if (nextPos >= correctWords.length) return;
    final nextWord = correctWords[nextPos];
    for (int i = 0; i < _shuffled.length; i++) {
      if (_inBank[i] && _shuffled[i] == nextWord) {
        setState(() {
          _hintPenalty += 20;
          _inBank[i] = false;
          _zoneIndices.add(i);
          _hintText = 'Next word placed: "$nextWord" (−20 pts)';
        });
        return;
      }
    }
  }

  void _tapBank(int idx) {
    if (_checked || !_inBank[idx]) return;
    setState(() {
      _inBank[idx] = false;
      _zoneIndices.add(idx);
    });
  }

  void _tapZone(int pos) {
    if (_checked) return;
    setState(() {
      final bankIdx = _zoneIndices[pos];
      _inBank[bankIdx] = true;
      _zoneIndices.removeAt(pos);
    });
  }

  void _check() {
    final placed = _zoneIndices.map((i) => _shuffled[i]).join(' ');
    final ok = placed == _sentences[_cur].words.join(' ');
    setState(() {
      _checked = true;
      _correct = ok;
      if (ok) _pts += 20;
    });
    if (ok) {
      Future.delayed(const Duration(milliseconds: 1100), () {
        if (!mounted) return;
        _advance();
      });
    }
    // Wrong: stay, user must tap Continue
  }

  void _dismissWrong() {
    final next = _cur + 1;
    if (next >= _sentences.length) {
      widget.onDone((_pts - _hintPenalty).clamp(0, 999));
    } else {
      setState(() {
        _cur = next;
        _initSentence();
      });
    }
  }

  void _advance() {
    final next = _cur + 1;
    if (next >= _sentences.length) {
      widget.onDone((_pts - _hintPenalty).clamp(0, 999));
    } else {
      setState(() {
        _cur = next;
        _initSentence();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _sentences[_cur];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Word order',
        name: 'Rebuild the sentence',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _checked ? null : _useHint,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_hintText.isNotEmpty) ...[
            _HintBanner(_hintText),
            const SizedBox(height: 10),
          ],
          Text(s.hint,
              style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.4))),
          const SizedBox(height: 10),
          Text('Tap words in the right order:',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35))),
          const SizedBox(height: 8),
          // Drop zone
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _kBg3,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: _checked
                      ? (_correct ? _kOkBdr : _kNoBdr)
                      : _kBdr2,
                  style: _checked ? BorderStyle.solid : BorderStyle.solid),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: List.generate(_zoneIndices.length, (pos) {
                final word = _shuffled[_zoneIndices[pos]];
                Color border = _checked
                    ? (_correct ? _kOkBdr : _kNoBdr)
                    : _kBdr3;
                Color bg = _checked
                    ? (_correct ? _kOkBg : _kNoBg)
                    : _kBg2;
                Color textC = _checked
                    ? (_correct ? _kOk : _kNo)
                    : _kText2;
                return GestureDetector(
                  onTap: () => _tapZone(pos),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: border),
                    ),
                    child: Text(word,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: textC)),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          // Bank
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(_shuffled.length, (i) {
              final inBank = _inBank[i];
              if (!inBank) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => _tapBank(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _kBg4,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _kBdr2),
                  ),
                  child: Text(_shuffled[i],
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _kText2)),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          if (!_checked)
            _ActionButton(
                label: 'Check',
                enabled: _zoneIndices.isNotEmpty,
                onTap: _check),
          if (_checked) ...[
            const SizedBox(height: 10),
            _FeedbackBox(
              ok: _correct,
              text: _correct
                  ? 'Correct! +20 pts'
                  : 'Answer: ${s.words.join(' ')}',
            ),
            if (!_correct) ...[
              const SizedBox(height: 10),
              _ActionButton(label: 'Continue', enabled: true, onTap: _dismissWrong),
            ],
          ],
        ]),
      ),
    );
  }
}

// ─── GAME 5: FILL IN THE BLANK ────────────────────────────────────────────────
class _FillBlankGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _FillBlankGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_FillBlankGame> createState() => _FillBlankGameState();
}

class _FillBlankGameState extends State<_FillBlankGame> {
  static const _blanks = [
    (
      before: 'In management, the',
      blank: 'OKR',
      after: 'framework sets one big direction (Objective) with 2–4 measurable Key Results.',
      hint: 'Three letters. Objectives & Key…',
      accept: ['okr', 'okrs']
    ),
    (
      before: 'A KPI tells you at a glance whether a part of the business is',
      blank: 'healthy',
      after: 'or struggling.',
      hint: 'The opposite of struggling',
      accept: ['healthy', 'ok', 'fine']
    ),
    (
      before: 'Making sure every person who can block a decision is on board before the meeting is called stakeholder',
      blank: 'alignment',
      after: '.',
      hint: 'The napkin drawing Koko made',
      accept: ['alignment', 'aligned']
    ),
    (
      before: 'Strategic',
      blank: 'headcount',
      after: 'means hiring specific roles to hit specific goals not just "we need more people".',
      hint: 'Number of people in a plan',
      accept: ['headcount', 'head count']
    ),
  ];

  int    _cur         = 0;
  int    _pts         = 0;
  int    _hintPenalty = 0;
  String _hintText    = '';
  bool _submitted = false;
  bool _correct   = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _useHint() {
    if (_submitted) return;
    final blank = _blanks[_cur].blank;
    setState(() {
      _hintPenalty += 20;
      _hintText = 'Starts with "${blank[0].toUpperCase()}" · ${blank.length} letters (−20 pts)';
    });
  }

  void _submit() {
    if (_submitted) return;
    final val = _ctrl.text.trim().toLowerCase();
    final ok = _blanks[_cur].accept.contains(val);
    setState(() {
      _submitted = true;
      _correct   = ok;
      if (ok) _pts += 20;
    });
    if (ok) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        _advance();
      });
    }
    // Wrong: stay, user must tap Continue
  }

  void _dismissWrong() {
    _advance();
  }

  void _advance() {
    final next = _cur + 1;
    if (next >= _blanks.length) {
      widget.onDone((_pts - _hintPenalty).clamp(0, 999));
    } else {
      setState(() {
        _cur       = next;
        _submitted = false;
        _correct   = false;
        _hintText  = '';
        _ctrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = _blanks[_cur];
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Fill in the blank',
        name: 'Complete the sentence',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _submitted ? null : _useHint,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_hintText.isNotEmpty) ...[
            _HintBanner(_hintText),
            const SizedBox(height: 10),
          ],
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 13, color: _kText2, height: 1.65),
              children: [
                TextSpan(text: '${_cur + 1}/${_blanks.length}:  "${b.before} '),
                const TextSpan(
                  text: '_____',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: _kHint),
                ),
                TextSpan(text: ' ${b.after}"'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('Hint: ${b.hint}',
              style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.35))),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            enabled: !_submitted,
            style: TextStyle(
                fontSize: 14,
                color: _submitted ? (_correct ? _kOk2 : _kNo) : _kText2),
            decoration: InputDecoration(
              hintText: 'Type the missing word…',
              hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.2)),
              filled: true,
              fillColor: _submitted ? (_correct ? _kOkBg : _kNoBg) : _kBg3,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBdr2)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kBdr2)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _kHint)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: _correct ? _kOkBdr : _kNoBdr)),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 10),
          if (!_submitted)
            _ActionButton(
                label: 'Submit',
                enabled: true,
                onTap: _submit),
          if (_submitted) ...[
            const SizedBox(height: 10),
            _FeedbackBox(
              ok: _correct,
              text: _correct
                  ? 'Correct! +20 pts'
                  : 'The answer was "${b.blank}"',
            ),
            if (!_correct) ...[
              const SizedBox(height: 10),
              _ActionButton(label: 'Continue', enabled: true, onTap: _dismissWrong),
            ],
          ],
        ]),
      ),
    );
  }
}

// ─── GAME 6: WORD CRAFT ───────────────────────────────────────────────────────
class _CraftCombo {
  final String k1, k2, name, icon, def;
  const _CraftCombo(this.k1, this.k2, this.name, this.icon, this.def);
}

class _WCEl {
  String label;
  String icon;
  Offset pos;
  bool glow;
  _WCEl(this.label, this.icon, this.pos, {this.glow = false});
}

class _WordCraftGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  final String deptId;
  const _WordCraftGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total,
      required this.deptId});
  @override
  State<_WordCraftGame> createState() => _WordCraftGameState();
}

class _WordCraftGameState extends State<_WordCraftGame> {
  late final Map<String, WcCombo> _comboMap;
  late final Map<String, String> _iconMap;
  late final int _targetCount;
  late final List<WcCombo> _combos;
  final List<_WCEl> _canvas = [];
  final Set<String> _discovered = {};
  late final List<(String, String)> _tray;

  int    _craftPts    = 0;
  int    _hintPenalty = 0;
  String _hintText    = '';
  WcCombo? _flash;
  bool _flashIsNew = false;
  bool _finishing  = false;
  int? _dragIdx;
  Size _canvasSize = const Size(300, 300);

  static const double _combineThreshold = 65.0;

  @override
  void initState() {
    super.initState();
    final data = WordCraftData.getData(widget.deptId);
    _targetCount = data.targetCount;
    _combos = data.combos;
    _tray = data.seeds.map((s) => (s.label, s.icon)).toList();
    _comboMap = {};
    _iconMap = { for (final s in data.seeds) s.label: s.icon };
    for (final c in data.combos) {
      _comboMap['${c.k1}+${c.k2}'] = c;
      _comboMap['${c.k2}+${c.k1}'] = c;
      _iconMap[c.result] = c.icon;
    }
  }

  void _useHint() {
    if (_finishing) return;
    for (final c in _combos) {
      if (!_discovered.contains(c.result)) {
        setState(() {
          _hintPenalty += 20;
          _hintText = 'Try combining: ${c.k1} + ${c.k2} (−20 pts)';
        });
        return;
      }
    }
  }

  void _addToCanvas(String label) {
    final n = _canvas.length;
    final x = (20.0 + (n % 4) * 80.0).clamp(0.0, _canvasSize.width - 120);
    final y = (20.0 + (n ~/ 4) * 56.0).clamp(0.0, _canvasSize.height - 40);
    setState(() => _canvas.add(_WCEl(label, _iconMap[label] ?? '📌', Offset(x, y))));
  }

  void _onPanStart(int idx) {
    setState(() {
      final el = _canvas.removeAt(idx);
      _canvas.add(el);
      _dragIdx = _canvas.length - 1;
    });
  }

  void _onPanUpdate(Offset delta) {
    final i = _dragIdx;
    if (i == null || i >= _canvas.length) return;
    final el = _canvas[i];
    setState(() {
      el.pos = Offset(
        (el.pos.dx + delta.dx).clamp(0.0, _canvasSize.width - 100),
        (el.pos.dy + delta.dy).clamp(0.0, _canvasSize.height - 40),
      );
    });
  }

  void _onPanEnd() {
    final i = _dragIdx;
    _dragIdx = null;
    if (i == null || i >= _canvas.length) return;
    final el = _canvas[i];

    int? nearIdx;
    double nearDist = _combineThreshold;
    for (int j = 0; j < _canvas.length; j++) {
      if (j == i) continue;
      final d = (el.pos - _canvas[j].pos).distance;
      if (d < nearDist) { nearDist = d; nearIdx = j; }
    }
    if (nearIdx == null) return;

    final other = _canvas[nearIdx];
    final combo = _comboMap['${el.label}+${other.label}'];
    if (combo == null) return;

    final isNew = !_discovered.contains(combo.result);
    final mergePos = Offset(
      ((el.pos.dx + other.pos.dx) / 2).clamp(0, _canvasSize.width - 100),
      ((el.pos.dy + other.pos.dy) / 2).clamp(0, _canvasSize.height - 40),
    );
    setState(() {
      final hi = i > nearIdx! ? i : nearIdx;
      final lo = i > nearIdx ? nearIdx : i;
      _canvas.removeAt(hi);
      _canvas.removeAt(lo);
      if (isNew) {
        _discovered.add(combo.result);
        if (!_tray.any((t) => t.$1 == combo.result)) _tray.add((combo.result, combo.icon));
        _craftPts += 15;
      }
      _canvas.add(_WCEl(combo.result, combo.icon, mergePos, glow: isNew));
      _flash = combo;
      _flashIsNew = isNew;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() {
        _flash = null;
        for (final e in _canvas) e.glow = false;
      });
    });

    if (_discovered.length >= _targetCount && !_finishing) {
      _finishing = true;
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) widget.onDone((_craftPts - _hintPenalty).clamp(0, 999));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Header ──
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('WORD CRAFT · ${widget.gameNum}/${widget.total}',
                style: const TextStyle(fontSize: 9, letterSpacing: 1.6, color: _kHint)),
            const Spacer(),
            Text('$_craftPts pts',
                style: const TextStyle(fontSize: 10, color: _kOk, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            if (!_finishing)
              GestureDetector(
                onTap: _useHint,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _kWarnBg,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: _kWarnBdr),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, size: 11, color: _kWarn),
                      SizedBox(width: 4),
                      Text('Hint', style: TextStyle(
                          fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                          fontSize: 10, color: _kWarn)),
                    ],
                  ),
                ),
              ),
          ]),
          if (_hintText.isNotEmpty) ...[
            const SizedBox(height: 6),
            _HintBanner(_hintText),
          ],
          const SizedBox(height: 3),
          const Text('Combine Management Concepts',
              style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 20, color: _kText2)),
          const SizedBox(height: 5),
          Row(children: [
            Text('${_discovered.length} / $_targetCount discovered',
                style: const TextStyle(fontSize: 10, color: _kOk)),
            const Spacer(),
            Text('drag words onto each other',
                style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3))),
          ]),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _discovered.length / _targetCount,
              minHeight: 3,
              backgroundColor: _kBg4,
              valueColor: const AlwaysStoppedAnimation(_kOk),
            ),
          ),
        ]),
      ),

      // ── Canvas ──
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: LayoutBuilder(builder: (ctx, bc) {
            _canvasSize = Size(bc.maxWidth, bc.maxHeight);
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF09090F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _kBdr2),
                ),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // Dot-grid background
                    Positioned.fill(
                      child: CustomPaint(painter: _DotGridPainter()),
                    ),

                    // Canvas elements
                    ..._canvas.asMap().entries.map((entry) {
                      final i = entry.key;
                      final el = entry.value;
                      final dragging = _dragIdx == i;
                      return Positioned(
                        left: el.pos.dx,
                        top: el.pos.dy,
                        child: GestureDetector(
                          onPanStart: (_) => _onPanStart(i),
                          onPanUpdate: (d) => _onPanUpdate(d.delta),
                          onPanEnd: (_) => _onPanEnd(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: el.glow
                                  ? _kOkBg
                                  : dragging
                                      ? _kBg4
                                      : const Color(0xFF18182E),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: el.glow ? _kOkBdr : dragging ? _kBdr3 : _kBdr2,
                                width: dragging ? 2 : 1.5,
                              ),
                              boxShadow: dragging
                                  ? [BoxShadow(color: _kBdr3.withValues(alpha: 0.7), blurRadius: 18, spreadRadius: 3)]
                                  : el.glow
                                      ? [BoxShadow(color: _kOk.withValues(alpha: 0.45), blurRadius: 16, spreadRadius: 2)]
                                      : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(el.icon, style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 6),
                                Text(
                                  el.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: el.glow ? _kOk : dragging ? Colors.white : _kText2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Empty state hint
                    if (_canvas.isEmpty)
                      Center(
                        child: Text(
                          'Tap an element below\nto place it here',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.18), height: 1.7),
                        ),
                      ),

                    // Result flash
                    if (_flash != null)
                      Positioned(
                        bottom: 10, left: 10, right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: _flashIsNew ? _kOkBg : _kBg4,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _flashIsNew ? _kOkBdr : _kBdr2),
                          ),
                          child: Row(children: [
                            if (_flashIsNew)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Text('✨', style: TextStyle(fontSize: 16)),
                              ),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  _flashIsNew ? 'New concept unlocked!' : 'Already discovered',
                                  style: TextStyle(fontSize: 9, letterSpacing: 1.1,
                                      color: _flashIsNew ? _kOk : _kHint),
                                ),
                                const SizedBox(height: 2),
                                Row(children: [
                                  Text(_flash!.icon, style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 6),
                                  Text(_flash!.result,
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                                          color: _flashIsNew ? _kOk : _kText2)),
                                ]),
                                const SizedBox(height: 2),
                                Text(_flash!.def,
                                    style: const TextStyle(fontSize: 10.5, color: _kText2, height: 1.45)),
                              ]),
                            ),
                          ]),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),

      // ── Element tray ──
      Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 5),
            child: Text('ELEMENTS, tap to add to canvas',
                style: TextStyle(fontSize: 8, letterSpacing: 1.3, color: Colors.white.withValues(alpha: 0.28))),
          ),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tray.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (ctx, i) {
                final (label, icon) = _tray[i];
                final discovered = _discovered.contains(label);
                return GestureDetector(
                  onTap: () => _addToCanvas(label),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: discovered ? _kOkBg : _kBg3,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: discovered ? _kOkBdr : _kBdr2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(icon, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Text(label,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                color: discovered ? _kOk : _kText2)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    ]);
  }
}

// Dot-grid background for the craft canvas
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF252545)..style = PaintingStyle.fill;
    const s = 24.0;
    for (double x = s; x < size.width; x += s) {
      for (double y = s; y < size.height; y += s) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── GAME 7: SCENARIO ─────────────────────────────────────────────────────────
class _ScenarioGame extends StatefulWidget {
  final void Function(int) onDone;
  final int gameNum, total;
  const _ScenarioGame(
      {super.key,
      required this.onDone,
      required this.gameNum,
      required this.total});
  @override
  State<_ScenarioGame> createState() => _ScenarioGameState();
}

class _ScenarioGameState extends State<_ScenarioGame> {
  static const _opts = [
    'Send a detailed email to the CFO and CTO explaining the headcount plan they can review it before tomorrow',
    'Message the CFO now, slip a note to the CTO between meetings, and mark the CPO\'s hallway comment as aligned then confirm with a 5-line summary to all three',
    'Send the deck tonight they\'ll raise concerns if they have any in the meeting',
    'Tell your manager "almost aligned" and wait until morning to confirm with the CTO before sending',
  ];
  static const _feedback = [
    (ok: false, pts: 20, text: 'An email informs it doesn\'t align. People skim, miss, or reply-all into chaos. Alignment needs a real signal of yes. +20 pts'),
    (ok: true,  pts: 50, text: 'The right move. You\'re treating each person differently based on where they are. Stakeholder alignment is not a broadcast it\'s a series of individual yeses. +50 pts'),
    (ok: false, pts: 0,  text: 'Dangerous. Discovering a CFO disagreement at board level in public is the worst outcome in management. Never let the board meeting be where alignment happens.'),
    (ok: false, pts: 10, text: '"Almost" is not alignment. And waiting until morning is a gamble. Act now. +10 pts'),
  ];

  int?   _picked;
  int    _hintPenalty = 0;
  String _hintText    = '';

  void _useHint() {
    if (_picked != null) return;
    setState(() {
      _hintPenalty += 20;
      _hintText = 'Stakeholder alignment = individual yeses, not a broadcast. Who still needs a real confirmation before tomorrow? (−20 pts)';
    });
  }

  void _pick(int i) {
    if (_picked != null) return;
    setState(() { _picked = i; });
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) widget.onDone((_feedback[i].pts - _hintPenalty).clamp(0, 999));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 32),
      child: _GameCard(
        tag: 'Scenario',
        name: 'The real test',
        step: '${widget.gameNum}/${widget.total}',
        onHint: _picked == null ? _useHint : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (_hintText.isNotEmpty) ...[
            _HintBanner(_hintText),
            const SizedBox(height: 10),
          ],
          // Scene
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _kBg3,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: _kBdr2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Floor 12 · Boardroom · 17:00',
                    style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        color: _kHint)),
                const SizedBox(height: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                        fontSize: 12.5, color: _kText2, height: 1.65),
                    children: [
                      TextSpan(
                          text:
                              'The board deck goes out first thing tomorrow. Your manager pulls you aside:\n\n'),
                      TextSpan(
                          text:
                              '"I need full stakeholder alignment on the headcount plan before that deck leaves."',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _kText2)),
                      TextSpan(
                          text:
                              '\n\nThe CFO hasn\'t been briefed. The CPO said "sounds fine" in a hallway. The CTO is in a 2-hour meeting.\n\n',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: _kHint)),
                      TextSpan(text: 'What do you do right now?'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(_opts.length, (i) {
            final picked = _picked;
            final isCorrect = i == 1;
            final isPicked = picked == i;
            Color border, bg;
            Color textC = _kText2;
            if (picked != null) {
              if (isCorrect) { border = _kOkBdr; bg = _kOkBg; textC = _kOk2; }
              else if (isPicked) { border = _kNoBdr; bg = _kNoBg; textC = _kNo; }
              else { border = _kBdr2; bg = _kBg3; }
            } else {
              border = _kBdr2; bg = _kBg3;
            }
            return GestureDetector(
              onTap: () => _pick(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 7),
                padding: const EdgeInsets.symmetric(
                    horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: picked != null && isCorrect
                            ? _kOkBdr
                            : picked != null && isPicked
                                ? _kNoBdr
                                : _kBg4,
                        border: Border.all(color: _kBdr2),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + i),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: picked != null &&
                                      (isCorrect || isPicked)
                                  ? Colors.white
                                  : _kHint),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(_opts[i],
                          style: TextStyle(
                              fontSize: 12, color: textC, height: 1.5)),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (_picked != null) ...[
            const SizedBox(height: 4),
            _FeedbackBox(
              ok: _feedback[_picked!].ok,
              text: _feedback[_picked!].text,
            ),
          ],
        ]),
      ),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────
class _GameCard extends StatelessWidget {
  final String tag, name, step;
  final Widget child;
  final VoidCallback? onHint;

  const _GameCard({
    required this.tag,
    required this.name,
    required this.step,
    required this.child,
    this.onHint,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _kBg2,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF1E1B3A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _kBg4,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kBdr2),
                ),
                child: Text(tag,
                    style: const TextStyle(
                        fontSize: 9, letterSpacing: 1.4, color: _kHint)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500, color: _kText2)),
              ),
              Text(step,
                  style: TextStyle(
                      fontSize: 11, color: Colors.white.withValues(alpha: 0.3))),
              if (onHint != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onHint,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kWarnBg,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: _kWarnBdr),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lightbulb_outline_rounded,
                            size: 11, color: _kWarn),
                        SizedBox(width: 4),
                        Text('Hint',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                                color: _kWarn)),
                      ],
                    ),
                  ),
                ),
              ],
            ]),
            const SizedBox(height: 14),
            child,
          ],
        ),
      );
}

class _CardQ extends StatelessWidget {
  final String text;
  final String boldWord;
  const _CardQ({required this.text, this.boldWord = ''});

  @override
  Widget build(BuildContext context) {
    if (boldWord.isEmpty) {
      return Text(text,
          style: const TextStyle(
              fontSize: 13, color: _kText2, height: 1.65));
    }
    final idx = text.indexOf(boldWord);
    if (idx < 0) {
      return Text(text,
          style: const TextStyle(
              fontSize: 13, color: _kText2, height: 1.65));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 13, color: _kText2, height: 1.65),
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: boldWord,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: _kText2),
          ),
          TextSpan(text: text.substring(idx + boldWord.length)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.label,
      required this.enabled,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: enabled ? _kBrand : _kBrand.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: enabled
                        ? _kText2
                        : _kText2.withValues(alpha: 0.3))),
          ),
        ),
      );
}

class _FeedbackBox extends StatelessWidget {
  final bool ok;
  final String text;
  const _FeedbackBox({required this.ok, required this.text});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: ok ? _kOkBg : _kNoBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ok ? _kOkBdr : _kNoBdr),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 11.5,
                color: ok ? _kOk2 : _kNo,
                height: 1.65)),
      );
}

class _HintBanner extends StatelessWidget {
  final String text;
  const _HintBanner(this.text);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _kWarnBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kWarnBdr),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_rounded, size: 13, color: _kWarn),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: _kWarn,
                      height: 1.5)),
            ),
          ],
        ),
      );
}

// ─── GAME PAGE ────────────────────────────────────────────────────────────────
// Separate Navigator route for each individual game.
// Pops with the earned score (int) so the hub can record it.
class _GamePage extends StatefulWidget {
  final int gameIdx, maxPts;
  final String deptId, modeIcon, modeName;

  const _GamePage({
    super.key,
    required this.gameIdx,
    required this.deptId,
    required this.modeIcon,
    required this.modeName,
    required this.maxPts,
  });

  @override
  State<_GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<_GamePage> {
  int? _earnedScore;

  void _onDone(int pts) => setState(() => _earnedScore = pts);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06060F),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                transitionBuilder: (child, anim) =>
                    FadeTransition(opacity: anim, child: child),
                child: _earnedScore != null
                    ? _buildEnd(_earnedScore!)
                    : _buildGame(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Row(
          children: [
            GestureDetector(
              // If game already done, pop with score. Otherwise pop with null.
              onTap: () => Navigator.pop(context, _earnedScore),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _kBdr2)),
                child: const Icon(Icons.arrow_back_rounded,
                    size: 15, color: _kHint),
              ),
            ),
            Expanded(
              child: Column(children: [
                Text('${widget.modeIcon}  GAME MODE',
                    style: const TextStyle(
                        fontSize: 9, letterSpacing: 1.8, color: _kBdr3)),
                const SizedBox(height: 2),
                Text(widget.modeName,
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: _kText2)),
              ]),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _kOkBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _kOkBdr),
              ),
              child: Text('${widget.maxPts} pts max',
                  style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      color: _kOk)),
            ),
          ],
        ),
      );

  Widget _buildGame() {
    const key = ValueKey('game');
    return switch (widget.gameIdx) {
      0 => _QuizGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      1 => _CrosswordGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      2 => _MatchingGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      3 => _WordOrderGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      4 => _FillBlankGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      5 => _WordCraftGame(key: key, onDone: _onDone, gameNum: 1, total: 1, deptId: widget.deptId),
      6 => _ScenarioGame(key: key, onDone: _onDone, gameNum: 1, total: 1),
      7 => _FourPicsGame(key: key, onDone: _onDone, deptId: widget.deptId),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildEnd(int score) {
    final pct = (score / widget.maxPts * 100).round();
    final String label;
    if (pct >= 80) label = 'Excellent';
    else if (pct >= 55) label = 'Good job';
    else label = 'Keep practising';

    final Color scoreColor;
    if (score <= 10) scoreColor = _kNo;
    else if (score < widget.maxPts / 2) scoreColor = _kWarn;
    else scoreColor = _kOk;

    return SingleChildScrollView(
      key: const ValueKey('end'),
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 60),
      child: Column(
        children: [
          Text(widget.modeIcon, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 12),
          Text(widget.modeName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: _kText2)),
          const SizedBox(height: 28),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: scoreColor, width: 2)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (_, val, __) => Text('$val',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                          color: scoreColor)),
                ),
                Text('pts',
                    style: TextStyle(
                        fontSize: 10, color: scoreColor, letterSpacing: 0.8)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(label,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: scoreColor)),
          Text('$score / ${widget.maxPts} pts',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4))),
          const SizedBox(height: 36),
          // Play again
          GestureDetector(
            onTap: () => setState(() => _earnedScore = null),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                  color: _kBg4,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: _kBdr2)),
              child: const Text('↺  Play again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _kText2)),
            ),
          ),
          const SizedBox(height: 10),
          // Back to game modes (saves score)
          GestureDetector(
            onTap: () => Navigator.pop(context, score),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                  color: _kBrand,
                  borderRadius: BorderRadius.circular(13)),
              child: const Text('← Back to game modes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _kText2)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 4 PICS 1 WORD ────────────────────────────────────────────────────────────

class _FourPicsGame extends StatefulWidget {
  final void Function(int score) onDone;
  final String deptId;
  const _FourPicsGame({super.key, required this.onDone, required this.deptId});

  @override
  State<_FourPicsGame> createState() => _FourPicsGameState();
}

class _PoolTile {
  final String letter;
  bool used;
  _PoolTile(this.letter) : used = false;
}

class _FourPicsGameState extends State<_FourPicsGame> {
  static const int _ptsPerWord = 10;

  final List<FourPicsWord> _words = fourPicsManagement;
  int _wordIdx = 0;
  int _score   = 0;
  bool _justCorrect = false;
  bool _wrong       = false;

  late List<String?> _answer;
  late List<int> _answerSource;
  late List<_PoolTile> _pool;

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  void _loadWord() {
    final word    = _words[_wordIdx].word;
    _answer       = List.filled(word.length, null);
    _answerSource = List.filled(word.length, -1);
    _pool         = _buildPool(word);
    _justCorrect  = false;
    _wrong        = false;
  }

  List<_PoolTile> _buildPool(String word) {
    final letters = word.split('').toList()..shuffle(math.Random());
    const alphabet = 'BCDFGHJKLMNPQRSTVWXYZ';
    final extras = <String>[];
    for (final c in (alphabet.split('')..shuffle(math.Random()))) {
      if (!word.contains(c) && extras.length < 4) extras.add(c);
      if (extras.length == 4) break;
    }
    return ([...letters, ...extras]..shuffle(math.Random()))
        .map((l) => _PoolTile(l))
        .toList();
  }

  void _tapPool(int idx) {
    if (_pool[idx].used || _justCorrect) return;
    final slot = _answer.indexOf(null);
    if (slot == -1) return;
    setState(() {
      _answer[slot]       = _pool[idx].letter;
      _answerSource[slot] = idx;
      _pool[idx].used     = true;
      _wrong              = false;
    });
  }

  void _tapSlot(int slot) {
    if (_answer[slot] == null || _justCorrect) return;
    setState(() {
      _pool[_answerSource[slot]].used = false;
      _answer[slot]                   = null;
      _answerSource[slot]             = -1;
      _wrong                          = false;
    });
  }

  void _submit() {
    if (_answer.any((l) => l == null) || _justCorrect) return;
    if (_answer.join() == _words[_wordIdx].word) {
      setState(() { _score += _ptsPerWord; _justCorrect = true; _wrong = false; });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        if (_wordIdx < _words.length - 1) {
          setState(() { _wordIdx++; _loadWord(); });
        } else {
          widget.onDone(_score);
        }
      });
    } else {
      setState(() => _wrong = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final word  = _words[_wordIdx];
    final total = _words.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_wordIdx + 1} / $total',
                  style: const TextStyle(fontSize: 12, color: _kText2)),
              Text('$_score pts',
                  style: const TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                      fontSize: 12, color: _kOk)),
            ],
          ),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            children: word.images.map(_buildImage).toList(),
          ),
          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: List.generate(word.word.length, (i) {
              final filled = _answer[i] != null;
              return GestureDetector(
                onTap: () => _tapSlot(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 32,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _justCorrect ? _kOkBg : _wrong && filled ? _kNoBg : filled ? _kBg4 : _kBg2,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: _justCorrect ? _kOkBdr : _wrong && filled ? _kNoBdr : filled ? _kBdr3 : _kBdr2),
                  ),
                  child: Center(
                    child: Text(
                      _answer[i] ?? '',
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: _justCorrect ? _kOk : _wrong && filled ? _kNo : _kText2,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),

          Text(word.hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.35))),
          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: List.generate(_pool.length, (i) {
              final tile = _pool[i];
              return GestureDetector(
                onTap: () => _tapPool(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 38,
                  height: 42,
                  decoration: BoxDecoration(
                    color: tile.used ? _kBg2 : _kBg4,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: tile.used
                            ? _kBdr2.withValues(alpha: 0.3)
                            : _kBdr3),
                  ),
                  child: Center(
                    child: Text(
                      tile.used ? '' : tile.letter,
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: tile.used ? Colors.transparent : _kText2,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: _answer.any((l) => l == null) || _justCorrect ? null : _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: _justCorrect
                    ? _kOkBg
                    : _wrong
                        ? _kNoBg
                        : _answer.any((l) => l == null)
                            ? _kBg2
                            : _kBrand,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: _justCorrect
                      ? _kOkBdr
                      : _wrong
                          ? _kNoBdr
                          : _answer.any((l) => l == null)
                              ? _kBdr2
                              : _kBrand,
                ),
              ),
              child: Center(
                child: Text(
                  _justCorrect ? '✓ Correct!' : _wrong ? '✗ Try again' : 'Submit',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: _justCorrect
                        ? _kOk
                        : _wrong
                            ? _kNo
                            : _answer.any((l) => l == null)
                                ? _kHint
                                : _kText2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(
              color: _kBg4,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, color: _kHint, size: 32),
            ),
          ),
        ),
      );
}
