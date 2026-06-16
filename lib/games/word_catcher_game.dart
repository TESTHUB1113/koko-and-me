import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

// ─── WORD CATCHER GAME (Flame) ───────────────────────────────────────────────
// Words float upward as bubbles. Tap the one matching the definition shown.
class WordCatcherGame extends FlameGame {
  final List<Map<String, String>> vocab;   // [{word, def}, ...]
  final Color deptColor;

  final ValueNotifier<String> definitionNotifier;
  final ValueNotifier<int>    livesNotifier;
  final ValueNotifier<int>    scoreNotifier;
  final VoidCallback          onGameOver;

  static const int totalRounds = 8;
  static const int startingLives = 3;

  int _round = 0;
  String _targetWord = '';
  bool _roundActive = false;
  final Random _rng = Random();

  static const List<Color> _bubbleColors = [
    Color(0xFF1BC6C6),
    Color(0xFF7B5EA7),
    Color(0xFFFF6B9D),
    Color(0xFF4ECDA0),
  ];

  WordCatcherGame({
    required this.vocab,
    required this.deptColor,
    required this.definitionNotifier,
    required this.livesNotifier,
    required this.scoreNotifier,
    required this.onGameOver,
  });

  @override
  Color backgroundColor() => const Color(0xFF08051A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _startRound();
  }

  void _startRound() {
    if (_round >= min(vocab.length, totalRounds)) {
      onGameOver();
      return;
    }

    final pair = vocab[_round % vocab.length];
    _targetWord = pair['word']!;
    definitionNotifier.value = pair['def']!;

    // Distractor words from other pairs
    final others = vocab
        .map((p) => p['word']!)
        .where((w) => w != _targetWord)
        .toList()
      ..shuffle(_rng);
    final words = [_targetWord, ...others.take(3)]..shuffle(_rng);

    // Spawn bubbles at equal x intervals with random y offsets
    for (var i = 0; i < words.length; i++) {
      final xFraction = (i + 0.5) / 4;
      final startY = size.y + 60 + _rng.nextDouble() * 80;
      add(WordBubble(
        word: words[i],
        isCorrect: words[i] == _targetWord,
        position: Vector2(size.x * xFraction, startY),
        bubbleColor: _bubbleColors[i % _bubbleColors.length],
        game: this,
      ));
    }

    _roundActive = true;
  }

  void onBubbleTapped(WordBubble bubble) {
    if (!_roundActive) return;

    if (bubble.isCorrect) {
      scoreNotifier.value++;
      _roundActive = false;
      bubble.celebrate();
      Future.delayed(const Duration(milliseconds: 700), () {
        removeWhere((c) => c is WordBubble);
        _round++;
        _startRound();
      });
    } else {
      bubble.wrongFeedback();
      livesNotifier.value--;
      if (livesNotifier.value <= 0) {
        _roundActive = false;
        Future.delayed(const Duration(milliseconds: 500), onGameOver);
      }
    }
  }

  void onBubbleEscaped(WordBubble bubble) {
    if (!_roundActive) return;
    if (bubble.isCorrect) {
      livesNotifier.value--;
      _roundActive = false;
      removeWhere((c) => c is WordBubble);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (livesNotifier.value <= 0) {
          onGameOver();
        } else {
          _startRound();
        }
      });
    } else {
      remove(bubble);
    }
  }
}

// ─── WORD BUBBLE COMPONENT ───────────────────────────────────────────────────
class WordBubble extends PositionComponent with TapCallbacks {
  final String word;
  final bool isCorrect;
  final Color bubbleColor;
  final WordCatcherGame game;

  static const double radius = 50.0;
  static const double speed  = 65.0;   // pixels/sec upward

  bool _celebrating = false;
  bool _wrong = false;
  double _wrongTimer = 0;
  double _scaleAnim = 1.0;

  late final CircleComponent _circle;
  late final TextComponent _label;

  WordBubble({
    required this.word,
    required this.isCorrect,
    required Vector2 position,
    required this.bubbleColor,
    required this.game,
  }) : super(
          position: position,
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Bubble background
    _circle = CircleComponent(
      radius: radius,
      paint: Paint()
        ..color = bubbleColor.withValues(alpha: 0.75)
        ..style = PaintingStyle.fill,
    );

    // Bubble border
    final border = CircleComponent(
      radius: radius,
      paint: Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Word label centred in bubble
    _label = TextComponent(
      text: word,
      anchor: Anchor.center,
      position: Vector2(radius, radius),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          fontFamily: 'Nunito',
          shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
        ),
      ),
    );

    addAll([_circle, border, _label]);
  }

  @override
  bool containsLocalPoint(Vector2 point) =>
      point.distanceTo(Vector2(radius, radius)) <= radius;

  @override
  void update(double dt) {
    super.update(dt);

    // Wrong flash
    if (_wrong) {
      _wrongTimer += dt;
      _circle.paint.color = Colors.red.shade400.withValues(alpha: 0.8);
      if (_wrongTimer > 0.5) {
        _wrong = false;
        _wrongTimer = 0;
        _circle.paint.color = bubbleColor.withValues(alpha: 0.75);
      }
      return;
    }

    // Celebration scale pulse
    if (_celebrating) {
      _scaleAnim += dt * 3;
      final s = 1.0 + 0.15 * sin(_scaleAnim * pi);
      scale = Vector2.all(s);
      return;
    }

    // Float upward
    position.y -= speed * dt;

    if (position.y < -radius * 2) {
      game.onBubbleEscaped(this);
    }
  }

  @override
  void onTapDown(TapDownEvent event) => game.onBubbleTapped(this);

  void celebrate() {
    _celebrating = true;
    _circle.paint.color = Colors.greenAccent.withValues(alpha: 0.9);
  }

  void wrongFeedback() {
    _wrong = true;
    _wrongTimer = 0;
  }
}
