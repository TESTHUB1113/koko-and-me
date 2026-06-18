import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/dept_progress.dart';
import '../models/department.dart';

enum NodeRole { mine, active, secondary, locked }

class DeptNodeWidget extends StatefulWidget {
  final Department dept;
  final NodeRole role;
  final double size;
  final VoidCallback onTap;

  const DeptNodeWidget({
    super.key,
    required this.dept,
    required this.role,
    required this.size,
    required this.onTap,
  });

  @override
  State<DeptNodeWidget> createState() => _DeptNodeWidgetState();
}

class _DeptNodeWidgetState extends State<DeptNodeWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.role == NodeRole.mine || widget.role == NodeRole.active) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dept     = widget.dept;
    final role     = widget.role;
    final size     = widget.size;
    final isMine   = role == NodeRole.mine;
    final isLocked = role == NodeRole.locked;

    Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMine) _CrownWidget(color: dept.color),

        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, child) => Transform.scale(
            scale: (role == NodeRole.mine || role == NodeRole.active)
                ? _pulseAnim.value
                : 1.0,
            child: child,
          ),
          child: _NodeBubble(dept: dept, role: role, size: size),
        ),

        const SizedBox(height: 8),

        Text(
          dept.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: isMine ? 12 : 10,
            color: isMine ? dept.color : Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
            height: 1.3,
          ),
        ),

        if (isMine) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: dept.colorDim,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: dept.color.withValues(alpha: 0.3)),
            ),
            child: Text(
              'My path',
              style: TextStyle(
                fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                fontSize: 8, color: dept.color, letterSpacing: 0.5,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 2),
          Text(
            dept.subtitle,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8,
              color: Colors.white.withValues(alpha: 0.4),
              shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),
        ],
      ],
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: size + 20,
        child: isLocked
            ? ColorFiltered(
                colorFilter: const ColorFilter.matrix([
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0,      0,      0,      1, 0,
                ]),
                child: column,
              )
            : column,
      ),
    );
  }
}

// ─── NODE BUBBLE WITH PROGRESS RING ──────────────────────────────────────────
class _NodeBubble extends StatelessWidget {
  final Department dept;
  final NodeRole role;
  final double size;

  const _NodeBubble({required this.dept, required this.role, required this.size});

  @override
  Widget build(BuildContext context) {
    final isMine      = role == NodeRole.mine;
    final isSecondary = role == NodeRole.secondary;
    final isLocked    = role == NodeRole.locked;
    final iconColor   = isMine
        ? dept.color
        : dept.color.withValues(alpha: 0.85);

    // Ring geometry: sits just outside the circle border
    const ringStrokeW = 4.5;
    const ringGap     = 3.0;
    final ringRadius  = size / 2 + ringGap + ringStrokeW / 2;
    final totalSize   = ringRadius * 2;

    final progress = isLocked ? 0.0 : DeptProgress.getProgress(dept.id);

    final bubble = Opacity(
      opacity: isSecondary ? 0.65 : 1.0,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: isLocked
                ? const [Color(0xFF1A1A35), Color(0xFF0E0920)]
                : [dept.colorDim, const Color(0xF00E0920)],
          ),
          border: Border.all(
            color: isMine
                ? dept.color
                : isLocked
                    ? const Color(0xFF3A3A5A)
                    : dept.color.withValues(alpha: 0.55),
            width: isMine ? 3.5 : 2.5,
          ),
          boxShadow: isMine
              ? [
                  BoxShadow(color: dept.color.withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 2),
                  BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
                ]
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 10)],
        ),
        child: Center(
          child: dept.imagePath != null
              ? ClipOval(
                  child: Image.asset(
                    dept.imagePath!,
                    width: isMine ? 62 : 50,
                    height: isMine ? 62 : 50,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, e, _) =>
                        Icon(dept.icon, size: isMine ? 30 : 24, color: iconColor),
                  ),
                )
              : Icon(dept.icon, size: isMine ? 30 : 24, color: iconColor),
        ),
      ),
    );

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(totalSize, totalSize),
            painter: _ProgressRingPainter(
              progress: progress,
              color: isLocked ? const Color(0xFF3A3A5A) : dept.color,
              strokeWidth: ringStrokeW,
            ),
          ),
          bubble,
        ],
      ),
    );
  }
}

// ─── PROGRESS RING PAINTER ────────────────────────────────────────────────────
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color  color;
  final double strokeWidth;

  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect   = Rect.fromCircle(center: center, radius: radius);

    // Faint background track
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Filled progress arc (clockwise from top)
    if (progress > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter old) =>
      old.progress != progress || old.color != color;
}

// ─── CROWN ────────────────────────────────────────────────────────────────────
class _CrownWidget extends StatefulWidget {
  final Color color;
  const _CrownWidget({required this.color});

  @override
  State<_CrownWidget> createState() => _CrownWidgetState();
}

class _CrownWidgetState extends State<_CrownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _bounce,
    builder: (ctx, child) => Transform.translate(
      offset: Offset(0, _bounce.value),
      child: Icon(
        Icons.workspace_premium_rounded,
        size: 20,
        color: widget.color,
        shadows: [Shadow(color: widget.color.withValues(alpha: 0.6), blurRadius: 8)],
      ),
    ),
  );
}
