import 'dart:io' as dart_io;
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/department.dart';
import '../widgets/dept_node_widget.dart';
import '../widgets/jungle_path_painter.dart';
import '../data/dept_progress.dart';
import '../data/user_progress.dart';
import '../data/user_profile.dart';
import 'dept_entry_screen.dart';
import 'intro_screen.dart';
import 'profile_screen.dart';
import '../data/user_profile.dart';

class JungleMapScreen extends StatefulWidget {
  const JungleMapScreen({super.key});

  @override
  State<JungleMapScreen> createState() => _JungleMapScreenState();
}

class _JungleMapScreenState extends State<JungleMapScreen>
    with TickerProviderStateMixin {

  // Koko idle float
  late AnimationController _kokoController;
  late Animation<double> _kokoFloat;
  Offset _kokoPosition = const Offset(260, 90);

  // Path draw animation
  late AnimationController _pathCtrl;
  late Animation<double> _pathAnim;
  int _activeNodeIdx = 0;

  static const List<Offset> nodePositions = [
    Offset(60,  100),
    Offset(220, 290),
    Offset(60,  480),
    Offset(220, 670),
    Offset(60,  860),
    Offset(220, 1050),
  ];

  static const double nodeSize  = 96;
  static const double mapWidth  = 390;
  static const double mapHeight = 1280;

  @override
  void initState() {
    super.initState();

    // Koko idle bob
    _kokoController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _kokoFloat = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _kokoController, curve: Curves.easeInOut),
    );

    // Path draw (0 → 1)
    _pathCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 650),
    );
    _pathAnim = CurvedAnimation(parent: _pathCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _kokoController.dispose();
    _pathCtrl.dispose();
    super.dispose();
  }

  // Sequential unlock: position N is active only if N-1 is itself active/mine
  // AND its test is done. Recursive so old saved data can't skip the chain.
  NodeRole _getRole(int index) {
    final id = _orderedDepts[index].id;
    if (DeptProgress.getStars(id) >= 3) return NodeRole.mine;
    if (index == 0) return NodeRole.active;
    final prevRole = _getRole(index - 1);
    if (prevRole == NodeRole.locked) return NodeRole.locked;
    if (!DeptProgress.isTestDone(_orderedDepts[index - 1].id)) return NodeRole.locked;
    return NodeRole.active;
  }

  List<Department> get _orderedDepts {
    if (UserProfile.focusDept.isEmpty) return allDepartments;
    final idx = allDepartments.indexWhere((d) => d.id == UserProfile.focusDept);
    if (idx <= 0) return allDepartments;
    return [
      allDepartments[idx],
      ...allDepartments.sublist(0, idx),
      ...allDepartments.sublist(idx + 1),
    ];
  }

  void _onDeptTapped(Department dept) {
    final idx = _orderedDepts.indexOf(dept);
    final pos = nodePositions[idx];

    // Move Koko
    setState(() {
      _kokoPosition = Offset(pos.dx + nodeSize + 6, pos.dy + 10);
      _activeNodeIdx = idx;
    });

    // Animate path draw then navigate
    _pathCtrl.forward(from: 0).then((_) {
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (ctx, anim, _) => DeptEntryScreen(dept: dept),
          transitionsBuilder: (ctx, anim, sec, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      // Au retour du département, rafraîchir la carte (nœuds + XP/streak)
      ).then((_) { if (mounted) setState(() {}); });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KokoColors.night,
      body: Stack(
        children: [
          // Background dark gradient base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF08051A), Color(0xFF0D0A2A), Color(0xFF130D35)],
              ),
            ),
          ),
          // Jungle map image at 50% opacity
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/jungle_map_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  onBack: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const IntroScreen()),
                  ),
                  onProfile: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (ctx, anim, _) => const ProfileScreen(),
                      transitionsBuilder: (ctx, anim, sec, child) =>
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: anim, curve: Curves.easeOutCubic)),
                            child: child,
                          ),
                      transitionDuration: const Duration(milliseconds: 350),
                    ),
                  ),
                ),
                Expanded(child: _buildMap()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: mapWidth,
        height: mapHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _pathAnim,
              builder: (context2, child2) => CustomPaint(
                size: const Size(mapWidth, mapHeight),
                painter: JunglePathPainter(
                  nodePositions: nodePositions,
                  departments: _orderedDepts,
                  activeNodeIdx: _activeNodeIdx,
                  pathProgress: _pathAnim.value,
                ),
              ),
            ),

            ...List.generate(_orderedDepts.length, (i) {
              final dept      = _orderedDepts[i];
              final pos       = nodePositions[i];
              final role      = _getRole(i);
              final isFocused = UserProfile.focusDept == dept.id;
              return Positioned(
                left: pos.dx,
                top:  pos.dy,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    DeptNodeWidget(
                      dept: dept, role: role, size: nodeSize,
                      onTap: role == NodeRole.locked ? () {} : () => _onDeptTapped(dept),
                    ),
                    // Étoile focus dept choisi à l'onboarding
                    if (isFocused)
                      Positioned(
                        top: -6, right: -6,
                        child: Container(
                          width: 18, height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5C842),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0E0920), width: 1.5),
                          ),
                          child: const Center(
                            child: Text('★',
                                style: TextStyle(fontSize: 9, color: Colors.black, height: 1)),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),

            // Koko floating character
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              left: _kokoPosition.dx,
              top:  _kokoPosition.dy,
              child: AnimatedBuilder(
                animation: _kokoFloat,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _kokoFloat.value), child: child,
                ),
                child: Image.asset(
                  'assets/images/koko.png',
                  width: 64, height: 64, fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Icon(Icons.pets, size: 52, color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// ─── TOP BAR ─────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onProfile;

  const _TopBar({required this.onBack, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xEE0E0920),
        border: Border(
          bottom: BorderSide(color: KokoColors.teal.withValues(alpha: 0.15)),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
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
              style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 18),
              children: [
                TextSpan(text: 'Koko', style: TextStyle(color: Colors.white)),
                TextSpan(text: '&', style: TextStyle(color: Color(0xFF1BC6C6))),
                TextSpan(text: 'me', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const Spacer(),
          _StatPill(icon: Icons.bolt_rounded, value: UserProgress.xpLabel, color: KokoColors.gold),
          const SizedBox(width: 8),
          _StatPill(icon: Icons.local_fire_department_rounded, value: UserProgress.streakLabel, color: const Color(0xFFFF8050)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onProfile,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: KokoColors.teal.withValues(alpha: 0.2),
              backgroundImage: UserProfile.avatarPath.isNotEmpty
                  ? dart_io.File(UserProfile.avatarPath).existsSync()
                      ? FileImage(dart_io.File(UserProfile.avatarPath))
                      : null
                  : null,
              child: UserProfile.avatarPath.isEmpty
                  ? Text(UserProfile.initial, style: const TextStyle(
                      fontFamily: 'Nunito', fontWeight: FontWeight.w900,
                      fontSize: 12, color: Colors.white,
                    ))
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _StatPill({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Nunito', fontWeight: FontWeight.w800,
            fontSize: 11, color: color,
          ),
        ),
      ],
    ),
  );
}

