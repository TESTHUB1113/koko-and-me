// ─── DIALOGUE DATA ────────────────────────────────────────────────────────────
// Structure: dialogueData[deptId][category] = List of 4 sub-lessons.
// Each sub-lesson shares its vocab with the matching Vocabulary lesson.
// **word** in KokoLine text marks a vocab word, highlighted and tappable.

sealed class DialogNode {
  const DialogNode();
}

class KokoLine extends DialogNode {
  final String text;
  const KokoLine(this.text);
}

class UserTurn extends DialogNode {
  final String option1;
  final String option2;
  final String reply1;
  final String reply2;
  const UserTurn({
    required this.option1,
    required this.option2,
    required this.reply1,
    required this.reply2,
  });
}

class CategoryDialogue {
  final String name;
  final Map<String, String> vocab;
  final List<DialogNode> script;
  const CategoryDialogue({
    required this.name,
    required this.vocab,
    required this.script,
  });
}

enum LessonCategory { vocabulary, writing, grammar, speaking }

extension LessonCategoryExt on LessonCategory {
  String get label {
    switch (this) {
      case LessonCategory.vocabulary: return 'Vocabulary';
      case LessonCategory.writing:    return 'Writing';
      case LessonCategory.grammar:    return 'Grammar';
      case LessonCategory.speaking:   return 'Speaking';
    }
  }

  String get subtitle {
    switch (this) {
      case LessonCategory.vocabulary: return 'Key business words in context';
      case LessonCategory.writing:    return 'Emails, reports & documents';
      case LessonCategory.grammar:    return 'Structures & phrasing';
      case LessonCategory.speaking:   return 'Meetings, calls & pitches';
    }
  }

  String get kokoIntro {
    switch (this) {
      case LessonCategory.vocabulary: return "Let's learn the key words. Pick a lesson to start.";
      case LessonCategory.writing:    return "Time to put those words on paper. Pick a lesson.";
      case LessonCategory.grammar:    return "Let's make sure you're using these words correctly. Pick a lesson.";
      case LessonCategory.speaking:   return "Now let's use these words in real conversations. Pick a lesson.";
    }
  }
}

const Map<String, String> deptKokoTitles = {
  'management': 'Department Manager',
  'rh':         'HR Manager',
  'finance':    'CFO',
  'marketing':  'Marketing Director',
  'tech':       'Tech Lead',
  'legal':      'Legal Counsel',
};

const Map<String, String> deptKokoIntro = {
  'management': "I'm your Department Manager. Pick a category and let's get to work.",
  'rh':         "HR Manager here. We'll cover everything from hiring to performance management.",
  'finance':    "CFO. Numbers need the right words. Let's start with Vocabulary.",
  'marketing':  "Marketing Director. Good campaigns start with great words. Let's begin.",
  'tech':       "Tech Lead. Before you ship code, you need to talk about it. Start with Vocabulary.",
  'legal':      "Legal Counsel. Precision matters here. Let's start with the words that carry weight.",
};

// ─── SHARED VOCAB MAPS (reused across Vocabulary / Grammar / Writing / Speaking) ─

const _mgmt1Vocab = {
  'agenda':      'List of topics to cover in a meeting',
  'AOB':         'Any Other Business, open floor at the end of a meeting',
  'minutes':     'Official written record of what was said in a meeting',
  'action item': 'A specific task assigned to someone after a meeting',
  'quorum':      'Minimum number of people needed to hold a valid vote',
};

const _mgmt2Vocab = {
  'CC':          'Send a copy of an email to another person',
  'follow-up':   'A message sent after first contact to continue the conversation',
  'sign-off':    'The formal closing phrase at the end of an email',
  'action item': 'A specific task assigned to someone, confirmed in writing',
};

const _mgmt3Vocab = {
  'constructive': "Criticism that's helpful and aimed at improvement, not just negative",
  'KPI':          'Key Performance Indicator, a metric used to measure success',
  'benchmark':    'A standard or reference point used for comparison',
  'deliverable':  'A specific result or output expected from a task or project',
};

const _mgmt4Vocab = {
  'leverage':   'An advantage you use in a negotiation to strengthen your position',
  'concession': 'Something you give up in order to reach an agreement',
  'win-win':    'An outcome that is beneficial for both sides of a negotiation',
  'deadlock':   'A situation where neither side can move forward or reach agreement',
};

// ── HR

const _hr1Vocab = {
  'cover letter': 'A short letter explaining why you applied for a role',
  'competency':   'A specific skill or ability required for a job',
  'panel':        'A group of interviewers who conduct an interview together',
  'shortlisted':  'Selected as one of the top candidates for a role',
};

const _hr2Vocab = {
  'probation':    'A trial period at the start of a new job',
  'induction':    'The introduction process for a new employee',
  'buddy system': 'Pairing a new hire with an experienced colleague for support',
  'org chart':    'A diagram showing the structure and hierarchy of a company',
};

const _hr3Vocab = {
  'appraisal':    'A formal assessment of an employee\'s work performance',
  '360 feedback': 'Feedback collected from peers, manager, and direct reports',
  'OKR':          'Objectives and Key Results, a goal-setting framework',
  'PIP':          'Performance Improvement Plan, a structured support plan for underperformers',
};

const _hr4Vocab = {
  'mediation':    'A process where a neutral third party helps resolve a dispute',
  'de-escalate':  'To reduce the intensity or tension of a conflict',
  'grievance':    'A formal complaint raised by an employee through official channels',
  'arbitration':  'A binding resolution process decided by an independent arbitrator',
};

// ── Finance

const _fin1Vocab = {
  'Capex':      'Capital Expenditure, money spent on long-term assets',
  'Opex':       'Operational Expenditure, the ongoing daily costs of running the business',
  'variance':   'The difference between what was budgeted and what was actually spent',
  'allocation': 'How a budget is divided and distributed across teams or areas',
};

const _fin2Vocab = {
  'P&L':           'Profit and Loss statement, shows revenue, costs, and net result',
  'balance sheet':  'A snapshot of a company\'s assets, liabilities, and equity at a point in time',
  'cash flow':      'The movement of money in and out of the business',
  'equity':         'The value of the business owned by shareholders after liabilities',
};

const _fin3Vocab = {
  'invoice':        'A bill sent to a client requesting payment for services or goods',
  'Net 30':         'Payment terms requiring the invoice to be paid within 30 days',
  'overdue':        'A payment that has not been received by its due date',
  'purchase order': 'A formal document from a buyer authorising a purchase',
};

const _fin4Vocab = {
  'EBITDA':     'Earnings Before Interest, Taxes, Depreciation, and Amortisation',
  'burn rate':  'The speed at which a company spends its available cash each month',
  'runway':     'The amount of time a company can operate before running out of cash',
  'margin':     'The difference between revenue and costs, expressed as a percentage',
};

// ── Marketing

const _mkt1Vocab = {
  'elevator pitch': 'A short, compelling summary of your idea delivered in under 60 seconds',
  'value prop':     "The unique benefit your product offers that others don't",
  'CTA':            'Call To Action, a prompt that tells your audience what to do next',
  'traction':       'Evidence of real growth or market response that proves your idea works',
};

const _mkt2Vocab = {
  'narrative':     'The story that connects a brand to its audience emotionally',
  'USP':           'Unique Selling Point, the one thing that makes your offer stand out',
  'tone of voice': 'The consistent personality and style a brand uses in its communications',
  'brand equity':  'The value and trust a brand has built with its audience over time',
};

const _mkt3Vocab = {
  'engagement':  'Any interaction with content, likes, comments, shares, or clicks',
  'reach':       'The number of unique people who saw a piece of content',
  'conversion':  'When a viewer takes the desired action, such as buying or signing up',
  'hashtag':     'A keyword tag used to categorise and surface content on social platforms',
};

const _mkt4Vocab = {
  'brief':           'A document that outlines the goals, audience, and scope of a campaign',
  'target audience': 'The specific group of people a campaign is designed to reach',
  'deliverable':     'A specific output or asset produced as part of a campaign',
  'KPI':             'Key Performance Indicator, the metric used to measure campaign success',
};

// ── Tech

const _tech1Vocab = {
  'sprint':   'A short fixed work cycle, usually one or two weeks, with a defined goal',
  'stand-up': 'A brief daily team meeting to share progress and flag blockers',
  'backlog':  'The full list of tasks and features waiting to be worked on',
  'velocity': 'The amount of work a team completes in a single sprint, used for planning',
};

const _tech2Vocab = {
  'documentation': 'Written material explaining how a system or codebase works',
  'API':           'Application Programming Interface, a way for software to communicate',
  'README':        'The first file in a repo that explains what the project is and how to use it',
  'user story':    "A feature described from the user's point of view: 'As a... I want... so that...'",
};

const _tech3Vocab = {
  'PR':             'Pull Request, a proposal to merge code changes into the main branch',
  'LGTM':           "Looks Good To Me, shorthand approval in a code review",
  'refactor':       'Improving the structure of existing code without changing its behaviour',
  'merge conflict': 'A clash that occurs when two code changes affect the same lines',
};

const _tech4Vocab = {
  'MVP':      'Minimum Viable Product, the simplest version of a product that delivers value',
  'roadmap':  'A plan showing the planned direction and future features of a product',
  'adoption': 'The rate at which users actively engage with a product or feature',
  'scalable': 'Able to handle growth in users or data without a loss in performance',
};

// ── Legal

const _leg1Vocab = {
  'clause':    'A specific section or provision within a contract',
  'liability': 'Legal responsibility for something that goes wrong',
  'indemnify': 'To protect another party from legal costs or claims',
  'breach':    'A failure to comply with the terms of a contract',
};

const _leg2Vocab = {
  'data subject':    'A person whose personal data is being collected or processed',
  'consent':         'Freely given, informed permission to process someone\'s personal data',
  'right to access': 'A legal right to request and receive a copy of your stored personal data',
  'DPA':             'Data Processing Agreement, a contract governing how data is handled by a third party',
};

const _leg3Vocab = {
  'without prejudice': 'A label that protects a communication from being used as evidence in court',
  'as per':            'In line with or according to a stated document or agreement',
  'pursuant to':       'In accordance with or as authorised by a rule, law, or agreement',
  'hereby':            'By this statement or document, used to make a formal declaration',
};

const _leg4Vocab = {
  'NDA':          'Non-Disclosure Agreement, a contract that keeps specified information secret',
  'confidential': 'Information that must be kept private and not shared without permission',
  'trade secret':  'Business information kept secret because it provides a competitive advantage',
  'injunction':   'A court order requiring a party to stop a specific action immediately',
};

// ─── DIALOGUE DATA ────────────────────────────────────────────────────────────

final Map<String, Map<LessonCategory, List<CategoryDialogue>>> dialogueData = {

  // ════════════════════════════════════════════════════════════════════════════
  // MANAGEMENT
  // ════════════════════════════════════════════════════════════════════════════
  'management': {

    // ── Vocabulary ───────────────────────────────────────────────────────────
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Pro Meetings',
        vocab: _mgmt1Vocab,
        script: [
          KokoLine("Morning. Take a seat. I've got the **agenda** ready for today."),
          UserTurn(
            option1: "What are we covering?",
            option2: "How long will this take?",
            reply1:  "Three items. Q2 review, roadmap sync, and **AOB** at the end for anything else.",
            reply2:  "Shouldn't be long. Three items, then **AOB** if anyone has something to add.",
          ),
          KokoLine("Last meeting someone forgot to take **minutes**. Not happening again today."),
          UserTurn(
            option1: "I can take them.",
            option2: "Can't we just record it?",
            reply1:  "Perfect. Every **action item** needs an owner and a deadline. Don't miss any.",
            reply2:  "We record, but we still need written **action items** after. That's what people actually follow up on.",
          ),
          KokoLine("Quick check before we start, do we have a **quorum**?"),
          UserTurn(
            option1: "Three out of five are here.",
            option2: "What's the minimum we need?",
            reply1:  "Three is enough. We can vote on the budget proposal if it comes up.",
            reply2:  "For this team, three people. So yes, we're good to go.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Formal Emails',
        vocab: _mgmt2Vocab,
        script: [
          KokoLine("When you email multiple people, think carefully about who goes in 'To' versus who gets a **CC**."),
          UserTurn(
            option1: "What's the practical difference?",
            option2: "Should I CC everyone involved?",
            reply1:  "'To' means you need something from them. **CC** is just keeping someone informed, no action expected.",
            reply2:  "No. Over-CCing creates noise. Only **CC** people who genuinely need visibility.",
          ),
          KokoLine("After any important exchange, send a **follow-up** confirming what was agreed."),
          UserTurn(
            option1: "Even if everything is already in the thread?",
            option2: "How quickly should I send it?",
            reply1:  "Especially then. A **follow-up** surfaces the key points, people don't re-read full threads.",
            reply2:  "Same day or next morning. Longer and the context fades.",
          ),
          KokoLine("Your **sign-off** signals the relationship. 'Best regards' is neutral. 'Kind regards' is the professional standard."),
          UserTurn(
            option1: "What about 'Sincerely'?",
            option2: "Does it change depending on the situation?",
            reply1:  "Very formal, save it for legal or official correspondence. Too stiff for day-to-day emails.",
            reply2:  "Yes. Internal team: 'Best'. Client you know: 'Kind regards'. New formal contact: 'Yours sincerely'.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Giving Feedback',
        vocab: _mgmt3Vocab,
        script: [
          KokoLine("The goal of feedback is to be **constructive**, not just to say what went wrong."),
          UserTurn(
            option1: "How do you make criticism constructive?",
            option2: "What if the work was genuinely poor?",
            reply1:  "Name the issue, explain why it matters, and suggest an improvement. That's the structure.",
            reply2:  "Even then, **constructive** feedback focuses on what to do differently, not just what failed.",
          ),
          KokoLine("Any feedback on performance should be anchored to a **KPI**, not to personal opinion."),
          UserTurn(
            option1: "What if the role doesn't have clear KPIs?",
            option2: "Can you give me an example?",
            reply1:  "Then you set them first. Feedback without a **KPI** is just subjective commentary.",
            reply2:  "Instead of 'your reports are slow', say 'the **KPI** is delivery by Thursday, you've missed it twice'.",
          ),
          KokoLine("Compare performance against a **benchmark**, and judge the **deliverable**, not the effort."),
          UserTurn(
            option1: "Why not compare people directly?",
            option2: "What's the difference between judging effort vs the deliverable?",
            reply1:  "It creates competition instead of growth. A **benchmark** is objective, it's a standard, not a ranking.",
            reply2:  "Effort is invisible. The **deliverable** is what was promised, that's what gets assessed.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Negotiation',
        vocab: _mgmt4Vocab,
        script: [
          KokoLine("Before any negotiation, know your **leverage**, what gives you the stronger position."),
          UserTurn(
            option1: "What if we don't have much leverage?",
            option2: "Should you show your leverage early?",
            reply1:  "Then you find it. Timeline, alternatives, urgency on their side, there's always something.",
            reply2:  "No. **Leverage** is most powerful when the other side suspects it but can't confirm it.",
          ),
          KokoLine("Be strategic about your **concessions**, each one should feel like it costs you something."),
          UserTurn(
            option1: "Why does it matter how a concession feels?",
            option2: "What concessions are safe to offer early?",
            reply1:  "A **concession** given too easily signals you had more room. They'll push further.",
            reply2:  "Non-financial ones, timelines, reporting frequency, small scope changes. Save price for last.",
          ),
          KokoLine("A **win-win** is the goal, but know your **deadlock** point before you walk in."),
          UserTurn(
            option1: "How do you know when you've hit a deadlock?",
            option2: "Is win-win always realistic?",
            reply1:  "When both sides have moved as far as they can and the gap remains. Walk away cleanly.",
            reply2:  "Not always. Sometimes one side has too much **leverage**. A fair deal for both is the target, not always achievable.",
          ),
        ],
      ),
    ],

    // ── Grammar ──────────────────────────────────────────────────────────────
    LessonCategory.grammar: [

      const CategoryDialogue(
        name: 'Pro Meetings',
        vocab: _mgmt1Vocab,
        script: [
          KokoLine("When you write **minutes**, use the past tense consistently , 'We discussed', not 'We discuss'."),
          UserTurn(
            option1: "What tense do action items use?",
            option2: "Should I use passive voice?",
            reply1:  "**Action items** use the infinitive , 'to submit the report by Friday'. It's an instruction, not a record.",
            reply2:  "Yes, passive works well , 'The report was assigned to Marc.' It keeps focus on the task, not the person.",
          ),
          KokoLine("'Quorum' is a collective noun. Always singular. 'A **quorum** was reached', never 'were reached'."),
          UserTurn(
            option1: "Does that rule apply to 'agenda' too?",
            option2: "What about 'minutes', singular or plural?",
            reply1:  "Yes , 'the **agenda** was sent'. Collective nouns in business English are almost always singular.",
            reply2:  "'**Minutes**' as a document is always plural: 'the minutes were approved'. That's the exception.",
          ),
          KokoLine("In an **agenda**, use the infinitive form , 'To review Q2 results', not 'We will review Q2 results'."),
          UserTurn(
            option1: "Why the infinitive and not future tense?",
            option2: "How do I list AOB formally?",
            reply1:  "An agenda is a list of tasks, not promises. Infinitives are direct and action-focused.",
            reply2:  "Just write '**AOB**'. No need to expand the abbreviation, it's standard in professional documents.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Formal Emails',
        vocab: _mgmt2Vocab,
        script: [
          KokoLine("In formal emails, use modal verbs to soften requests. 'Could you **CC** me on replies' sounds better than 'CC me'."),
          UserTurn(
            option1: "What other modals work in professional emails?",
            option2: "When is a direct request appropriate?",
            reply1:  "'Would you', 'might you', 'I'd appreciate if you could', each slightly softer than the last.",
            reply2:  "With your own team, direct is fine. With clients or senior contacts, always soften with a modal.",
          ),
          KokoLine("A **follow-up** email should reference the prior exchange using the past perfect: 'As we had discussed...' not 'As we discussed'."),
          UserTurn(
            option1: "What's the difference in meaning?",
            option2: "Is 'per our conversation' correct English?",
            reply1:  "Past perfect shows the action was fully completed before now. It's more precise and sounds polished.",
            reply2:  "Technically yes, but it sounds rigid. 'As discussed' or 'following our call' flows more naturally.",
          ),
          KokoLine("Your **sign-off** changes by register: 'Yours faithfully' for Dear Sir/Madam; 'Kind regards' for named contacts."),
          UserTurn(
            option1: "When do I use 'Yours faithfully' vs 'Yours sincerely'?",
            option2: "Can I use 'Cheers' as a sign-off at work?",
            reply1:  "'Faithfully' when you don't know the name. 'Sincerely' when you do. Both are formal. **Sign-off** matches the opening.",
            reply2:  "Only in very informal internal culture. Never as a **sign-off** to a client, senior, or new contact.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Giving Feedback',
        vocab: _mgmt3Vocab,
        script: [
          KokoLine("Replace 'you should' with 'you could' in feedback. It's not just polite, it's grammatically softer."),
          UserTurn(
            option1: "What makes 'could' grammatically softer than 'should'?",
            option2: "Does that apply in written reviews too?",
            reply1:  "'Should' expresses obligation and implies failure. 'Could' expresses possibility, it opens a door.",
            reply2:  "Especially in writing. A **constructive** review uses 'could' and 'might' throughout, it's also more legally defensible.",
          ),
          KokoLine("Use comparatives carefully with **benchmark**: 'The output was closer to the benchmark this quarter'. Never 'more closer'."),
          UserTurn(
            option1: "What about 'more constructive', is that correct?",
            option2: "How do I compare a deliverable against a benchmark without sounding harsh?",
            reply1:  "Yes, three-syllable adjectives use 'more'. 'More **constructive**' is correct. 'Constructiver' is not a word.",
            reply2:  "Neutral framing: 'The **benchmark** is X. The **deliverable** reached Y. The gap is Z, here's how to close it.'",
          ),
          KokoLine("When referencing a **KPI** in written feedback, define it on first use. Never assume the reader knows the abbreviation."),
          UserTurn(
            option1: "Like 'the on-time delivery KPI, which measures...'?",
            option2: "What if the KPI is industry-standard?",
            reply1:  "Exactly. Define it once, then use the abbreviation throughout. Clear writing always wins.",
            reply2:  "Still define it on first mention in a written document. It's grammar and style practice, one line, no effort.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Negotiation',
        vocab: _mgmt4Vocab,
        script: [
          KokoLine("The second conditional is your most useful tool in negotiation language. 'If you could meet us on price, we would extend the contract.'"),
          UserTurn(
            option1: "Why second conditional and not first?",
            option2: "Is there a more formal version of that structure?",
            reply1:  "First conditional ('if you do, we will') sounds like a demand. Second ('if you could, we would') sounds like an offer.",
            reply2:  "'Were you to reduce the price, we would be in a position to extend.' 'Were you to' is the most formal conditional.",
          ),
          KokoLine("When you offer a **concession**, use past perfect to frame it as one-time: 'We hadn't planned to offer this, but we're prepared to...'"),
          UserTurn(
            option1: "Why does past perfect help here?",
            option2: "What if they ask for more after I've already made a concession?",
            reply1:  "It signals the **concession** is exceptional, not your starting position. It limits the expectation of more.",
            reply2:  "'We've already moved on this. To keep this a **win-win**, we'd need something from your side in return.'",
          ),
          KokoLine("When a **deadlock** is approaching, softening language matters: 'I'm afraid we may be reaching an impasse' is more professional than 'we're stuck'."),
          UserTurn(
            option1: "What other phrases signal a deadlock professionally?",
            option2: "Should I name the deadlock or let it sit?",
            reply1:  "'We seem to have reached the limits of what's possible today.' 'It may be worth reconvening after reflection.'",
            reply2:  "Name it. 'I think we've reached a **deadlock**' is professional, it opens the door to a break or new angle.",
          ),
        ],
      ),
    ],

    // ── Writing ──────────────────────────────────────────────────────────────
    LessonCategory.writing: [

      const CategoryDialogue(
        name: 'Pro Meetings',
        vocab: _mgmt1Vocab,
        script: [
          KokoLine("You have one hour to write up the **minutes** from today's meeting. Where do you start?"),
          UserTurn(
            option1: "I list every agenda item and what was decided.",
            option2: "I summarize the conversation in order.",
            reply1:  "Good structure. Lead with the **agenda**, then decisions, then **action items**, owner and deadline on every one.",
            reply2:  "Don't summarize conversation, capture decisions only. The **minutes** are a record, not a transcript.",
          ),
          KokoLine("When you send the **agenda** before a meeting, keep it to three lines per item. No paragraphs."),
          UserTurn(
            option1: "What should each line include?",
            option2: "How far in advance do I send it?",
            reply1:  "The topic, the person presenting, and the time allowed. That's the format.",
            reply2:  "24 hours minimum. Send it too late and people arrive unprepared.",
          ),
          KokoLine("Under **AOB**, always write 'Raised by [name]' next to each point in the written record."),
          UserTurn(
            option1: "Even for minor points?",
            option2: "Should AOB points become action items?",
            reply1:  "Especially then. **AOB** items get forgotten, a name creates accountability.",
            reply2:  "If they need follow-up, yes. Write them as **action items** so they don't disappear after the meeting.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Formal Emails',
        vocab: _mgmt2Vocab,
        script: [
          KokoLine("When you write a post-meeting email, structure it: context, decisions, **action items**. In that order."),
          UserTurn(
            option1: "What goes in the context line?",
            option2: "Do I CC people who weren't in the meeting?",
            reply1:  "One sentence: who met, when, why. Nothing more, people don't re-read context they already know.",
            reply2:  "Yes, deliberately. **CC** anyone who needs visibility. 'To' is only for **action item** owners.",
          ),
          KokoLine("Your **follow-up** email is not a transcript, it's a decision log. Write what was decided, not what was said."),
          UserTurn(
            option1: "What if something wasn't resolved in the meeting?",
            option2: "How short should a follow-up be?",
            reply1:  "Log it: 'No consensus reached on X. To be revisited by [date].' Make it an **action item** with an owner.",
            reply2:  "Five lines max. Context, three bullet decisions, **action items**. Strip everything else.",
          ),
          KokoLine("End with your **sign-off** and name. On first emails to someone, add your role and contact below."),
          UserTurn(
            option1: "Should I always include a full email signature?",
            option2: "Do I sign off every reply in a thread?",
            reply1:  "External emails, yes. Internal threads, a **sign-off** phrase and first name is enough after the first message.",
            reply2:  "On internal reply chains, your **sign-off** isn't needed on every reply. Just your name or initials is fine.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Giving Feedback',
        vocab: _mgmt3Vocab,
        script: [
          KokoLine("A written performance review always starts with the **deliverable**, what was expected, and what was submitted."),
          UserTurn(
            option1: "Should I list every deliverable or summarize?",
            option2: "What tone should the opening section have?",
            reply1:  "List the key ones with dates. A formal document needs specifics , 'the Q2 report due May 14' not 'the report'.",
            reply2:  "Neutral and factual. Save judgment for the **constructive** section. The opening is the record.",
          ),
          KokoLine("The **constructive** section follows 'observed → impact → change': what you saw, why it mattered, what to do differently."),
          UserTurn(
            option1: "Do I need to cite specific examples?",
            option2: "How do I write this without sounding harsh?",
            reply1:  "Always. 'The report lacked a **benchmark** comparison' is defensible. General statements are not.",
            reply2:  "Lead with the impact: 'The missing **benchmark** made it harder for the team to evaluate progress.' Then suggest the change.",
          ),
          KokoLine("Close the review with **KPI** targets for next quarter. Make them specific and time-bound."),
          UserTurn(
            option1: "What makes a KPI well-written?",
            option2: "Should I get the person to agree to the KPIs in writing?",
            reply1:  "Measurable and time-bound. 'Improve reports' is not a **KPI**. 'Submit benchmark-aligned reports every two weeks' is.",
            reply2:  "Yes, always. A signed **KPI** is the only thing that makes a performance review hold weight.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Negotiation',
        vocab: _mgmt4Vocab,
        script: [
          KokoLine("After a negotiation, always send a written summary, even if nothing was agreed. It documents where things stand."),
          UserTurn(
            option1: "What do I include if we reached a deadlock?",
            option2: "Who sends the follow-up, us or them?",
            reply1:  "'Following today's discussion, we were unable to agree on [point]. We remain open to reconvening.' Reference the **deadlock** formally.",
            reply2:  "Whoever has more to gain from documenting the current state. If you made a **concession**, send it, it's on record.",
          ),
          KokoLine("When confirming a **concession** in writing, be precise. 'We are prepared to offer X in exchange for Y'. Never vague."),
          UserTurn(
            option1: "What if the concession was verbal and they later deny it?",
            option2: "How do I frame a concession without sounding weak?",
            reply1:  "That's exactly why you write it. 'As discussed on [date], we agreed to...', documentation protects you.",
            reply2:  "Frame it as partnership: 'To help us reach a **win-win**, we're offering...' Concession as collaboration, not surrender.",
          ),
          KokoLine("If the negotiation led to a **win-win**, summarize both sides' gains, not just yours."),
          UserTurn(
            option1: "Why mention their gains in our summary?",
            option2: "Is there a risk of oversharing in writing?",
            reply1:  "It reinforces the **win-win** framing and makes them feel the deal was fair, which increases commitment.",
            reply2:  "Yes. Don't detail your internal **leverage** or strategy. Summarize the agreed terms only.",
          ),
        ],
      ),
    ],

    // ── Speaking ─────────────────────────────────────────────────────────────
    LessonCategory.speaking: [

      const CategoryDialogue(
        name: 'Pro Meetings',
        vocab: _mgmt1Vocab,
        script: [
          KokoLine("When you open a meeting, state the **agenda** out loud. Don't assume everyone read it."),
          UserTurn(
            option1: "Should I read every item or just give an overview?",
            option2: "What if someone wants to add something new?",
            reply1:  "One sentence per item. 'First we cover Q2, then roadmap, then **AOB**.' Keep it under 30 seconds.",
            reply2:  "Note it for **AOB** at the end. Don't let it derail the **agenda**, you'll lose the room.",
          ),
          KokoLine("To assign an **action item** verbally, always say the person's name, the task, and the deadline."),
          UserTurn(
            option1: "Like 'Marc, send the report by Friday'?",
            option2: "What if no one volunteers for a task?",
            reply1:  "Exactly. Name first. It creates immediate ownership. Never say 'someone should', it disappears.",
            reply2:  "Assign it directly. 'Marc, can you take this one?' A question still assigns it clearly.",
          ),
          KokoLine("Before closing, confirm all decisions are on record for the **minutes** and check you have a **quorum** for any votes."),
          UserTurn(
            option1: "Do I need to call a formal vote every time?",
            option2: "What if someone objects at the last minute?",
            reply1:  "Not always. A verbal 'Any objections?' is usually enough unless the **quorum** rules require a formal vote.",
            reply2:  "Log it in the **minutes**. 'Objection raised by [name], noted.' That becomes the official record.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Formal Emails',
        vocab: _mgmt2Vocab,
        script: [
          KokoLine("When referencing an email in a meeting, say who it was to, not just what it said. 'I **CC**'d the team on that' is clearer than 'I sent an email'."),
          UserTurn(
            option1: "What if people didn't read the email before the meeting?",
            option2: "Should I summarize it or just reference it?",
            reply1:  "Summarize the key point in one sentence. If it was worth a **CC**, it's worth one sentence out loud.",
            reply2:  "Reference, then summarize the relevant **action items** from it. Don't read it aloud, that wastes meeting time.",
          ),
          KokoLine("When assigning a **follow-up** verbally, use the future perfect: 'By Thursday, you'll have sent the revised proposal.'"),
          UserTurn(
            option1: "Why future perfect instead of simple future?",
            option2: "What if the person doesn't acknowledge the task?",
            reply1:  "It implies the task is as good as done. Clearer expectation than 'you will send it'.",
            reply2:  "Pause and wait. Don't move on. Silence makes the assignment real.",
          ),
          KokoLine("Your verbal **sign-off** is how you close a meeting professionally. 'I'll send the **follow-up** by end of day' signals you're wrapping up."),
          UserTurn(
            option1: "Any other good verbal closing phrases?",
            option2: "What if the meeting had no clear conclusions?",
            reply1:  "'Thanks everyone. I'll circulate the **action items** tonight.' It signals closure and accountability.",
            reply2:  "Then your verbal **sign-off** does extra work: 'We didn't reach a decision today. Next step is X by Y date.'",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Giving Feedback',
        vocab: _mgmt3Vocab,
        script: [
          KokoLine("When giving feedback verbally, open by naming the **deliverable** and when it was submitted. Facts first."),
          UserTurn(
            option1: "What if they get defensive immediately?",
            option2: "Should I ask permission before giving feedback?",
            reply1:  "Stay on the **deliverable**, not the person. 'The report from last week', not 'the way you work'.",
            reply2:  "In a formal review, no. In a casual moment, 'Can I share some feedback?' makes it land better.",
          ),
          KokoLine("Use the **KPI** as your anchor when delivering feedback. 'The target was X. You reached Y. Let's talk about the gap.'"),
          UserTurn(
            option1: "What if they dispute the KPI?",
            option2: "What if they already know they missed it?",
            reply1:  "Acknowledge the dispute, then focus on what you both agree on. Don't let the **KPI** debate derail the feedback.",
            reply2:  "Acknowledge it first: 'I know you're aware.' Then move straight to **constructive**, what to do about it.",
          ),
          KokoLine("End by agreeing on a **benchmark** for next time. Make it specific and get a verbal confirmation."),
          UserTurn(
            option1: "What if they push back on the benchmark?",
            option2: "How do you get a genuine confirmation, not just a polite 'yes'?",
            reply1:  "Negotiate it. A **benchmark** they helped set is one they'll actually work toward.",
            reply2:  "Ask them to repeat it back: 'Just so we're aligned, what are you committing to?' That makes it real.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Negotiation',
        vocab: _mgmt4Vocab,
        script: [
          KokoLine("Open a negotiation by establishing a **win-win** frame: 'We're here to find something that works for both sides.'"),
          UserTurn(
            option1: "Doesn't that signal weakness?",
            option2: "What if the other side opens aggressively?",
            reply1:  "No, it signals confidence. You're comfortable enough not to start with a power move.",
            reply2:  "Acknowledge without matching it. 'I hear you. Let's see what common ground we can find.' Then redirect.",
          ),
          KokoLine("When you make a **concession** verbally, slow down. Speak deliberately. Make it feel considered, not easy."),
          UserTurn(
            option1: "What phrases frame a concession as deliberate?",
            option2: "What if they immediately ask for more after a concession?",
            reply1:  "'This isn't something we'd normally offer, but...', it frames the **concession** as valuable.",
            reply2:  "Pause. Then: 'We've moved on this. To go further, we'd need something from your side.' Hold the line.",
          ),
          KokoLine("If you're approaching a **deadlock**, name it calmly. 'I think we've reached the limits of what's possible today.' Then suggest a break."),
          UserTurn(
            option1: "What if they use the break to pressure me?",
            option2: "How do you reopen after a deadlock?",
            reply1:  "A break resets the room. If they use it to pressure, they weren't negotiating in good faith, useful information.",
            reply2:  "Start fresh: 'Since we last spoke, we've had another look. Here's a new angle.' One small move restarts momentum.",
          ),
        ],
      ),
    ],
  },

  // ════════════════════════════════════════════════════════════════════════════
  // HUMAN RESOURCES
  // ════════════════════════════════════════════════════════════════════════════
  'rh': {
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Job Interviews',
        vocab: _hr1Vocab,
        script: [
          KokoLine("I just reviewed the applications. We're down to eight, all **shortlisted** on their **cover letter** alone."),
          UserTurn(
            option1: "What made a cover letter stand out?",
            option2: "How many are we actually interviewing?",
            reply1:  "Specificity. The best ones named our company and a concrete **competency** they bring.",
            reply2:  "Four. We're running a **panel** interview, three of us in the room at the same time.",
          ),
          KokoLine("The **panel** format can feel intense. But it tells us how someone handles pressure."),
          UserTurn(
            option1: "What should each of us focus on?",
            option2: "Doesn't that put candidates at a disadvantage?",
            reply1:  "You take technical **competency**, I handle culture fit, Priya covers role specifics.",
            reply2:  "It can feel that way, which is why we tell them in advance. We want the real person in the room.",
          ),
          KokoLine("One candidate was already **shortlisted** last year. She reapplied after building her profile."),
          UserTurn(
            option1: "That's a good sign, persistence matters.",
            option2: "Didn't we reject her before?",
            reply1:  "Exactly. It shows she actually wants to be here, not just any job.",
            reply2:  "We did. But she's grown since then. That's exactly what the **cover letter** showed.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Onboarding',
        vocab: _hr2Vocab,
        script: [
          KokoLine("Marc starts Monday. His **induction** is scheduled for the morning, two hours covering tools, policies, and culture."),
          UserTurn(
            option1: "What should an induction cover?",
            option2: "Two hours sounds short.",
            reply1:  "Policies, tools, team structure, and who to contact for what. The rest they learn by doing.",
            reply2:  "The **induction** is just the map. Real learning happens in the first month. Keep it focused.",
          ),
          KokoLine("He'll be on **probation** for three months. That gives both sides time to evaluate the fit."),
          UserTurn(
            option1: "What happens at the end of probation?",
            option2: "Can we let someone go during probation?",
            reply1:  "A review meeting. If both sides are happy, he moves to a permanent contract.",
            reply2:  "Yes, and it's simpler during **probation** than after. That's one of its purposes, it protects both parties.",
          ),
          KokoLine("We're assigning a **buddy** through the **buddy system**, someone in the team who's been here at least a year."),
          UserTurn(
            option1: "What does the buddy actually do?",
            option2: "Can a manager be the buddy?",
            reply1:  "Answers the informal questions new hires are afraid to ask officially, and shows them where things are on the **org chart**.",
            reply2:  "Never a manager. The **buddy system** works because it's peer-to-peer, no hierarchy, no judgment.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Performance Reviews',
        vocab: _hr3Vocab,
        script: [
          KokoLine("The quarterly **appraisal** process starts next week. Each team lead submits their assessments by Friday."),
          UserTurn(
            option1: "What format does the appraisal follow?",
            option2: "Is 360 feedback part of this cycle?",
            reply1:  "Achievements against **OKRs**, behaviors, and development areas. Three sections, no longer than two pages.",
            reply2:  "Yes. **360 feedback** goes out today, each person gets input from their manager, two peers, and one direct report.",
          ),
          KokoLine("**360 feedback** can be uncomfortable to read. But it's the most complete picture we have."),
          UserTurn(
            option1: "How do we ensure people give honest feedback?",
            option2: "What if the 360 results conflict with the manager's view?",
            reply1:  "Anonymity helps. But culture matters more, people give honest **360 feedback** when they trust it's for growth, not punishment.",
            reply2:  "Both views are valid data. Discuss the discrepancy in the **appraisal**, it usually reveals something important.",
          ),
          KokoLine("If the **appraisal** shows consistent underperformance, the next step is a **PIP**, a structured improvement plan."),
          UserTurn(
            option1: "What does a PIP include?",
            option2: "Is a PIP always a sign someone is about to be let go?",
            reply1:  "Specific targets, a timeline, and weekly check-ins. A **PIP** is only valid if the goals are achievable.",
            reply2:  "Not always. A well-run **PIP** can genuinely reset someone's trajectory, but it requires real support, not just paperwork.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Conflict Resolution',
        vocab: _hr4Vocab,
        script: [
          KokoLine("There's a conflict between two team members that isn't resolving on its own. We need to **de-escalate** before it spreads."),
          UserTurn(
            option1: "What does de-escalation look like in practice?",
            option2: "Should I meet them separately first?",
            reply1:  "Slow things down. Separate conversations first, then bring them together. Reduce emotional heat before you solve anything.",
            reply2:  "Always. Never put two people in conflict in the same room before you understand each side. That's how you **de-escalate** safely.",
          ),
          KokoLine("If de-escalation doesn't work, either party can raise a formal **grievance** through HR."),
          UserTurn(
            option1: "What triggers a formal grievance?",
            option2: "Does a grievance mean the manager failed?",
            reply1:  "Any complaint about workplace treatment, conduct, conditions, discrimination. The person puts it in writing and HR investigates.",
            reply2:  "Not necessarily. Some conflicts need a formal process. A **grievance** means the informal route didn't work, that's what it's for.",
          ),
          KokoLine("If the **grievance** can't be resolved internally, the options are **mediation**, or in serious cases, **arbitration**."),
          UserTurn(
            option1: "What's the difference between mediation and arbitration?",
            option2: "Who pays for external mediation?",
            reply1:  "**Mediation** helps both sides reach their own agreement. **Arbitration** is binding, the arbitrator decides.",
            reply2:  "Usually the company. **Mediation** is always cheaper than going to tribunal, and faster.",
          ),
        ],
      ),
    ],
  },

  // ════════════════════════════════════════════════════════════════════════════
  // FINANCE
  // ════════════════════════════════════════════════════════════════════════════
  'finance': {
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Budget Meetings',
        vocab: _fin1Vocab,
        script: [
          KokoLine("First question, do you know the difference between **Capex** and **Opex**?"),
          UserTurn(
            option1: "Capex is long-term investment, Opex is daily costs.",
            option2: "Not really. Can you walk me through it?",
            reply1:  "Correct. The servers we buy are **Capex**. The electricity to run them every month is **Opex**.",
            reply2:  "**Capex** is what you buy that lasts. **Opex** is what it costs to run the business day to day.",
          ),
          KokoLine("There's a significant **variance** in last quarter's IT budget. Someone needs to explain that."),
          UserTurn(
            option1: "Is the variance over or under budget?",
            option2: "What caused it?",
            reply1:  "Over by 18%. Cloud migration costs exceeded the estimate.",
            reply2:  "The cloud migration. We underestimated data transfer costs. Every **variance** needs a written explanation.",
          ),
          KokoLine("Going forward, I want clear **allocation** plans before any team submits a budget request."),
          UserTurn(
            option1: "What level of detail do you need?",
            option2: "Who sets the allocation limits?",
            reply1:  "Line by line. Not just 'marketing spend'. I need to see exactly what that covers.",
            reply2:  "The board sets the total. I translate it into department **allocation** caps. Teams work within that.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Financial Reports',
        vocab: _fin2Vocab,
        script: [
          KokoLine("End of quarter, the **P&L** is ready. Revenue up, but costs rose faster. Let's talk about what that means."),
          UserTurn(
            option1: "What should I look at first on a P&L?",
            option2: "Is revenue growth always good news?",
            reply1:  "The bottom line, net profit or loss. Then work backwards to understand what drove it.",
            reply2:  "Not if costs outpace it. The **P&L** shows both sides, revenue means nothing without the cost picture.",
          ),
          KokoLine("The **balance sheet** tells you what the company owns and what it owes, at a single point in time."),
          UserTurn(
            option1: "What's the difference between the balance sheet and the P&L?",
            option2: "What does equity mean on a balance sheet?",
            reply1:  "The **P&L** covers a period, this quarter's result. The **balance sheet** is today's position, assets vs liabilities.",
            reply2:  "**Equity** is what's left after you subtract liabilities from assets. The company's net worth owned by shareholders.",
          ),
          KokoLine("**Cash flow** is different from profit, a company can be profitable on paper and still run out of cash."),
          UserTurn(
            option1: "How is that possible?",
            option2: "Which matters more, profit or cash flow?",
            reply1:  "If clients pay late and your costs are due now, **cash flow** is negative even if the **P&L** shows profit.",
            reply2:  "**Cash flow** keeps you alive today. Profit makes you viable long term. You need both.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Invoice & Billing',
        vocab: _fin3Vocab,
        script: [
          KokoLine("The client approved the work. Now we issue the **invoice**. Send it the same day delivery is confirmed."),
          UserTurn(
            option1: "What must an invoice include?",
            option2: "What payment terms do we use by default?",
            reply1:  "Our details, the client's details, itemized services, total amount, and payment terms, usually **Net 30**.",
            reply2:  "**Net 30**, payment due within 30 days of the invoice date. Some clients push for **Net 60**, but we resist that.",
          ),
          KokoLine("Any **invoice** not paid within terms becomes **overdue**. We follow up on day 31, not later."),
          UserTurn(
            option1: "What does an overdue follow-up look like?",
            option2: "Do we charge interest on overdue invoices?",
            reply1:  "A short email: invoice number, original due date, and a request for payment or confirmation of when it arrives.",
            reply2:  "We can, it's in the terms. We usually waive it once. The second time an **invoice** is **overdue**, we apply it.",
          ),
          KokoLine("Before we start work for any new client, we need a **purchase order** from their side. No PO, no start."),
          UserTurn(
            option1: "Why is a purchase order required?",
            option2: "What if the client says they'll send it later?",
            reply1:  "A **purchase order** is their formal commitment to pay. Without it, the **invoice** can be disputed internally on their side.",
            reply2:  "We wait. 'Later' usually means the budget wasn't approved yet. No **purchase order** means no contract.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Financial KPIs',
        vocab: _fin4Vocab,
        script: [
          KokoLine("The board asked for our **EBITDA** this quarter. It's the clearest measure of core business profitability."),
          UserTurn(
            option1: "Why EBITDA and not just net profit?",
            option2: "What does the acronym stand for?",
            reply1:  "**EBITDA** strips out financing, tax, and depreciation, it shows what the business itself earns.",
            reply2:  "Earnings Before Interest, Taxes, Depreciation, and Amortisation. Removes variables to make comparison fair.",
          ),
          KokoLine("At our current **burn rate**, we have about seven months of **runway** left. That drives every decision we make."),
          UserTurn(
            option1: "What is the burn rate exactly?",
            option2: "How do we extend our runway?",
            reply1:  "The rate at which we spend cash each month. If we spend £200k a month, that's our **burn rate**.",
            reply2:  "Cut the **burn rate**, or raise funding. Every month we extend **runway**, we buy more time to hit profitability.",
          ),
          KokoLine("Our gross **margin** is healthy, but net **margin** is thin. That's where we need to focus."),
          UserTurn(
            option1: "What's the difference between gross and net margin?",
            option2: "What's a good net margin for our industry?",
            reply1:  "Gross **margin** is revenue minus cost of goods. Net **margin** is what's left after every cost, salaries, operations, everything.",
            reply2:  "For SaaS we target above 15%. Below 10% net **margin** means we're not converting revenue into real value.",
          ),
        ],
      ),
    ],
  },

  // ════════════════════════════════════════════════════════════════════════════
  // MARKETING
  // ════════════════════════════════════════════════════════════════════════════
  'marketing': {
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Pitch Deck',
        vocab: _mkt1Vocab,
        script: [
          KokoLine("We're pitching to a new client on Friday. You need a solid **elevator pitch** , 30 seconds, no more."),
          UserTurn(
            option1: "What's the core message?",
            option2: "Thirty seconds isn't much.",
            reply1:  "Lead with their problem, then your **value prop**, what only we can solve for them.",
            reply2:  "It's enough if you know what to say. Problem first, **value prop** last. Practice out loud.",
          ),
          KokoLine("Every slide needs a clear **CTA**. Don't end on a fact, end on an ask."),
          UserTurn(
            option1: "Like 'Let's schedule a follow-up call'?",
            option2: "What if they're not ready to commit?",
            reply1:  "Perfect. Low friction, easy to say yes to. That's a strong **CTA**.",
            reply2:  "Soften it , 'Would you be open to a second conversation?' Still a **CTA**, just smaller.",
          ),
          KokoLine("We also need to show **traction**. Clients don't invest in potential, they invest in proof."),
          UserTurn(
            option1: "We have 3,000 users from the beta.",
            option2: "What counts as traction at our stage?",
            reply1:  "Lead with that number. **Traction** is exactly this, real users, real engagement. Slide two.",
            reply2:  "User growth, retention, testimonials. **Traction** is evidence the market responded.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Brand Storytelling',
        vocab: _mkt2Vocab,
        script: [
          KokoLine("Every brand needs a **narrative**, not just what it sells, but why it exists."),
          UserTurn(
            option1: "How is a narrative different from a tagline?",
            option2: "Does a B2B company need a narrative?",
            reply1:  "A tagline is a line. A **narrative** is the story that makes people feel something, the origin, the mission.",
            reply2:  "Especially then. B2B buyers are people. A strong **narrative** is the difference between a vendor and a partner.",
          ),
          KokoLine("Your **USP** is the one thing you do that no one else does, or does as well."),
          UserTurn(
            option1: "What if competitors offer the same thing?",
            option2: "How do I identify our USP?",
            reply1:  "Then the **USP** is in execution, speed, service, community. Same product, different experience.",
            reply2:  "Ask your best customers why they chose you over others. The pattern in their answers is your **USP**.",
          ),
          KokoLine("**Tone of voice** is how your brand sounds across every touchpoint, consistent, even when the channel changes."),
          UserTurn(
            option1: "Does tone of voice need to change for social media vs formal docs?",
            option2: "How do you document a brand's tone of voice?",
            reply1:  "The register changes, but the personality shouldn't. A playful **tone of voice** can be slightly more formal without feeling off-brand.",
            reply2:  "A tone of voice guide: three adjectives describing the voice, on-brand vs off-brand examples, a do/don't list.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Social Media',
        vocab: _mkt3Vocab,
        script: [
          KokoLine("This post got 4,000 impressions but almost no **engagement**. That's a signal we need to look at."),
          UserTurn(
            option1: "What counts as engagement?",
            option2: "Why would high reach and low engagement be a problem?",
            reply1:  "Likes, comments, shares, saves, clicks. **Engagement** is any action beyond just seeing the post.",
            reply2:  "It means the content reached people but didn't land. High **reach**, low **engagement** = wrong message or wrong audience.",
          ),
          KokoLine("**Reach** tells you how many people saw it. **Conversion** tells you how many did something because of it."),
          UserTurn(
            option1: "What counts as a conversion on social media?",
            option2: "Is reach or conversion more important?",
            reply1:  "A click to the website, a form fill, a purchase, a follow. Whatever the goal of the post, that's the **conversion**.",
            reply2:  "**Conversion**. **Reach** is vanity, **conversion** is value. A small **reach** with high **conversion** beats a viral post that sells nothing.",
          ),
          KokoLine("Using the right **hashtag** extends your **reach** beyond your existing followers, but only if it's relevant."),
          UserTurn(
            option1: "How many hashtags should a post have?",
            option2: "Do hashtags still matter?",
            reply1:  "Three to five relevant ones outperform a wall of tags. Too many and the algorithm reads it as spam.",
            reply2:  "On LinkedIn and Instagram, yes, they categorize content. On X, one or two relevant **hashtags** is enough.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Campaign Brief',
        vocab: _mkt4Vocab,
        script: [
          KokoLine("Before any campaign starts, we need a **brief**, it's the single document everything else is built on."),
          UserTurn(
            option1: "What goes into a campaign brief?",
            option2: "Who writes the brief?",
            reply1:  "The objective, the **target audience**, the **KPIs**, the **deliverables**, the timeline, and the budget. In that order.",
            reply2:  "The account lead writes the first draft. Creative reviews it before any work starts. A bad **brief** produces bad work.",
          ),
          KokoLine("Defining the **target audience** isn't about demographics, it's about behavior and mindset."),
          UserTurn(
            option1: "What do you mean by mindset?",
            option2: "How specific should a target audience be?",
            reply1:  "What they care about, what they scroll past, what makes them stop. The **target audience** is a person, not a spreadsheet.",
            reply2:  "'Women 25-34' is too broad. 'First-time managers who feel out of their depth' is a **target audience**.",
          ),
          KokoLine("Each **deliverable** in the brief must map to a **KPI**. If you can't measure it, you can't improve it."),
          UserTurn(
            option1: "What if a deliverable is qualitative, like brand awareness?",
            option2: "Who owns the KPIs, the client or us?",
            reply1:  "Make it measurable: survey scores, sentiment analysis, share of voice. Every **deliverable** can tie to a **KPI**.",
            reply2:  "Both. The client owns the business outcome **KPI**. We own the campaign **KPI** that drives it.",
          ),
        ],
      ),
    ],
  },

  // ════════════════════════════════════════════════════════════════════════════
  // TECH & IT
  // ════════════════════════════════════════════════════════════════════════════
  'tech': {
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Agile Meetings',
        vocab: _tech1Vocab,
        script: [
          KokoLine("We just kicked off a new **sprint**. Two weeks to ship the notification system."),
          UserTurn(
            option1: "What's in the backlog for this sprint?",
            option2: "Two weeks feels tight.",
            reply1:  "Five tickets pulled from the **backlog**. You're on the push notification flow.",
            reply2:  "It is. Which is why we track **velocity**, what we actually complete, so we plan better next time.",
          ),
          KokoLine("Daily **stand-up** is at 9:15. Three things: what you did, what you're doing, what's blocking you."),
          UserTurn(
            option1: "Should I prepare anything in advance?",
            option2: "What if I have nothing to report?",
            reply1:  "Just check your ticket. Keep it under two minutes, the **stand-up** is not the place to debug.",
            reply2:  "You always have something. Even 'no blockers, same task' is useful data for the team.",
          ),
          KokoLine("At the end of the sprint we review our **velocity**. If we ship below capacity, we adjust the **backlog**."),
          UserTurn(
            option1: "What usually causes low velocity?",
            option2: "How exactly do you measure it?",
            reply1:  "Unclear tickets, context switching, or unplanned bugs. Usually one of those three.",
            reply2:  "Story points completed per sprint. We pull that from the **backlog** tool after each cycle closes.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Technical Writing',
        vocab: _tech2Vocab,
        script: [
          KokoLine("Before the sprint closes, every feature needs **documentation**. Not a novel, just enough for another engineer to use it."),
          UserTurn(
            option1: "What's the minimum that counts as documentation?",
            option2: "Who's responsible for writing it?",
            reply1:  "Purpose, inputs and outputs, and one example. If it has an **API**, document every endpoint.",
            reply2:  "The engineer who built it. **Documentation** written by the builder is faster and more accurate.",
          ),
          KokoLine("The **README** is the first thing anyone sees when they open the repo. Write it for someone who's never heard of this project."),
          UserTurn(
            option1: "What sections should a README always have?",
            option2: "How long should it be?",
            reply1:  "What it does, how to install it, how to run it, and how to contribute. That's the minimum.",
            reply2:  "Long enough to answer 'what is this and how do I start'. Link out to the **documentation** for the rest.",
          ),
          KokoLine("A **user story** describes a feature from the user's perspective: 'As a [role], I want [action] so that [benefit].'"),
          UserTurn(
            option1: "Why write it from the user's point of view?",
            option2: "Who writes user stories, devs or product?",
            reply1:  "Because features exist to solve user problems, not showcase technology. The **user story** keeps the team anchored.",
            reply2:  "Product writes the first draft. Engineers review for feasibility. The **user story** is a collaboration.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Code Reviews',
        vocab: _tech3Vocab,
        script: [
          KokoLine("You've finished the feature, now open a **PR**. Description first, code second."),
          UserTurn(
            option1: "What should the PR description include?",
            option2: "How big should a PR be?",
            reply1:  "What the change does, why it was made, and how to test it. A **PR** without context slows every reviewer down.",
            reply2:  "Small enough to review in one sitting. A **PR** with 50 lines gets reviewed carefully. 500 lines gets **LGTM** and a prayer.",
          ),
          KokoLine("When you see **LGTM** in a review, it's approval, but a good reviewer always adds at least one comment."),
          UserTurn(
            option1: "What kind of comment adds value?",
            option2: "Is LGTM with no comment acceptable?",
            reply1:  "A question about edge cases, a suggestion to **refactor** a function name, or a note about test coverage.",
            reply2:  "For very small changes, yes. For anything significant, a bare **LGTM** suggests the reviewer didn't really look.",
          ),
          KokoLine("You've hit a **merge conflict**. Stop and read both versions before deciding what to keep."),
          UserTurn(
            option1: "How do you resolve a merge conflict without breaking things?",
            option2: "How do you avoid merge conflicts in the first place?",
            reply1:  "Pull main, understand both changes, combine them intentionally. Never just accept 'theirs' without reading both.",
            reply2:  "Short-lived branches, small **PRs**, regular syncs with main. The longer a branch lives, the worse the **merge conflict**.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Product Pitch',
        vocab: _tech4Vocab,
        script: [
          KokoLine("We're pitching to engineering leadership next week. Lead with the **MVP**, what's shipping, not what's planned."),
          UserTurn(
            option1: "How do you define what's in the MVP?",
            option2: "Should we show the roadmap in the pitch?",
            reply1:  "The smallest set of features that delivers real value to a real user. If it's hypothetical, it's not in the **MVP**.",
            reply2:  "Yes, but after the **MVP**. Show what exists first, then the **roadmap** to show direction.",
          ),
          KokoLine("Show **adoption** numbers early, even small ones. Leadership responds to evidence, not projections."),
          UserTurn(
            option1: "What if adoption is low?",
            option2: "What counts as adoption?",
            reply1:  "Contextualize it: 'Two weeks live, zero marketing, here's the organic **adoption** so far.' Trend matters as much as number.",
            reply2:  "Active users, return visits, feature usage. **Adoption** means people came back, not just that they signed up.",
          ),
          KokoLine("The question they'll always ask: 'Is this **scalable**?' Have an answer ready before they ask it."),
          UserTurn(
            option1: "How do I prove something is scalable in a pitch?",
            option2: "What if we haven't tested scalability yet?",
            reply1:  "Architecture decisions. 'We built on X because it's **scalable** to Y users at Z cost.' Specific, not vague.",
            reply2:  "Be honest: 'We've designed it to be **scalable** and will stress-test it in the next sprint.' Don't claim what you haven't proven.",
          ),
        ],
      ),
    ],
  },

  // ════════════════════════════════════════════════════════════════════════════
  // LEGAL
  // ════════════════════════════════════════════════════════════════════════════
  'legal': {
    LessonCategory.vocabulary: [

      const CategoryDialogue(
        name: 'Contract Language',
        vocab: _leg1Vocab,
        script: [
          KokoLine("Before you sign anything, read every **clause**. Every single one."),
          UserTurn(
            option1: "Are there red flags in this contract?",
            option2: "What am I specifically looking for?",
            reply1:  "There's an auto-renewal **clause** on page 4. Miss the opt-out window and you're locked in for another year.",
            reply2:  "Termination rights, **liability** caps, and auto-renewal triggers. That's where the risk hides.",
          ),
          KokoLine("Page 7 has a broad **liability** cap. They're limiting their responsibility to almost nothing."),
          UserTurn(
            option1: "Can we push back on that?",
            option2: "What's the risk if we accept it?",
            reply1:  "Yes. We'll ask them to **indemnify** us for any damages caused by their platform. That's standard.",
            reply2:  "If their system fails and we lose data, we'd have almost no recourse. That's the exposure.",
          ),
          KokoLine("They also want us to **indemnify** them if a third party sues. That's a **breach** risk we don't accept."),
          UserTurn(
            option1: "We shouldn't agree to that.",
            option2: "Is that standard in supplier contracts?",
            reply1:  "Correct. We'll redline it. You never **indemnify** a vendor for failures in their own product.",
            reply2:  "It appears sometimes, but we reject it. If they **breach** their own terms, we shouldn't be on the hook.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'GDPR Basics',
        vocab: _leg2Vocab,
        script: [
          KokoLine("Under GDPR, every person whose data we hold is a **data subject**. That changes how we think about our user database."),
          UserTurn(
            option1: "What rights does a data subject have?",
            option2: "Do internal employees count as data subjects?",
            reply1:  "The **right to access** their data, the right to correct it, and the right to be deleted, among others.",
            reply2:  "Yes. Anyone whose personal data we process, customers, employees, contractors, is a **data subject** under GDPR.",
          ),
          KokoLine("We can't process personal data without a legal basis. For most of our marketing, that basis is **consent**."),
          UserTurn(
            option1: "What makes consent valid under GDPR?",
            option2: "Can we use legitimate interest instead of consent?",
            reply1:  "It must be freely given, specific, informed, and unambiguous. A pre-ticked box is not valid **consent**.",
            reply2:  "Sometimes, for B2B outreach, legitimate interest is defensible. For consumer data, **consent** is safer.",
          ),
          KokoLine("Any **data subject** can invoke their **right to access**, we have 30 days to respond with everything we hold on them."),
          UserTurn(
            option1: "What if we share data with third parties?",
            option2: "Do we need a DPA with every vendor?",
            reply1:  "We have to disclose that in the response. The **data subject** can see who we shared their data with.",
            reply2:  "Yes. Any vendor who processes personal data on our behalf needs a **DPA**, no exceptions.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'Legal Emails',
        vocab: _leg3Vocab,
        script: [
          KokoLine("When negotiating a dispute by email, mark sensitive communications '**without prejudice**'. It protects what you write."),
          UserTurn(
            option1: "What does without prejudice actually mean legally?",
            option2: "Does the other side also need to mark their emails?",
            reply1:  "It means the email can't be used as evidence in court if negotiations fail. It protects frank discussion.",
            reply2:  "Not necessarily, if yours is marked **without prejudice**, the exchange is generally protected. Cleaner if both do.",
          ),
          KokoLine("In legal emails, '**as per**' and '**pursuant to**' both reference a document, but they're not interchangeable."),
          UserTurn(
            option1: "What's the difference between the two?",
            option2: "Can I use 'as per' in an informal email?",
            reply1:  "'**As per** the contract' = in line with what it says. '**Pursuant to** clause 7' = acting on the authority of that clause.",
            reply2:  "In casual business writing, yes. In legal correspondence, '**pursuant to**' or 'in accordance with' is preferred.",
          ),
          KokoLine("The word '**hereby**' makes a statement formally binding. 'I **hereby** confirm...' isn't just formal, it has legal weight."),
          UserTurn(
            option1: "When should I use 'hereby'?",
            option2: "What if I write 'hereby' in an email and later change my mind?",
            reply1:  "When making a formal declaration: 'I **hereby** agree to the terms' or 'the company **hereby** authorises...'",
            reply2:  "'**Hereby**' in writing can constitute a binding statement. Check with legal before using it in anything consequential.",
          ),
        ],
      ),

      const CategoryDialogue(
        name: 'NDAs',
        vocab: _leg4Vocab,
        script: [
          KokoLine("We're sharing our product architecture with a potential partner. We need an **NDA** signed before that meeting."),
          UserTurn(
            option1: "What does an NDA actually protect?",
            option2: "Can we draft our own NDA?",
            reply1:  "It defines what information is **confidential** and prevents the other party from sharing or using it without permission.",
            reply2:  "For a standard **NDA**, a legal-reviewed template is fine. For anything involving **trade secrets**, get a lawyer.",
          ),
          KokoLine("The NDA should specifically list what is and isn't **confidential**. Vague NDAs are hard to enforce."),
          UserTurn(
            option1: "What categories should we list as confidential?",
            option2: "What happens if they breach the NDA?",
            reply1:  "Product specs, pricing, source code, **trade secrets**, client lists, and internal financial data. Be specific.",
            reply2:  "We can seek an **injunction** to stop them immediately, then sue for damages. The **NDA** must define the remedy.",
          ),
          KokoLine("A **trade secret** is information that gives us a competitive edge and is actively kept secret. That's a higher bar than just **confidential**."),
          UserTurn(
            option1: "How is a trade secret different from confidential information?",
            option2: "Can we protect trade secrets without an NDA?",
            reply1:  "**Confidential** is anything we label as such. A **trade secret** has legal protection on its own, but only if we actively protect it.",
            reply2:  "To some extent, trade secret law applies automatically. But an **NDA** with an **injunction** clause is much stronger in practice.",
          ),
        ],
      ),
    ],
  },
};
