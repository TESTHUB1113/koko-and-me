import 'package:flutter/material.dart';
import '../models/department.dart';
import '../widgets/dept_node_widget.dart';

class DeptBottomSheet extends StatelessWidget {
  final Department dept;
  final NodeRole role;

  const DeptBottomSheet({super.key, required this.dept, required this.role});

  @override
  Widget build(BuildContext context) {
    final isMine   = role == NodeRole.mine;
    final isLocked = role == NodeRole.locked;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0920),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      padding: EdgeInsets.only(
        left: 22, right: 22, top: 6,
        bottom: MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4, margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: dept.colorDim,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: dept.color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(dept.icon, size: 13, color: dept.color),
                const SizedBox(width: 6),
                Text(
                  dept.label,
                  style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                    fontSize: 11, color: dept.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Text(
            dept.label,
            style: const TextStyle(
              fontFamily: 'Nunito', fontWeight: FontWeight.w900,
              fontSize: 22, color: Colors.white,
            ),
          ),
          Text(
            '${dept.totalLessons} lessons  ·  ${dept.xpEarned > 0 ? '${dept.xpEarned} XP' : '0 XP'}  ·  ${dept.subtitle}',
            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.38)),
          ),

          if (isMine) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: dept.colorDim,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: dept.color.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, size: 18, color: dept.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your main path personalised just for you!',
                      style: TextStyle(
                        fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                        fontSize: 11, color: dept.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Progress bar
          if (dept.doneLessons > 0) ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: dept.progress,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation(dept.color),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${dept.doneLessons}/${dept.totalLessons}',
                  style: TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                    fontSize: 11, color: dept.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Lesson list
          ...dept.lessons.map((lesson) => _LessonRow(lesson: lesson, dept: dept)),

          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLocked ? null : () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: isMine
                    ? dept.color
                    : isLocked
                        ? Colors.white.withValues(alpha: 0.07)
                        : dept.color.withValues(alpha: 0.8),
                foregroundColor: isMine ? const Color(0xFF063030) : Colors.white,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.07),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLocked
                        ? Icons.lock_outline
                        : isMine
                            ? Icons.play_arrow_rounded
                            : Icons.eco_outlined,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isLocked
                        ? 'Module not available yet'
                        : isMine
                            ? 'Continue my path'
                            : 'Explore this module',
                    style: const TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final Department dept;

  const _LessonRow({required this.lesson, required this.dept});

  @override
  Widget build(BuildContext context) {
    final isDone   = lesson.state == LessonState.done;
    final isActive = lesson.state == LessonState.active;

    final bgColor = isDone
        ? const Color(0x134ECDA0)
        : isActive
            ? dept.colorDim
            : Colors.white.withValues(alpha: 0.02);

    final borderColor = isDone
        ? const Color(0x334ECDA0)
        : isActive
            ? dept.color.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.05);

    final stateIcon = isDone
        ? Icons.check_circle_rounded
        : isActive
            ? Icons.play_arrow_rounded
            : Icons.lock_outline;
    final stateColor = isDone
        ? const Color(0xFF4ECDA0)
        : isActive
            ? dept.color
            : Colors.white.withValues(alpha: 0.25);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: dept.colorDim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(lesson.icon, size: 17, color: dept.color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.name,
                  style: const TextStyle(
                    fontFamily: 'Nunito', fontWeight: FontWeight.w800,
                    fontSize: 13, color: Colors.white,
                  ),
                ),
                Text(
                  lesson.typeLabel,
                  style: TextStyle(fontSize: 9.5, color: Colors.white.withValues(alpha: 0.38)),
                ),
              ],
            ),
          ),
          Icon(stateIcon, size: 16, color: stateColor),
        ],
      ),
    );
  }
}
