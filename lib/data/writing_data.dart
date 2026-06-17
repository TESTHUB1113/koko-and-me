// ─── WRITING EXERCISE DATA ────────────────────────────────────────────────────
// One writing exercise per vocab word per lesson.
// writingData[deptId][lessonIdx] → list of exercises for that lesson.

class WritingExercise {
  final String word;
  final String prompt;
  final String example;
  const WritingExercise({
    required this.word,
    required this.prompt,
    required this.example,
  });
}

final Map<String, List<List<WritingExercise>>> writingData = {

  // ══════════════════════════════════════════════════════════════════════════
  // MANAGEMENT
  // ══════════════════════════════════════════════════════════════════════════
  'management': [
    // Lesson 1, agenda, AOB, minutes, action item, quorum
    [
      const WritingExercise(
        word: 'agenda',
        prompt: 'Write a sentence opening a meeting by referencing the agenda.',
        example: "Let's get started. I've shared the agenda in advance, so we have three items to get through in 40 minutes.",
      ),
      const WritingExercise(
        word: 'AOB',
        prompt: 'Write a sentence inviting AOB at the end of a meeting.',
        example: "We've covered everything on the agenda, does anyone have anything for AOB before we wrap up?",
      ),
      const WritingExercise(
        word: 'minutes',
        prompt: 'Write a sentence telling the team you will send the minutes.',
        example: "I'll send the minutes out by end of day. Please flag any corrections within 48 hours.",
      ),
      const WritingExercise(
        word: 'action item',
        prompt: 'Write a sentence assigning a clear action item to a colleague.',
        example: 'Action item for Marc: share the revised brief with the client by Thursday noon.',
      ),
      const WritingExercise(
        word: 'quorum',
        prompt: "Write a sentence explaining you can't vote yet because quorum hasn't been reached.",
        example: "We don't have quorum yet. Let's hold off on the vote until David joins.",
      ),
    ],
    // Lesson 2. CC, follow-up, sign-off, action item
    [
      const WritingExercise(
        word: 'CC',
        prompt: "Write a sentence explaining why you're CC'ing someone on an email.",
        example: "I'm CC'ing Sarah so she has full context before the debrief on Friday.",
      ),
      const WritingExercise(
        word: 'follow-up',
        prompt: 'Write a short sentence opening a follow-up email.',
        example: 'Following up on our call last Tuesday, just confirming the delivery date we agreed on.',
      ),
      const WritingExercise(
        word: 'sign-off',
        prompt: 'Write a professional email sign-off for an internal message.',
        example: "Let me know if you have any questions, happy to jump on a quick call. Best, Emma.",
      ),
      const WritingExercise(
        word: 'action item',
        prompt: 'Write a sentence confirming an action item in writing after a meeting.',
        example: 'As agreed: action item. Please send the updated proposal to legal before Friday EOD.',
      ),
    ],
    // Lesson 3, constructive, KPI, benchmark, deliverable
    [
      const WritingExercise(
        word: 'constructive',
        prompt: 'Write a sentence opening a constructive feedback conversation.',
        example: "I have some constructive feedback on the presentation, there's one section we can make much stronger before it goes to the board.",
      ),
      const WritingExercise(
        word: 'KPI',
        prompt: 'Write a sentence reporting on a KPI in a status update.',
        example: 'Our key KPI for Q3 is response time, we are currently at 4.5 hours against a target of 3.',
      ),
      const WritingExercise(
        word: 'benchmark',
        prompt: "Write a sentence using 'benchmark' to set a performance expectation.",
        example: 'The industry benchmark is 2.5% conversion, we are at 1.8%, so there is clear room to improve.',
      ),
      const WritingExercise(
        word: 'deliverable',
        prompt: 'Write a sentence clarifying the deliverable for a task.',
        example: 'The deliverable for this phase is a 5-page report summarising the user research, due by the 20th.',
      ),
    ],
    // Lesson 4, leverage, concession, win-win, deadlock
    [
      const WritingExercise(
        word: 'leverage',
        prompt: 'Write a sentence describing the leverage your team has in a negotiation.',
        example: "Our leverage here is the exclusivity clause, they need us more than they're letting on.",
      ),
      const WritingExercise(
        word: 'concession',
        prompt: 'Write a sentence offering a concession while holding your main position.',
        example: "We're willing to make a concession on the timeline, but the price needs to stay where it is.",
      ),
      const WritingExercise(
        word: 'win-win',
        prompt: 'Write a sentence proposing a win-win outcome in a negotiation.',
        example: 'If we extend the contract by a year, that is a win-win, volume guarantee for us, a lower rate for them.',
      ),
      const WritingExercise(
        word: 'deadlock',
        prompt: 'Write a sentence suggesting a way to break a deadlock in talks.',
        example: "We've hit a deadlock on this point. I suggest we both go away and come back with revised terms on Monday.",
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // HR
  // ══════════════════════════════════════════════════════════════════════════
  'rh': [
    // Lesson 1, cover letter, competency, panel, shortlisted
    [
      const WritingExercise(
        word: 'cover letter',
        prompt: 'Write a sentence opening a cover letter for a role you are excited about.',
        example: "I'm writing to apply for the Operations Manager role, three years running cross-functional teams has prepared me well for exactly this challenge.",
      ),
      const WritingExercise(
        word: 'competency',
        prompt: 'Write a sentence describing a competency you assess in interviews.',
        example: 'One core competency we assess is conflict resolution, we ask candidates to walk us through a real situation.',
      ),
      const WritingExercise(
        word: 'panel',
        prompt: 'Write a sentence preparing a candidate for a panel interview.',
        example: "You'll be meeting with a panel of three, the HR lead, the hiring manager, and one of the team.",
      ),
      const WritingExercise(
        word: 'shortlisted',
        prompt: 'Write a sentence informing a candidate they have been shortlisted.',
        example: "I'm pleased to let you know you've been shortlisted, we'd like to invite you for a second interview next week.",
      ),
    ],
    // Lesson 2, probation, induction, buddy system, org chart
    [
      const WritingExercise(
        word: 'probation',
        prompt: 'Write a sentence explaining the probation period to a new hire.',
        example: 'Your probation is 90 days, we will have a check-in at 30 and 60 days before the final review.',
      ),
      const WritingExercise(
        word: 'induction',
        prompt: 'Write a sentence describing what the induction will cover.',
        example: "Your induction starts Monday, you'll get an overview of the company, your tools, and meet the key people you'll be working with.",
      ),
      const WritingExercise(
        word: 'buddy system',
        prompt: 'Write a sentence introducing the buddy system to a new starter.',
        example: "We run a buddy system here. Tom will be your go-to for any questions during your first few weeks.",
      ),
      const WritingExercise(
        word: 'org chart',
        prompt: 'Write a sentence directing someone to the org chart.',
        example: 'If you are unsure who to contact, check the org chart on the intranet, it shows every team and who reports to whom.',
      ),
    ],
    // Lesson 3, appraisal, 360 feedback, OKR, PIP
    [
      const WritingExercise(
        word: 'appraisal',
        prompt: 'Write a sentence setting up an annual appraisal meeting.',
        example: "Your appraisal is scheduled for Thursday at 2pm, we'll go through your goals, feedback, and development plan for next year.",
      ),
      const WritingExercise(
        word: '360 feedback',
        prompt: 'Write a sentence explaining the 360 feedback process to your team.',
        example: "We're running 360 feedback this cycle, you'll receive input from your manager, two peers, and one direct report.",
      ),
      const WritingExercise(
        word: 'OKR',
        prompt: 'Write a sentence introducing OKRs at the start of a quarter.',
        example: "Let's align on our OKRs for Q2, one Objective per team, with three Key Results each, reviewed at the mid-point.",
      ),
      const WritingExercise(
        word: 'PIP',
        prompt: 'Write a sentence introducing a Performance Improvement Plan sensitively.',
        example: "I want to support you through this, which is why we're putting a PIP in place, it's a structured plan, not a punishment.",
      ),
    ],
    // Lesson 4, mediation, de-escalate, grievance, arbitration
    [
      const WritingExercise(
        word: 'mediation',
        prompt: 'Write a sentence proposing mediation to resolve a team conflict.',
        example: 'Given where things stand, I think mediation would help, a neutral third party can often get us to a solution faster.',
      ),
      const WritingExercise(
        word: 'de-escalate',
        prompt: 'Write a sentence explaining a decision made to de-escalate a situation.',
        example: 'We moved them to separate projects temporarily to de-escalate, once the review is done, we will revisit.',
      ),
      const WritingExercise(
        word: 'grievance',
        prompt: 'Write a sentence acknowledging a formal grievance has been received.',
        example: "We've received your grievance and will acknowledge it in writing within five working days, as required.",
      ),
      const WritingExercise(
        word: 'arbitration',
        prompt: 'Write a sentence explaining when arbitration would be used.',
        example: 'If mediation does not resolve it, the next step is arbitration, a binding decision made by an independent arbitrator.',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // FINANCE
  // ══════════════════════════════════════════════════════════════════════════
  'finance': [
    // Lesson 1. Capex, Opex, variance, allocation
    [
      const WritingExercise(
        word: 'Capex',
        prompt: 'Write a sentence explaining a Capex purchase in a budget meeting.',
        example: "The new server infrastructure is a Capex item, it's a one-time investment that will sit on the balance sheet.",
      ),
      const WritingExercise(
        word: 'Opex',
        prompt: 'Write a sentence distinguishing Opex from Capex.',
        example: 'The cloud subscriptions are Opex, they go straight to the P&L each month, unlike the hardware which is Capex.',
      ),
      const WritingExercise(
        word: 'variance',
        prompt: 'Write a sentence flagging a budget variance in a report.',
        example: 'We have a variance of €12,000 against budget this quarter, the overspend is mainly in contractor costs.',
      ),
      const WritingExercise(
        word: 'allocation',
        prompt: 'Write a sentence explaining how the budget allocation was decided.',
        example: 'The allocation for Q3 prioritises product and sales, support teams are flat on last year.',
      ),
    ],
    // Lesson 2. P&L, balance sheet, cash flow, equity
    [
      const WritingExercise(
        word: 'P&L',
        prompt: 'Write a sentence requesting the P&L for a board call.',
        example: "Can you share last month's P&L before the board call? I want to check the gross margin line.",
      ),
      const WritingExercise(
        word: 'balance sheet',
        prompt: 'Write a sentence summarising what the balance sheet shows.',
        example: 'The balance sheet as of December 31st shows strong equity, liabilities are down 18% year on year.',
      ),
      const WritingExercise(
        word: 'cash flow',
        prompt: 'Write a sentence flagging a cash flow concern.',
        example: 'The cash flow forecast is tight through February, we need to accelerate two outstanding invoices.',
      ),
      const WritingExercise(
        word: 'equity',
        prompt: 'Write a sentence explaining equity to a new team member.',
        example: "Equity is what's left for shareholders after you subtract all liabilities from the assets, it's the net value of the business.",
      ),
    ],
    // Lesson 3, invoice, Net 30, overdue, purchase order
    [
      const WritingExercise(
        word: 'invoice',
        prompt: 'Write a sentence following up on an unpaid invoice.',
        example: "I'm following up on invoice #1042, sent on the 3rd. Could you confirm when payment will be processed?",
      ),
      const WritingExercise(
        word: 'Net 30',
        prompt: 'Write a sentence setting payment terms in a client email.',
        example: 'Our standard payment terms are Net 30, you will receive the invoice on delivery and payment is due within 30 days.',
      ),
      const WritingExercise(
        word: 'overdue',
        prompt: 'Write a sentence flagging an overdue payment.',
        example: 'Invoice #1042 is now overdue by 14 days. Please advise on when we can expect settlement.',
      ),
      const WritingExercise(
        word: 'purchase order',
        prompt: 'Write a sentence requesting a purchase order before starting work.',
        example: "Before we begin, we'll need a purchase order from your procurement team. Can you raise one this week?",
      ),
    ],
    // Lesson 4. EBITDA, burn rate, runway, margin
    [
      const WritingExercise(
        word: 'EBITDA',
        prompt: 'Write a sentence using EBITDA in a financial summary.',
        example: 'EBITDA for the half-year is €2.1M, up 14% on the same period last year, driven by the enterprise contracts.',
      ),
      const WritingExercise(
        word: 'burn rate',
        prompt: 'Write a sentence reporting on the monthly burn rate.',
        example: 'Current burn rate is €180K per month, at this pace, we have just under nine months of runway.',
      ),
      const WritingExercise(
        word: 'runway',
        prompt: 'Write a sentence giving a runway update to investors.',
        example: "With the latest raise, runway extends to Q3 next year, enough to hit the revenue milestones we committed to.",
      ),
      const WritingExercise(
        word: 'margin',
        prompt: 'Write a sentence highlighting a margin improvement.',
        example: 'Gross margin improved to 68% this quarter, cost efficiencies in fulfilment drove most of the gain.',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // MARKETING
  // ══════════════════════════════════════════════════════════════════════════
  'marketing': [
    // Lesson 1, elevator pitch, value prop, CTA, traction
    [
      const WritingExercise(
        word: 'elevator pitch',
        prompt: 'Write a one-sentence elevator pitch for a business idea.',
        example: 'We help early-stage founders practice pitching through 60-second recorded sessions reviewed by senior investors.',
      ),
      const WritingExercise(
        word: 'value prop',
        prompt: "Write a sentence stating a product's value prop clearly.",
        example: 'Our value prop is simple: half the cost of a traditional agency, with a 48-hour turnaround.',
      ),
      const WritingExercise(
        word: 'CTA',
        prompt: 'Write a sentence that includes a strong CTA for a campaign.',
        example: 'Ready to cut your cost per lead in half? Book a free 20-minute call this week.',
      ),
      const WritingExercise(
        word: 'traction',
        prompt: 'Write a sentence highlighting traction in a pitch.',
        example: 'We already have traction , 400 paying users in eight weeks, with zero marketing spend.',
      ),
    ],
    // Lesson 2, narrative, USP, tone of voice, brand equity
    [
      const WritingExercise(
        word: 'narrative',
        prompt: 'Write a sentence describing a brand narrative.',
        example: "Our narrative is simple: we built this because we were the customer, and nothing worked the way it should.",
      ),
      const WritingExercise(
        word: 'USP',
        prompt: "Write a sentence explaining a product's USP in a pitch.",
        example: "Our USP is that we're the only tool on the market that integrates inventory, billing, and CRM in one screen.",
      ),
      const WritingExercise(
        word: 'tone of voice',
        prompt: "Write a sentence defining a brand's tone of voice for a copywriter.",
        example: "Our tone of voice is direct and warm, like a smart friend who happens to know a lot about finance.",
      ),
      const WritingExercise(
        word: 'brand equity',
        prompt: 'Write a sentence explaining what builds brand equity.',
        example: "Brand equity isn't built by a campaign, it's the sum of every interaction a customer has ever had with you.",
      ),
    ],
    // Lesson 3, engagement, reach, conversion, hashtag
    [
      const WritingExercise(
        word: 'engagement',
        prompt: 'Write a sentence reporting on engagement for a campaign.',
        example: 'Engagement on the launch post is strong , 4.2% rate against a 1.8% benchmark for the sector.',
      ),
      const WritingExercise(
        word: 'reach',
        prompt: 'Write a sentence presenting reach numbers in a campaign debrief.',
        example: 'Total reach for the campaign was 2.1M , 340K of that was organic, the rest came from paid amplification.',
      ),
      const WritingExercise(
        word: 'conversion',
        prompt: 'Write a sentence flagging a conversion problem on a landing page.',
        example: 'Traffic is healthy but conversion from the landing page is at 0.9%, we need to test the headline and CTA.',
      ),
      const WritingExercise(
        word: 'hashtag',
        prompt: 'Write a sentence explaining how to use a hashtag in a campaign.',
        example: "We're running a branded hashtag , #MadeWithUs, and seeding it with five influencer partners before launch.",
      ),
    ],
    // Lesson 4, brief, target audience, deliverable, KPI
    [
      const WritingExercise(
        word: 'brief',
        prompt: 'Write a sentence requesting a brief from a client before scoping work.',
        example: "Before we scope the project, could you share a brief? It helps us align on objectives and avoid revisions later.",
      ),
      const WritingExercise(
        word: 'target audience',
        prompt: "Write a sentence defining a campaign's target audience.",
        example: 'The target audience for this campaign is working parents aged 28–42 in urban areas, high income, low time.',
      ),
      const WritingExercise(
        word: 'deliverable',
        prompt: 'Write a sentence listing the deliverables for a campaign.',
        example: 'The deliverables include a 30-second video, five social assets, and a campaign brief, all due by the 15th.',
      ),
      const WritingExercise(
        word: 'KPI',
        prompt: 'Write a sentence agreeing on a primary KPI before a campaign launches.',
        example: "Before we go live, let's agree on the primary KPI, is it reach, engagement, or sign-ups?",
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // TECH
  // ══════════════════════════════════════════════════════════════════════════
  'tech': [
    // Lesson 1, sprint, stand-up, backlog, velocity
    [
      const WritingExercise(
        word: 'sprint',
        prompt: 'Write a sentence opening a sprint planning meeting.',
        example: "This sprint runs for two weeks. Let's pull from the backlog and agree on what the team can realistically ship.",
      ),
      const WritingExercise(
        word: 'stand-up',
        prompt: 'Write a sentence explaining the stand-up format to a new team member.',
        example: 'We hold a stand-up every morning at 9:15, three questions: what did you do, what are you doing, and what is blocking you.',
      ),
      const WritingExercise(
        word: 'backlog',
        prompt: 'Write a sentence about prioritising the backlog.',
        example: "The backlog is getting long. Let's groom it on Thursday and deprioritise anything that hasn't been touched in two sprints.",
      ),
      const WritingExercise(
        word: 'velocity',
        prompt: 'Write a sentence reporting team velocity in a planning session.',
        example: 'Our velocity for the last three sprints has averaged 34 points, so let us commit to 32 this time and leave buffer.',
      ),
    ],
    // Lesson 2, documentation, API, README, user story
    [
      const WritingExercise(
        word: 'documentation',
        prompt: 'Write a sentence explaining why documentation matters.',
        example: 'The documentation is as important as the code, if the next engineer cannot understand it, it is not done.',
      ),
      const WritingExercise(
        word: 'API',
        prompt: 'Write a sentence explaining an API integration to a non-technical stakeholder.',
        example: "The API lets our platform talk to theirs directly, no manual exports, no CSV files, it syncs automatically.",
      ),
      const WritingExercise(
        word: 'README',
        prompt: 'Write a sentence about what a good README should include.',
        example: 'The README should explain what the project does, how to run it locally, and what the main dependencies are, in that order.',
      ),
      const WritingExercise(
        word: 'user story',
        prompt: 'Write a user story for a feature where users need to reset their password.',
        example: 'As a user who has forgotten my password, I want to reset it by email so that I can regain access within 60 seconds.',
      ),
    ],
    // Lesson 3. PR, LGTM, refactor, merge conflict
    [
      const WritingExercise(
        word: 'PR',
        prompt: 'Write a sentence describing what your PR does, as if writing the PR description.',
        example: 'This PR adds pagination to the user list endpoint, tested on staging, all existing tests pass.',
      ),
      const WritingExercise(
        word: 'LGTM',
        prompt: 'Write a sentence approving a PR in a code review.',
        example: 'LGTM, clean logic, good test coverage. One optional suggestion in the comments but happy to merge as-is.',
      ),
      const WritingExercise(
        word: 'refactor',
        prompt: 'Write a sentence proposing a refactor without blocking the current sprint.',
        example: "The auth module needs a refactor, it's not breaking anything now, but let's schedule it for next sprint before it becomes a problem.",
      ),
      const WritingExercise(
        word: 'merge conflict',
        prompt: 'Write a sentence explaining a merge conflict to a junior developer.',
        example: "You've got a merge conflict on line 42, both branches changed the same function. Pick the version you want, then commit.",
      ),
    ],
    // Lesson 4. MVP, roadmap, adoption, scalable
    [
      const WritingExercise(
        word: 'MVP',
        prompt: 'Write a sentence explaining the MVP scope to a stakeholder.',
        example: 'The MVP covers login, the core workflow, and basic reporting, everything else goes on the roadmap after we validate.',
      ),
      const WritingExercise(
        word: 'roadmap',
        prompt: 'Write a sentence presenting the product roadmap to a new hire.',
        example: 'The roadmap covers Q2 to Q4, search comes first, then the integrations layer, then the mobile app.',
      ),
      const WritingExercise(
        word: 'adoption',
        prompt: 'Write a sentence reporting on feature adoption in a product review.',
        example: 'Adoption of the new dashboard is at 41% in week three, we will push a tooltip walkthrough to lift that above 60.',
      ),
      const WritingExercise(
        word: 'scalable',
        prompt: 'Write a sentence defending an architectural choice as scalable.',
        example: 'We went with microservices precisely because it is scalable, each service can grow independently without touching the others.',
      ),
    ],
  ],

  // ══════════════════════════════════════════════════════════════════════════
  // LEGAL
  // ══════════════════════════════════════════════════════════════════════════
  'legal': [
    // Lesson 1, clause, liability, indemnify, breach
    [
      const WritingExercise(
        word: 'clause',
        prompt: 'Write a sentence flagging a clause in a contract for review.',
        example: "There's a clause in section 4 that limits our ability to sub-contract, we need to redline it before we sign.",
      ),
      const WritingExercise(
        word: 'liability',
        prompt: 'Write a sentence capping liability in a contract email.',
        example: "We're happy to proceed, but we'll need to cap our liability at the contract value, standard for engagements of this size.",
      ),
      const WritingExercise(
        word: 'indemnify',
        prompt: 'Write a sentence explaining an indemnification clause in plain language.',
        example: 'The indemnification clause means that if a third party sues us because of something you did, you cover our legal costs.',
      ),
      const WritingExercise(
        word: 'breach',
        prompt: 'Write a sentence alerting a party to a potential breach.',
        example: "We're writing to flag a potential breach of section 8.2, payment was due on the 1st and has not been received.",
      ),
    ],
    // Lesson 2, data subject, consent, right to access, DPA
    [
      const WritingExercise(
        word: 'data subject',
        prompt: 'Write a sentence explaining who a data subject is in a privacy policy.',
        example: 'A data subject is any individual whose personal data we collect, in our case, that means users, clients, and job applicants.',
      ),
      const WritingExercise(
        word: 'consent',
        prompt: 'Write a sentence explaining when consent is required under data regulations.',
        example: 'We need explicit consent before sending marketing emails, a pre-ticked box does not count under current regulations.',
      ),
      const WritingExercise(
        word: 'right to access',
        prompt: 'Write a sentence responding to a right to access request.',
        example: "We've received your right to access request and will provide a copy of all personal data held within 30 days, as required by law.",
      ),
      const WritingExercise(
        word: 'DPA',
        prompt: 'Write a sentence requesting a DPA before sharing data with a vendor.',
        example: "Before we send any client data to your platform, we'll need a signed DPA, our legal team will send the draft this week.",
      ),
    ],
    // Lesson 3, without prejudice, as per, pursuant to, hereby
    [
      const WritingExercise(
        word: 'without prejudice',
        prompt: 'Write a sentence opening a settlement proposal marked without prejudice.',
        example: 'Without prejudice, we would like to propose a settlement of €15,000 to resolve this matter without further proceedings.',
      ),
      const WritingExercise(
        word: 'as per',
        prompt: "Write a sentence referencing a previous agreement using 'as per'.",
        example: 'As per our agreement dated 12 January, payment is due within 14 days of invoice receipt.',
      ),
      const WritingExercise(
        word: 'pursuant to',
        prompt: "Write a sentence invoking a contract clause using 'pursuant to'.",
        example: 'Pursuant to clause 9.3, we are exercising our right to terminate the agreement with 30 days notice.',
      ),
      const WritingExercise(
        word: 'hereby',
        prompt: "Write a sentence using 'hereby' to make a formal declaration.",
        example: 'The Company hereby confirms acceptance of the revised terms as set out in the amendment dated 15 March.',
      ),
    ],
    // Lesson 4. NDA, confidential, trade secret, injunction
    [
      const WritingExercise(
        word: 'NDA',
        prompt: 'Write a sentence requesting an NDA before sharing sensitive information.',
        example: "Before we share the product specs, we'll need a signed NDA. Can your team turn that around by Thursday?",
      ),
      const WritingExercise(
        word: 'confidential',
        prompt: 'Write a sentence labelling a message as confidential.',
        example: 'This email and its attachments are confidential and intended solely for the named recipient. Please do not forward.',
      ),
      const WritingExercise(
        word: 'trade secret',
        prompt: 'Write a sentence protecting a trade secret in a client agreement.',
        example: 'The proprietary algorithm is considered a trade secret and may not be reverse-engineered or disclosed under any circumstances.',
      ),
      const WritingExercise(
        word: 'injunction',
        prompt: 'Write a sentence explaining when an injunction would be sought.',
        example: 'If the information is shared before trial, we will seek an injunction to stop further disclosure immediately.',
      ),
    ],
  ],
};
