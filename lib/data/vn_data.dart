import 'package:flutter/material.dart';

// ─── ENUMS & MODELS ───────────────────────────────────────────────────────────

enum VnBg {
  // Management
  elevator, boardroom, boardroomTense, corridor, kitchen, office, allHands, elevatorEnd,
  // Marketing
  mktOpenSpace, mktCampaignWall, mktCampaignTense, mktWhiteboard, mktAnalytics, mktMeeting, mktRooftop,
  // Accounting
  acctFloor, acctLedger, acctLedgerTense, acctWhiteboard, acctAuditRoom, acctDesk, acctMeeting, acctArchive,
  // Legal
  legalFloor, legalContractDesk, legalNDA, legalGDPR, legalMeeting, legalDueDiligence, legalPartnerOffice, legalAfterWork,
  // Finance
  finLobby, finMeetingRoom, finBreakRoom, finDesk, finCrisis, finConference, finMarcusOffice, finRooftop,
  // HR
  hrFloor, hrRecruit, hrOnboarding, hrCompensation, hrPerformance, hrDifficultConvo, hrEngagement, hrWrap,
  // Tech
  techEngFloor, techStandUp, techArchitecture, techIncident, techPRReview, techRoadmap, techRetro, techNightOffice,
}

/// One piece of dialogue plain text, italic, or a tappable vocab highlight.
class VnSegment {
  final String text;
  final bool italic;
  final int? vocabIdx; // tapping reveals vocab[vocabIdx]
  const VnSegment(this.text, {this.italic = false, this.vocabIdx});
}

class VnVocab {
  final String term;
  final String definition;
  const VnVocab(this.term, this.definition);
}

class VnSprite {
  final String role; // 'you' or 'koko'
  final double x;   // left offset in 360-wide scene
  final bool flip;
  const VnSprite({required this.role, required this.x, this.flip = false});
}

class VnChoice {
  final String id;
  final String text;
  const VnChoice(this.id, this.text);
}

class VnResult {
  final bool correct;
  final String feedback;
  final int xp;
  const VnResult({required this.correct, required this.feedback, this.xp = 0});
}

class VnScene {
  final String location;
  final String chapter;
  final VnBg bg;
  final List<VnSprite> sprites;
  final String speaker;
  final Color speakerColor;
  final List<VnSegment> segments;
  final List<VnVocab> vocab;
  final List<VnChoice>? choices;
  final Map<String, VnResult>? results;
  final bool isLast;

  const VnScene({
    required this.location,
    required this.chapter,
    required this.bg,
    required this.sprites,
    required this.speaker,
    required this.speakerColor,
    required this.segments,
    this.vocab = const [],
    this.choices,
    this.results,
    this.isLast = false,
  });

  bool get isChoice => choices != null;
}

// ─── MANAGEMENT (9 scenes) ────────────────────────────────────────────────────

const List<VnScene> managementScenes = [
  // 0 Elevator arrival
  VnScene(
    location: 'Elevator · Floor 12',
    chapter: 'Act I Arrival',
    bg: VnBg.elevator,
    sprites: [
      VnSprite(role: 'you', x: 40),
      VnSprite(role: 'koko', x: 210, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 12. Management.\n'),
      VnSegment('"This is where everything gets decided," ', italic: true),
      VnSegment('Koko says, eyes on the numbers ticking up. '),
      VnSegment('"Not what you build what you bet on."', italic: true),
      VnSegment('\nThe doors open before you can answer.'),
    ],
  ),

  // 1 Boardroom chaos
  VnScene(
    location: 'Boardroom · Strategy Review',
    chapter: 'Act I The meeting',
    bg: VnBg.boardroom,
    sprites: [
      VnSprite(role: 'you', x: 32),
      VnSprite(role: 'koko', x: 210, flip: true),
    ],
    speaker: 'You',
    speakerColor: Color(0xFFAFA9EC),
    segments: [
      VnSegment('The meeting is already running. Slides. Numbers. Words you\'ve never heard drop like rain.\n'),
      VnSegment('OKRs', vocabIdx: 0),
      VnSegment('. '),
      VnSegment('KPIs', vocabIdx: 1),
      VnSegment('. '),
      VnSegment('Board deck', vocabIdx: 2),
      VnSegment('. You sit down quietly. Koko watches your face and says nothing yet.'),
    ],
    vocab: [
      VnVocab('OKR Objectives & Key Results',
          'A goal with a scoreboard. The Objective is the direction. The Key Results are 2–4 numbers that prove you got there.'),
      VnVocab('KPI Key Performance Indicator',
          'The number that tells you at a glance whether a part of the business is healthy or struggling.'),
      VnVocab('Board deck',
          'The quarterly presentation to the board of directors. No fluff pure strategy, numbers, risk. Things get approved or killed here.'),
    ],
  ),

  // 2 The hot seat (choice)
  VnScene(
    location: 'Boardroom · Silence',
    chapter: 'Act I The hot seat',
    bg: VnBg.boardroomTense,
    sprites: [
      VnSprite(role: 'you', x: 145),
    ],
    speaker: 'Director',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"What do you think about our '),
      VnSegment('OKR attainment rate', vocabIdx: 0),
      VnSegment(' this quarter?"\n\nThe room looks at you. Koko looks at you. You feel every second.'),
    ],
    vocab: [
      VnVocab('OKR attainment rate',
          'The % of Key Results actually achieved. 70% is common 100% might mean your goals weren\'t ambitious enough.'),
    ],
    choices: [
      VnChoice('a', '"It looks… good? I think the numbers are solid."'),
      VnChoice('b', '"I\'d need more context on the targets to give a real answer."'),
      VnChoice('c', '"Sorry could you clarify what you mean by attainment?"'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko (whispering): "Never bluff in Management. They\'ll test you on it next." But it\'s OK. This is how you learn.'),
      'b': VnResult(correct: true,
          feedback: 'Koko nods slightly. Honest without exposing yourself. That\'s the move.'),
      'c': VnResult(correct: true,
          feedback: 'Koko: "Asking for clarity is a power move, not a weakness. Remember that."'),
    },
  ),

  // 3 Corridor debrief
  VnScene(
    location: 'Corridor · After the meeting',
    chapter: 'Act II Koko explains',
    bg: VnBg.corridor,
    sprites: [
      VnSprite(role: 'koko', x: 70),
      VnSprite(role: 'you', x: 205, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Don\'t be hard on yourself. Nobody is born knowing what an '),
      VnSegment('OKR', vocabIdx: 0),
      VnSegment(' is." Koko pulls out an imaginary post-it. '),
      VnSegment('"Let me decode what just happened in there word by word."', italic: true),
    ],
    vocab: [
      VnVocab('OKR Objectives & Key Results',
          'Set one big direction (Objective). Attach 2–4 measurable outcomes (Key Results). Track them every quarter. Simple in theory, political in practice.'),
    ],
  ),

  // 4 Kitchen napkin
  VnScene(
    location: 'Kitchen · Coffee break',
    chapter: 'Act II The napkin sketch',
    bg: VnBg.kitchen,
    sprites: [
      VnSprite(role: 'koko', x: 52),
      VnSprite(role: 'you', x: 204, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Koko draws on a napkin. '),
      VnSegment('"In management, before any decision you map who can say no. That\'s ', italic: true),
      VnSegment('stakeholder alignment', vocabIdx: 0),
      VnSegment('."', italic: true),
      VnSegment('\n\nThe drawing takes shape. Just people, lines, and who talks to whom first.'),
    ],
    vocab: [
      VnVocab('Stakeholder alignment',
          'Making sure every person who can block a decision is informed and on board before the meeting, not during it. A surprised CFO is a blocked project.'),
    ],
  ),

  // 5 Office headcount
  VnScene(
    location: 'Koko\'s desk · Open office',
    chapter: 'Act II The headcount plan',
    bg: VnBg.office,
    sprites: [
      VnSprite(role: 'koko', x: 42),
      VnSprite(role: 'you', x: 200, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"See this slide? They call it '),
      VnSegment('strategic headcount', vocabIdx: 0),
      VnSegment('." Koko points at each row. '),
      VnSegment('"This isn\'t HR deciding who to hire. This is management betting on what the company will be able to do next year."',
          italic: true),
    ],
    vocab: [
      VnVocab('Strategic headcount',
          'Hiring with a plan. Not "we need more people" specific roles chosen to hit specific goals by a specific date. Every hire is an argument.'),
    ],
  ),

  // 6 Rehearsal (choice)
  VnScene(
    location: 'Corridor · Rehearsal',
    chapter: 'Act II Your turn to speak',
    bg: VnBg.corridor,
    sprites: [
      VnSprite(role: 'koko', x: 70),
      VnSprite(role: 'you', x: 205, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Same question. Same room. But now you have the words." Koko smiles. '),
      VnSegment('"How would you talk about the headcount plan in one sentence, to the CFO?"',
          italic: true),
    ],
    choices: [
      VnChoice('a', '"We\'re planning to add 16 people across Sales, Tech and Marketing by Q4."'),
      VnChoice('b', '"Our strategic headcount plan targets 16 FTEs aligned to our Q4 OKRs."'),
      VnChoice('c', '"HR is working on the hiring numbers I can follow up."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Koko: "Clear, concrete, no jargon. That\'s actually perfect for a CFO."'),
      'b': VnResult(correct: true,
          feedback: 'Koko grins: "You\'re already starting to sound like you belong in that room."', xp: 120),
      'c': VnResult(correct: false,
          feedback: 'Koko: "Close but you just handed ownership to HR. Management owns the plan. Own it."'),
    },
  ),

  // 7 All-hands test (choice)
  VnScene(
    location: 'All-hands · Management floor',
    chapter: 'Act III Your move',
    bg: VnBg.allHands,
    sprites: [
      VnSprite(role: 'you', x: 145),
    ],
    speaker: 'Manager',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"Before the '),
      VnSegment('board deck', vocabIdx: 0),
      VnSegment(' goes out we need full stakeholder alignment on the headcount plan."\n\n'),
      VnSegment('"Who is handling it?"\n\n', italic: true),
      VnSegment('Koko is not in the room. This one is yours.'),
    ],
    vocab: [
      VnVocab('Board deck',
          'The presentation going to the board of directors. Once it\'s sent, it\'s official. Errors or missing alignment become very public, very fast.'),
    ],
    choices: [
      VnChoice('a', 'Send a detailed email to all C-suite explaining the headcount plan'),
      VnChoice('b', 'Book individual 15-min calls with CFO, CPO and CTO before the deck is finalised'),
      VnChoice('c', 'Wait alignment will happen naturally in the board meeting itself'),
    ],
    results: {
      'a': VnResult(correct: false, xp: 40,
          feedback: 'An email informs it doesn\'t align. People skim it or reply-all into chaos. Alignment needs real dialogue.'),
      'b': VnResult(correct: true, xp: 120,
          feedback: 'Yes. Individual calls before the deck means no one is blindsided. They arrive already aligned. That\'s the move.'),
      'c': VnResult(correct: false, xp: 20,
          feedback: 'Dangerous. Discovering disagreement at board level in public is the worst outcome in management.'),
    },
  ),

  // 8 Elevator epilogue
  VnScene(
    location: 'Elevator · Ground floor',
    chapter: 'Act III Epilogue',
    bg: VnBg.elevatorEnd,
    sprites: [
      VnSprite(role: 'you', x: 40),
      VnSprite(role: 'koko', x: 210, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Back in the elevator. Koko watches the numbers count down.\n\n'),
      VnSegment('"You heard the words today. Now you\'re starting to understand what they do."',
          italic: true),
      VnSegment('\n\nThe doors open. Floor 0.'),
    ],
    isLast: true,
  ),
];

// ─── MARKETING (9 scenes) ─────────────────────────────────────────────────────

const List<VnScene> marketingScenes = [
  // 0 Arrival
  VnScene(
    location: 'Open space · Floor 8',
    chapter: 'Act I Arrival',
    bg: VnBg.mktOpenSpace,
    sprites: [VnSprite(role: 'you', x: 55), VnSprite(role: 'koko', x: 230, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 8. The Marketing floor.\n\n'),
      VnSegment('"Loud, colourful, fast," ', italic: true),
      VnSegment('Koko says, scanning the room. '),
      VnSegment('"These people don\'t just sell they engineer desire."', italic: true),
      VnSegment('\n\nScreens everywhere. Numbers everywhere. Energy everywhere.'),
    ],
  ),

  // 1 Campaign wall (vocab)
  VnScene(
    location: 'Campaign wall · Open space',
    chapter: 'Act I The wall',
    bg: VnBg.mktCampaignWall,
    sprites: [VnSprite(role: 'you', x: 55), VnSprite(role: 'koko', x: 230, flip: true)],
    speaker: 'You',
    speakerColor: Color(0xFFF0997B),
    segments: [
      VnSegment('Three screens cover the wall. Campaigns, numbers, percentages.\n\n'),
      VnSegment('CAC', vocabIdx: 0),
      VnSegment('. '),
      VnSegment('CTR', vocabIdx: 1),
      VnSegment('. '),
      VnSegment('Top of funnel', vocabIdx: 2),
      VnSegment('. '),
      VnSegment('ROI', vocabIdx: 3),
      VnSegment('.\n\nYou stare. Koko stands next to you and waits.'),
    ],
    vocab: [
      VnVocab('CAC Customer Acquisition Cost',
          'How much it costs to acquire one paying customer. If your CAC is \$50 and a customer pays \$10/month, you need 5+ months just to break even.'),
      VnVocab('CTR Click-Through Rate',
          'The % of people who saw something and clicked it. A 2% CTR on an email means 2 out of 100 people clicked. High CTR = the message landed.'),
      VnVocab('Top of funnel',
          'The widest part people who just discovered you. They\'re not ready to buy. Your job here is awareness, not conversion.'),
      VnVocab('ROI Return on Investment',
          'Did the money you spent come back? ROI = (revenue − cost) / cost. A 3× ROI means every €1 spent returned €3.'),
    ],
  ),

  // 2 Hot seat (choice)
  VnScene(
    location: 'Campaign wall · Silence',
    chapter: 'Act I The hot seat',
    bg: VnBg.mktCampaignTense,
    sprites: [VnSprite(role: 'you', x: 160)],
    speaker: 'Marketing Lead',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"Our '),
      VnSegment('CAC', vocabIdx: 0),
      VnSegment(' went up 20% this quarter. What would you prioritise to bring it back down?"\n\nSilence. Everyone turns. Koko is across the room too far to help.'),
    ],
    vocab: [
      VnVocab('CAC Customer Acquisition Cost',
          'Rising CAC means you\'re spending more to get the same customer. Could be market saturation, weak targeting, or a funnel leak.'),
    ],
    choices: [
      VnChoice('a', '"We should probably spend more on ads to get more volume."'),
      VnChoice('b', '"I\'d look at where in the funnel we\'re losing people before increasing spend."'),
      VnChoice('c', '"Can we revisit the question after I review the numbers?"'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko (later): "More spend with a leaky funnel just loses money faster. Always fix the leak first."'),
      'b': VnResult(correct: true,
          feedback: 'Koko nods from across the room. Diagnosis before prescription. That\'s the right instinct.'),
      'c': VnResult(correct: true,
          feedback: 'Koko: "Buying time to think is underrated. Better than a wrong answer said with confidence."'),
    },
  ),

  // 3 Whiteboard funnel
  VnScene(
    location: 'Meeting room · Whiteboard',
    chapter: 'Act II Koko explains',
    bg: VnBg.mktWhiteboard,
    sprites: [VnSprite(role: 'koko', x: 80), VnSprite(role: 'you', x: 220, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Marketing thinks in funnels." Koko draws one on the whiteboard.\n\n'),
      VnSegment('"', italic: true),
      VnSegment('Top of funnel', vocabIdx: 0),
      VnSegment(' is strangers. Bottom is buyers. Your job is moving people down without losing them."', italic: true),
    ],
    vocab: [
      VnVocab('The funnel',
          'Awareness → Consideration → Conversion. Most people enter at the top and never reach the bottom. Each stage needs different content, messages, and metrics.'),
    ],
  ),

  // 4 Analytics desk
  VnScene(
    location: 'Analytics desk · Open space',
    chapter: 'Act II The numbers',
    bg: VnBg.mktAnalytics,
    sprites: [VnSprite(role: 'koko', x: 72), VnSprite(role: 'you', x: 216, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Two numbers every marketer lives by: '),
      VnSegment('CAC', vocabIdx: 0),
      VnSegment(' and '),
      VnSegment('LTV', vocabIdx: 1),
      VnSegment('." Koko points at the screen.\n\n'),
      VnSegment('"If your LTV is 6× your CAC you\'re healthy. If it\'s 1× you\'re barely surviving."',
          italic: true),
    ],
    vocab: [
      VnVocab('CAC Customer Acquisition Cost',
          'What you spend to get one customer. Lower is better but not at the cost of quality.'),
      VnVocab('LTV Lifetime Value',
          'Total revenue one customer generates over their entire relationship with you. LTV:CAC above 3× is the benchmark for a healthy marketing operation.'),
    ],
  ),

  // 5 Rehearsal (choice)
  VnScene(
    location: 'Meeting room · Rehearsal',
    chapter: 'Act II Your turn',
    bg: VnBg.mktMeeting,
    sprites: [VnSprite(role: 'koko', x: 80), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Same question as before. But now you have the words." Koko leans back.\n\n'),
      VnSegment('"Our CAC went up 20%. In one sentence what do you do?"', italic: true),
    ],
    choices: [
      VnChoice('a', '"I\'d audit the funnel for drop-off points before touching the budget."'),
      VnChoice('b', '"I\'d run an A/B test on the landing page to improve conversion rate."'),
      VnChoice('c', '"I\'d pause paid campaigns and focus on organic for 30 days."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Koko: "Exactly. Find the leak before you add more water. Clean thinking."'),
      'b': VnResult(correct: true,
          feedback: 'Koko: "Smart conversion rate is often where CAC bleeds. Good instinct."'),
      'c': VnResult(correct: false,
          feedback: 'Koko: "Bold but pausing paid with no data is a guess. Always diagnose first."'),
    },
  ),

  // 6 Brand vs performance
  VnScene(
    location: 'Open space · Afternoon',
    chapter: 'Act II Brand vs performance',
    bg: VnBg.mktOpenSpace,
    sprites: [VnSprite(role: 'koko', x: 80), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"There are two tribes in Marketing." Koko holds up two fingers.\n\n'),
      VnSegment('"', italic: true),
      VnSegment('Brand', vocabIdx: 0),
      VnSegment(' builds identity slow, emotional, hard to measure. ', italic: true),
      VnSegment('Performance', vocabIdx: 1),
      VnSegment(' drives clicks fast, trackable, easy to kill."', italic: true),
      VnSegment('\n\n"Most companies need both. Most only fund one."'),
    ],
    vocab: [
      VnVocab('Brand marketing',
          'Building long-term perception and identity. You can\'t always see the ROI tomorrow but in 3 years, it\'s the reason people choose you without thinking.'),
      VnVocab('Performance marketing',
          'Campaigns directly tied to measurable outcomes: clicks, sign-ups, purchases. Every £ is tracked. CAC, CTR, ROAS all performance metrics.'),
    ],
  ),

  // 7 Real test (choice)
  VnScene(
    location: 'Campaign review · All team',
    chapter: 'Act III Your move',
    bg: VnBg.mktMeeting,
    sprites: [VnSprite(role: 'you', x: 160)],
    speaker: 'CMO',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"We have €50k left in Q3 budget. '),
      VnSegment('CAC', vocabIdx: 0),
      VnSegment(' is up, '),
      VnSegment('LTV', vocabIdx: 1),
      VnSegment(' is flat. Where do we put the money?"\n\nKoko is not in the room. The team looks at you.'),
    ],
    vocab: [
      VnVocab('CAC Customer Acquisition Cost',
          'Up 20% this quarter. Each new customer costs more your spend efficiency is dropping.'),
      VnVocab('LTV Lifetime Value',
          'Flat means customers aren\'t spending more or staying longer. Growth requires reducing CAC or growing LTV.'),
    ],
    choices: [
      VnChoice('a', 'Double down on paid social more impressions, more top-of-funnel volume'),
      VnChoice('b', 'Invest in retention: email sequences and loyalty grow LTV instead of chasing new customers'),
      VnChoice('c', 'Split it: fix the funnel conversion rate first, then reinvest the savings into paid'),
    ],
    results: {
      'a': VnResult(correct: false, xp: 30,
          feedback: 'With CAC already rising, more top-of-funnel spend without fixing conversion just burns budget faster.'),
      'b': VnResult(correct: true, xp: 100,
          feedback: 'Smart. When CAC is high and LTV is flat, the lever is retention not acquisition. Koko: "You just thought like a CMO."'),
      'c': VnResult(correct: true, xp: 120,
          feedback: 'The best answer. Fix the leak, then scale. Koko: "That\'s exactly what the best marketers do they don\'t spend their way out of a funnel problem."'),
    },
  ),

  // 8 Rooftop epilogue
  VnScene(
    location: 'Rooftop · End of day',
    chapter: 'Act III Epilogue',
    bg: VnBg.mktRooftop,
    sprites: [VnSprite(role: 'you', x: 60), VnSprite(role: 'koko', x: 228, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Rooftop. The city below. Koko looks out.\n\n'),
      VnSegment('"Marketing people speak fast and measure everything. But the best ones ask one question before any other:"',
          italic: true),
      VnSegment('\n\n"Why would someone care?"\n\nYou nod. You\'re starting to understand.'),
    ],
    isLast: true,
  ),
];

// ─── ACCOUNTING (9 scenes) ────────────────────────────────────────────────────

const List<VnScene> accountingScenes = [
  // 0 Floor 6 arrival
  VnScene(
    location: 'Floor 6 · Accounting',
    chapter: 'Act I Arrival',
    bg: VnBg.acctFloor,
    sprites: [VnSprite(role: 'you', x: 55), VnSprite(role: 'koko', x: 230, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 6. Quieter than Marketing. More focused.\n\n'),
      VnSegment('"Accounting people are the memory of the company," ', italic: true),
      VnSegment('Koko says. '),
      VnSegment('"Every number that has ever existed they know where it went."', italic: true),
      VnSegment('\n\nScreens glow with spreadsheets. A trial balance sits on every monitor.'),
    ],
  ),

  // 1 Numbers wall (vocab)
  VnScene(
    location: 'Open space · Ledger wall',
    chapter: 'Act I The numbers wall',
    bg: VnBg.acctLedger,
    sprites: [VnSprite(role: 'you', x: 55), VnSprite(role: 'koko', x: 228, flip: true)],
    speaker: 'You',
    speakerColor: Color(0xFFEF9F27),
    segments: [
      VnSegment('A massive income statement fills the screen. You try to read it top to bottom.\n\n'),
      VnSegment('Revenue', vocabIdx: 0),
      VnSegment('. '),
      VnSegment('Gross profit', vocabIdx: 1),
      VnSegment('. '),
      VnSegment('EBITDA', vocabIdx: 2),
      VnSegment('. '),
      VnSegment('Accruals', vocabIdx: 3),
      VnSegment('.\n\nEach line leads to another. Koko watches you trace the numbers.'),
    ],
    vocab: [
      VnVocab('Revenue',
          'The total money a company brings in before any costs are deducted. Also called "top line." It tells you how much business happened not how profitable it was.'),
      VnVocab('Gross profit',
          'Revenue minus the direct cost of making or delivering the product (COGS). Gross profit shows how efficiently the core business runs before overhead.'),
      VnVocab('EBITDA',
          'Earnings Before Interest, Tax, Depreciation and Amortisation. A proxy for operating profitability strips out financing and accounting decisions to show raw performance.'),
      VnVocab('Accruals',
          'Recording revenue or expenses when they happen not when cash moves. If you deliver a service in December but invoice in January, the revenue is accrued in December.'),
    ],
  ),

  // 2 Hot seat (choice)
  VnScene(
    location: 'Open space · Hot seat',
    chapter: 'Act I The hot seat',
    bg: VnBg.acctLedgerTense,
    sprites: [VnSprite(role: 'you', x: 160)],
    speaker: 'CFO',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"Our '),
      VnSegment('EBITDA', vocabIdx: 0),
      VnSegment(' is healthy but our cash position is shrinking. How is that possible?"\n\nThe room goes quiet. Six accountants look up from their screens. Koko is not here.'),
    ],
    vocab: [
      VnVocab('EBITDA vs cash',
          'A company can be profitable on paper but cash-poor in reality if customers pay late, inventory piles up, or capex is high. Profit ≠ cash.'),
    ],
    choices: [
      VnChoice('a', '"Maybe the revenue figures are wrong we should recheck them."'),
      VnChoice('b', '"Profit and cash aren\'t the same thing timing of payments and capex could explain it."'),
      VnChoice('c', '"I\'d need to look at the cash flow statement before giving an answer."'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko (later): "Revenue being wrong is a crisis. Timing differences are normal. Always check cash flow first."'),
      'b': VnResult(correct: true,
          feedback: 'Koko nods. Profit measures value created. Cash measures money in the bank. Knowing the difference is fundamental.'),
      'c': VnResult(correct: true,
          feedback: 'Koko: "Exactly right. The cash flow statement is where that answer lives not the P&L."'),
    },
  ),

  // 3 Three statements
  VnScene(
    location: 'Meeting room · Whiteboard',
    chapter: 'Act II The three statements',
    bg: VnBg.acctWhiteboard,
    sprites: [VnSprite(role: 'koko', x: 80), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Accounting runs on three documents," Koko draws three boxes.\n\n"The '),
      VnSegment('P&L', vocabIdx: 0),
      VnSegment(' tells you if you made money. The '),
      VnSegment('balance sheet', vocabIdx: 1),
      VnSegment(' tells you what you own and owe. The '),
      VnSegment('cash flow statement', vocabIdx: 2),
      VnSegment(' tells you if you can pay your bills."\n\n"You need all three to see the full picture."'),
    ],
    vocab: [
      VnVocab('P&L Profit & Loss',
          'Also called the income statement. Shows revenue, costs and profit over a period. The "score" of the business for that period.'),
      VnVocab('Balance sheet',
          'A snapshot of what the company owns (assets), what it owes (liabilities), and what\'s left for owners (equity). Assets = Liabilities + Equity. Always.'),
      VnVocab('Cash flow statement',
          'Tracks actual cash in and out from operations, investing, and financing. A company can be profitable but still run out of cash.'),
    ],
  ),

  // 4 Audit room
  VnScene(
    location: 'Audit room · Q3 review',
    chapter: 'Act II The audit',
    bg: VnBg.acctAuditRoom,
    sprites: [VnSprite(role: 'koko', x: 72), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"See that flag?" Koko points at the depreciation line.\n\n'),
      VnSegment('"A '),
      VnSegment('depreciation', vocabIdx: 0),
      VnSegment(' discrepancy means an asset was written down incorrectly. Small error. Big problem if auditors find it first."', italic: true),
      VnSegment('\n\n"Accounting is about trust. One wrong number breaks everything."'),
    ],
    vocab: [
      VnVocab('Depreciation',
          'Spreading the cost of an asset over its useful life. A €10,000 machine used for 5 years is depreciated €2,000/year not expensed all at once. Errors here misstate profit.'),
    ],
  ),

  // 5 Desk (month-end close)
  VnScene(
    location: 'Koko\'s desk · Open office',
    chapter: 'Act II Accruals & close',
    bg: VnBg.acctDesk,
    sprites: [VnSprite(role: 'koko', x: 72), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"'),
      VnSegment('Month-end close', vocabIdx: 0),
      VnSegment(' is the most intense week in Accounting." Koko scrolls through two screens.\n\n'),
      VnSegment('"Every accrual has to be posted. Every reconciliation signed off. If something doesn\'t balance you don\'t go home."', italic: true),
    ],
    vocab: [
      VnVocab('Month-end close',
          'The process of finalising all accounting entries for the month. Accruals, reconciliations, journal entries everything must balance before the books are "closed" and reported.'),
    ],
  ),

  // 6 Rehearsal (choice)
  VnScene(
    location: 'Meeting room · Rehearsal',
    chapter: 'Act II Your turn',
    bg: VnBg.acctMeeting,
    sprites: [VnSprite(role: 'koko', x: 80), VnSprite(role: 'you', x: 218, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Same situation as before. EBITDA is positive. Cash is falling." Koko leans back.\n\n'),
      VnSegment('"Walk me through where you\'d look first."', italic: true),
    ],
    choices: [
      VnChoice('a', '"I\'d check the cash flow statement operating, investing and financing sections."'),
      VnChoice('b', '"I\'d look at accounts receivable if customers aren\'t paying, cash falls even when profit is up."'),
      VnChoice('c', '"I\'d recheck the P&L for any misclassified expenses."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Koko: "Exactly. The cash flow statement is the diagnostic tool. Start there, always."'),
      'b': VnResult(correct: true,
          feedback: 'Koko: "Sharp. Receivables timing is one of the most common reasons for the profit-cash gap."'),
      'c': VnResult(correct: false,
          feedback: 'Koko: "The P&L shows profit not cash. Misclassified expenses affect profit, not the cash position."'),
    },
  ),

  // 7 Real test (choice)
  VnScene(
    location: 'Month-end close · All team',
    chapter: 'Act III Your move',
    bg: VnBg.acctMeeting,
    sprites: [VnSprite(role: 'you', x: 160)],
    speaker: 'Finance Director',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"The auditors arrive Monday. We have one item flagged a '),
      VnSegment('depreciation', vocabIdx: 0),
      VnSegment(' discrepancy on three assets. It\'s small but it affects the '),
      VnSegment('P&L', vocabIdx: 1),
      VnSegment('. What do we do?"\n\nKoko is not in the room. The team looks at you.'),
    ],
    vocab: [
      VnVocab('Depreciation discrepancy',
          'An asset was written down by the wrong amount. This understates or overstates expenses which means profit is also wrong. Auditors will flag it.'),
      VnVocab('P&L impact',
          'If depreciation is wrong, the expenses line is wrong net profit is wrong. This must be corrected before auditors sign off.'),
    ],
    choices: [
      VnChoice('a', 'Correct the depreciation entries now, restate the affected periods, and document the change before Monday'),
      VnChoice('b', 'Leave it the amount is small and auditors might not notice'),
      VnChoice('c', 'Flag it to the CFO immediately and wait for their decision before touching anything'),
    ],
    results: {
      'a': VnResult(correct: true, xp: 120,
          feedback: 'The right move. Correct, document, disclose. Auditors respect transparency. Koko: "You just thought like a qualified accountant."'),
      'b': VnResult(correct: false, xp: 20,
          feedback: 'Auditors always notice. Hiding a known error is far worse than the error itself it becomes a material misstatement.'),
      'c': VnResult(correct: true, xp: 90,
          feedback: 'Also valid escalating a material issue before acting shows good judgement. Koko: "Good instinct to loop in leadership."'),
    },
  ),

  // 8 Archive epilogue
  VnScene(
    location: 'Archive room · End of day',
    chapter: 'Act III Epilogue',
    bg: VnBg.acctArchive,
    sprites: [VnSprite(role: 'you', x: 58), VnSprite(role: 'koko', x: 225, flip: true)],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('The archive room. Files going back decades. Koko pulls one out, then puts it back.\n\n'),
      VnSegment('"Every business decision leaves a trace in here. The people in this department are the ones who make sure the trace is true."',
          italic: true),
      VnSegment('\n\n"That\'s not a small thing. That\'s everything."'),
    ],
    isLast: true,
  ),
];

// ─── LEGAL (8 scenes) ─────────────────────────────────────────────────────────

const List<VnScene> legalScenes = [
  // 0 Floor arrival
  VnScene(
    location: 'Meridian HQ · 7th floor',
    chapter: 'Monday morning',
    bg: VnBg.legalFloor,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 228, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 7 is quieter than Finance. Darker, somehow. The shelves are real actual books, not decoration.\n\n'),
      VnSegment('"Legal is different," Koko says. "Every other department moves fast and asks for forgiveness. Legal moves carefully and asks for permission. They\'re the ones who make sure the rest of the company doesn\'t accidentally break something it can\'t fix."\n\n', italic: true),
      VnSegment('Someone walks past carrying a contract marked with red ink. Another has a '),
      VnSegment('brief', vocabIdx: 0),
      VnSegment(' open across two screens. A third is on the phone, repeating the word '),
      VnSegment('jurisdiction', vocabIdx: 1),
      VnSegment(' very slowly.'),
    ],
    vocab: [
      VnVocab('Brief',
          'A written document that outlines the facts, legal arguments, and position of one party on a matter. In a company, "writing a brief" means preparing a summary of a legal issue for internal review or external counsel. Precision is everything every word is a choice.'),
      VnVocab('Jurisdiction',
          'The legal authority of a court or regulatory body to hear a case or enforce a law. "Which jurisdiction applies?" is one of the first questions in any cross-border deal or dispute. It determines which country\'s laws govern the agreement.'),
    ],
  ),

  // 1 Contract desk (choice)
  VnScene(
    location: 'Legal desk · Contract review',
    chapter: 'Monday · The redline',
    bg: VnBg.legalContractDesk,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 222, flip: true),
    ],
    speaker: 'Laure',
    speakerColor: Color(0xFFA088CC),
    segments: [
      VnSegment('Laure is the senior legal counsel. She slides a contract across the desk without preamble.\n\n'),
      VnSegment('"Supplier agreement. We\'re on version four. The ', italic: true),
      VnSegment('indemnity', vocabIdx: 0, italic: true),
      VnSegment(' clause is still open they want us to cover third-party claims arising from our data. That\'s too broad. The ', italic: true),
      VnSegment('liability cap', vocabIdx: 1, italic: true),
      VnSegment(' is agreed at two million. The ', italic: true),
      VnSegment('termination for cause', vocabIdx: 2, italic: true),
      VnSegment(' clause is ours."\n\n', italic: true),
      VnSegment('She taps §11. "This is the one. Read it."\n\nKoko leans over your shoulder. '),
      VnSegment('"An open indemnity means you\'re agreeing to pay for things you haven\'t caused yet. That\'s... a lot."', italic: true),
    ],
    vocab: [
      VnVocab('Indemnity',
          'A contractual obligation to compensate another party for losses or damages. "Broad indemnity" means you\'re agreeing to cover a wide range of potential claims including things you didn\'t directly cause. Lawyers always try to narrow indemnity clauses.'),
      VnVocab('Liability cap',
          'A contractual limit on how much one party can be required to pay in damages, regardless of what goes wrong. A €2M cap means the maximum exposure is €2M. Without a cap, liability is theoretically unlimited.'),
      VnVocab('Termination for cause',
          'A clause allowing one party to end the contract immediately if the other party breaches a specific condition fraud, insolvency, material breach. "For cause" is more powerful than a standard termination clause, which usually requires notice.'),
    ],
    choices: [
      VnChoice('a', '"The indemnity as written would expose us to third-party IP claims we can\'t control. We should limit it to direct damages from our own breach."'),
      VnChoice('b', '"Can we accept it if we add a carve-out for claims arising from the supplier\'s own negligence?"'),
      VnChoice('c', '"I\'d want to see how this clause read in version two before suggesting a counter."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Laure nods. "Exactly the right frame. Limit scope to what we can actually control." Koko: "You just read a contract like a lawyer."'),
      'b': VnResult(correct: true,
          feedback: '"A carve-out yes. That\'s the practical compromise." Laure marks it in red. "Write that up and I\'ll review it." Koko: "That\'s how negotiation works. Not rejection redirection."'),
      'c': VnResult(correct: true,
          feedback: 'Laure pulls version two without hesitation. "Good instinct. Never counter without knowing what changed." Koko: "Context before position. That\'s legal thinking."'),
    },
  ),

  // 2 NDA scene
  VnScene(
    location: 'Meeting room · 11:00am',
    chapter: 'Monday · The NDA',
    bg: VnBg.legalNDA,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 222, flip: true),
    ],
    speaker: 'Laure',
    speakerColor: Color(0xFFA088CC),
    segments: [
      VnSegment('A new supplier wants to discuss a partnership. Before anyone says anything, Laure produces a document.\n\n'),
      VnSegment('"Standard ', italic: true),
      VnSegment('NDA', vocabIdx: 0, italic: true),
      VnSegment('. Nothing moves without one. It covers ', italic: true),
      VnSegment('confidential information', vocabIdx: 1, italic: true),
      VnSegment(', defines both parties\' obligations, and runs for three years."\n\n', italic: true),
      VnSegment('The supplier\'s rep looks at the document. '),
      VnSegment('"What happens if we breach it?"\n\n', italic: true),
      VnSegment('Koko whispers: '),
      VnSegment('"Good question. And one Legal always has an answer to."', italic: true),
    ],
    vocab: [
      VnVocab('NDA Non-Disclosure Agreement',
          'A contract that legally prevents parties from sharing confidential information with third parties. One of the most common legal documents in business signed before partnerships, M&A conversations, and any sensitive discussion. Mutual NDAs bind both sides. Unilateral NDAs bind only the receiving party.'),
      VnVocab('Confidential information',
          'In a legal context, specifically defined information that one party agrees not to disclose. The definition matters too broad and it covers everything; too narrow and it protects nothing. Courts interpret it against the party that drafted it if it\'s ambiguous.'),
      VnVocab('Breach',
          'Failure to comply with the terms of a contract. A breach gives the other party the right to seek remedies damages, injunctions, or termination. "Material breach" is serious enough to trigger termination for cause. "Minor breach" may only entitle compensation.'),
    ],
  ),

  // 3 GDPR audit (choice)
  VnScene(
    location: 'Legal desk · Wednesday',
    chapter: 'Wednesday · Data law',
    bg: VnBg.legalGDPR,
    sprites: [
      VnSprite(role: 'you', x: 148),
      VnSprite(role: 'koko', x: 258, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Laure hands you a checklist and disappears into a meeting. "GDPR audit. Start with the DPA gap."\n\nKoko looks at the list with you. '),
      VnSegment('"'),
      VnSegment('GDPR', vocabIdx: 0),
      VnSegment(' is the European data protection regulation it governs how companies collect, store and use personal data. Every company touching EU data has to comply, or face serious fines."\n\n', italic: true),
      VnSegment('The incomplete item is a missing '),
      VnSegment('DPA', vocabIdx: 1),
      VnSegment(' with a third-party processor. Four '),
      VnSegment('data subject rights', vocabIdx: 2),
      VnSegment(' requests are pending. The 30-day clock is already running.'),
    ],
    vocab: [
      VnVocab('GDPR General Data Protection Regulation',
          'EU regulation governing how personal data is collected, stored, processed and protected. Applies to any company handling data about EU residents regardless of where the company is based. Fines can reach €20M or 4% of global annual revenue, whichever is higher.'),
      VnVocab('DPA Data Processing Agreement',
          'A contract required under GDPR between a company (data controller) and any third party that processes personal data on its behalf (data processor). Without a DPA in place, the arrangement is non-compliant even if the processing itself is fine.'),
      VnVocab('Data subject rights',
          'Rights granted to individuals under GDPR including the right to access their data, correct it, delete it ("right to be forgotten"), and restrict its processing. Companies must respond to these requests within 30 days. Missing the deadline is a regulatory violation.'),
    ],
    choices: [
      VnChoice('a', 'Draft the missing DPA first the processor relationship is the compliance gap. Rights requests can wait 48 hours.'),
      VnChoice('b', 'Respond to the data subject rights requests first the clock is running and missing the deadline is a direct violation.'),
      VnChoice('c', 'Flag both to Laure before acting this needs a senior decision on priority.'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko: "The DPA matters but four people have rights requests with a legal deadline attached. Missing that deadline is the more immediate exposure." Laure would say: rights requests first.'),
      'b': VnResult(correct: true,
          feedback: 'Koko: "30 days is the law. The DPA gap is serious but it\'s not expiring today. Always handle the ticking clock first." Laure nods when she hears it.'),
      'c': VnResult(correct: true,
          feedback: 'Laure steps out of her meeting. "Rights requests then DPA. Good call to check." Koko: "Knowing when to escalate is one of the most underrated legal skills."'),
    },
  ),

  // 4 Negotiation meeting
  VnScene(
    location: 'Meeting room · Thursday',
    chapter: 'Thursday · Negotiation',
    bg: VnBg.legalMeeting,
    sprites: [
      VnSprite(role: 'you', x: 44),
      VnSprite(role: 'koko', x: 222, flip: true),
    ],
    speaker: 'Laure',
    speakerColor: Color(0xFFA088CC),
    segments: [
      VnSegment('The supplier is back. The indemnity clause is still open. The room has that particular tension of two lawyers who both know what they want.\n\nLaure explains the position quietly before they enter. '),
      VnSegment('"They want ', italic: true),
      VnSegment('unlimited liability', vocabIdx: 0, italic: true),
      VnSegment(' on our side for data incidents. We\'re countering with a cap plus a ', italic: true),
      VnSegment('warranty', vocabIdx: 1, italic: true),
      VnSegment(' carve-out. If they push back, we walk the ', italic: true),
      VnSegment('force majeure', vocabIdx: 2, italic: true),
      VnSegment(' clause is already in our favour."\n\n', italic: true),
      VnSegment('Koko whispers: '),
      VnSegment('"Force majeure I know that one. It\'s the \'act of God\' clause. If something impossible happens, neither side is liable. Laure already has her exits planned."', italic: true),
    ],
    vocab: [
      VnVocab('Unlimited liability',
          'When there is no cap on how much a party can be required to pay in damages. In commercial contracts, unlimited liability is almost always rejected by well-advised companies the exposure is theoretically infinite. The fight is usually about where the cap sits.'),
      VnVocab('Warranty',
          'A contractual promise that something is true at the time of signing "the software is fit for purpose," "there is no ongoing litigation." Breach of warranty gives the other party the right to claim damages. Warranties are heavily negotiated in M&A.'),
      VnVocab('Force majeure',
          'A clause that excuses a party from performance if an extraordinary event beyond their control occurs natural disaster, war, pandemic. It limits liability in circumstances no one could have predicted. Courts interpret it narrowly it doesn\'t cover ordinary commercial risk.'),
    ],
  ),

  // 5 M&A due diligence
  VnScene(
    location: 'War room · Friday morning',
    chapter: 'Friday · M&A crunch',
    bg: VnBg.legalDueDiligence,
    sprites: [
      VnSprite(role: 'you', x: 44),
      VnSprite(role: 'koko', x: 222, flip: true),
    ],
    speaker: 'Thomas',
    speakerColor: Color(0xFF9090A8),
    segments: [
      VnSegment('Thomas is Meridian\'s M&A counsel. He doesn\'t look up when you arrive.\n\n'),
      VnSegment('"FinScale due diligence. We have a ', italic: true),
      VnSegment('data room', vocabIdx: 0, italic: true),
      VnSegment(' with 400 documents. Legal needs to clear the ', italic: true),
      VnSegment('IP', vocabIdx: 1, italic: true),
      VnSegment(' position, the warranty exposure, and check for any undisclosed ', italic: true),
      VnSegment('litigation', vocabIdx: 2, italic: true),
      VnSegment('. If we find a problem we didn\'t know about, it goes to ', italic: true),
      VnSegment('reps and warranties', vocabIdx: 3, italic: true),
      VnSegment('."'),
      VnSegment('\n\nKoko stares at the screen. '),
      VnSegment('"Four hundred documents. Right. Where do we even start?"', italic: true),
      VnSegment(' Thomas answers without looking up: "IP licences. Always start with IP."'),
    ],
    vocab: [
      VnVocab('Data room',
          'A secure digital repository where a seller provides documents to potential buyers during M&A due diligence. Everything from contracts to board minutes to tax filings lives there. Legal teams spend weeks inside data rooms reviewing, flagging, and cross-referencing.'),
      VnVocab('IP Intellectual Property',
          'Legally protected creations of the mind patents, trademarks, copyright, trade secrets. In a tech acquisition, IP is often the main asset being purchased. If the target doesn\'t clearly own its IP (e.g., code written by contractors without assignment clauses), the deal value collapses.'),
      VnVocab('Litigation',
          'Formal legal proceedings in a court. "Undisclosed litigation" means the target company is involved in a lawsuit they didn\'t mention. This is a significant risk it can become the buyer\'s problem after the deal closes.'),
      VnVocab('Reps and warranties',
          'Representations (statements of fact) and warranties (promises) made by the seller at closing. If something turns out to be false or incomplete, the buyer can claim damages. Reps and warranties insurance exists to cover the gap between what was promised and what was true.'),
    ],
  ),

  // 6 Partner's office (choice)
  VnScene(
    location: 'Partner\'s office · End of day',
    chapter: 'Friday · Final read',
    bg: VnBg.legalPartnerOffice,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Laure',
    speakerColor: Color(0xFFA088CC),
    segments: [
      VnSegment('Laure closes the door. One chair. One question.\n\n'),
      VnSegment('"What\'s your read on the FinScale file?"\n\n', italic: true),
      VnSegment('Koko is in the corridor. You have the words now '),
      VnSegment('material breach', vocabIdx: 0),
      VnSegment(', '),
      VnSegment('IP gap', vocabIdx: 1),
      VnSegment(', '),
      VnSegment('warranty exposure', vocabIdx: 2),
      VnSegment(', '),
      VnSegment('governing law', vocabIdx: 3),
      VnSegment('. A week of Legal is in the room with you.'),
    ],
    vocab: [
      VnVocab('Material breach',
          'A breach serious enough to justify terminating the contract and/or claiming substantial damages. "Material" means it goes to the heart of the agreement not a technicality. Courts assess whether a reasonable party would have contracted differently had they known about it.'),
      VnVocab('IP gap',
          'A situation where the target company\'s intellectual property isn\'t cleanly owned or properly licensed. Common in startups where code was written by contractors without IP assignment clauses. An IP gap is a due diligence red flag.'),
      VnVocab('Warranty exposure',
          'The financial risk created by warranties that may turn out to be inaccurate. If a seller warranted "there is no pending litigation" and there was the buyer can claim. Warranty exposure is calculated as part of M&A risk assessment.'),
      VnVocab('Governing law',
          'The legal system that will apply to the contract and any disputes arising from it. "French governing law" means a French court would interpret and enforce the agreement. Parties negotiate this each side prefers their home jurisdiction.'),
    ],
    choices: [
      VnChoice('a', '"The IP gap is the main risk if they don\'t own the code, we\'re buying a liability. Everything else is manageable."'),
      VnChoice('b', '"Three open items: IP licences, board minutes, and warranty exposure on undisclosed litigation. We need representations on all three before we can recommend proceeding."'),
      VnChoice('c', '"I\'d want outside counsel\'s view on the IP position before I give you a read. It\'s the item I\'m least confident on."'),
    ],
    results: {
      'a': VnResult(correct: true, xp: 100,
          feedback: 'Laure nods slowly. "Correct priority. IP is the deal-breaker if it\'s wrong. The rest we can negotiate around." Koko (outside): "You just gave a legal risk assessment."'),
      'b': VnResult(correct: true, xp: 120,
          feedback: '"Structured, complete, accurate." Laure picks up her pen. "That\'s exactly what I needed." Koko: "Three items, clearly framed. That\'s how senior lawyers think."'),
      'c': VnResult(correct: true, xp: 80,
          feedback: 'Laure doesn\'t skip a beat. "Good instinct. I\'ll arrange the call." Koko: "Knowing the limit of your read is its own kind of legal intelligence."'),
    },
  ),

  // 7 After work epilogue
  VnScene(
    location: 'Bar downstairs · Friday evening',
    chapter: 'End of week',
    bg: VnBg.legalAfterWork,
    sprites: [
      VnSprite(role: 'you', x: 44),
      VnSprite(role: 'koko', x: 140),
      VnSprite(role: 'you', x: 234, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Laure makes a joke about force majeure and the train being late. You laugh.\n\nThen you realise: you understood the joke.\n\nShe catches your eye. "You asked good questions this week." That\'s it. That\'s the whole review.\n\n'),
      VnSegment('Koko raises a glass. "Monday you didn\'t know what jurisdiction meant. Friday you\'re giving due diligence reads to a partner. I watched it happen. It wasn\'t magic it was just paying attention."', italic: true),
    ],
    isLast: true,
  ),
];

// ─── FINANCE (8 scenes) ───────────────────────────────────────────────────────

const List<VnScene> financeScenes = [
  // 0 Lobby arrival
  VnScene(
    location: 'Meridian HQ · Lobby',
    chapter: 'Monday 8:45am',
    bg: VnBg.finLobby,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 228, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('First day at Meridian. The receptionist barely looks up.\n\n"Finance is on the 4th floor. They\'re in the middle of '),
      VnSegment('month-end close', vocabIdx: 0),
      VnSegment('."\n\nNeither of you knows what that means. The elevator doors open onto a floor of people who clearly haven\'t slept. Koko leans close. '),
      VnSegment('"I think this is the ', italic: true),
      VnSegment('fiscal year', vocabIdx: 1, italic: true),
      VnSegment('\'s most stressful week. Look at everyone\'s screens."', italic: true),
      VnSegment(' Spreadsheets everywhere. Every desk full that\'s '),
      VnSegment('headcount', vocabIdx: 2),
      VnSegment(' at capacity.'),
    ],
    vocab: [
      VnVocab('Month-end close',
          'The process of finalising all accounting entries at the end of the month accruals, reconciliations, journal entries. Everything must balance before the books are "closed" and results reported. It\'s intense because accuracy is non-negotiable and the deadline is fixed.'),
      VnVocab('Fiscal year',
          'A company\'s 12-month accounting period not always January to December. Meridian\'s fiscal year ends in December, so Q3 is July–September. "FY Q3" = third quarter of the fiscal year.'),
      VnVocab('Headcount',
          'The number of people employed in a team or company. Finance tracks headcount carefully every person is a cost on the P&L. "Strategic headcount" means being deliberate about who you hire and when.'),
    ],
  ),

  // 1 Meeting room (choice)
  VnScene(
    location: 'Meeting room · 4th floor',
    chapter: 'Monday 9:00am',
    bg: VnBg.finMeetingRoom,
    sprites: [
      VnSprite(role: 'koko', x: 44),
      VnSprite(role: 'you', x: 222, flip: true),
    ],
    speaker: 'Marcus',
    speakerColor: Color(0xFF9090A8),
    segments: [
      VnSegment('Marcus Chen, CFO. He doesn\'t introduce himself the room already knows who he is.\n\n'),
      VnSegment('"', italic: true),
      VnSegment('Gross margin', vocabIdx: 0, italic: true),
      VnSegment(' is down 3.6 points. ', italic: true),
      VnSegment('COGS', vocabIdx: 1, italic: true),
      VnSegment(' is the drag. ', italic: true),
      VnSegment('Revenue', vocabIdx: 2, italic: true),
      VnSegment(' is on target so don\'t come at me with a top-line story."\n\n', italic: true),
      VnSegment('Koko whispers from behind you: '),
      VnSegment('"Gross margin it\'s how much is left after making the thing. He\'s saying costs went up without prices going up."', italic: true),
      VnSegment(' Sara, the analyst beside you, has a number on her screen. Her hand moves toward the keyboard. Then stops.'),
    ],
    vocab: [
      VnVocab('Gross margin',
          'Revenue minus the cost of goods sold (COGS), expressed as a percentage. Shows how much remains from each euro of sales after paying for what was delivered. A falling gross margin means the product is getting more expensive to produce without prices rising to match.'),
      VnVocab('COGS Cost of Goods Sold',
          'The direct costs of producing the product or service materials, manufacturing, delivery. "COGS is the drag" means rising production costs are pulling gross margin down.'),
      VnVocab('Revenue',
          'Total money coming in from sales, before any costs are deducted. Also called "top line." Marcus has revenue on target sales are holding. The problem lives below that line.'),
    ],
    choices: [
      VnChoice('a', 'Nudge Sara catch her eye and gesture toward the keyboard, encouraging her to speak.'),
      VnChoice('b', 'Stay back. This is Marcus\'s room. Watch and learn.'),
      VnChoice('c', '"What exactly goes into COGS?"'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Sara speaks. Her number lands perfectly. Marcus pauses then nods once. Later, in the corridor: "Thanks," she says. "I needed that."'),
      'b': VnResult(correct: true,
          feedback: 'Sara stays quiet. In the corridor after: "I had the answer. I should have said it." You both learned something. Koko: "Next time."'),
      'c': VnResult(correct: true,
          feedback: 'Marcus answers without irritation: "Materials, production, delivery anything tied to making the product." Sara catches your eye. The room relaxes slightly.'),
    },
  ),

  // 2 Break room with Sara
  VnScene(
    location: 'Break room · 10:30am',
    chapter: 'Monday · Coffee with Sara',
    bg: VnBg.finBreakRoom,
    sprites: [
      VnSprite(role: 'koko', x: 66),
      VnSprite(role: 'you', x: 222, flip: true),
    ],
    speaker: 'Sara',
    speakerColor: Color(0xFFD4537E),
    segments: [
      VnSegment('Sara draws on a napkin with a borrowed pen. "Okay. Basically."\n\n'),
      VnSegment('"'),
      VnSegment('P&L', vocabIdx: 0),
      VnSegment(' is the story of what happened. Top: '),
      VnSegment('net revenue', vocabIdx: 1),
      VnSegment('. Then you subtract everything rent, salaries, software that\'s '),
      VnSegment('operating expenses', vocabIdx: 2),
      VnSegment('. What\'s left before the complicated stuff is '),
      VnSegment('EBITDA', vocabIdx: 3),
      VnSegment('. Take out taxes, interest, all of it you get '),
      VnSegment('net income', vocabIdx: 4),
      VnSegment('. That\'s the actual bottom line."\n\n', italic: true),
      VnSegment('She taps the napkin. "Kind of like what came in, minus what went out, minus what we owe the universe."'),
    ],
    vocab: [
      VnVocab('P&L Profit & Loss',
          'Also called the income statement. The financial story of a period a month, quarter, or year. Starts with revenue at the top and works down through costs to profit at the bottom. Reading a P&L tells you whether a company made or lost money.'),
      VnVocab('Net revenue',
          'Revenue after deducting returns, discounts, and allowances. The real money that came in. Gross revenue minus anything that reduces the actual sale value.'),
      VnVocab('Operating expenses (OpEx)',
          'Ongoing costs of running the business salaries, rent, software, marketing. Not the cost of making the product (that\'s COGS) but everything else required to keep operating.'),
      VnVocab('EBITDA',
          'Earnings Before Interest, Tax, Depreciation and Amortisation. A measure of operational performance that strips out financing and accounting decisions. Sara\'s shortcut: "what\'s left before the complicated stuff." Used to compare companies and assess core profitability.'),
      VnVocab('Net income',
          'The actual bottom line profit after everything: COGS, OpEx, interest, taxes, depreciation. Also called net profit. If negative, the company made a loss for the period.'),
    ],
  ),

  // 3 Desk email (choice)
  VnScene(
    location: 'Your desk · 2:00pm',
    chapter: 'Monday · The email',
    bg: VnBg.finDesk,
    sprites: [
      VnSprite(role: 'you', x: 148),
      VnSprite(role: 'koko', x: 258, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('A company-wide email lands from Marcus. Koko leans over your shoulder and reads it out loud, slowly.\n\n'),
      VnSegment('"Q3 ', italic: true),
      VnSegment('YTD', vocabIdx: 0),
      VnSegment(' ', italic: true),
      VnSegment('variance', vocabIdx: 1),
      VnSegment(': negative 8%. ', italic: true),
      VnSegment('Underspend', vocabIdx: 2),
      VnSegment(' in capex offset by opex overrun. ', italic: true),
      VnSegment('Forecast', vocabIdx: 3),
      VnSegment(' revised. ', italic: true),
      VnSegment('Allocation', vocabIdx: 4),
      VnSegment(' TBD."\n\n', italic: true),
      VnSegment('"Okay," Koko says. "YTD is year-to-date from January until now. The rest I think I understand it now. Do you?"'),
    ],
    vocab: [
      VnVocab('YTD Year-to-Date',
          'From the start of the fiscal year to the current date. "YTD variance of -8%" means that from January through now, results are 8% below plan. A standard time reference in any finance email or report.'),
      VnVocab('Budget variance',
          'The difference between what was planned (budget) and what actually happened. Negative variance = worse than planned. -8% is a gap that requires explanation and action.'),
      VnVocab('Underspend',
          'Spending less than budgeted. Sounds positive but Marcus says it\'s "offset by opex overrun," meaning savings in capital expenditure are cancelled by overspending on operating costs.'),
      VnVocab('Forecast',
          'An updated projection of full-year results, based on current trends. Different from the original budget forecasts are revised as reality changes. "Forecast revised" means the original plan no longer holds.'),
      VnVocab('Allocation',
          'How budget is distributed across teams or projects. "Allocation TBD" means Finance hasn\'t decided yet how to redistribute money for the rest of the year.'),
    ],
    choices: [
      VnChoice('a', '"Understood. Happy to help with reallocation analysis if useful."'),
      VnChoice('b', '"Could you clarify what underspend in capex means specifically?"'),
      VnChoice('c', 'Don\'t reply this isn\'t directed at you personally.'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Three minutes later, Marcus replies with one word: "Good." Koko: "Clean, professional, useful. You offered something without overstepping. That\'s the register."'),
      'b': VnResult(correct: true,
          feedback: 'Marcus replies: "Capital expenditure equipment, infrastructure. Long-term assets." Koko: "Asking for clarity is never wrong. He answered, didn\'t he?"'),
      'c': VnResult(correct: true,
          feedback: 'Koko nods. "Knowing when not to reply is also a skill. You\'re watching, learning not creating noise. Sometimes that\'s exactly right."'),
    },
  ),

  // 4 Cash flow crisis (choice)
  VnScene(
    location: 'Open space · 4:00pm',
    chapter: 'Monday · Cash flow crisis',
    bg: VnBg.finCrisis,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Sara',
    speakerColor: Color(0xFFD4537E),
    segments: [
      VnSegment('Sara appears at your desk, low voice, fast words.\n\n'),
      VnSegment('"Marcus is on the phone with the supplier. Their invoice is 14 days overdue ', italic: true),
      VnSegment('accounts payable', vocabIdx: 0),
      VnSegment(' problem. Can you pull the ', italic: true),
      VnSegment('cash flow', vocabIdx: 1),
      VnSegment(' summary? Check the ', italic: true),
      VnSegment('working capital', vocabIdx: 2),
      VnSegment(' line ', italic: true),
      VnSegment('liquidity', vocabIdx: 3),
      VnSegment(' is the question. The ', italic: true),
      VnSegment('burn rate', vocabIdx: 4),
      VnSegment(' dashboard is open on your screen."\n\n', italic: true),
      VnSegment('Koko is not here. This is the first real task.'),
    ],
    vocab: [
      VnVocab('Accounts payable (AP)',
          'Money a company owes to its suppliers invoices received but not yet paid. Overdue AP signals a cash flow or process problem, and damages supplier relationships.'),
      VnVocab('Cash flow',
          'The actual movement of cash in and out of the business. Separate from profit a company can show profit on the P&L while having no cash to pay its bills.'),
      VnVocab('Working capital',
          'Current assets minus current liabilities. The short-term financial health of the business can it pay its bills this month? A ratio below 1.0 is a warning sign. Meridian\'s is 0.84.'),
      VnVocab('Liquidity',
          'How easily a company can meet short-term obligations with available cash or near-cash assets. "Liquidity is tight" means cash flow pressure exists not the same as being unprofitable.'),
      VnVocab('Burn rate',
          'How much cash the company spends each month. At €340k/month, Meridian needs consistent cash inflows to stay solvent. High burn + low liquidity = urgent problem.'),
    ],
    choices: [
      VnChoice('a', '"Operating cash flow is negative this month that\'s why the payment is blocked."'),
      VnChoice('b', '"Working capital ratio is 0.84. Below 1.0 current liabilities exceed current assets."'),
      VnChoice('c', '"Let me find the right report before I say anything."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Sara nods sharply. "That\'s the line Marcus needs." Koko appears, quietly: "You remembered. Profit and cash aren\'t the same thing. That\'s the whole lesson."'),
      'b': VnResult(correct: true,
          feedback: 'Sara: "Good. 0.84 is the problem in one number." Koko: "Straight to the diagnostic. That\'s Finance thinking."'),
      'c': VnResult(correct: true,
          feedback: 'Sara: "Smart don\'t guess." She points you to the right report. Koko: "Knowing what you don\'t know yet is also a skill. Especially in a crisis."'),
    },
  ),

  // 5 Investor call
  VnScene(
    location: 'Conference room · Tuesday morning',
    chapter: 'Tuesday · The investor call',
    bg: VnBg.finConference,
    sprites: [
      VnSprite(role: 'koko', x: 44),
      VnSprite(role: 'you', x: 210, flip: true),
      VnSprite(role: 'koko', x: 270, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Marcus presents Q3 results to investors. You sit in and take notes. The language comes fast and dense.\n\n'),
      VnSegment('"'),
      VnSegment('Runway', vocabIdx: 0),
      VnSegment(' of 14 months. ', italic: true),
      VnSegment('Equity', vocabIdx: 1),
      VnSegment(' position solid. No planned ', italic: true),
      VnSegment('dilution', vocabIdx: 2),
      VnSegment(' this cycle. ', italic: true),
      VnSegment('ROE', vocabIdx: 3),
      VnSegment(' at 11.4% ', italic: true),
      VnSegment('leverage', vocabIdx: 4),
      VnSegment(' within covenant. ', italic: true),
      VnSegment('Valuation', vocabIdx: 5),
      VnSegment(' holds."\n\n', italic: true),
      VnSegment('An investor goes quiet after "runway." Koko leans in: '),
      VnSegment('"14 months that means the money lasts 14 more months. The investor just went quiet. I don\'t think that\'s great."', italic: true),
    ],
    vocab: [
      VnVocab('Runway',
          'How many months the company can keep operating at the current burn rate before cash runs out. 14 months sounds safe but fundraising takes 6–9 months. So 14 months of runway means the clock is already ticking on the next raise.'),
      VnVocab('Equity',
          'The ownership stake in the company what remains after liabilities are subtracted from assets. "Equity solid" means shareholders\' value is intact. Also refers to shares issued during a fundraise.'),
      VnVocab('Dilution',
          'When new shares are issued, existing shareholders own a smaller percentage of the company. "No planned dilution" means Meridian isn\'t planning a new equity raise good news for current investors whose stake won\'t shrink.'),
      VnVocab('ROE Return on Equity',
          'Net income divided by shareholders\' equity. For every €100 invested, how much profit did the company make? 11.4% ROE tells investors how efficiently their capital is being used.'),
      VnVocab('Leverage',
          'Using borrowed money (debt) to finance operations. "Within covenant" means the debt ratio hasn\'t breached the limits set in the loan agreement. The company is borrowing within its allowed range.'),
      VnVocab('Valuation',
          'The estimated worth of the company. "Valuation holds" means the company\'s value hasn\'t dropped despite the challenges discussed relevant for investors who bought in at a specific price.'),
    ],
  ),

  // 6 Marcus's office (choice)
  VnScene(
    location: 'Marcus\'s office · End of day',
    chapter: 'Tuesday · Boss scene',
    bg: VnBg.finMarcusOffice,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Marcus',
    speakerColor: Color(0xFF9090A8),
    segments: [
      VnSegment('Marcus closes the door. He sits. He doesn\'t open his laptop.\n\n'),
      VnSegment('"What\'s your read on the Q3 numbers?"\n\n', italic: true),
      VnSegment('Koko is outside. Two days of Finance are inside your head now. You know the words '),
      VnSegment('margin pressure', vocabIdx: 0),
      VnSegment(', '),
      VnSegment('cost structure', vocabIdx: 1),
      VnSegment(', '),
      VnSegment('cash position', vocabIdx: 2),
      VnSegment(', '),
      VnSegment('growth trajectory', vocabIdx: 3),
      VnSegment('. This is the moment to use them.'),
    ],
    vocab: [
      VnVocab('Margin pressure',
          'Something squeezing the gross or net margin downward rising costs, pricing pressure, or both. "We\'re seeing margin pressure from COGS" is how you name the problem precisely without overstating it.'),
      VnVocab('Cost structure',
          'The breakdown of a company\'s costs fixed vs variable, COGS vs OpEx. "The cost structure needs reviewing" is the measured way to say spending is the problem.'),
      VnVocab('Cash position',
          'How much cash the company holds and whether it\'s sufficient to meet obligations. "Cash position is tight" is precise it names the situation without catastrophising.'),
      VnVocab('Growth trajectory',
          'The direction and pace of growth is revenue accelerating, flattening, or declining? "Growth trajectory intact" means sales are still moving in the right direction despite other challenges.'),
    ],
    choices: [
      VnChoice('a', '"Revenue is on target but there\'s margin pressure from COGS. Cash position is tighter than the P&L suggests."'),
      VnChoice('b', '"Growth trajectory looks solid. The cost structure is the issue margins are being squeezed."'),
      VnChoice('c', '"I\'m still learning the numbers. I\'d rather not give you a half-read."'),
    ],
    results: {
      'a': VnResult(correct: true, xp: 120,
          feedback: 'Marcus goes quiet for three seconds. "That\'s exactly it." He turns back to his screen. Outside, Koko grins. "You just spoke Finance to the CFO. That\'s not nothing."'),
      'b': VnResult(correct: true, xp: 100,
          feedback: '"Cost structure yes. What specifically?" The conversation runs fifteen minutes. Koko, outside: "You held the room. That\'s the whole game."'),
      'c': VnResult(correct: true, xp: 60,
          feedback: 'Marcus looks at you differently something like respect. "Fair." A pause. "Come back Thursday. We\'ll go through it together." Koko: "He didn\'t fire you, did he?"'),
    },
  ),

  // 7 Rooftop epilogue
  VnScene(
    location: 'Rooftop · Friday 6pm',
    chapter: 'End of week',
    bg: VnBg.finRooftop,
    sprites: [
      VnSprite(role: 'you', x: 44),
      VnSprite(role: 'koko', x: 140),
      VnSprite(role: 'koko', x: 234, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Marcus makes a joke about the burn rate and the catering bill. You laugh.\n\nThen you notice: you laughed because you understood it.\n\nSara catches your eye across the rooftop. "First week," she says. "You\'ll be fine."\n\n'),
      VnSegment('Koko leans on the railing and looks out at the city. "Remember Monday morning? The receptionist said \'month-end close\' and we had absolutely nothing. Look at you now."', italic: true),
    ],
    isLast: true,
  ),
];

// ─── HR (9 scenes) ────────────────────────────────────────────────────────────

const List<VnScene> hrScenes = [
  // 0 Floor arrival
  VnScene(
    location: 'Floor 2 · People & Culture',
    chapter: 'Act I Arrival',
    bg: VnBg.hrFloor,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 230, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 2 is quieter than the others. Warmer, somehow. Plants on the desks. A jar of biscuits nobody touches.\n\n'),
      VnSegment('"HR gets underestimated," Koko says. "People think it\'s paperwork and parties. It\'s actually the department that decides whether this company has a future by deciding what kind of people work here."', italic: true),
    ],
  ),

  // 1 Vocabulary wall
  VnScene(
    location: 'Meeting room · Vocabulary wall',
    chapter: 'Act I The language',
    bg: VnBg.hrRecruit,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 225, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('A hiring pipeline fills the screen. 84 people applied. 1 offer is out.\n\n'),
      VnSegment('"HR has its own language and most of it isn\'t about HR. It\'s about how a company treats the people inside it."\n\n', italic: true),
      VnSegment('Headcount', vocabIdx: 0),
      VnSegment('. '),
      VnSegment('Attrition', vocabIdx: 1),
      VnSegment('. '),
      VnSegment('eNPS', vocabIdx: 2),
      VnSegment('. '),
      VnSegment('Employer brand', vocabIdx: 3),
      VnSegment('. '),
      VnSegment('Psychological safety', vocabIdx: 4),
      VnSegment('.'),
    ],
    vocab: [
      VnVocab('Headcount',
          'The number of people employed by a company or department. "Strategic headcount" means making deliberate decisions about how many people to hire, where, and at what level. Every hire is an investment and a commitment.'),
      VnVocab('Attrition',
          'The rate at which employees leave the company. "Voluntary attrition" is when people choose to leave. "Involuntary attrition" is layoffs. High attrition is expensive replacing someone costs roughly 1.5x their annual salary.'),
      VnVocab('eNPS Employee Net Promoter Score',
          'A measure of how likely employees are to recommend the company as a place to work, on a scale of -100 to +100. Above +30 is considered good. It\'s a quick pulse check on culture and belonging.'),
      VnVocab('Employer brand',
          'The company\'s reputation as a place to work how candidates and employees perceive it. A strong employer brand attracts better talent and reduces time-to-hire. Shaped by culture, reviews, and how the company treats people publicly.'),
      VnVocab('Psychological safety',
          'The belief that you can speak up, take risks, make mistakes, or ask questions without being punished or humiliated. Teams with high psychological safety perform better and innovate more. It\'s the foundation HR tries to protect.'),
    ],
  ),

  // 2 Interview debrief (choice)
  VnScene(
    location: 'Interview debrief · Hot seat',
    chapter: 'Act I The question',
    bg: VnBg.hrRecruit,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Hiring Manager',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"Two finalists. Candidate A is technically stronger. Candidate B has better cultural alignment and a stronger growth trajectory." She pauses.\n\n"We can only make one offer. HR says we should decide by Friday. What\'s your thinking?"'),
    ],
    choices: [
      VnChoice('a', '"Go with Candidate A technical skills are the hardest to train."'),
      VnChoice('b', '"Go with Candidate B culture fit and growth mindset matter more long-term."'),
      VnChoice('c', '"Dig deeper into Candidate B\'s technical skills before deciding the gap might be smaller than it looks."'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko (later): "Technical skills matter. So do the people around the table every day. Companies often regret the brilliant hire nobody could work with."'),
      'b': VnResult(correct: false,
          feedback: 'Koko: "Culture fit is important but it shouldn\'t paper over real skill gaps. Make sure \'cultural alignment\' isn\'t code for \'familiar\' or \'comfortable\'."'),
      'c': VnResult(correct: true,
          feedback: 'Koko: "Good instinct. A debrief rarely has complete information. Asking for more before a decision that matters that\'s how good hiring works."'),
    },
  ),

  // 3 Onboarding
  VnScene(
    location: 'HR desk · Onboarding',
    chapter: 'Act II The first 90 days',
    bg: VnBg.hrOnboarding,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Hiring the right person is only half the job." Koko opens the onboarding plan.\n\n'),
      VnSegment('"The first 90 days determine whether someone stays or quietly starts looking elsewhere. ', italic: true),
      VnSegment('Onboarding', vocabIdx: 0),
      VnSegment(' isn\'t paperwork it\'s the first chapter of the story you\'re telling a new employee."\n\n', italic: true),
      VnSegment('"If they feel lost in week two, you\'re already losing them."'),
    ],
    vocab: [
      VnVocab('Onboarding',
          'The structured process of integrating a new hire into the company their role, their team, the culture, the tools. Good onboarding accelerates time-to-productivity and signals that the company is organised and cares.'),
      VnVocab('30-60-90 day plan',
          'A roadmap for a new hire\'s first three months. 30 days: learn. 60 days: contribute. 90 days: lead something. Gives structure to both the hire and their manager, and creates early accountability.'),
      VnVocab('Buddy system',
          'Assigning an existing employee to informally guide a new hire through the first weeks. The buddy answers the questions people are too embarrassed to ask their manager. Cheap to implement; high impact on retention.'),
    ],
  ),

  // 4 Compensation
  VnScene(
    location: 'HR office · Compensation',
    chapter: 'Act II The pay question',
    bg: VnBg.hrCompensation,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Everyone wonders about pay. Few people know how it actually works." Koko pulls up the compensation framework.\n\n'),
      VnSegment('"Most companies have ', italic: true),
      VnSegment('compensation bands', vocabIdx: 0),
      VnSegment(' pay ranges for each level. Your salary sits somewhere in the band. Where you land depends on your experience, performance, and sometimes, how well you negotiated."', italic: true),
    ],
    vocab: [
      VnVocab('Compensation bands',
          'Salary ranges defined for each job level. Every role has a minimum, midpoint, and maximum. HR uses bands to ensure internal equity (fairness within the team) and market competitiveness. Being "at band max" often means a promotion is the next step.'),
      VnVocab('Total compensation',
          'Everything you receive not just base salary, but bonus, equity (stock options or RSUs), pension contribution, and benefits. Always ask about total comp, not just salary, when evaluating an offer.'),
      VnVocab('Equity / Stock options',
          'The right to buy company shares at a set price, usually vesting over 4 years. If the company grows, your equity grows with it. A small equity stake in a successful startup can be worth significantly more than a higher salary elsewhere.'),
    ],
  ),

  // 5 Difficult conversation (choice)
  VnScene(
    location: '1:1 room · Difficult conversation',
    chapter: 'Act II Your turn',
    bg: VnBg.hrDifficultConvo,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"HR handles the moments managers avoid." Koko looks at the PIP document.\n\n'),
      VnSegment('"A ', italic: true),
      VnSegment('PIP', vocabIdx: 0),
      VnSegment(' isn\'t a punishment it\'s a structured attempt to help someone improve before the situation becomes irreversible. How you run it matters as much as the outcome."\n\n', italic: true),
      VnSegment('"What matters most in a difficult performance conversation?"'),
    ],
    vocab: [
      VnVocab('PIP Performance Improvement Plan',
          'A formal document outlining specific concerns about an employee\'s performance, clear expectations for improvement, a timeline, and support offered. Done well, it\'s supportive. Done poorly, it\'s a paper trail before termination.'),
      VnVocab('Performance calibration',
          'A meeting where managers across teams align on ratings before they\'re finalised. Prevents grade inflation in some teams and grade deflation in others. Ensures the same standard applies company-wide.'),
      VnVocab('360 feedback',
          'Feedback collected from all directions manager, peers, direct reports, and sometimes clients. Gives a fuller picture than top-down review alone. Often used alongside self-assessment in performance cycles.'),
    ],
    choices: [
      VnChoice('a', '"Be clear about what\'s not working and document everything for legal protection."'),
      VnChoice('b', '"Start by understanding what\'s causing the performance issue before proposing solutions."'),
      VnChoice('c', '"Deliver feedback quickly and clearly don\'t soften it so much the person doesn\'t understand the seriousness."'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko: "Documentation is necessary but starting with legal protection puts you in adversarial mode. That\'s rarely the right opening."'),
      'b': VnResult(correct: true,
          feedback: 'Koko: "A performance issue often has a cause. Workload, personal situation, wrong role. Understanding comes before prescription."'),
      'c': VnResult(correct: false,
          feedback: 'Koko: "Clarity matters. But starting with \'what\'s happening for you\' before \'here\'s the problem\' changes the whole conversation."'),
    },
  ),

  // 6 Engagement data
  VnScene(
    location: 'Culture room · Engagement data',
    chapter: 'Act II The retention problem',
    bg: VnBg.hrEngagement,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Three senior engineers have left in six months. Exit interviews all say the same thing." Koko reads through the data.\n\n'),
      VnSegment('"'),
      VnSegment('Retention', vocabIdx: 0),
      VnSegment(' isn\'t about ping pong tables. It\'s about whether people feel they\'re growing, being heard, and fairly compensated. When those three align people stay."', italic: true),
    ],
    vocab: [
      VnVocab('Retention',
          'The ability to keep employees. Measured as a percentage: 91% retention means 9% of people left. Retention is affected by growth opportunities, management quality, culture, and compensation. It\'s cheaper to retain than to replace.'),
      VnVocab('Flight risk',
          'An employee considered at risk of leaving voluntarily. HR tracks flight risks through engagement surveys, performance trends, and 1:1 signals. Proactive conversation is cheaper than an exit interview.'),
      VnVocab('Recognition',
          'Acknowledging and rewarding contributions formally (awards, bonuses) or informally (a thank you, a mention in all-hands). One of the most consistent factors in employee satisfaction, and one of the cheapest levers HR has.'),
    ],
  ),

  // 7 Executive meeting (choice)
  VnScene(
    location: 'Executive meeting · Final decision',
    chapter: 'Act III The hard call',
    bg: VnBg.hrPerformance,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'CPO',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"We\'re restructuring one team. That means three roles are being eliminated. We\'ve told Finance and the board but the employees don\'t know yet. We have to communicate this by Friday."\n\n"HR is leading this. What\'s the right way to handle it?"\n\nKoko\'s chair is empty.'),
    ],
    choices: [
      VnChoice('a', 'Tell the affected employees individually, privately, and first before any team or company-wide announcement'),
      VnChoice('b', 'Send a company-wide email announcing the restructure so everyone hears at the same time'),
      VnChoice('c', 'Wait until final details are confirmed before communicating anything don\'t create anxiety with incomplete information'),
    ],
    results: {
      'a': VnResult(correct: true, xp: 120,
          feedback: 'Koko (appearing quietly): "Always. Individual, private, respectful and before the rumour mill. Dignity in a hard moment is what people remember."'),
      'b': VnResult(correct: false, xp: 20,
          feedback: 'Koko: "Finding out your role is eliminated in a company-wide email is a failure of care. HR\'s job is to preserve dignity, especially in hard moments."'),
      'c': VnResult(correct: false, xp: 30,
          feedback: 'Koko: "Waiting creates a vacuum and rumours fill it faster than facts. Timely, direct communication even when incomplete is almost always better."'),
    },
  ),

  // 8 Epilogue
  VnScene(
    location: 'People team · End of day',
    chapter: 'Act III Epilogue',
    bg: VnBg.hrWrap,
    sprites: [
      VnSprite(role: 'you', x: 58),
      VnSprite(role: 'koko', x: 225, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('The day is done. The plant is still there. The biscuits are gone now.\n\n'),
      VnSegment('"Every other department builds products, sells things, writes code. HR builds the environment in which all of that is possible."\n\n', italic: true),
      VnSegment('"When it works you don\'t notice it. You just feel like you belong."'),
    ],
    isLast: true,
  ),
];

// ─── TECH (9 scenes) ──────────────────────────────────────────────────────────

const List<VnScene> techScenes = [
  // 0 Floor arrival
  VnScene(
    location: 'Floor 3 · Engineering',
    chapter: 'Act I Arrival',
    bg: VnBg.techEngFloor,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 230, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('Floor 3 smells like cold coffee and intent. Screens everywhere. Headphones on every head.\n\n'),
      VnSegment('"Tech teams have their own universe," Koko says quietly. "Their language feels technical but most of it is about how people work together, not just how code works."\n\n', italic: true),
      VnSegment('A terminal blinks. A deploy is running.'),
    ],
  ),

  // 1 Stand-up vocabulary
  VnScene(
    location: 'Open space · Vocabulary wall',
    chapter: 'Act I The language',
    bg: VnBg.techStandUp,
    sprites: [
      VnSprite(role: 'you', x: 55),
      VnSprite(role: 'koko', x: 225, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('A stand-up is starting. Everyone gives a ten-second update. Three questions, always the same.\n\nKoko whispers the key words. '),
      VnSegment('Sprint', vocabIdx: 0),
      VnSegment('. '),
      VnSegment('Velocity', vocabIdx: 1),
      VnSegment('. '),
      VnSegment('Blocker', vocabIdx: 2),
      VnSegment('. '),
      VnSegment('Deploy', vocabIdx: 3),
      VnSegment('. '),
      VnSegment('Technical debt', vocabIdx: 4),
      VnSegment('.\n\n'),
      VnSegment('"These aren\'t tech concepts. They\'re rhythm words. They describe how the team moves."', italic: true),
    ],
    vocab: [
      VnVocab('Sprint',
          'A fixed time period (usually 2 weeks) during which the team commits to deliver a set of features or fixes. Sprints create rhythm. At the end, something ships or doesn\'t.'),
      VnVocab('Velocity',
          'How much work a team completes per sprint, measured in story points. Used to forecast how long a project will take. "Our velocity is 34 points" means they\'re moving at a known, measurable pace.'),
      VnVocab('Blocker',
          'Anything stopping a team member from moving forward. "I\'m blocked" means work has stopped and something a decision, access, a dependency needs to be resolved before progress resumes.'),
      VnVocab('Deploy',
          'Releasing code to production the live environment where real users interact with the product. Deploying is the moment where the work becomes real.'),
      VnVocab('Technical debt',
          'Code shortcuts or outdated approaches that will need to be fixed later. Like financial debt, it accumulates interest the longer you wait, the more expensive it becomes to fix.'),
    ],
  ),

  // 2 Stand-up hot seat (choice)
  VnScene(
    location: 'Standup · Hot seat',
    chapter: 'Act I The question',
    bg: VnBg.techStandUp,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Engineering Lead',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"The dashboard feature is blocked. Priya\'s PR has been waiting 3 days for review. We\'re going to miss the sprint goal."\n\nEveryone looks at the team. Koko isn\'t there.\n\n"What do we prioritise the review or the new tickets already in the backlog?"'),
    ],
    choices: [
      VnChoice('a', '"Clear the blocker first. New tickets can wait unblocking Priya protects the sprint goal."'),
      VnChoice('b', '"Split the team some do reviews, some pull new tickets. We can do both."'),
      VnChoice('c', '"Pull the feature from the sprint. We can\'t hit the goal anyway."'),
    ],
    results: {
      'a': VnResult(correct: true,
          feedback: 'Koko (later): "In Agile, clearing blockers always takes priority. Unblocked work compounds. Blocked work rots."'),
      'b': VnResult(correct: false,
          feedback: 'Koko: "Context switching kills velocity. Partial focus on both means neither gets done well and the sprint still misses."'),
      'c': VnResult(correct: false,
          feedback: 'Koko: "Pulling features mid-sprint is a last resort not a first response. Always unblock before you descope."'),
    },
  ),

  // 3 Architecture whiteboard
  VnScene(
    location: 'Whiteboard room · Architecture',
    chapter: 'Act II How they build',
    bg: VnBg.techArchitecture,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Tech teams talk about their system like it\'s a city," Koko draws boxes. "The '),
      VnSegment('frontend', vocabIdx: 0),
      VnSegment(' is what users see. The '),
      VnSegment('backend', vocabIdx: 1),
      VnSegment(' is everything underneath logic, databases, processing."\n\n'),
      VnSegment('"Then there\'s ', italic: true),
      VnSegment('infrastructure', vocabIdx: 2),
      VnSegment(' the roads everything runs on. Without it, nothing reaches anyone."', italic: true),
    ],
    vocab: [
      VnVocab('Frontend',
          'The part of the product users interact with directly the interface, the buttons, the screens. Built for humans. Measured in clarity, speed, and feel.'),
      VnVocab('Backend',
          'The server-side logic, databases, and APIs that power the product. Users never see it, but everything depends on it. When the backend breaks, the frontend becomes a beautiful empty shell.'),
      VnVocab('Infrastructure (Infra)',
          'The servers, cloud services, networks, and pipelines that run the software. Often managed by a dedicated "infra" or "DevOps" team. Think of it as the plumbing invisible until something breaks.'),
      VnVocab('API Application Programming Interface',
          'A contract between two systems: "send me this, I\'ll send you that." APIs let the frontend talk to the backend, and let external services connect to your product. Everything talks through APIs.'),
      VnVocab('Microservices',
          'Breaking a large application into small, independent services that each do one thing. Opposite of a "monolith." More scalable, but harder to manage. Requires strong communication between services.'),
    ],
  ),

  // 4 P0 Incident
  VnScene(
    location: 'War room · P0 Incident',
    chapter: 'Act II The fire',
    bg: VnBg.techIncident,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"This is a '),
      VnSegment('P0', vocabIdx: 0),
      VnSegment('. Production is down. Everyone drops what they\'re doing." Koko\'s voice is calm, precise.\n\n'),
      VnSegment('"In an incident, the first question isn\'t who broke it it\'s how to restore service. ', italic: true),
      VnSegment('Rollback', vocabIdx: 1),
      VnSegment(' first. Post-mortem later."', italic: true),
    ],
    vocab: [
      VnVocab('P0 / Priority 0',
          'The highest severity incident. Production is down or a critical function is broken for all users. A P0 triggers immediate all-hands response. Everything else stops.'),
      VnVocab('Rollback',
          'Reverting to the previous stable version of the code. When a bad deploy causes an incident, rolling back is often the fastest path to recovery faster than fixing forward.'),
      VnVocab('Post-mortem',
          'A blame-free analysis after an incident. Documents what happened, why, and what changes will prevent it happening again. Good post-mortems focus on system failures, not individual blame.'),
      VnVocab('On-call',
          'The rotation where one engineer is responsible for responding to incidents during off-hours. Being on-call means carrying a pager (or equivalent) and waking up at 3am when production breaks.'),
    ],
  ),

  // 5 Code review
  VnScene(
    location: 'Review room · Code review',
    chapter: 'Act II Your turn',
    bg: VnBg.techPRReview,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"Code review is how the team keeps quality high without a single gatekeeper." Koko points at the screen.\n\n'),
      VnSegment('"A ', italic: true),
      VnSegment('pull request', vocabIdx: 0),
      VnSegment(' is a proposal \'I changed this, what do you think?\' The reviewer\'s job is to improve the code, not judge the author."\n\n', italic: true),
      VnSegment('"Good feedback is specific. Great feedback teaches."'),
    ],
    vocab: [
      VnVocab('Pull Request (PR)',
          'A formal request to merge code changes into the main branch. Before merging, one or more engineers review the code for correctness, style, and edge cases. PRs are where a lot of knowledge sharing happens.'),
      VnVocab('Code review',
          'The process of reading and evaluating someone else\'s code before it ships. Good reviews catch bugs, share knowledge, and maintain consistency. A PR waiting for review is often a blocker.'),
      VnVocab('Branch / Main',
          'A branch is a separate copy of the codebase where changes are developed safely. "Main" is the stable, production-ready version. You code on a branch, review it, then merge to main.'),
    ],
  ),

  // 6 Roadmap sprint planning (choice)
  VnScene(
    location: 'Sprint planning · Q4 roadmap',
    chapter: 'Act II The roadmap',
    bg: VnBg.techRoadmap,
    sprites: [
      VnSprite(role: 'koko', x: 72),
      VnSprite(role: 'you', x: 218, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('"'),
      VnSegment('Scope creep', vocabIdx: 0),
      VnSegment(' is the quiet killer," Koko says. "You start the quarter with four features. By week three, someone has added six more. Velocity drops. Nothing ships."\n\n'),
      VnSegment('"The PM\'s job is to say no. The team\'s job is to honour the sprint. Both require discipline."', italic: true),
    ],
    vocab: [
      VnVocab('Scope creep',
          'When requirements expand beyond what was originally agreed, usually mid-sprint. Each addition feels small. Together they make the sprint impossible. The antidote is a ticket freeze and a strong PM.'),
      VnVocab('MVP Minimum Viable Product',
          'The smallest version of a feature that delivers real value to users. Shipping an MVP fast lets the team learn from real usage before building more. "Perfect" is often the enemy of "shipped."'),
      VnVocab('Backlog',
          'The prioritised list of all work to be done features, bugs, tech debt. The backlog is never empty. The art is knowing which items matter most right now.'),
    ],
    choices: [
      VnChoice('a', '"We can fit the new payments feature in just scope it tightly."'),
      VnChoice('b', '"Payments goes in the backlog. We protect the current sprint commitment."'),
      VnChoice('c', '"We should extend the sprint by a week to accommodate it."'),
    ],
    results: {
      'a': VnResult(correct: false,
          feedback: 'Koko: "\'Scoped tightly\' is how scope creep starts. You can\'t un-squeeze a sprint."'),
      'b': VnResult(correct: true,
          feedback: 'Koko: "Exactly. Backlog it, prioritise it for next sprint, and keep the current commitment clean."'),
      'c': VnResult(correct: false,
          feedback: 'Koko: "Sprint extensions teach the team that deadlines are negotiable. They\'re not. Protect the rhythm."'),
    },
  ),

  // 7 Retro (choice)
  VnScene(
    location: 'Retro room · End of sprint',
    chapter: 'Act III The final call',
    bg: VnBg.techRetro,
    sprites: [
      VnSprite(role: 'you', x: 160),
    ],
    speaker: 'Engineering Lead',
    speakerColor: Color(0xFF888780),
    segments: [
      VnSegment('"We shipped everything. Then at 2am, we had a '),
      VnSegment('P0', vocabIdx: 0),
      VnSegment('. Root cause was '),
      VnSegment('technical debt', vocabIdx: 1),
      VnSegment(' in the auth module we knew about it for six months." He pauses.\n\n"I want to dedicate the entire next sprint to fixing it. No new features. Is that the right call?"\n\nKoko\'s seat is empty. It\'s your turn to speak.'),
    ],
    vocab: [
      VnVocab('P0 from tech debt',
          'Unresolved technical debt eventually becomes an incident. What was a "we\'ll fix it later" becomes a 2am production outage. This is why tech debt must be tracked and budgeted, not ignored.'),
      VnVocab('Technical debt sprint',
          'A sprint dedicated entirely to reducing technical debt no new features. Controversial with product teams, but necessary when debt has accumulated to breaking point.'),
    ],
    choices: [
      VnChoice('a', 'Agree one full sprint on tech debt now prevents three more incidents later'),
      VnChoice('b', 'Disagree mix tech debt and feature work; a full pause hurts the roadmap too much'),
      VnChoice('c', 'Propose a middle path: a dedicated debt epic tracked across two sprints, alongside lower-priority features'),
    ],
    results: {
      'a': VnResult(correct: true, xp: 100,
          feedback: 'Koko (appearing quietly): "One clean sprint of debt reduction often buys you a quarter of stability. That\'s a strong trade."'),
      'b': VnResult(correct: false, xp: 30,
          feedback: 'Koko: "Mixing debt and features slows both. The debt that caused a P0 deserves dedicated focus not a side project."'),
      'c': VnResult(correct: true, xp: 120,
          feedback: 'Koko: "This is mature engineering leadership. Spreading it preserves velocity while still making the debt visible and trackable. Well done."'),
    },
  ),

  // 8 Night office epilogue
  VnScene(
    location: 'Engineering · Night shift done',
    chapter: 'Act III Epilogue',
    bg: VnBg.techNightOffice,
    sprites: [
      VnSprite(role: 'you', x: 58),
      VnSprite(role: 'koko', x: 225, flip: true),
    ],
    speaker: 'Koko',
    speakerColor: Color(0xFF5DCAA5),
    segments: [
      VnSegment('2:47am. The incident is resolved. The post-mortem is scheduled for Monday.\n\n'),
      VnSegment('"Most people only see what Tech ships. They don\'t see the discipline the stand-ups, the reviews, the calls at midnight."\n\n', italic: true),
      VnSegment('"You do now. That\'s worth something."'),
    ],
    isLast: true,
  ),
];

// ─── DEPT → SCENES REGISTRY ───────────────────────────────────────────────────

final Map<String, List<VnScene>> _departmentScenes = {
  'management': managementScenes,
  'marketing':  marketingScenes,
  'accounting': accountingScenes,
  'legal':      legalScenes,
  'finance':    financeScenes,
  'rh':         hrScenes,
  'tech':       techScenes,
};

List<VnScene> getScenesForDept(String deptId) =>
    _departmentScenes[deptId] ?? managementScenes;
