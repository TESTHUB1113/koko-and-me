import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_profile.dart';
import '../data/user_progress.dart';
import '../services/notification_service.dart';
import 'edit_profile_screen.dart';
import 'intro_screen.dart';
import 'privacy_policy_screen.dart';

// ─── PROFILE COLORS ──────────────────────────────────────────────────────────
const _kBg      = Color(0xFF232337);
const _kCard    = Color(0xFF43435C);
const _kTeal    = Color(0xFF52EBE9);
const _kTealBg  = Color(0xFF0B5E60);
const _kPurple  = Color(0xFF8689E8);
const _kYellow  = Color(0xFFEBB04B);
const _kRed     = Color(0xFFEB4B66);
const _kGray    = Color(0xFF66667E);
const _kText    = Color(0xFFD9D9D9);
const _kGrad1   = Color(0xFF501794);
const _kGrad2   = Color(0xFF3E70A1);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  // Rafraîchir après édition
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final lessons = UserProfile.completedDepts;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            _ProfileTopBar(onSettings: () => _showSettings(context)),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Avatar
                      const SizedBox(height: 28),
                      Center(child: _Avatar()),
                      const SizedBox(height: 20),

                      // ── Nom + sous-titre
                      Center(
                        child: Column(
                          children: [
                            Text(
                              UserProfile.displayName,
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                color: _kTeal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              UserProfile.email.isNotEmpty
                                  ? UserProfile.email
                                  : 'Business English Learner',
                              style: const TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14,
                                color: _kGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Stats card (vraies valeurs)
                      _StatsCard(
                        xp:      UserProgress.xp,
                        streak:  UserProgress.streak,
                        lessons: lessons,
                      ),
                      const SizedBox(height: 24),

                      // ── Achievements
                      const _SectionHeader('Achievements'),
                      const SizedBox(height: 12),
                      const _Badges(),
                      const SizedBox(height: 8),
                      Text(
                        lessons == 0
                            ? 'Complete your first department to earn badges!'
                            : 'Completed $lessons department${lessons > 1 ? "s" : ""}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: _kGray,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Your Progress
                      const _SectionHeader('Your Progress'),
                      const SizedBox(height: 12),
                      const _ChartCard(),
                      const SizedBox(height: 20),

                      // ── Edit Profile + Sign Out buttons
                      _EditButton(onTap: () async {
                        final changed = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                              builder: (_) => const EditProfileScreen()),
                        );
                        if (changed == true) _refresh();
                      }),
                      const SizedBox(height: 12),
                      _SignOutButton(onTap: () => _confirmSignOut(context)),
                      const SizedBox(height: 28),

                      // ── Skill progress bars (progression XP relative)
                      _SkillBar(
                          label: 'Vocabulary',
                          color: _kTeal,
                          progress: _skillProgress(0)),
                      const SizedBox(height: 16),
                      _SkillBar(
                          label: 'Grammar',
                          color: _kYellow,
                          progress: _skillProgress(1)),
                      const SizedBox(height: 16),
                      _SkillBar(
                          label: 'Speaking',
                          color: _kPurple,
                          progress: _skillProgress(2)),
                      const SizedBox(height: 16),
                      _SkillBar(
                          label: 'Writing',
                          color: _kRed,
                          progress: _skillProgress(3)),
                      const SizedBox(height: 28),

                      // ── Friends
                      const _SectionHeader('Friends'),
                      const SizedBox(height: 12),
                      const _FriendsRow(),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Progression simulée basée sur l'XP total (0.0 – 1.0)
  /// Chaque compétence progresse à des vitesses légèrement différentes
  double _skillProgress(int index) {
    if (UserProgress.xp == 0) return 0.0;
    final factors = [1.0, 0.85, 0.70, 0.60];
    final raw = (UserProgress.xp * factors[index]) / 500.0;
    return raw.clamp(0.0, 1.0);
  }

  // ── Settings bottom sheet ─────────────────────────────────────────────────
  void _showSettings(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final initialNotif = prefs.getBool('notif_enabled') ?? true;
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool notifEnabled = initialNotif;
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // ── Notifications toggle
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: notifEnabled ? _kTeal : Colors.white54,
                    size: 22,
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    notifEnabled ? 'Streak reminders at 7 PM' : 'Disabled',
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: Color(0xFF66667E),
                    ),
                  ),
                  trailing: Switch(
                    value: notifEnabled,
                    activeThumbColor: _kTeal,
                    activeTrackColor: _kTeal.withValues(alpha: 0.3),
                    inactiveThumbColor: Colors.white38,
                    inactiveTrackColor: const Color(0xFF3B3B5C),
                    onChanged: (val) async {
                      setSheetState(() => notifEnabled = val);
                      await prefs.setBool('notif_enabled', val);
                      if (val) {
                        await NotificationService.requestPermission();
                        await NotificationService.scheduleStreakReminder();
                      } else {
                        await NotificationService.cancelTodayReminder();
                      }
                    },
                  ),
                ),
                const Divider(color: Color(0xFF3B3B5C), height: 1),
                _SettingsRow(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  subtitle: 'English',
                  onTap: () {},
                ),
                const Divider(color: Color(0xFF3B3B5C), height: 1),
                _SettingsRow(
                  icon: Icons.policy_outlined,
                  label: 'Privacy Policy',
                  subtitle: 'How we use your data',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ));
                  },
                ),
                const Divider(color: Color(0xFF3B3B5C), height: 1),
                _SettingsRow(
                  icon: Icons.logout_rounded,
                  label: 'Sign Out',
                  subtitle: 'Keep your data, just log out',
                  color: _kRed,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _confirmSignOut(context);
                  },
                ),
                const Divider(color: Color(0xFF3B3B5C), height: 1),
                _SettingsRow(
                  icon: Icons.delete_forever_rounded,
                  label: 'Delete Account',
                  subtitle: 'Permanently delete all your data',
                  color: _kRed,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _confirmDeleteAccount(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A45),
        title: const Text('Delete Account?',
            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800, color: Colors.white)),
        content: const Text(
          'This will permanently delete your account and all your data. This cannot be undone.',
          style: TextStyle(fontFamily: 'Nunito', color: Color(0xFFD9D9D9), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel', style: TextStyle(fontFamily: 'Nunito', color: Color(0xFF52EBE9))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(
                fontFamily: 'Nunito', color: Color(0xFFEB4B66), fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await UserProfile.deleteAccount();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const IntroScreen()),
          (_) => false,
        );
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A45),
        title: const Text('Sign Out?',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        content: const Text(
          'You will be logged out. Your progress is saved and will be restored when you sign back in.',
          style: TextStyle(
              fontFamily: 'Nunito', color: Color(0xFFD9D9D9), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(
                    fontFamily: 'Nunito', color: Color(0xFF52EBE9))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign Out',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    color: Color(0xFFEB4B66),
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await UserProfile.signOut();
      } catch (_) {}
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const IntroScreen(isReturning: false)),
          (_) => false,
        );
      }
    }
  }
}

// ─── SIGN OUT BUTTON ─────────────────────────────────────────────────────────
class _SignOutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SignOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kRed.withValues(alpha: 0.6)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 16, color: _kRed.withValues(alpha: 0.8)),
            const SizedBox(width: 8),
            Text('Sign Out',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: _kRed.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }
}

// ─── TOP BAR ─────────────────────────────────────────────────────────────────
class _ProfileTopBar extends StatelessWidget {
  final VoidCallback onSettings;
  const _ProfileTopBar({required this.onSettings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0920),
        border: Border(
          bottom: BorderSide(color: _kTeal.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 14, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                  fontSize: 18),
              children: [
                TextSpan(text: 'koko', style: TextStyle(color: Colors.white)),
                TextSpan(text: '&', style: TextStyle(color: _kTeal)),
                TextSpan(text: 'me', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSettings,
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: _kCard,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.settings_outlined,
                  size: 18, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AVATAR ──────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hasPhoto = UserProfile.avatarPath.isNotEmpty;
    return Container(
      width: 180, height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kPurple,
        boxShadow: [
          BoxShadow(
            color: _kPurple.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: hasPhoto
          ? Image.file(
              dart_io.File(UserProfile.avatarPath),
              width: 180, height: 180,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initialText(),
            )
          : _initialText(),
    );
  }

  Widget _initialText() => Text(
        UserProfile.initial,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w900,
          fontSize: 72,
          color: Colors.white,
        ),
      );
}

// ─── STATS CARD ──────────────────────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  final int xp;
  final int streak;
  final int lessons;
  const _StatsCard(
      {required this.xp, required this.streak, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(value: '$xp', label: 'XP'),
          Container(width: 1, height: 36,
              color: _kGray.withValues(alpha: 0.3)),
          _StatItem(value: '$streak', label: 'Streak'),
          Container(width: 1, height: 36,
              color: _kGray.withValues(alpha: 0.3)),
          _StatItem(value: '$lessons', label: 'Depts'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Nunito', fontSize: 12, color: _kGray)),
      ],
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: _kText));
}

// ─── BADGES ──────────────────────────────────────────────────────────────────
class _Badges extends StatelessWidget {
  const _Badges();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _BadgePill(
            label: 'Advanced',
            color: _kYellow,
            textColor: const Color(0xFF232337)),
        const SizedBox(width: 8),
        _BadgePill(label: 'B2', color: _kRed),
        const SizedBox(width: 8),
        _BadgePill(
            label: 'Business Pro', color: _kTealBg, textColor: _kTeal),
      ],
    );
  }
}

class _BadgePill extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;
  const _BadgePill(
      {required this.label, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(15)),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: textColor ?? Colors.white)),
    );
  }
}

// ─── CHART CARD ──────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: _kCard, borderRadius: BorderRadius.circular(14)),
      child: CustomPaint(
        painter: _ChartPainter(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final d in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                    Text(d,
                        style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 10,
                            color: _kGray)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _kChartPoints = [
  Offset(0.00, 1.00),
  Offset(0.16, 0.77),
  Offset(0.33, 0.25),
  Offset(0.50, 0.00),
  Offset(0.67, 0.68),
  Offset(0.84, 0.47),
  Offset(1.00, 0.47),
];

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const padH = 16.0;
    const padT = 14.0;
    const padB = 26.0;
    final chartW = size.width - padH * 2;
    final chartH = size.height - padT - padB;

    Offset tc(Offset p) =>
        Offset(padH + p.dx * chartW, padT + p.dy * chartH);

    final path = Path();
    path.moveTo(tc(_kChartPoints[0]).dx, tc(_kChartPoints[0]).dy);
    for (int i = 1; i < _kChartPoints.length; i++) {
      final prev = tc(_kChartPoints[i - 1]);
      final curr = tc(_kChartPoints[i]);
      final cp1 = Offset((prev.dx + curr.dx) / 2, prev.dy);
      final cp2 = Offset((prev.dx + curr.dx) / 2, curr.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(
        path,
        Paint()
          ..color = _kTeal
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round);

    final dot = Paint()..color = _kTeal;
    for (final p in _kChartPoints) {
      canvas.drawCircle(tc(p), 3, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ─── EDIT BUTTON ─────────────────────────────────────────────────────────────
class _EditButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_kGrad1, _kGrad2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Text('Edit Profile',
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Colors.white)),
      ),
    );
  }
}

// ─── SKILL BAR ───────────────────────────────────────────────────────────────
class _SkillBar extends StatelessWidget {
  final String label;
  final Color color;
  final double progress;
  const _SkillBar(
      {required this.label, required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: color)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(13.5),
          child: Stack(
            children: [
              Container(
                height: 27,
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(13.5)),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 27,
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(13.5)),
                  alignment: Alignment.center,
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: _kBg),
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

// ─── FRIENDS ROW ─────────────────────────────────────────────────────────────
class _FriendsRow extends StatelessWidget {
  const _FriendsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FriendAvatar(color: const Color(0xFFF9EBA4), label: 'J'),
        const SizedBox(width: 12),
        _FriendAvatar(color: _kTeal, label: 'M'),
        const SizedBox(width: 12),
        _FriendAvatar(color: _kPurple, label: 'S'),
        const SizedBox(width: 12),
        _FriendAvatar(
            color: _kGray.withValues(alpha: 0.3), label: '+4',
            textColor: _kGray),
      ],
    );
  }
}

class _FriendAvatar extends StatelessWidget {
  final Color color;
  final String label;
  final Color? textColor;
  const _FriendAvatar(
      {required this.color, required this.label, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      alignment: Alignment.center,
      child: Text(label,
          style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: textColor ?? const Color(0xFF232337))),
    );
  }
}

// ─── SETTINGS ROW ────────────────────────────────────────────────────────────
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? color;
  final VoidCallback onTap;
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.white;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: c, size: 22),
      title: Text(label,
          style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: c)),
      subtitle: Text(subtitle,
          style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: Color(0xFF66667E))),
      trailing: Icon(Icons.chevron_right_rounded,
          color: Colors.white.withValues(alpha: 0.3), size: 20),
      onTap: onTap,
    );
  }
}
