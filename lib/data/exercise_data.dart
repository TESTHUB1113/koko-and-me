enum ExType { fillBlank, dialogue, docFill }

class Exo {
  final ExType type;
  final String? scenario;
  final List<String>? bubbles;
  final String prompt;
  final String? docTitle;
  final List<String>? docLines;
  final List<String> options;
  final int correct;
  final String tip;

  const Exo({
    required this.type,
    this.scenario,
    this.bubbles,
    required this.prompt,
    this.docTitle,
    this.docLines,
    required this.options,
    required this.correct,
    required this.tip,
  });
}

const Map<String, List<Exo>> deptExercises = {
  // ── MANAGEMENT ──────────────────────────────────────────────────────────────
  'management': [
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are sending a project update to your team.',
      prompt: 'Please _____ me on that email — I need to stay in the loop.',
      options: ['CC', 'BCC', 'tag', 'forward'],
      correct: 0,
      tip: 'CC (Carbon Copy) sends a visible copy to another person so they stay informed.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'Monday morning — weekly team check-in.',
      bubbles: [
        'Manager: "The board meeting is in 10 minutes. Only 4 out of 10 members are here."',
        'Chairperson: "Can we start the vote on the budget?"',
      ],
      prompt: 'You (Company Secretary) say:',
      options: [
        'No — we need a quorum. We need at least 6 members to make the vote official.',
        'Yes, 4 people is enough to start.',
        'Let\'s check the agenda first and decide later.',
        'We should move it to the AOB section.',
      ],
      correct: 0,
      tip: 'Quorum = the minimum number of members required for a meeting or vote to be official.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'Negotiations with a key supplier have broken down.',
      prompt: 'Neither side would move. After 4 hours of talks, we reached a _____.',
      options: ['deadlock', 'concession', 'win-win', 'leverage'],
      correct: 0,
      tip: 'A deadlock means both sides are stuck — no progress, no agreement. Also called a stalemate.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'After a client pitch with your team member.',
      bubbles: ['Your manager: "How do you think Tom did in the meeting?"'],
      prompt: 'You respond:',
      options: [
        'He gave constructive feedback — he flagged what could improve while staying professional.',
        'He was very harsh. I think the client was uncomfortable.',
        'He stayed quiet and mostly listened.',
        'He went off topic and talked too much.',
      ],
      correct: 0,
      tip: 'Constructive feedback is specific, helpful, and improvement-focused — not just criticism.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are presenting Q3 results to the board.',
      prompt: 'We invested €10K in ads and earned €40K back. Our _____ is 300%.',
      options: ['ROI', 'margin', 'revenue', 'EBITDA'],
      correct: 0,
      tip: 'ROI (Return On Investment) = (Gain - Cost) / Cost x 100. It measures how profitable an investment is.',
    ),
  ],

  // ── HUMAN RESOURCES ─────────────────────────────────────────────────────────
  'rh': [
    Exo(
      type: ExType.fillBlank,
      scenario: 'A new hire is reviewing their contract.',
      prompt: 'Your first 3 months are a _____ period. After that, your role becomes permanent.',
      options: ['probation', 'induction', 'appraisal', 'benchmark'],
      correct: 0,
      tip: 'Probation is a trial period at the start of employment — for both sides to assess the fit.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'The CEO stops by HR to check on the senior hire.',
      bubbles: ['CEO: "We had 300 applications for Head of Sales. Where are we in the process?"'],
      prompt: 'You (HR Manager) respond:',
      options: [
        'We\'ve shortlisted the top 12. Interviews start Monday.',
        'We\'re still going through all 300 one by one.',
        'No one matched the profile, so we paused the process.',
        'We cancelled the role due to budget constraints.',
      ],
      correct: 0,
      tip: 'Shortlisted = selected as top candidates from a larger pool — the ones who will be interviewed.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'It is your quarterly planning session with your manager.',
      prompt: 'My _____ for Q3: reduce staff turnover by 5% and fill all 3 open engineering roles.',
      options: ['OKR', 'PIP', 'appraisal', 'KPI'],
      correct: 0,
      tip: 'OKR = Objectives and Key Results. A goal-setting framework used to align and track priorities.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'Two colleagues are arguing near the coffee machine.',
      bubbles: [
        'Colleague A: "This is completely unacceptable!"',
        'Colleague B: "You never listen to anyone on this team!"',
      ],
      prompt: 'You (HR) step in and say:',
      options: [
        'I\'m going to step in here and try to de-escalate this before it becomes a formal complaint.',
        'This is none of my business — I\'ll leave them to sort it out.',
        'If you continue, you\'ll both be dismissed.',
        'Let\'s schedule a mediation session for next month.',
      ],
      correct: 0,
      tip: 'De-escalate = to reduce the intensity or tension of a conflict before it worsens.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'An employee had a difficult experience with their manager.',
      prompt: 'Sam filed a formal _____ after his manager criticised him publicly in front of the whole team.',
      options: ['grievance', 'complaint', 'dispute', 'conflict'],
      correct: 0,
      tip: 'A grievance is a formal, official complaint raised by an employee through HR channels.',
    ),
  ],

  // ── FINANCE ─────────────────────────────────────────────────────────────────
  'finance': [
    Exo(
      type: ExType.docFill,
      scenario: 'You are finalising an invoice to send to a client.',
      prompt: 'Fill in the missing payment terms:',
      docTitle: 'INVOICE #2024-047',
      docLines: [
        'From: koko&me Ltd',
        'To:   Acme Corporation',
        'Services: Brand Strategy Q3',
        'Amount: €8,500',
        'Payment Terms: [?]',
        'Due Date: 30 days from today',
      ],
      options: ['Net 30', 'Net 365', 'COD', 'Immediate'],
      correct: 0,
      tip: 'Net 30 means payment is due within 30 days of the invoice date. The most common B2B payment term.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are presenting the annual budget to the board.',
      prompt: 'Buying new office servers is a _____ — it\'s a long-term asset that stays on our books.',
      options: ['Capex', 'Opex', 'Variance', 'Equity'],
      correct: 0,
      tip: 'Capex (Capital Expenditure) = spending on long-term assets like equipment, buildings, or software.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'The accounts team flags a payment issue.',
      bubbles: [
        'Accountant: "The Smith account still has not paid. Invoice was due October 31st."',
        'Today: November 15th.',
      ],
      prompt: 'You report to the CFO:',
      options: [
        'The account is overdue by 15 days. I\'ll send a formal reminder today.',
        'No worries — they will probably pay by end of month.',
        'Let\'s write it off as a loss for this quarter.',
        'We should wait until they contact us.',
      ],
      correct: 0,
      tip: 'Overdue = payment not received by the agreed due date. Follow-up immediately and professionally.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'Quarterly financial review with the leadership team.',
      prompt: 'The _____ shows revenue of €800K and total costs of €550K — profit of €250K this quarter.',
      options: ['P&L', 'Balance Sheet', 'Cash Flow Statement', 'Audit Report'],
      correct: 0,
      tip: 'P&L (Profit and Loss statement) tracks income and expenses over a period. Revenue - Costs = Profit.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'A startup board meeting is reviewing the financial situation.',
      prompt: 'We\'re spending €100K per month. With €400K in the bank, our _____ is only 4 months.',
      options: ['runway', 'burn rate', 'margin', 'EBITDA'],
      correct: 0,
      tip: 'Runway = how long a company can keep operating at its current spend rate before running out of cash.',
    ),
  ],

  // ── MARKETING ───────────────────────────────────────────────────────────────
  'marketing': [
    Exo(
      type: ExType.fillBlank,
      scenario: 'You step into the elevator with the CEO of a major company.',
      prompt: 'You have 30 seconds. You deliver your _____ for koko&me.',
      options: ['elevator pitch', 'value prop', 'CTA', 'brand brief'],
      correct: 0,
      tip: 'An elevator pitch is a short, compelling summary of your idea — short enough for a lift ride.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'Pitch meeting with a potential investor.',
      bubbles: ['"This looks interesting. But why would I choose you over the cheaper alternatives?"'],
      prompt: 'You respond:',
      options: [
        'Our value prop is simple: we save HR teams 10 hours a week — no other tool does that.',
        'We are actually cheaper than most tools on the market.',
        'We have a really nice design and friendly customer service.',
        'Our elevator pitch already covers that — let me repeat it.',
      ],
      correct: 0,
      tip: 'Value prop (value proposition) = the unique benefit you offer that makes customers choose you.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'The social media manager is reviewing last week\'s results.',
      prompt: '50,000 people saw the post but only 3 commented and 12 liked it. The _____ rate is very low.',
      options: ['engagement', 'reach', 'conversion', 'impression'],
      correct: 0,
      tip: 'Engagement = likes + comments + shares. Low engagement means people saw it but did not interact.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are finalising a product launch presentation.',
      prompt: 'End the last slide with a clear _____ — tell the audience exactly what to do next.',
      options: ['CTA', 'value prop', 'brief', 'tagline'],
      correct: 0,
      tip: 'CTA (Call To Action) = a clear instruction for the audience: "Sign up free", "Book a call", etc.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'Pitching to a VC firm. They look sceptical.',
      bubbles: ['"The concept is interesting. But has anyone actually paid for this yet?"'],
      prompt: 'You open your metrics slide and say:',
      options: [
        '800 paying customers in 3 months. Our traction data speaks for itself.',
        'Not yet, but we have a lot of people who are interested.',
        'We are still in beta and not focused on revenue yet.',
        'We prefer to focus on growth before we start charging.',
      ],
      correct: 0,
      tip: 'Traction = real evidence of market interest and growth — paying customers, signups, or revenue.',
    ),
  ],

  // ── TECH & IT ────────────────────────────────────────────────────────────────
  'tech': [
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are joining a new tech team and explaining their process.',
      prompt: 'We work in 2-week _____ — plan, build, demo, and then repeat.',
      options: ['sprints', 'phases', 'iterations', 'milestones'],
      correct: 0,
      tip: 'A sprint is a short, fixed work cycle in Agile. The team commits to a set of tasks and ships at the end.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'A new developer joins the team on day one.',
      bubbles: ['"What do I need to do every morning at 9am?"'],
      prompt: 'You (team lead) explain:',
      options: [
        'Join the stand-up — 15 minutes max. What you did, what you\'re doing, and any blockers.',
        'Start coding immediately. We don\'t have morning meetings.',
        'Read through the backlog and pick whatever looks interesting.',
        'Send a written status report to the project manager.',
      ],
      correct: 0,
      tip: 'Stand-up = a short daily team meeting. Each person shares progress, plan, and blockers. Max 15 min.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are preparing for the quarterly planning session.',
      prompt: 'There are 40 features waiting to be built. The _____ is huge — we need to prioritise.',
      options: ['backlog', 'roadmap', 'sprint board', 'kanban'],
      correct: 0,
      tip: 'Backlog = the full list of features, bugs, and tasks not yet done. Prioritised before each sprint.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are reviewing old code with a colleague.',
      prompt: 'We are not changing what it does — just cleaning up the structure. That\'s a _____.',
      options: ['refactor', 'rewrite', 'review', 'rebuild'],
      correct: 0,
      tip: 'Refactoring = improving code quality and structure without changing its external behaviour.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are pitching the product strategy to the board.',
      prompt: 'Before building all 20 features, we launch the _____ — just the core experience — and learn from users.',
      options: ['MVP', 'beta', 'prototype', 'roadmap'],
      correct: 0,
      tip: 'MVP (Minimum Viable Product) = the simplest working version you can ship to test real market demand.',
    ),
  ],

  // ── LEGAL ────────────────────────────────────────────────────────────────────
  'legal': [
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are reviewing a new supplier contract.',
      prompt: 'Section 5 is the payment _____ — it states all invoices must be paid within 30 days.',
      options: ['clause', 'term', 'article', 'provision'],
      correct: 0,
      tip: 'A clause is a specific section within a contract that covers one particular obligation or topic.',
    ),
    Exo(
      type: ExType.docFill,
      scenario: 'You are drafting a confidentiality agreement with a new partner.',
      prompt: 'Fill in the document abbreviation:',
      docTitle: 'CONFIDENTIALITY AGREEMENT',
      docLines: [
        'This [?] is entered into between',
        'koko&me Ltd (Disclosing Party)',
        'and Acme Corp (Receiving Party).',
        'Date: 15 June 2024',
      ],
      options: ['NDA', 'DPA', 'MOU', 'SLA'],
      correct: 0,
      tip: 'NDA (Non-Disclosure Agreement) = a contract that legally binds parties to keep information secret.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'Your company is about to launch an email marketing campaign.',
      prompt: 'Under GDPR, you must have explicit _____ from every contact before sending marketing emails.',
      options: ['consent', 'permission', 'agreement', 'authorisation'],
      correct: 0,
      tip: 'Consent under GDPR must be freely given, specific, informed, and unambiguous. No pre-ticked boxes.',
    ),
    Exo(
      type: ExType.dialogue,
      scenario: 'The client\'s lawyer has just sent a formal letter.',
      bubbles: ['"Your agency delivered 3 months late and the output did not meet the agreed specification."'],
      prompt: 'You respond to your legal team:',
      options: [
        'That is a breach of contract on their side — they changed the scope 5 times. Get the lawyers ready.',
        'They are right — let\'s settle and pay them compensation immediately.',
        'Ignore it. They are bluffing and will not take this further.',
        'Forward it to finance — this looks like a billing dispute.',
      ],
      correct: 0,
      tip: 'Breach = failing to honour a contract term. Identifying who is in breach is critical in any dispute.',
    ),
    Exo(
      type: ExType.fillBlank,
      scenario: 'You are in sensitive settlement negotiations.',
      prompt: 'Mark this email "_____ " — any offer made here cannot be used as evidence in court.',
      options: ['Without Prejudice', 'Confidential', 'Private and Secure', 'Off the Record'],
      correct: 0,
      tip: '"Without Prejudice" legally protects settlement discussions from being used in court proceedings.',
    ),
  ],
};
