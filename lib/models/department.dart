import 'package:flutter/material.dart';
import '../main.dart';

// ─── LESSON MODEL ────────────────────────────────────
enum LessonState { done, active, locked }
enum LessonType  { lesson, quiz, challenge }

class Lesson {
  final String name;
  final IconData icon;
  final LessonType type;
  final LessonState state;

  const Lesson({
    required this.name,
    required this.icon,
    required this.type,
    this.state = LessonState.locked,
  });

  String get typeLabel {
    switch (type) {
      case LessonType.lesson:    return 'Lesson';
      case LessonType.quiz:      return 'Quiz';
      case LessonType.challenge: return 'Challenge';
    }
  }
}

// ─── DEPARTMENT MODEL ────────────────────────────────
class Department {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String subtitle;
  final List<Lesson> lessons;
  final int xpEarned;
  final String? imagePath;

  const Department({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.lessons,
    this.xpEarned = 0,
    this.imagePath,
  });

  Color get colorDim => color.withValues(alpha: 0.12);
  int get totalLessons => lessons.length;
  int get doneLessons => lessons.where((l) => l.state == LessonState.done).length;
  double get progress => totalLessons > 0 ? doneLessons / totalLessons : 0.0;
  int get stars => progress == 1.0 ? 3 : progress > 0.5 ? 2 : progress > 0 ? 1 : 0;
}

// ─── ALL DEPARTMENTS ─────────────────────────────────
final List<Department> allDepartments = [
  Department(
    id: 'management',
    label: 'Management',
    icon: Icons.bar_chart_rounded,
    color: KokoColors.teal,
    subtitle: 'Leadership & Strategy',
    xpEarned: 180,
    lessons: const [
      Lesson(name: 'Formal Emails',      icon: Icons.mail_outline,        type: LessonType.lesson,    state: LessonState.done),
      Lesson(name: 'Pro Meetings',        icon: Icons.handshake_outlined,  type: LessonType.quiz,      state: LessonState.done),
      Lesson(name: 'Giving Feedback',     icon: Icons.chat_bubble_outline, type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Negotiation',         icon: Icons.balance,             type: LessonType.challenge, state: LessonState.active),
      Lesson(name: 'Presenting KPIs',     icon: Icons.trending_up,         type: LessonType.lesson,    state: LessonState.active),
    ],
  ),
  Department(
    id: 'rh',
    label: 'Human Resources',
    icon: Icons.group_outlined,
    color: KokoColors.purple,
    subtitle: 'Hiring & People Skills',
    xpEarned: 80,
    lessons: const [
      Lesson(name: 'Job Interview',       icon: Icons.mic_none,            type: LessonType.lesson,    state: LessonState.done),
      Lesson(name: 'Onboarding',          icon: Icons.rocket_launch,       type: LessonType.quiz,      state: LessonState.active),
      Lesson(name: 'Performance Review',  icon: Icons.bar_chart_rounded,   type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Conflict Resolution', icon: Icons.spa_outlined,        type: LessonType.challenge, state: LessonState.active),
    ],
  ),
  Department(
    id: 'finance',
    label: 'Finance',
    icon: Icons.account_balance_wallet_outlined,
    color: KokoColors.gold,
    subtitle: 'Reports & Budgets',
    lessons: const [
      Lesson(name: 'Budget Meetings',   icon: Icons.assignment_outlined,   type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Financial Reports', icon: Icons.bar_chart_rounded,     type: LessonType.quiz,      state: LessonState.active),
      Lesson(name: 'Financial KPIs',    icon: Icons.gps_fixed,             type: LessonType.challenge, state: LessonState.active),
      Lesson(name: 'Invoice & Billing', icon: Icons.receipt_long_outlined, type: LessonType.lesson,    state: LessonState.active),
    ],
  ),
  Department(
    id: 'marketing',
    label: 'Marketing',
    icon: Icons.campaign_outlined,
    color: const Color(0xFFFF6B9D),
    subtitle: 'Campaigns & Pitch',
    lessons: const [
      Lesson(name: 'Pitch Deck',         icon: Icons.mic_none,            type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Brand Storytelling', icon: Icons.auto_awesome,        type: LessonType.quiz,      state: LessonState.active),
      Lesson(name: 'Social Media Copy',  icon: Icons.phone_android,       type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Campaign Brief',     icon: Icons.rocket_launch,       type: LessonType.challenge, state: LessonState.active),
    ],
  ),
  Department(
    id: 'tech',
    label: 'Tech & IT',
    icon: Icons.laptop_outlined,
    color: const Color(0xFF4ECDA0),
    subtitle: 'Dev, Agile & Product',
    lessons: const [
      Lesson(name: 'Agile Meetings',    icon: Icons.sync,                type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Technical Writing', icon: Icons.edit_note,           type: LessonType.quiz,      state: LessonState.active),
      Lesson(name: 'Code Review Comms', icon: Icons.code,                type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'Product Pitch',     icon: Icons.lightbulb_outline,   type: LessonType.challenge, state: LessonState.active),
    ],
  ),
  Department(
    id: 'legal',
    label: 'Legal',
    icon: Icons.balance,
    color: const Color(0xFF9B8EC4),
    subtitle: 'Contracts & Compliance',
    lessons: const [
      Lesson(name: 'Contract Language', icon: Icons.description_outlined, type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'GDPR Basics',       icon: Icons.lock_outline,         type: LessonType.quiz,      state: LessonState.active),
      Lesson(name: 'Legal Emails',      icon: Icons.mail_outline,         type: LessonType.lesson,    state: LessonState.active),
      Lesson(name: 'NDAs',              icon: Icons.handshake_outlined,   type: LessonType.challenge, state: LessonState.active),
    ],
  ),
];
