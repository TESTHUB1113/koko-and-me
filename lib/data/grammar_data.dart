// ─── GRAMMAR EXERCISE DATA ────────────────────────────────────────────────────
// 4 multiple-choice questions per lesson, tied to the matching Vocabulary words.
// grammarData[deptId][lessonIdx] → list of 4 GrammarQuestions.

class GrammarQuestion {
  final String question;
  final List<String> options; // exactly 4
  final int correctIdx;       // 0–3
  final String explanation;
  const GrammarQuestion({
    required this.question,
    required this.options,
    required this.correctIdx,
    required this.explanation,
  });
}

final Map<String, List<List<GrammarQuestion>>> grammarData = {

  // ══════════════════════════════════════════════════════════════════════════
  // MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════
  'management': [
    // Lesson 1, agenda, AOB, minutes, action item, quorum
    [
      const GrammarQuestion(
        question: 'Which sentence uses "agenda" correctly?',
        options: [
          'Let\'s agenda the key topics before the call.',
          'Can you send the agenda before the meeting?',
          'The agenda are all covered now.',
          'We don\'t have agenda today.',
        ],
        correctIdx: 1,
        explanation: '"Agenda" is a singular noun, it always needs an article or possessive: "the agenda", "our agenda". It is never used as a verb. Singular verb: "the agenda is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence about "minutes" is correct?',
        options: [
          'Please send the minute of the last meeting.',
          'The minutes was approved at the start of the session.',
          'Please approve the minutes before we move on.',
          'I\'ll take a minute of today\'s meeting.',
        ],
        correctIdx: 2,
        explanation: '"Minutes" (meeting notes) is always plural. Say "the minutes were approved", "take the minutes". Never "the minute" or "a minute" in this sense.',
      ),
      const GrammarQuestion(
        question: 'Choose the correct sentence about "quorum".',
        options: [
          'We don\'t have a quorum, let\'s wait for two more members.',
          'We need to quorum the vote now.',
          'The quorum were finally reached.',
          'Do we quorum to proceed?',
        ],
        correctIdx: 0,
        explanation: '"Quorum" is a noun only, never a verb. It takes a singular verb: "a quorum is needed". Standard phrases: "reach a quorum", "have a quorum".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "action item" correctly?',
        options: [
          'We need to action item this task immediately.',
          'I have action item to complete by Friday.',
          'The action items was all noted in the minutes.',
          'Your action item is to send the report by Thursday.',
        ],
        correctIdx: 3,
        explanation: '"Action item" is a countable noun. Singular: "an action item is". Plural: "action items are". The verb comes separately: "My action item is to…".',
      ),
    ],
    // Lesson 2. CC, follow-up, sign-off, action item
    [
      const GrammarQuestion(
        question: 'Which sentence uses "CC" correctly?',
        options: [
          'Please CC to the whole team on this.',
          'I\'ve CC\'d the manager so she has context.',
          'She CC me on the email yesterday.',
          'The email was CC the client.',
        ],
        correctIdx: 1,
        explanation: '"CC" as a verb needs the past form "CC\'d". Never add "to" after CC: it\'s "CC someone", not "CC to someone". Present: "I CC everyone"; past: "I CC\'d her".',
      ),
      const GrammarQuestion(
        question: 'Which is the correct use of "follow-up"?',
        options: [
          'I\'ll follow up you tomorrow about the contract.',
          'Did you followed up with the client?',
          'I\'ll send a follow-up email after the call.',
          'Let\'s follow-up to the client this week.',
        ],
        correctIdx: 2,
        explanation: 'As a noun: "a follow-up". As a verb: "follow up" (two words, no hyphen). Always "follow up WITH someone" or "follow up ON something". After "did", use the base form: "did you follow up?".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "sign-off" correctly?',
        options: [
          'We need sign-off from the director before we proceed.',
          'She sign-off the contract yesterday.',
          'Can you sign off to this document?',
          'The sign-offs were requiring from three departments.',
        ],
        correctIdx: 0,
        explanation: '"Sign-off" (noun) = approval. "Sign off" (verb) = to approve: "sign off ON something" (not "sign off to"). Past tense: "she signed off on it".',
      ),
      const GrammarQuestion(
        question: 'Which sentence lists action items correctly?',
        options: [
          'We have three actions items from today\'s meeting.',
          'Action item: Tom is sending the brief by Friday.',
          'The action items from today: Tom to send the brief, Lisa to book the venue.',
          'The action item from today are: review the contract.',
        ],
        correctIdx: 2,
        explanation: 'Plural is "action items" (not "actions items"). In action lists, use infinitives: "Tom to send the brief" (not "Tom is sending"). Singular: "The action item is".',
      ),
    ],
    // Lesson 3, constructive, KPI, benchmark, deliverable
    [
      const GrammarQuestion(
        question: 'Which sentence uses "constructive" correctly?',
        options: [
          'She gave me constructive. I know what to fix.',
          'The feedback was constructively and helpful.',
          'Your feedback was very constructive. I know exactly what to improve.',
          'This is a constructive problem we need to resolve.',
        ],
        correctIdx: 2,
        explanation: '"Constructive" is an adjective that modifies nouns: "constructive feedback", "constructive criticism". It is not a noun itself ("gave me constructive" is wrong). The adverb is "constructively".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "KPI" correctly?',
        options: [
          'What are the KPI for this campaign?',
          'The KPIs was reported in the monthly review.',
          'We\'re tracking three KPIs: reach, engagement, and conversion.',
          'Let\'s KPI the team\'s performance this quarter.',
        ],
        correctIdx: 2,
        explanation: '"KPI" is a countable noun. Plural "KPIs" takes a plural verb: "KPIs are/were". Never use it as a verb. Singular: "a KPI is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "benchmark" correctly?',
        options: [
          'The industry benchmark for conversion is 2.5%.',
          'We set a benchmarks for the team.',
          'Our results were below benchmark, let\'s benchmark again.',
          'The benchmark are higher than last year.',
        ],
        correctIdx: 0,
        explanation: '"Benchmark" is a singular countable noun. "A benchmark", "the benchmark". Plural: "benchmarks". Standard phrases: "below/above the benchmark", "set a benchmark". Singular verb: "the benchmark is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "deliverable" correctly?',
        options: [
          'The deliverable are a report and a presentation.',
          'We need to deliverance this project on time.',
          'Each deliverable must be approvaled before payment.',
          'The main deliverable is a 10-page report, due by the 20th.',
        ],
        correctIdx: 3,
        explanation: '"Deliverable" is a countable noun. Singular: "the deliverable is". Plural: "deliverables are". Never used as a verb. Past participle of "approve" is "approved", not "approvaled".',
      ),
    ],
    // Lesson 4, leverage, concession, win-win, deadlock
    [
      const GrammarQuestion(
        question: 'Which sentence uses "leverage" correctly?',
        options: [
          'Let\'s leverage to get a better deal.',
          'We have leverage, so let\'s leverage the client into it.',
          'The leverage are in our favour this time.',
          'We have significant leverage, they need our technology.',
        ],
        correctIdx: 3,
        explanation: '"Leverage" (noun) = power/advantage. "Leverage" (verb) = use strategically: "leverage our data/relationships". You leverage things, not people. Singular: "our leverage is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "concession" correctly?',
        options: [
          'We made a concession on the timeline to close the deal.',
          'They concession us a lower price.',
          'The concessions were making by both sides.',
          'We need to make a concession of the deadline.',
        ],
        correctIdx: 0,
        explanation: '"Concession" is a noun. Never a verb. Standard phrases: "make a concession", "offer a concession". The correct preposition is ON: "a concession on the timeline/price".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "win-win" correctly?',
        options: [
          'This deal is win-win for both parties.',
          'We win-win the negotiation successfully.',
          'The negotiation was very win-winning.',
          'Extending the contract is a win-win for both sides.',
        ],
        correctIdx: 3,
        explanation: '"Win-win" is a noun or adjective. As a noun it needs an article: "a win-win" or "it\'s a win-win". As an adjective: "a win-win situation". Never a verb. "This is win-win" needs "a": "this is a win-win".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "deadlock" correctly?',
        options: [
          'Talks have reached a deadlock. Neither side will move.',
          'The deadlock were broken after a third meeting.',
          'We are in deadlock situation since two weeks.',
          'Let\'s deadlock this issue until Monday.',
        ],
        correctIdx: 0,
        explanation: '"Deadlock" is a noun. Singular verb: "the deadlock was broken". Preposition: "in a deadlock" or "at a deadlock". Time duration: "for two weeks" (not "since two weeks" without a start point). Never a verb.',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // HR
  // ══════════════════════════════════════════════════════════════════════════
  'rh': [
    // Lesson 1, cover letter, competency, panel, shortlisted
    [
      const GrammarQuestion(
        question: 'Which sentence uses "cover letter" correctly?',
        options: [
          'I have written a cover letter for the position.',
          'My cover letters was well received by HR.',
          'She cover lettered the company last week.',
          'Please send a covers letter with your application.',
        ],
        correctIdx: 0,
        explanation: '"Cover letter" is a countable noun, never a verb. Plural: "cover letters". Singular: "a cover letter was". The compound noun stays as two words: "cover letter", not "covers letter".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "competency" correctly?',
        options: [
          'She is very competency in her work.',
          'His competency are very impressive.',
          'We assess competency of the candidates.',
          'Communication is a core competency for this role.',
        ],
        correctIdx: 3,
        explanation: '"Competency" is a noun; the adjective is "competent". Say "she is competent" (not "competency"). Singular: "a competency is". Say "assess candidates\' competency" or "assess competencies".',
      ),
      const GrammarQuestion(
        question: 'Which sentence about "panel" is correct?',
        options: [
          'The panelled interview went very well.',
          'You\'ll be interviewed by a panel of three experts.',
          'A panel interview have been scheduled for Thursday.',
          'The panel were disagreeing on every point.',
        ],
        correctIdx: 1,
        explanation: '"Panel" is a collective noun that takes a singular verb in formal writing: "the panel was". "A panel interview has been scheduled". "Panelled" as an adjective here is incorrect.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "shortlisted" correctly?',
        options: [
          'We shortlist two candidates yesterday.',
          'She is shortlist for the final round.',
          'Three candidates have been shortlisted for the final interview.',
          'The shortlisted of candidates includes five people.',
        ],
        correctIdx: 2,
        explanation: '"Shortlisted" is a past participle used in passive voice: "have been shortlisted". "Shortlist" (noun) = the list; "shortlisted" (adjective) = on the list. "The shortlist of candidates" (not "shortlisted of").',
      ),
    ],
    // Lesson 2, probation, induction, buddy system, org chart
    [
      const GrammarQuestion(
        question: 'Which sentence uses "probation" correctly?',
        options: [
          'She is on probation for the first three months.',
          'He was probationed when he joined.',
          'The probation period are six months.',
          'We put them in probation on their first day.',
        ],
        correctIdx: 0,
        explanation: '"On probation" is the correct phrase, the preposition is ON, not IN. Singular verb: "the probation period is". "Probation" is never used as a verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "induction" correctly?',
        options: [
          'We induction new staff every quarter.',
          'The inductions program covers HR and IT.',
          'Her induction is scheduled for Monday morning.',
          'She was inducted at last Tuesday.',
        ],
        correctIdx: 2,
        explanation: '"Induction" is a noun; the verb is "induct". Say "induction programme" (singular, not "inductions programme"). Preposition: inducted ON a date (not "at").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "buddy system" correctly?',
        options: [
          'Your buddy system will be assigned on your first day.',
          'We buddy-systemed her with the sales team.',
          'We use a buddy system to help new starters settle in.',
          'The buddy system are very popular here.',
        ],
        correctIdx: 2,
        explanation: '"Buddy system" is a noun phrase, never a verb. The system is what you use; the individual is "your buddy". Singular verb: "the buddy system is". Say "you\'ll be assigned a buddy" not "your buddy system will be assigned".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "org chart" correctly?',
        options: [
          'The org chart clearly shows the reporting structure.',
          'Can you org chart the new team for me?',
          'We have a org chart on the intranet.',
          'The org charts is out of date.',
        ],
        correctIdx: 0,
        explanation: '"Org chart" is a noun, never a verb. Use "an org chart" (vowel sound: /ɔːrɡ/). Plural: "org charts are". Say "update/draw/check the org chart".',
      ),
    ],
    // Lesson 3, appraisal, 360 feedback, OKR, PIP
    [
      const GrammarQuestion(
        question: 'Which sentence uses "appraisal" correctly?',
        options: [
          'We appraisaled his performance last month.',
          'The appraisals was positive across the team.',
          'She received a great appraise from her manager.',
          'Her annual appraisal is next week, she\'s well prepared.',
        ],
        correctIdx: 3,
        explanation: 'The noun is "appraisal"; the verb is "appraise" (past: "appraised"). Plural: "appraisals were". "Appraise" ≠ "appraisal". Never say "an appraise".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "360 feedback" correctly?',
        options: [
          'She received a 360-feedbacks from her team.',
          'We use 360 feedback to get a full picture of performance.',
          'The 360 feedback were very positive this year.',
          'Let\'s 360 feedback the new manager this cycle.',
        ],
        correctIdx: 1,
        explanation: '"360 feedback" is treated as a singular, uncountable concept: "360 feedback was positive". Never pluralised as "360-feedbacks". Never used as a verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "OKR" correctly?',
        options: [
          'The team\'s OKRs for Q2 are set and shared.',
          'Our OKR for this quarter is reduce costs by 10%.',
          'We OKR the team every quarter.',
          'The OKRs was agreed in the planning session.',
        ],
        correctIdx: 0,
        explanation: '"OKR" is a countable noun. Plural "OKRs" takes a plural verb: "OKRs are/were". Never a verb. The Key Result is written as an infinitive: "to reduce costs by 10%" (not "is reduce costs").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "PIP" correctly?',
        options: [
          'She was put on a PIP after two consecutive poor reviews.',
          'The manager PIPped the employee last week.',
          'A PIP are a formal document outlining improvement goals.',
          'He received PIP from his line manager.',
        ],
        correctIdx: 0,
        explanation: '"PIP" is a countable noun. Say "put someone on a PIP" or "place someone on a PIP". Singular verb: "a PIP is a formal document". Never a verb. Always use an article: "a PIP" (not just "received PIP").',
      ),
    ],
    // Lesson 4, mediation, de-escalate, grievance, arbitration
    [
      const GrammarQuestion(
        question: 'Which sentence uses "mediation" correctly?',
        options: [
          'Both parties agreed to mediation after talks broke down.',
          'They mediationed the issue last week.',
          'The mediations are scheduled for this Thursday.',
          'We mediations every conflict in this department.',
        ],
        correctIdx: 0,
        explanation: '"Mediation" is an uncountable noun. Never "mediationed" or "mediations" (for a single process). The verb is "mediate". Phrases: "go to mediation", "enter mediation", "agree to mediation".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "de-escalate" correctly?',
        options: [
          'We need to de-escalation the conflict.',
          'She de-escalating the tension successfully.',
          'The manager intervened to de-escalate the situation.',
          'The HR team de-escalate the issue since last month.',
        ],
        correctIdx: 2,
        explanation: '"De-escalate" is a verb; the noun is "de-escalation". After "to" use the base form: "to de-escalate". Past tense: "de-escalated". "Has been de-escalating" for ongoing action.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "grievance" correctly?',
        options: [
          'She grievanced her manager over the incident.',
          'He submitted a formal grievance to the HR department.',
          'The grievances was handled promptly by the team.',
          'We received a grievance of unfair treatment.',
        ],
        correctIdx: 1,
        explanation: '"Grievance" is a noun only. Use "raise/file/submit a grievance". Plural: "grievances were". Preposition: "a grievance about/regarding" something (not "of").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "arbitration" correctly?',
        options: [
          'We arbitrationed the case last spring.',
          'The arbitration are binding on both parties.',
          'The dispute was resolved through arbitration, avoiding a costly trial.',
          'She arbitration her contract dispute independently.',
        ],
        correctIdx: 2,
        explanation: '"Arbitration" is a noun. The verb is "arbitrate". Singular: "arbitration is binding". Phrases: "go to arbitration", "take to arbitration", "enter arbitration".',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // FINANCE
  // ══════════════════════════════════════════════════════════════════════════
  'finance': [
    // Lesson 1. Capex, Opex, variance, allocation
    [
      const GrammarQuestion(
        question: 'Which sentence uses "Capex" correctly?',
        options: [
          'We Capexed the equipment purchase last year.',
          'Software licences are Opex; hardware is Capex.',
          'The Capexes are over budget this quarter.',
          'All Capexes must be approved by the CFO.',
        ],
        correctIdx: 1,
        explanation: '"Capex" and "Opex" are mass nouns, they don\'t pluralise as "Capexes/Opexes". Think of them like "spending": "Capex spending is", "our Capex is". Never used as verbs.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "variance" correctly?',
        options: [
          'Our results variance significantly from forecast.',
          'We have variance issues in two departments, both overspent.',
          'There is a €15,000 variance between budget and actual spend.',
          'The variances is all under €5,000 this month.',
        ],
        correctIdx: 2,
        explanation: '"Variance" is a noun; the verb is "vary". "A variance of X" = the gap. Plural: "variances are". "We have variance issues" is acceptable, but "variance between" is the most precise form.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "allocation" correctly?',
        options: [
          'The budget allocation for marketing was increased by 20%.',
          'We need to allocating more funds to R&D.',
          'The allocation are split across four teams.',
          'She allocated the funds very allocation.',
        ],
        correctIdx: 0,
        explanation: '"Allocation" is a noun; "allocate" is the verb. After modal verbs and "need to", use the base form: "need to allocate" (not "allocating"). Singular: "the allocation is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence correctly contrasts Capex and Opex?',
        options: [
          'Cloud hosting is Opex; buying servers outright is Capex.',
          'We Opexed the hosting and Capexed the hardware.',
          'The Opex and Capex was approved in Q1.',
          'All our Opexes are higher than last year.',
        ],
        correctIdx: 0,
        explanation: '"Capex" and "Opex" used as uncountable mass nouns: "our Opex is", "Capex was approved". Never "Opexes/Capexes". When two uncountable subjects are joined by "and", the verb is usually plural: "Opex and Capex were approved".',
      ),
    ],
    // Lesson 2. P&L, balance sheet, cash flow, equity
    [
      const GrammarQuestion(
        question: 'Which sentence uses "P&L" correctly?',
        options: [
          'Can you send me the P&L for last quarter?',
          'We P&L\'d the project to check profitability.',
          'The P&L for March are attached.',
          'The P&Ls for all three regions was shared.',
        ],
        correctIdx: 0,
        explanation: '"P&L" is singular for one statement: "the P&L is". Multiple statements: "P&Ls were shared". Never a verb. Say "review/analyse the P&L".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "balance sheet" correctly?',
        options: [
          'We need to balance sheet the new acquisitions.',
          'She has strong balance sheet.',
          'The balance sheets was reviewed by the auditors.',
          'The balance sheet as of 31 December shows a healthy equity position.',
        ],
        correctIdx: 3,
        explanation: '"Balance sheet" is a noun phrase, never a verb. Use the article: "a balance sheet", "the balance sheet". Singular: "the balance sheet is/shows". Plural: "balance sheets were".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "cash flow" correctly?',
        options: [
          'We need to cash flow the business more carefully.',
          'Positive cash flow means the business earns more than it spends.',
          'The cash flow were negative in January.',
          'She has a very cash flow company.',
        ],
        correctIdx: 1,
        explanation: '"Cash flow" is a noun (often uncountable). Singular verb: "cash flow was/is". Never a verb. Say "generate/improve/manage cash flow". Not "a very cash flow company", say "a cash-generative company".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "equity" correctly?',
        options: [
          'We need to equity the company before the sale.',
          'The equity are shared between four shareholders.',
          'After paying off all liabilities, the equity stood at €5M.',
          'She has high equity in the business.',
        ],
        correctIdx: 2,
        explanation: '"Equity" is an uncountable noun with a singular verb: "equity is/was". Never a verb. Say "a significant equity stake" or "strong equity position" (not "high equity" alone).',
      ),
    ],
    // Lesson 3, invoice, Net 30, overdue, purchase order
    [
      const GrammarQuestion(
        question: 'Which sentence uses "invoice" correctly?',
        options: [
          'The invoice was send last Tuesday.',
          'We have three invoices unpaid who are overdue.',
          'Please invoice me an amount of €500.',
          'I\'ll invoice you for the work once it\'s completed.',
        ],
        correctIdx: 3,
        explanation: '"Invoice" works as both noun and verb. As a verb: "invoice someone FOR something" (not "invoice someone an amount"). Passive: "was sent" (not "was send"). Relative pronoun for things: "which", not "who".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "Net 30" correctly?',
        options: [
          'We Net 30 all of our clients.',
          'Payment is due on Net 30 days.',
          'Our payment terms are Net 30, payment is due within 30 days of the invoice.',
          'The Net 30s are expiring this week.',
        ],
        correctIdx: 2,
        explanation: '"Net 30" is a noun phrase used as a modifier: "Net 30 terms". Never a verb. "On Net 30 terms" or "within 30 days", not "on Net 30 days". Never pluralised as "Net 30s".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "overdue" correctly?',
        options: [
          'This invoice is three weeks overdue. Please chase the client.',
          'The payment was overdue since March.',
          'We have five invoices overdueing this month.',
          'She overdue her report by two days.',
        ],
        correctIdx: 0,
        explanation: '"Overdue" is an adjective, never a verb. For ongoing state: "has been overdue since March" (not "was overdue since"). "Three weeks overdue" = three weeks past the due date.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "purchase order" correctly?',
        options: [
          'We can\'t start work without a purchase order from your team.',
          'Please purchase order the materials this week.',
          'The purchase orders was approved this morning.',
          'She raised a purchases order for the equipment.',
        ],
        correctIdx: 0,
        explanation: '"Purchase order" is a noun phrase, never a verb. Plural: "purchase orders were". Use "raise/issue/send a purchase order". The compound stays singular: "a purchase order" (not "a purchases order").',
      ),
    ],
    // Lesson 4. EBITDA, burn rate, runway, margin
    [
      const GrammarQuestion(
        question: 'Which sentence uses "EBITDA" correctly?',
        options: [
          'EBITDA for Q3 was €1.8M, up 12% year on year.',
          'We EBITDA\'d the company at €2M.',
          'The company\'s EBITDA are improving steadily.',
          'She has a high EBITDA this year.',
        ],
        correctIdx: 0,
        explanation: '"EBITDA" is a singular uncountable noun: "EBITDA is/was". Never a verb. Say "EBITDA of €2M" or "an EBITDA of €2M". "High EBITDA margin" is correct; "high EBITDA" alone is unusual.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "burn rate" correctly?',
        options: [
          'We need to burn rate less this quarter.',
          'At our current burn rate, we have eight months of runway.',
          'The burn rates is unsustainable right now.',
          'She has a high burn rate job.',
        ],
        correctIdx: 1,
        explanation: '"Burn rate" is a singular noun (it\'s a rate, not a count): "the burn rate is". Never a verb. Say "reduce/lower the burn rate", not "burn rate less". "Burn rates" is non-standard for this metric.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "runway" correctly?',
        options: [
          'We runway until Q3 before needing more funding.',
          'The company runways are getting shorter each month.',
          'Our runway are extending after the latest round.',
          'With €500K and a €50K monthly burn, we have ten months of runway.',
        ],
        correctIdx: 3,
        explanation: '"Runway" (financial) is a singular uncountable noun: "the runway is X months". Never a verb. "Runways" is only for airports, not finance. Singular: "runway is extending".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "margin" correctly?',
        options: [
          'We need to margin the product more carefully.',
          'Their margin are very competitive this year.',
          'We have high margin on this product line.',
          'Cutting costs improved our net margin from 12% to 18%.',
        ],
        correctIdx: 3,
        explanation: '"Margin" is a countable noun. Singular: "the margin is". Plural: "margins are". Never a verb. Say "a 20% margin", "high margins", or "our margin is 18%", not "high margin" without an article.',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // MARKETING
  // ══════════════════════════════════════════════════════════════════════════
  'marketing': [
    // Lesson 1, elevator pitch, value prop, CTA, traction
    [
      const GrammarQuestion(
        question: 'Which sentence uses "elevator pitch" correctly?',
        options: [
          'Let\'s elevator pitch the client tomorrow.',
          'His elevator pitches was well received by investors.',
          'She gave a compelling elevator pitch in under 60 seconds.',
          'We need to elevator-pitch our idea at the event.',
        ],
        correctIdx: 2,
        explanation: '"Elevator pitch" is a noun phrase. The verb is "give/deliver an elevator pitch" or just "pitch". Never use "elevator pitch" as a verb. Plural: "elevator pitches were".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "value prop" correctly?',
        options: [
          'We value propped the new product in the pitch.',
          'The value prop of the service are impressive.',
          'Our value prop is clear: we save clients 40% compared to the alternative.',
          'She has a strong value prop background.',
        ],
        correctIdx: 2,
        explanation: '"Value prop" is a noun phrase, never a verb. Singular: "the value prop is". "Value prop background" is odd, say "background in value proposition" or "pitch skills".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "CTA" correctly?',
        options: [
          'Test two versions of the CTA to see which drives more conversions.',
          'The CTA on this page are too weak.',
          'We CTA\'d the audience to sign up.',
          'Add a CTA in each of the email\'s section.',
        ],
        correctIdx: 0,
        explanation: '"CTA" is a countable noun. Singular: "the CTA is". Plural: "the CTAs are". Never a verb. Preposition: "add a CTA to each section" (not "in each section").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "traction" correctly?',
        options: [
          'We tractionned fast in the first month.',
          'We have a strong traction with early users.',
          'The product is gaining traction , 500 users after two weeks.',
          'Our traction is growing rapidly this quarter.',
        ],
        correctIdx: 2,
        explanation: '"Traction" is an uncountable noun in business: "gain traction", "have traction". No article needed: "gaining traction" (not "a traction"). Never a verb. "Our traction is growing" is unusual, prefer "we\'re gaining traction".',
      ),
    ],
    // Lesson 2, narrative, USP, tone of voice, brand equity
    [
      const GrammarQuestion(
        question: 'Which sentence uses "narrative" correctly?',
        options: [
          'We narrative the campaign around our founder\'s story.',
          'Their narratives is very inspiring.',
          'The brand narrative needs to be consistent across all channels.',
          'She narrative-d the pitch deck effectively.',
        ],
        correctIdx: 2,
        explanation: '"Narrative" is a noun. In business, the verb is "build/craft/align the narrative". Plural: "narratives are". Never used directly as a verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "USP" correctly?',
        options: [
          'We USP\'d the product as faster and cheaper.',
          'The company USP\'s are speed and simplicity.',
          'The USP of the two products are identical.',
          'We need to communicate our USP more clearly in the first five seconds.',
        ],
        correctIdx: 3,
        explanation: '"USP" is a countable noun. Plural is "USPs", no apostrophe for plurals. Singular: "the USP is". Never a verb. "The USP of the two products IS identical" (singular).',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "tone of voice" correctly?',
        options: [
          'She has great tone of voices.',
          'The brand\'s tone of voice are inconsistent.',
          'Our tone of voice should be warm and direct. Never jargon-heavy.',
          'We need to tone of voice this campaign.',
        ],
        correctIdx: 2,
        explanation: '"Tone of voice" is a singular noun phrase. Never pluralised as "tones of voice" in marketing. Singular verb: "the tone of voice is". Never a verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "brand equity" correctly?',
        options: [
          'We brand-equitied the product with social media.',
          'The brand equities were damaged by the scandal.',
          'She has a lot of brand equity.',
          'Years of consistent messaging have built strong brand equity.',
        ],
        correctIdx: 3,
        explanation: '"Brand equity" is an uncountable noun. Never "brand equities". Never a verb. Standard phrases: "build/damage/strengthen brand equity". "Brand equity" belongs to brands, not people.',
      ),
    ],
    // Lesson 3, engagement, reach, conversion, hashtag
    [
      const GrammarQuestion(
        question: 'Which sentence uses "engagement" correctly?',
        options: [
          'The campaign very engaged the audience this month.',
          'Our engagements are all above 5% this week.',
          'We need to engagement the followers more.',
          'Engagement on the post reached 8%, double our usual rate.',
        ],
        correctIdx: 3,
        explanation: '"Engagement" is an uncountable noun in marketing. The verb is "engage". "Engagement is/was X%". Not "engagements are" for a single metric. Never a verb itself.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "reach" correctly?',
        options: [
          'Our reach are growing month on month.',
          'We reached a reach of 500K on the first day.',
          'The campaign reached 2 million people, strong reach for the budget.',
          'The post has great reachs this week.',
        ],
        correctIdx: 2,
        explanation: '"Reach" as a marketing noun is uncountable: "strong reach", "great reach", "a reach of 2M". Never "reachs". As a verb: "the campaign reached 2M". Don\'t combine both in one sentence.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "conversion" correctly?',
        options: [
          'We need to conversion more visitors into buyers.',
          'The conversions rate is too low right now.',
          'Our conversion rate dropped after the redesign.',
          'We conversioned 500 users this month.',
        ],
        correctIdx: 2,
        explanation: '"Conversion" is a noun; the verb is "convert". "Conversion rate" (not "conversions rate"). Uncountable in the metric sense: "conversion improved". Never a verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "hashtag" correctly?',
        options: [
          'The hashtag are performing well this week.',
          'She hashtagged very well at the event.',
          'Add a hashtags to each post.',
          'Using a branded hashtag helps users find all campaign content.',
        ],
        correctIdx: 3,
        explanation: '"Hashtag" is a countable noun. Singular: "a hashtag is". Plural: "hashtags are". "A hashtags" is wrong, singular uses "a hashtag". As a verb, "hashtag it" is informal but "hashtagged very well" is not standard.',
      ),
    ],
    // Lesson 4, brief, target audience, deliverable, KPI
    [
      const GrammarQuestion(
        question: 'Which sentence uses "brief" correctly?',
        options: [
          'We brief the client with the campaign results.',
          'The briefs for both campaigns is ready.',
          'She wrote a very briefs document for the agency.',
          'The agency needs a clear brief before they can start.',
        ],
        correctIdx: 3,
        explanation: '"Brief" is a noun (a document) and a verb (to inform someone). Plural noun: "briefs are". Past verb: "she briefed the client". As an adjective, "brief" means short , "a brief document", not "a briefs document".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "target audience" correctly?',
        options: [
          'They target audienced the campaign at millennials.',
          'The target audiences for both products is the same.',
          'We need to define our target audience before choosing channels.',
          'She has a great target audience.',
        ],
        correctIdx: 2,
        explanation: '"Target audience" is a noun phrase, never a verb. Plural: "target audiences are". "The target audiences… ARE the same". People don\'t have target audiences, products/campaigns do.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "deliverable" correctly?',
        options: [
          'The deliverable are due on the 15th.',
          'We need to deliverable this project on time.',
          'The agency confirmed three deliverables: a video, a banner set, and a social pack.',
          'All deliverable must be approved before launch.',
        ],
        correctIdx: 2,
        explanation: '"Deliverable" is a countable noun. Never a verb. Plural: "deliverables are". Singular: "the deliverable is". "All deliverables must" (plural noun requires plural verb).',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "KPI" correctly in a marketing context?',
        options: [
          'We agreed on one primary KPI for the campaign: email sign-ups.',
          'The KPI was a success last quarter.',
          'Our KPIs was all achieved this quarter.',
          'She KPI-ed the campaign to track performance.',
        ],
        correctIdx: 0,
        explanation: 'You "set", "track", "meet", "miss", or "exceed" a KPI, you don\'t "KPI" things. "The KPI was met/exceeded/missed" (not "was a success"). Plural: "KPIs were achieved".',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // TECH
  // ══════════════════════════════════════════════════════════════════════════
  'tech': [
    // Lesson 1, sprint, stand-up, backlog, velocity
    [
      const GrammarQuestion(
        question: 'Which sentence uses "sprint" correctly?',
        options: [
          'The team sprinted their features by Friday.',
          'How many sprint do we have left before the release?',
          'We sprint every two weeks to ship features.',
          'We\'re halfway through the sprint, three stories are done.',
        ],
        correctIdx: 3,
        explanation: '"Sprint" is a countable noun in Agile. Plural: "sprints". As a verb in Agile context, say "run a sprint" or "complete the sprint". "How many sprints" (plural).',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "stand-up" correctly?',
        options: [
          'We hold a stand-up every morning at 9am to sync the team.',
          'The stand-up meeting are too long.',
          'She stand-upped the team about the blocker.',
          'We stand up everyday about our progress.',
        ],
        correctIdx: 0,
        explanation: '"Stand-up" is a noun in Agile: "the stand-up", "a daily stand-up". Singular: "the stand-up is". Never a verb. Frequency word: "every day" (two words) or "daily".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "backlog" correctly?',
        options: [
          'Let\'s groom the backlog on Thursday and prioritise for the next sprint.',
          'We need to backlog these features before the review.',
          'The backlog were reviewed by the product manager.',
          'The backlogs are all getting too long this month.',
        ],
        correctIdx: 0,
        explanation: '"Backlog" is a countable noun. Singular: "the backlog was". Never a verb. Say "add to the backlog", "groom/refine the backlog". "Backlogs" (plural) is fine for multiple backlogs across teams.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "velocity" correctly?',
        options: [
          'The team velocitied at 35 points this sprint.',
          'The team\'s velocities is 32 points per sprint on average.',
          'Team velocity dropped this sprint due to two unplanned incidents.',
          'Let\'s velocity the team to go faster.',
        ],
        correctIdx: 2,
        explanation: '"Velocity" is an uncountable noun in Agile: "velocity is/was X points". Never a verb. "Velocity" (singular), not "velocities" for a team metric. Say "increase velocity" or "track velocity".',
      ),
    ],
    // Lesson 2, documentation, API, README, user story
    [
      const GrammarQuestion(
        question: 'Which sentence uses "documentation" correctly?',
        options: [
          'We need to documentation this feature properly.',
          'The documentations are available on Confluence.',
          'She wrote a great documentations for the API.',
          'The documentation is out of date, we need to update it.',
        ],
        correctIdx: 3,
        explanation: '"Documentation" is an uncountable noun. Never "documentations". The verb is "document": "document this feature". Singular: "documentation is".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "API" correctly?',
        options: [
          'We API\'d the payment provider last sprint.',
          'The APIs was well-documented.',
          'She builded the API from scratch in two weeks.',
          'The third-party API allows our app to sync data in real time.',
        ],
        correctIdx: 3,
        explanation: '"API" is a countable noun. Plural: "APIs were" (not "was"). Past tense of "build": "built" (irregular). Never used as a verb. Say "integrate/consume/build an API".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "README" correctly?',
        options: [
          'We READMEd the project before pushing.',
          'The READMEs for both repos is out of date.',
          'She has a good README skills.',
          'The README explains how to set up the project locally.',
        ],
        correctIdx: 3,
        explanation: '"README" is a countable noun. Plural: "READMEs are" (plural verb). Never a verb. Say "she writes good READMEs" not "she has a good README skills".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "user story" correctly?',
        options: [
          'Let\'s user story the new feature before development.',
          'The user stories was all approved by the product owner.',
          'She wrote an user story for the login flow.',
          'Each user story should be small enough to complete in one sprint.',
        ],
        correctIdx: 3,
        explanation: '"User story" is a countable noun, never a verb. Plural: "user stories were". Article: "a user story" (not "an user" , "user" starts with a /j/ consonant sound).',
      ),
    ],
    // Lesson 3. PR, LGTM, refactor, merge conflict
    [
      const GrammarQuestion(
        question: 'Which sentence uses "PR" correctly in a development context?',
        options: [
          'She PR\'d the feature yesterday.',
          'The PR\'s are ready for review.',
          'I\'ve opened a PR. Can someone review before end of day?',
          'We need to PR this change before the release.',
        ],
        correctIdx: 2,
        explanation: '"PR" is a countable noun. Plural: "PRs" (no apostrophe for plurals). Say "open/submit/raise/review/merge a PR". As a verb, "PR" is non-standard, prefer "open a PR".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "LGTM" correctly?',
        options: [
          'LGTM are the response from both reviewers.',
          'We LGTM all PRs before merging them.',
          'Left a comment on line 14, but overall LGTM. Feel free to merge.',
          'The code was very LGTM this sprint.',
        ],
        correctIdx: 2,
        explanation: '"LGTM" is used as an approval phrase or informal noun. Singular: "LGTM is". Say "both reviewers said LGTM", not "LGTM are the response". Never force it as a main verb.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "refactor" correctly?',
        options: [
          'We need to refactoring the database layer this sprint.',
          'The refactor was improved the performance significantly.',
          'She refactor the authentication module last week.',
          'The PR is a minor refactor, no new features, just cleaner code.',
        ],
        correctIdx: 3,
        explanation: '"Refactor" is a verb: "refactor something". After "to", use the base form: "to refactor" (not "to refactoring"). Past tense: "refactored". Informally, "a refactor" is also used as a noun.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "merge conflict" correctly?',
        options: [
          'She merge conflicted the branch this morning.',
          'The merge conflicts is easy to resolve in this case.',
          'Fix the merge conflict by deciding which version of the code to keep.',
          'We have a merge confliction to resolve before pushing.',
        ],
        correctIdx: 2,
        explanation: '"Merge conflict" is a noun phrase, never a verb. Plural: "merge conflicts are". "Confliction" is not a standard word, the noun is "conflict". Say "resolve a merge conflict", "run into a merge conflict".',
      ),
    ],
    // Lesson 4. MVP, roadmap, adoption, scalable
    [
      const GrammarQuestion(
        question: 'Which sentence uses "MVP" correctly?',
        options: [
          'We MVP\'d the product and got feedback fast.',
          'The MVP are ready for testing.',
          'She built an MVP version of the feature.',
          'We\'re launching the MVP in six weeks to test with real users.',
        ],
        correctIdx: 3,
        explanation: '"MVP" is a countable noun. Singular: "the MVP is". Never a verb. "An MVP prototype" or just "an MVP" , "MVP version" is redundant (Minimum Viable Product already implies it\'s a version).',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "roadmap" correctly?',
        options: [
          'Let\'s roadmap this feature for next sprint.',
          'We\'re in the roadmap phase of development.',
          'The roadmap shows what we\'re building through to the end of the year.',
          'She roadmapped the entire product last quarter.',
        ],
        correctIdx: 2,
        explanation: '"Roadmap" is a countable noun, never a standard verb. "Build/update/share a roadmap". "In the planning phase" (not "roadmap phase"). Say "she planned/scheduled the product roadmap".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "adoption" correctly?',
        options: [
          'We need to adoption the new tool across the team.',
          'The adoption for the new dashboard are growing.',
          'Feature adoption is at 45%, better than our 40% target.',
          'She adoption-tracked all new features this cycle.',
        ],
        correctIdx: 2,
        explanation: '"Adoption" is an uncountable noun in tech: "adoption is". The verb is "adopt". Say "drive/measure/increase adoption". "Adoption of the dashboard IS growing" (singular).',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "scalable" correctly?',
        options: [
          'We need to scalable the system for more users.',
          'This is a more scalable than the previous approach.',
          'She built a scalable.',
          'The architecture is scalable, we can handle 10x the traffic without rebuilding.',
        ],
        correctIdx: 3,
        explanation: '"Scalable" is an adjective, never a noun or verb. "A scalable system", "is scalable". The verb is "scale": "scale the system". Comparative: "a more scalable approach" (adjective before a noun).',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // LEGAL
  // ══════════════════════════════════════════════════════════════════════════
  'legal': [
    // Lesson 1, clause, liability, indemnify, breach
    [
      const GrammarQuestion(
        question: 'Which sentence uses "clause" correctly?',
        options: [
          'We need to clause the contract to include our requirements.',
          'The clauses in the agreement is very broad.',
          'She flagged an important clauses for review.',
          'Section 7.2 contains a confidentiality clause that needs to be reviewed.',
        ],
        correctIdx: 3,
        explanation: '"Clause" is a countable noun, never a verb. Singular: "a clause is". Plural: "clauses are". Say "include/add/remove/trigger a clause".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "liability" correctly?',
        options: [
          'They liabilitied us for the damage caused.',
          'Our liabilities is higher than last year.',
          'We\'re capping our liability at the value of the contract.',
          'She has great liability experience at the firm.',
        ],
        correctIdx: 2,
        explanation: '"Liability" is a noun, never a verb. The adjective is "liable": "held liable". Plural: "liabilities are". Say "limit/cap/accept liability". "Experience in liability law" (not "liability experience").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "indemnify" correctly?',
        options: [
          'The contract requires the supplier to indemnify us against any third-party claims.',
          'We indemnified the clause last week.',
          'She is very indemnifying in her contract work.',
          'They need to indemnify us of all losses incurred.',
        ],
        correctIdx: 0,
        explanation: '"Indemnify" is a verb: "indemnify someone against/for something". The preposition is "against" or "for" (not "of"). Clauses are not indemnified, parties are.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "breach" correctly?',
        options: [
          'The supplier is in breach of contract, delivery is three months late.',
          'She breached the contract in agreement with all parties.',
          'We need to breach the clause about payment terms.',
          'The breachs were serious and required legal action.',
        ],
        correctIdx: 0,
        explanation: '"Breach" is a noun ("a breach", "in breach") and a verb ("to breach"). Plural: "breaches" (not "breachs"). "In breach of" = not complying with. "Breach a clause" is unusual, you breach a contract or duty.',
      ),
    ],
    // Lesson 2, data subject, consent, right to access, DPA
    [
      const GrammarQuestion(
        question: 'Which sentence uses "data subject" correctly?',
        options: [
          'We data subjected the employees last year.',
          'The data subjects rights must be respected by law.',
          'She is a data subjects in this context.',
          'Under GDPR, each data subject has the right to request access to their personal data.',
        ],
        correctIdx: 3,
        explanation: '"Data subject" is a legal noun. Plural possessive: "data subjects\' rights" (apostrophe after the plural). Never a verb. Singular: "a data subject has".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "consent" correctly?',
        options: [
          'We need written consent before processing any sensitive data.',
          'She consented the data processing last month.',
          'The consent were obtained before the survey was sent.',
          'We need a consent of the data subject to proceed.',
        ],
        correctIdx: 0,
        explanation: '"Consent" (noun) is uncountable: "consent was obtained". As a verb: "consent TO something" (not "consent the processing"). Noun phrase: "consent from" or "consent of" (not "a consent of").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "right to access" correctly?',
        options: [
          'She right to accessed the information on file.',
          'We gave them the right to accesses.',
          'The data subject exercised their right to access and requested all data held.',
          'Their rights to accesses are legally protected.',
        ],
        correctIdx: 2,
        explanation: '"Right to access" is a noun phrase. "Access" here is an infinitive, it never takes "-es". Say "exercise/grant the right to access". Plural: "rights to access" (not "rights to accesses").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "DPA" correctly?',
        options: [
          'We DPA\'d the vendor before sending any data.',
          'The DPA are required by GDPR for all processors.',
          'She DPA the contract yesterday morning.',
          'We won\'t share data with the vendor until a DPA is signed.',
        ],
        correctIdx: 3,
        explanation: '"DPA" is a countable noun. Singular: "a DPA is". Plural: "DPAs are". Never a verb. Say "sign/require/put in place a DPA".',
      ),
    ],
    // Lesson 3, without prejudice, as per, pursuant to, hereby
    [
      const GrammarQuestion(
        question: 'Which sentence uses "without prejudice" correctly?',
        options: [
          'All settlement discussions are conducted without prejudice.',
          'The offer is without prejudices.',
          'We without prejudiced the negotiation this week.',
          'She spoke without prejudice to both sides involved.',
        ],
        correctIdx: 0,
        explanation: '"Without prejudice" is a fixed legal phrase, it never changes form or takes a plural. It marks communications as protected: "on a without prejudice basis", "conducted without prejudice".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "as per" correctly?',
        options: [
          'We done the work as per.',
          'As per her, the contract is completely fine.',
          'The invoices was raised as per agreed.',
          'As per our agreement, the final report is due on the 30th.',
        ],
        correctIdx: 3,
        explanation: '"As per" always requires a noun phrase after it: "as per the agreement/clause/our discussion". Never use it alone or before a person. Past tense: "were raised as per the agreement" (not "was").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "pursuant to" correctly?',
        options: [
          'She acted pursuant our instructions on this matter.',
          'The decision was made pursuant.',
          'Pursuant to, the contract is now terminated.',
          'Pursuant to section 9, all disputes must be settled by arbitration.',
        ],
        correctIdx: 3,
        explanation: '"Pursuant to" is always followed by a noun phrase: "pursuant to clause X / the agreement / section 9". Never "pursuant" alone or "pursuant our", it requires "to" before the noun.',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "hereby" correctly?',
        options: [
          'The Company hereby waives its right to a refund under this agreement.',
          'We are hereby the contract as of today.',
          'She hereby that the information provided is accurate.',
          'The document herebyly states our position clearly.',
        ],
        correctIdx: 0,
        explanation: '"Hereby" is a formal adverb placed before or after the subject to modify a verb: "hereby waives", "hereby confirms", "hereby declares". "Herebyly" does not exist.',
      ),
    ],
    // Lesson 4. NDA, confidential, trade secret, injunction
    [
      const GrammarQuestion(
        question: 'Which sentence uses "NDA" correctly?',
        options: [
          'Both parties signed an NDA before the product demo.',
          'We NDA\'d the client before sharing the specs.',
          'The NDAs was reviewed by the legal team.',
          'Please sign a NDA before we proceed.',
        ],
        correctIdx: 0,
        explanation: '"NDA" is a countable noun. Use "an NDA" (the letter N is pronounced /en/, a vowel sound). Plural: "NDAs were". Never a verb. Say "sign/draft/require an NDA".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "confidential" correctly?',
        options: [
          'We confidentialled the information before sending.',
          'The meeting was kept confidentially by all attendees.',
          'This document is strictly confidential. Please do not share.',
          'She confidential the document before filing.',
        ],
        correctIdx: 2,
        explanation: '"Confidential" is an adjective. Say "keep something confidential", "mark as confidential". "Kept confidentially" is wrong , "confidential" is an adjective here, not an adverb: "kept confidential".',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "trade secret" correctly?',
        options: [
          'We trade secreted the process to protect our IP.',
          'The trade secrets is protected by law.',
          'She has a trade secret background at the firm.',
          'The formula is a trade secret, disclosure would allow competitors to copy it.',
        ],
        correctIdx: 3,
        explanation: '"Trade secret" is a countable noun, never a verb. Plural: "trade secrets are". Say "protect/disclose/misappropriate a trade secret". "Background in trade secret law" (not "trade secret background").',
      ),
      const GrammarQuestion(
        question: 'Which sentence uses "injunction" correctly?',
        options: [
          'We injunctioned the company from using our technology.',
          'The injunctions was granted by the judge.',
          'She files a injunction against the competitor.',
          'The court granted an injunction preventing the defendant from sharing the data.',
        ],
        correctIdx: 3,
        explanation: '"Injunction" is a countable noun, never a verb. Use "an injunction" (vowel sound: /ɪn/). Plural: "injunctions were". Say "seek/obtain/grant/file for an injunction".',
      ),
    ],
  ],
};
