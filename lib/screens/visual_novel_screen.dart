import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../data/dept_progress.dart';
import '../data/vn_data.dart';
import '../models/department.dart';

// ─── VISUAL NOVEL SCREEN ──────────────────────────────────────────────────────
// Same logic as koko_management_full_vn.html ported to Flutter/Dart.
// Scenes advance linearly; highlighted words reveal vocab cards; choice scenes
// have A/B/C buttons with feedback before continuing.
class VisualNovelScreen extends StatefulWidget {
  final Department dept;
  final List<VnScene> scenes;

  const VisualNovelScreen({
    super.key,
    required this.dept,
    required this.scenes,
  });

  @override
  State<VisualNovelScreen> createState() => _VisualNovelScreenState();
}

class _VisualNovelScreenState extends State<VisualNovelScreen>
    with SingleTickerProviderStateMixin {
  int _cur = 0;
  int? _shownVocabIdx;
  String? _pickedChoice;
  bool _choiceDone = false;
  int _earnedXP = 0;
  bool _showEnd = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  VnScene get _scene => widget.scenes[_cur];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _go(int idx) {
    if (idx < 0 || idx >= widget.scenes.length) return;
    _fadeCtrl.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _cur = idx;
        _shownVocabIdx = null;
        _pickedChoice = null;
        _choiceDone = false;
      });
      _fadeCtrl.forward();
    });
  }

  void _pickChoice(String id) {
    if (_choiceDone) return;
    final r = _scene.results?[id];
    if (r == null) return;
    setState(() {
      _pickedChoice = id;
      _choiceDone = true;
      if (r.xp > 0) _earnedXP = r.xp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0817),
      body: SafeArea(
        child: _showEnd ? _buildEnd() : _buildVN(),
      ),
    );
  }

  // ── VN layout ───────────────────────────────────────────────────────────────
  Widget _buildVN() {
    return FadeTransition(
      opacity: _fade,
      child: Column(
        children: [
          _statusBar(),
          _sceneArea(),
          _progressDots(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dialogue(),
                  _vocabCard(),
                  _scene.isChoice ? _choices() : _actions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status bar ──────────────────────────────────────────────────────────────
  Widget _statusBar() {
    return Container(
      color: const Color(0xFF0A0817),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF26215C), width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF7F77DD)),
            ),
          ),
          const Spacer(),
          Text(
            'Scene ${_cur + 1} / ${widget.scenes.length}',
            style: const TextStyle(
              fontSize: 10, color: Color(0xFF3C3489), letterSpacing: 0.08,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 30), // balance
        ],
      ),
    );
  }

  // ── Scene area (background + tags + koko sprite) ────────────────────────────
  Widget _sceneArea() {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: [
          // Fond de scène dégradé propre à chaque type de lieu (VnBg)
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _sceneColors(widget.scenes[_cur].bg),
                ),
              ),
            ),
          ),
          // Subtle dark vignette so text tags stay readable
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
          ),
          // Location tag
          Positioned(
            top: 10, left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xDD0A0817),
                border: Border.all(color: const Color(0xFF3C3489), width: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _scene.location,
                style: const TextStyle(
                  fontSize: 9, color: Color(0xFF7F77DD),
                  fontWeight: FontWeight.w500, letterSpacing: 0.04,
                ),
              ),
            ),
          ),
          // Chapter tag
          Positioned(
            top: 10, right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xCC26215C),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _scene.chapter,
                style: const TextStyle(
                  fontSize: 9, color: Color(0xFFAFA9EC), fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Koko character always bottom-right, slightly larger when speaking
          Positioned(
            bottom: 0, right: 12,
            child: Image.asset(
              'assets/images/koko_char.png',
              height: _scene.speaker == 'Koko' ? 180 : 150,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // ── Scene background colours (one gradient per VnBg) ────────────────────────
  List<Color> _sceneColors(VnBg bg) {
    switch (bg) {
      // ── Management deep navy / slate blues
      case VnBg.elevator:       return [const Color(0xFF0D1B3E), const Color(0xFF1A2F5A)];
      case VnBg.boardroom:      return [const Color(0xFF0A1628), const Color(0xFF0E2244)];
      case VnBg.boardroomTense: return [const Color(0xFF0E0A1E), const Color(0xFF1C1240)];
      case VnBg.corridor:       return [const Color(0xFF111828), const Color(0xFF1C2A40)];
      case VnBg.kitchen:        return [const Color(0xFF162030), const Color(0xFF1F3048)];
      case VnBg.office:         return [const Color(0xFF0C1830), const Color(0xFF162645)];
      case VnBg.allHands:       return [const Color(0xFF091525), const Color(0xFF14263C)];
      case VnBg.elevatorEnd:    return [const Color(0xFF0D1B3E), const Color(0xFF1B3060)];

      // ── Marketing warm amber / burnt orange
      case VnBg.mktOpenSpace:      return [const Color(0xFF2A1500), const Color(0xFF3D2000)];
      case VnBg.mktCampaignWall:   return [const Color(0xFF2E1800), const Color(0xFF4A2800)];
      case VnBg.mktCampaignTense:  return [const Color(0xFF1C0E00), const Color(0xFF2E1600)];
      case VnBg.mktWhiteboard:     return [const Color(0xFF261200), const Color(0xFF3C1E00)];
      case VnBg.mktAnalytics:      return [const Color(0xFF201000), const Color(0xFF341A00)];
      case VnBg.mktMeeting:        return [const Color(0xFF241400), const Color(0xFF382000)];
      case VnBg.mktRooftop:        return [const Color(0xFF341C00), const Color(0xFF5A3200)];

      // ── Accounting / Finance floors blue-green / teal
      case VnBg.acctFloor:         return [const Color(0xFF001A1A), const Color(0xFF002C2C)];
      case VnBg.acctLedger:        return [const Color(0xFF001818), const Color(0xFF003030)];
      case VnBg.acctLedgerTense:   return [const Color(0xFF000E10), const Color(0xFF001C20)];
      case VnBg.acctWhiteboard:    return [const Color(0xFF001C1C), const Color(0xFF003434)];
      case VnBg.acctAuditRoom:     return [const Color(0xFF00100E), const Color(0xFF001E1C)];
      case VnBg.acctDesk:          return [const Color(0xFF001818), const Color(0xFF002828)];
      case VnBg.acctMeeting:       return [const Color(0xFF001616), const Color(0xFF002828)];
      case VnBg.acctArchive:       return [const Color(0xFF000E0E), const Color(0xFF001C1C)];

      // ── Legal dark burgundy / mahogany
      case VnBg.legalFloor:          return [const Color(0xFF1A0208), const Color(0xFF2C0410)];
      case VnBg.legalContractDesk:   return [const Color(0xFF1C0208), const Color(0xFF300412)];
      case VnBg.legalNDA:            return [const Color(0xFF140208), const Color(0xFF240310)];
      case VnBg.legalGDPR:           return [const Color(0xFF120106), const Color(0xFF200210)];
      case VnBg.legalMeeting:        return [const Color(0xFF180208), const Color(0xFF2A0410)];
      case VnBg.legalDueDiligence:   return [const Color(0xFF100106), const Color(0xFF1C0210)];
      case VnBg.legalPartnerOffice:  return [const Color(0xFF1A0408), const Color(0xFF2E060E)];
      case VnBg.legalAfterWork:      return [const Color(0xFF0E0204), const Color(0xFF180308)];

      // ── Finance rich blue-green / corporate teal
      case VnBg.finLobby:         return [const Color(0xFF001C28), const Color(0xFF003040)];
      case VnBg.finMeetingRoom:   return [const Color(0xFF001828), const Color(0xFF002C40)];
      case VnBg.finBreakRoom:     return [const Color(0xFF001A2A), const Color(0xFF00324A)];
      case VnBg.finDesk:          return [const Color(0xFF001420), const Color(0xFF002838)];
      case VnBg.finCrisis:        return [const Color(0xFF0A0010), const Color(0xFF180020)];
      case VnBg.finConference:    return [const Color(0xFF001828), const Color(0xFF003040)];
      case VnBg.finMarcusOffice:  return [const Color(0xFF001020), const Color(0xFF002038)];
      case VnBg.finRooftop:       return [const Color(0xFF001C34), const Color(0xFF003458)];

      // ── HR warm violet / plum
      case VnBg.hrFloor:           return [const Color(0xFF1A0A28), const Color(0xFF2C1040)];
      case VnBg.hrRecruit:         return [const Color(0xFF180A26), const Color(0xFF2A1040)];
      case VnBg.hrOnboarding:      return [const Color(0xFF1C0C2A), const Color(0xFF301445)];
      case VnBg.hrCompensation:    return [const Color(0xFF160824), const Color(0xFF280E3C)];
      case VnBg.hrPerformance:     return [const Color(0xFF180A26), const Color(0xFF2C1040)];
      case VnBg.hrDifficultConvo:  return [const Color(0xFF0E0618), const Color(0xFF1A0A28)];
      case VnBg.hrEngagement:      return [const Color(0xFF1C0C2C), const Color(0xFF30144A)];
      case VnBg.hrWrap:            return [const Color(0xFF1A0A28), const Color(0xFF2E1248)];

      // ── Tech dark teal / dark cyan
      case VnBg.techEngFloor:     return [const Color(0xFF001A18), const Color(0xFF002E28)];
      case VnBg.techStandUp:      return [const Color(0xFF001C1A), const Color(0xFF00302C)];
      case VnBg.techArchitecture: return [const Color(0xFF001814), const Color(0xFF002A24)];
      case VnBg.techIncident:     return [const Color(0xFF0A0004), const Color(0xFF180008)];
      case VnBg.techPRReview:     return [const Color(0xFF001A18), const Color(0xFF003028)];
      case VnBg.techRoadmap:      return [const Color(0xFF001C1A), const Color(0xFF003030)];
      case VnBg.techRetro:        return [const Color(0xFF001814), const Color(0xFF002C24)];
      case VnBg.techNightOffice:  return [const Color(0xFF000C0A), const Color(0xFF001410)];
    }
  }

  // ── Progress dots ────────────────────────────────────────────────────────────
  Widget _progressDots() {
    return Container(
      color: const Color(0xFF0A0817),
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.scenes.length, (i) {
          final done = i < _cur;
          final active = i == _cur;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: active ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: done
                  ? const Color(0xFF1D9E75)
                  : active
                      ? const Color(0xFF534AB7)
                      : const Color(0xFF1A1535),
            ),
          );
        }),
      ),
    );
  }

  // ── Dialogue box ─────────────────────────────────────────────────────────────
  Widget _dialogue() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0817),
        border: Border(top: BorderSide(color: Color(0xFF13102A))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Namebox
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: const BoxDecoration(
              color: Color(0xFF13102A),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
            ),
            child: Text(
              _scene.speaker,
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500, color: _scene.speakerColor,
              ),
            ),
          ),
          // Rich text dialogue
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: _richText(),
          ),
        ],
      ),
    );
  }

  Widget _richText() {
    final spans = <InlineSpan>[];
    for (final seg in _scene.segments) {
      if (seg.vocabIdx != null) {
        final idx = seg.vocabIdx!;
        final active = _shownVocabIdx == idx;
        final rec = TapGestureRecognizer()
          ..onTap = () => setState(() {
                _shownVocabIdx = active ? null : idx;
              });
        spans.add(TextSpan(
          text: seg.text,
          recognizer: rec,
          style: TextStyle(
            fontSize: 12.5,
            color: active ? const Color(0xFFCECBF6) : const Color(0xFFAFA9EC),
            backgroundColor: active ? const Color(0xFF26215C) : const Color(0xFF1A1535),
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
            decorationColor: const Color(0xFF534AB7),
            decorationThickness: 1.5,
            height: 1.65,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: seg.text,
          style: TextStyle(
            fontSize: 12.5,
            color: seg.italic ? const Color(0xFFAFA9EC) : const Color(0xFFCECBF6),
            fontStyle: seg.italic ? FontStyle.italic : FontStyle.normal,
            height: 1.65,
          ),
        ));
      }
    }
    return RichText(text: TextSpan(children: spans));
  }

  // ── Vocab card ────────────────────────────────────────────────────────────────
  Widget _vocabCard() {
    final show = _shownVocabIdx != null && _shownVocabIdx! < _scene.vocab.length;
    if (!show) return const SizedBox.shrink();
    final v = _scene.vocab[_shownVocabIdx!];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0D22),
        border: Border.all(color: const Color(0xFF3C3489), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v.term,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF7F77DD))),
          const SizedBox(height: 4),
          Text(v.definition,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF8B84CC), height: 1.5)),
        ],
      ),
    );
  }

  // ── Actions (back / continue) ─────────────────────────────────────────────────
  Widget _actions() {
    final isLast = _scene.isLast;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: _cur > 0 ? () => _go(_cur - 1) : null,
            child: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF0F0D22),
                border: Border.all(color: const Color(0xFF26215C), width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_rounded, size: 18,
                  color: _cur > 0 ? const Color(0xFF7F77DD) : const Color(0xFF26215C)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: isLast ? () {
                DeptProgress.markLessonDone(widget.dept.id);
                setState(() => _showEnd = true);
              } : () => _go(_cur + 1),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF534AB7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    isLast ? 'See results' : 'Tap to continue',
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFEEEDFE),
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

  // ── Choices ────────────────────────────────────────────────────────────────────
  Widget _choices() {
    final choices = _scene.choices!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
      child: Column(
        children: [
          ...choices.map((c) {
            final r = _scene.results?[c.id];
            final picked = _pickedChoice == c.id;
            final showBest = _choiceDone && !picked && (r?.correct == true);

            Color border = const Color(0xFF26215C);
            Color bg     = const Color(0xFF0F0D22);
            Color text   = const Color(0xFFCECBF6);
            Color lBg    = const Color(0xFF1A1535);
            Color lFg    = const Color(0xFF534AB7);

            if (_choiceDone && (picked || showBest)) {
              final good = r?.correct == true;
              border = good ? const Color(0xFF1D9E75) : const Color(0xFF791F1F);
              bg     = good ? const Color(0xFF04342C) : const Color(0xFF1A0808);
              text   = good ? const Color(0xFF9FE1CB) : const Color(0xFFF7C1C1);
              lBg    = good ? const Color(0xFF0F6E56) : const Color(0xFF791F1F);
              lFg    = good ? const Color(0xFF9FE1CB) : const Color(0xFFF7C1C1);
            }

            return GestureDetector(
              onTap: _choiceDone ? null : () => _pickChoice(c.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                decoration: BoxDecoration(
                  color: bg,
                  border: Border.all(color: border, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(color: lBg, shape: BoxShape.circle),
                      child: Center(
                        child: Text(c.id.toUpperCase(),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: lFg)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(c.text,
                          style: TextStyle(fontSize: 12, color: text, height: 1.45)),
                    ),
                  ],
                ),
              ),
            );
          }),

          // Feedback + continue button
          if (_choiceDone && _pickedChoice != null) ...[
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: _scene.results?[_pickedChoice]?.correct == true
                    ? const Color(0xFF04342C)
                    : const Color(0xFF1A0808),
                border: Border.all(
                  color: _scene.results?[_pickedChoice]?.correct == true
                      ? const Color(0xFF0F6E56)
                      : const Color(0xFF791F1F),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _scene.results?[_pickedChoice]?.feedback ?? '',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.55,
                  color: _scene.results?[_pickedChoice]?.correct == true
                      ? const Color(0xFF9FE1CB)
                      : const Color(0xFFF7C1C1),
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _scene.isLast
                  ? () {
                      DeptProgress.markLessonDone(widget.dept.id);
                      setState(() => _showEnd = true);
                    }
                  : () => _go(_cur + 1),
              child: Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF534AB7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Continue →',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFEEEDFE))),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── End screen ─────────────────────────────────────────────────────────────────
  Widget _buildEnd() {
    final xp   = _earnedXP > 0 ? _earnedXP : 120;
    final good = xp >= 100;

    // Collect unique vocab terms learned across all scenes
    final terms = <String>[];
    for (final s in widget.scenes) {
      for (final v in s.vocab) {
        final short = v.term.split('').first.split('–').first.trim();
        // Take first 3 words max
        final chip = short.split(' ').take(3).join(' ');
        if (!terms.contains(chip)) terms.add(chip);
      }
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          children: [
            // XP ring
            Container(
              width: 82, height: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: good ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A), width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$xp',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500,
                          color: good ? const Color(0xFF1D9E75) : const Color(0xFFE24B4A))),
                  Text('XP',
                      style: TextStyle(
                          fontSize: 10,
                          color: good ? const Color(0xFF5DCAA5) : const Color(0xFFFF6B6B))),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (good) ...[
                  Icon(widget.dept.icon, size: 20, color: widget.dept.color),
                  const SizedBox(width: 8),
                ],
                Text(
                  good ? '${widget.dept.label} cleared' : 'Good effort',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFFEEEDFE)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              good
                  ? 'You\'re starting to sound like you belong in that room.'
                  : 'The vocabulary is yours. The instinct will follow Koko never judges.',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF7F77DD), height: 1.55),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Learned vocab chips
            Wrap(
              spacing: 6, runSpacing: 6, alignment: WrapAlignment.center,
              children: terms
                  .map((t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF13102A),
                          border: Border.all(color: const Color(0xFF26215C), width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(t,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF7F77DD))),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF534AB7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Back to the map ←',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFEEEDFE)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
