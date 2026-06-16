import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../data/dept_progress.dart';
import '../data/user_progress.dart';

// ─── QUIZ DATA MODEL ──────────────────────────────────
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

// ─── SAMPLE QUESTIONS PER LESSON ─────────────────────
const Map<String, List<QuizQuestion>> lessonQuestions = {
  'Formal Emails': [
    QuizQuestion(
      question: 'Which phrase best opens a formal business email?',
      options: ['Hey!', 'Dear Mr. Smith,', 'Yo, what\'s up?', 'Hiya!'],
      correctIndex: 1,
      explanation: '"Dear [Name]," is the standard formal email opener in business English.',
    ),
    QuizQuestion(
      question: 'What does "CC" mean in an email?',
      options: ['Carbon Copy', 'Confidential Content', 'Corporate Contact', 'Copied Confirmation'],
      correctIndex: 0,
      explanation: 'CC stands for Carbon Copy it sends a copy to additional recipients.',
    ),
    QuizQuestion(
      question: 'Which sign-off is most professional?',
      options: ['Cheers!', 'See ya!', 'Best regards,', 'Byeee'],
      correctIndex: 2,
      explanation: '"Best regards," or "Kind regards," are the go-to professional sign-offs.',
    ),
  ],
  'Pro Meetings': [
    QuizQuestion(
      question: 'What is an "agenda" in a meeting context?',
      options: [
        'A hidden plan',
        'A list of topics to cover',
        'The meeting location',
        'A summary after the meeting',
      ],
      correctIndex: 1,
      explanation: 'An agenda is a list of items to be discussed during a meeting.',
    ),
    QuizQuestion(
      question: 'What does "AOB" stand for at the end of a meeting?',
      options: ['Any Other Business', 'All On Board', 'Agenda Over Basics', 'Action Of Board'],
      correctIndex: 0,
      explanation: 'AOB = Any Other Business time for topics not on the original agenda.',
    ),
  ],
  'Budget Meetings': [
    QuizQuestion(
      question: 'What is "gross margin"?',
      options: [
        'Total revenue minus total costs',
        'Revenue minus cost of goods sold',
        'Net profit after taxes',
        'Total company expenses',
      ],
      correctIndex: 1,
      explanation: 'Gross margin = Revenue − Cost of Goods Sold. It shows production profitability.',
    ),
    QuizQuestion(
      question: 'What does "ROI" stand for?',
      options: ['Rate of Income', 'Return on Investment', 'Revenue over Index', 'Risk of Interest'],
      correctIndex: 1,
      explanation: 'ROI = Return on Investment. It measures the gain relative to the cost.',
    ),
  ],
  'Job Interview': [
    QuizQuestion(
      question: 'What is a "cover letter"?',
      options: [
        'A letter covering the envelope',
        'A document summarising your skills sent with a CV',
        'A thank-you note after an interview',
        'An email to cancel an application',
      ],
      correctIndex: 1,
      explanation: 'A cover letter accompanies your CV and explains why you\'re a good fit for the role.',
    ),
    QuizQuestion(
      question: 'What does "headhunting" mean?',
      options: [
        'Firing employees',
        'Actively recruiting top talent from other companies',
        'Reviewing performance',
        'Writing job descriptions',
      ],
      correctIndex: 1,
      explanation: 'Headhunting = proactively approaching talented people to recruit them.',
    ),
  ],
  'Pitch Deck': [
    QuizQuestion(
      question: 'What is a "value proposition" in a pitch?',
      options: [
        'The price of the product',
        'The unique benefit your product offers customers',
        'A list of company values',
        'The investment amount needed',
      ],
      correctIndex: 1,
      explanation: 'A value proposition clearly explains how your product solves a problem or delivers benefits.',
    ),
  ],
  'Agile Meetings': [
    QuizQuestion(
      question: 'What is a "stand-up" in Agile?',
      options: [
        'A comedy show at the office',
        'A short daily team meeting',
        'A monthly review',
        'A training session',
      ],
      correctIndex: 1,
      explanation: 'A stand-up is a short (15-min) daily meeting where the team shares progress and blockers.',
    ),
    QuizQuestion(
      question: 'What does "MVP" mean in a tech context?',
      options: ['Most Valuable Player', 'Minimum Viable Product', 'Main Version Plan', 'Managed Value Process'],
      correctIndex: 1,
      explanation: 'MVP = Minimum Viable Product the simplest version of a product that can be released.',
    ),
  ],
};

// ─── FALLBACK QUESTIONS ───────────────────────────────
const List<QuizQuestion> fallbackQuestions = [
  QuizQuestion(
    question: 'What does "stakeholder" mean in business?',
    options: [
      'A steak restaurant owner',
      'Anyone with an interest in a company\'s decisions',
      'A financial investor only',
      'A company\'s CEO',
    ],
    correctIndex: 1,
    explanation: 'A stakeholder is anyone affected by or with an interest in the company employees, clients, investors, etc.',
  ),
  QuizQuestion(
    question: 'What is "KPI"?',
    options: ['Key Performance Indicator', 'Keep Planning It', 'Knowledge Production Index', 'Known Profit Income'],
    correctIndex: 0,
    explanation: 'KPI = Key Performance Indicator a measurable value showing how effectively goals are being met.',
  ),
  QuizQuestion(
    question: 'What does "synergy" mean in business?',
    options: [
      'A new software tool',
      'Two entities producing more together than separately',
      'A type of company merger',
      'A financial report',
    ],
    correctIndex: 1,
    explanation: 'Synergy = the idea that combined efforts produce a result greater than the sum of individual parts.',
  ),
];

// ─── QUIZ SCREEN ─────────────────────────────────────
class GameQuizScreen extends StatefulWidget {
  final Lesson lesson;
  final Department dept;

  const GameQuizScreen({super.key, required this.lesson, required this.dept});

  @override
  State<GameQuizScreen> createState() => _GameQuizScreenState();
}

class _GameQuizScreenState extends State<GameQuizScreen>
    with TickerProviderStateMixin {

  late List<QuizQuestion> questions;
  int _current = 0;
  int? _selected;
  bool _answered = false;
  int _score = 0;
  bool _finished = false;

  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;
  late AnimationController _progressController;
  late AnimationController _correctPopController;
  late Animation<double> _correctScale;
  late Animation<double> _correctFade;
  bool _showCorrectPop = false;

  late AnimationController _wrongPopController;
  late Animation<double> _wrongScale;
  late Animation<double> _wrongFade;
  bool _showWrongPop = false;

  @override
  void initState() {
    super.initState();
    questions = lessonQuestions[widget.lesson.name] ?? fallbackQuestions;

    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _feedbackScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 0,
    );
    _progressController.animateTo(1 / questions.length);

    // Correct answer celebration pop
    _correctPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _correctScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _correctPopController, curve: Curves.elasticOut),
    );
    _correctFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _correctPopController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // Wrong answer sad pop
    _wrongPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _wrongScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _wrongPopController, curve: Curves.easeOutBack),
    );
    _wrongFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _wrongPopController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _progressController.dispose();
    _correctPopController.dispose();
    _wrongPopController.dispose();
    super.dispose();
  }

  void _select(int idx) {
    if (_answered) return;
    final isCorrect = idx == questions[_current].correctIndex;
    setState(() {
      _selected = idx;
      _answered = true;
      if (isCorrect) _score++;
    });
    _feedbackController.forward(from: 0);

    if (isCorrect) {
      // Confetti Koko pop
      setState(() => _showCorrectPop = true);
      _correctPopController.forward(from: 0).then((_) {
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            _correctPopController.reverse().then((_) {
              if (mounted) setState(() => _showCorrectPop = false);
            });
          }
        });
      });
    } else {
      // Sad Koko pop
      setState(() => _showWrongPop = true);
      _wrongPopController.forward(from: 0).then((_) {
        Future.delayed(const Duration(milliseconds: 900), () {
          if (mounted) {
            _wrongPopController.reverse().then((_) {
              if (mounted) setState(() => _showWrongPop = false);
            });
          }
        });
      });
    }
  }

  void _next() {
    if (_current + 1 >= questions.length) {
      // Quiz terminé → persister score + XP
      DeptProgress.setTestScore(
          widget.dept.id, _score, questions.length);
      UserProgress.addXp(_score * 15);
      setState(() => _finished = true);
    } else {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
      _progressController.animateTo((_current + 1) / questions.length);
      _feedbackController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08051A), Color(0xFF130D35)],
              ),
            ),
          ),
          SafeArea(
            child: _finished ? _buildResults() : _buildQuestion(),
          ),

          // ── Correct answer celebration overlay
          if (_showCorrectPop)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: FadeTransition(
                    opacity: _correctFade,
                    child: ScaleTransition(
                      scale: _correctScale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/koko_correct.png',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, e, _) =>
                                const Icon(Icons.celebration_rounded, size: 100, color: Color(0xFF4ECDA0)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ECDA0),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4ECDA0).withValues(alpha: 0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Correct!',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // ── Wrong answer sad overlay
          if (_showWrongPop)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: FadeTransition(
                    opacity: _wrongFade,
                    child: ScaleTransition(
                      scale: _wrongScale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/koko_wrong.png',
                            width: 190,
                            height: 190,
                            fit: BoxFit.contain,
                            errorBuilder: (ctx, e, _) =>
                                const Icon(Icons.sentiment_dissatisfied_rounded, size: 100, color: Color(0xFFFF6B6B)),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.45),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Text(
                              'Not quite!',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildQuestion() {
    final q = questions[_current];
    final dept = widget.dept;
    final isCorrect = _answered && _selected == q.correctIndex;

    return Column(
      children: [
        // ── Top bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (ctx, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _progressController.value,
                      minHeight: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation(dept.color),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_current + 1}/${questions.length}',
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

        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // ── Koko + question
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/koko.png',
                      width: 48, height: 48,
                      errorBuilder: (ctx, e, _) =>
                          const Icon(Icons.pets, size: 36, color: Colors.white54),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                        ),
                        child: Text(
                          q.question,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Options
                ...q.options.asMap().entries.map((e) {
                  final i = e.key;
                  final opt = e.value;
                  final isThisCorrect = i == q.correctIndex;
                  final isThisSelected = i == _selected;

                  Color borderColor = Colors.white.withValues(alpha: 0.1);
                  Color bgColor = Colors.white.withValues(alpha: 0.03);
                  Color textColor = Colors.white;

                  if (_answered) {
                    if (isThisCorrect) {
                      borderColor = const Color(0xFF4ECDA0);
                      bgColor = const Color(0xFF4ECDA0).withValues(alpha: 0.12);
                      textColor = const Color(0xFF4ECDA0);
                    } else if (isThisSelected) {
                      borderColor = const Color(0xFFFF6B6B);
                      bgColor = const Color(0xFFFF6B6B).withValues(alpha: 0.1);
                      textColor = const Color(0xFFFF6B6B);
                    }
                  }

                  return GestureDetector(
                    onTap: () => _select(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _answered && isThisCorrect
                                  ? const Color(0xFF4ECDA0).withValues(alpha: 0.2)
                                  : _answered && isThisSelected
                                      ? const Color(0xFFFF6B6B).withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.06),
                              border: Border.all(color: borderColor),
                            ),
                            child: Center(
                              child: _answered
                                  ? Icon(
                                      isThisCorrect
                                          ? Icons.check_rounded
                                          : isThisSelected
                                              ? Icons.close_rounded
                                              : null,
                                      size: 14,
                                      color: textColor,
                                    )
                                  : Text(
                                      String.fromCharCode(65 + i),
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                        color: Colors.white.withValues(alpha: 0.5),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // ── Feedback
                if (_answered) ...[
                  const SizedBox(height: 16),
                  ScaleTransition(
                    scale: _feedbackScale,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? const Color(0xFF4ECDA0).withValues(alpha: 0.10)
                            : const Color(0xFFFF6B6B).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFF4ECDA0).withValues(alpha: 0.35)
                              : const Color(0xFFFF6B6B).withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle_rounded : Icons.lightbulb_outline_rounded,
                            size: 20,
                            color: isCorrect ? const Color(0xFF4ECDA0) : const Color(0xFFFF6B6B),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCorrect ? 'Correct!' : 'Not quite!',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                    color: isCorrect
                                        ? const Color(0xFF4ECDA0)
                                        : const Color(0xFFFF6B6B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  q.explanation,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.65),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // ── Next / Check button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _answered ? _next : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.06),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.25),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Ink(
                decoration: _answered
                    ? BoxDecoration(
                        gradient: LinearGradient(
                          colors: [dept.color, KokoColors.purple],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )
                    : null,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    _answered
                        ? (_current + 1 >= questions.length ? 'See results →' : 'Next →')
                        : 'Choose an answer',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final dept = widget.dept;
    final total = questions.length;
    final pct = _score / total;
    final isPerfect = _score == total;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),

        // Koko reaction
        Image.asset(
          'assets/images/koko.png',
          width: 120, height: 120,
          errorBuilder: (ctx, e, _) =>
              Icon(isPerfect ? Icons.celebration_rounded : Icons.pets,
                  size: 80, color: isPerfect ? const Color(0xFF4ECDA0) : Colors.white54),
        ),
        const SizedBox(height: 16),

        Text(
          isPerfect
              ? 'Perfect score!'
              : pct >= 0.6
                  ? 'Well done!'
                  : 'Keep going!',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$_score out of $total correct',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),

        const SizedBox(height: 32),

        // Score ring
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: pct,
                strokeWidth: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation(dept.color),
                strokeCap: StrokeCap.round,
              ),
              Text(
                '${(pct * 100).round()}%',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  color: dept.color,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // XP earned
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          decoration: BoxDecoration(
            color: KokoColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KokoColors.gold.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt_rounded, size: 20, color: KokoColors.gold),
              const SizedBox(width: 8),
              Text(
                '+${(_score * 20)} XP earned!',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: KokoColors.gold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [dept.color, KokoColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '← Back to modules',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _current = 0;
                    _selected = null;
                    _answered = false;
                    _score = 0;
                    _finished = false;
                  });
                  _progressController.animateTo(1 / questions.length);
                },
                child: Text(
                  'Try again',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.35),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
