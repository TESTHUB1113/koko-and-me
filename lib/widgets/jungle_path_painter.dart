import 'package:flutter/material.dart';
import '../models/department.dart';

class JunglePathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final List<Department> departments;
  // Index of the currently selected node (0-based)
  final int activeNodeIdx;
  // 0→1: how far the teal line has drawn toward activeNodeIdx
  final double pathProgress;

  static const double nodeSize = 96;

  JunglePathPainter({
    required this.nodePositions,
    required this.departments,
    this.activeNodeIdx = 0,
    this.pathProgress = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centers = nodePositions
        .map((pos) => Offset(pos.dx + nodeSize / 2, pos.dy + nodeSize / 2))
        .toList();

    final segments = _buildSegments(centers);

    // ── Layer 1: shadow under full path
    for (final seg in segments) {
      canvas.drawPath(seg, Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 26
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round);
    }

    // ── Layer 2: dirt track (full path)
    for (final seg in segments) {
      canvas.drawPath(seg, Paint()
        ..color = const Color(0xFF5D3A1A).withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round);
    }

    // ── Layer 3: dashed white overlay (full path)
    for (final seg in segments) {
      _drawDashedPath(canvas, seg, Colors.white.withValues(alpha: 0.07), 6, 10, 8);
    }

    // ── Layer 4: teal progress path
    final tealPaint = Paint()
      ..color = const Color(0xFF1BC6C6).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final tealGlowPaint = Paint()
      ..color = const Color(0xFF1BC6C6).withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < segments.length; i++) {
      if (i < activeNodeIdx - 1) {
        // Fully completed segments
        canvas.drawPath(segments[i], tealGlowPaint);
        canvas.drawPath(segments[i], tealPaint);
      } else if (i == activeNodeIdx - 1) {
        // Segment currently being animated
        final partial = _extractPartial(segments[i], pathProgress);
        canvas.drawPath(partial, tealGlowPaint);
        canvas.drawPath(partial, tealPaint);
      }
    }

    // ── Node dots
    for (final center in centers) {
      canvas.drawCircle(center, 5,
          Paint()..color = Colors.white.withValues(alpha: 0.12));
    }
  }

  // Build one cubic-bezier Path per adjacent pair of nodes
  List<Path> _buildSegments(List<Offset> centers) {
    final result = <Path>[];
    for (int i = 1; i < centers.length; i++) {
      final prev = centers[i - 1];
      final curr = centers[i];
      final side = (i % 2 == 0) ? 1.0 : -1.0;
      final bulge = 80.0 * side;
      final my = (prev.dy + curr.dy) / 2;
      final path = Path()..moveTo(prev.dx, prev.dy);
      path.cubicTo(
        prev.dx + bulge, my - 20,
        curr.dx - bulge, my + 20,
        curr.dx, curr.dy,
      );
      result.add(path);
    }
    return result;
  }

  // Extract the first t (0→1) portion of a path
  Path _extractPartial(Path path, double t) {
    if (t <= 0) return Path();
    if (t >= 1) return path;
    final metric = path.computeMetrics().first;
    return metric.extractPath(0, metric.length * t);
  }

  void _drawDashedPath(Canvas canvas, Path path, Color color,
      double strokeWidth, double dashLen, double gapLen) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      while (dist < metric.length) {
        final end = (dist + dashLen).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(dist, end),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = StrokeCap.round,
        );
        dist += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(JunglePathPainter old) =>
      old.activeNodeIdx != activeNodeIdx ||
      old.pathProgress != pathProgress ||
      old.nodePositions != nodePositions;
}
