// Vocabulary pairs used by WordMatch and WordCatcher games.
// Each lesson has a list of {word, def} maps.

const Map<String, List<Map<String, String>>> lessonVocab = {
  // ── MANAGEMENT ───────────────────────────────────────────────────────────
  'Formal Emails': [
    {'word': 'CC',          'def': 'Send a copy to another person'},
    {'word': 'Action Item', 'def': 'Task assigned after a meeting'},
    {'word': 'Follow-up',   'def': 'Message sent after first contact'},
    {'word': 'Sign-off',    'def': 'Formal closing phrase in an email'},
  ],
  'Pro Meetings': [
    {'word': 'Agenda',  'def': 'List of topics to discuss'},
    {'word': 'Minutes', 'def': 'Written record of what was said'},
    {'word': 'Quorum',  'def': 'Min. attendees to make it official'},
    {'word': 'AOB',     'def': 'Any Other Business, last item on the agenda'},
  ],
  'Giving Feedback': [
    {'word': 'Constructive', 'def': 'Helpful criticism meant to improve'},
    {'word': 'KPI',          'def': 'Key metric to measure performance'},
    {'word': 'Benchmark',    'def': 'Standard used for comparison'},
    {'word': 'Deliverable',  'def': 'Final result expected from a task'},
  ],
  'Negotiation': [
    {'word': 'Leverage',   'def': 'Advantage used in a negotiation'},
    {'word': 'Concession', 'def': 'Something given up to reach a deal'},
    {'word': 'Win-win',    'def': 'Agreement good for both parties'},
    {'word': 'Deadlock',   'def': 'Standstill where no progress is made'},
  ],
  'Presenting KPIs': [
    {'word': 'ROI',         'def': 'Return On Investment, profit vs cost'},
    {'word': 'Stakeholder', 'def': 'Person with interest in outcomes'},
    {'word': 'Baseline',    'def': 'Starting point for comparison'},
    {'word': 'Forecast',    'def': 'Prediction of future performance'},
  ],

  // ── HUMAN RESOURCES ──────────────────────────────────────────────────────
  'Job Interview': [
    {'word': 'Cover Letter', 'def': 'Letter explaining why you applied'},
    {'word': 'Competency',   'def': 'Skill or ability needed for a role'},
    {'word': 'Panel',        'def': 'Group of interviewers in one session'},
    {'word': 'Shortlisted',  'def': 'Selected as a top candidate'},
  ],
  'Onboarding': [
    {'word': 'Probation',    'def': 'Trial period at start of a new job'},
    {'word': 'Induction',    'def': 'Introduction process for new staff'},
    {'word': 'Buddy System', 'def': 'Pairing new hire with a colleague'},
    {'word': 'Org Chart',    'def': 'Diagram showing company structure'},
  ],
  'Performance Review': [
    {'word': 'Appraisal',    'def': 'Formal assessment of work performance'},
    {'word': '360 Feedback', 'def': 'Feedback from peers, manager & reports'},
    {'word': 'OKR',          'def': 'Objectives and Key Results framework'},
    {'word': 'PIP',          'def': 'Performance Improvement Plan'},
  ],
  'Conflict Resolution': [
    {'word': 'Mediation',    'def': 'Neutral third party helps resolve dispute'},
    {'word': 'De-escalate',  'def': 'Reduce tension in a conflict'},
    {'word': 'Grievance',    'def': 'Formal complaint raised by an employee'},
    {'word': 'Arbitration',  'def': 'Binding decision made by an arbitrator'},
  ],

  // ── FINANCE ──────────────────────────────────────────────────────────────
  'Budget Meetings': [
    {'word': 'Capex',      'def': 'Capital Expenditure, long-term spending'},
    {'word': 'Opex',       'def': 'Operational Expenditure, daily costs'},
    {'word': 'Variance',   'def': 'Difference between budget and actual'},
    {'word': 'Allocation', 'def': 'How budget is divided across areas'},
  ],
  'Financial Reports': [
    {'word': 'P&L',           'def': 'Profit and Loss statement'},
    {'word': 'Balance Sheet', 'def': 'Snapshot of assets and liabilities'},
    {'word': 'Cash Flow',     'def': 'Money moving in and out of business'},
    {'word': 'Equity',        'def': 'Value owned after liabilities deducted'},
  ],
  'Invoice & Billing': [
    {'word': 'Invoice',        'def': 'Bill sent to a client for services'},
    {'word': 'Net 30',         'def': 'Payment due within 30 days'},
    {'word': 'Overdue',        'def': 'Payment not received on time'},
    {'word': 'Purchase Order', 'def': 'Official request to buy something'},
  ],
  'Financial KPIs': [
    {'word': 'EBITDA',    'def': 'Earnings before interest, tax & depreciation'},
    {'word': 'Burn Rate', 'def': 'Speed at which a company spends cash'},
    {'word': 'Runway',    'def': 'Time before a company runs out of money'},
    {'word': 'Margin',    'def': 'Difference between revenue and costs'},
  ],

  // ── MARKETING ────────────────────────────────────────────────────────────
  'Pitch Deck': [
    {'word': 'Elevator Pitch', 'def': 'Very short compelling summary of idea'},
    {'word': 'Value Prop',     'def': 'Unique benefit your product offers'},
    {'word': 'CTA',            'def': 'Call To Action, prompts the audience to act'},
    {'word': 'Traction',       'def': 'Evidence of growth or market progress'},
  ],
  'Brand Storytelling': [
    {'word': 'Narrative',    'def': 'Story that connects brand to people'},
    {'word': 'USP',          'def': 'Unique Selling Point of a product'},
    {'word': 'Tone of Voice','def': 'How a brand sounds in communications'},
    {'word': 'Brand Equity', 'def': 'Value built through brand recognition'},
  ],
  'Social Media Copy': [
    {'word': 'Engagement', 'def': 'Likes, comments, shares on a post'},
    {'word': 'Reach',      'def': 'Number of people who saw the content'},
    {'word': 'Conversion', 'def': 'When a viewer becomes a customer'},
    {'word': 'Hashtag',    'def': 'Tag used to categorize social content'},
  ],
  'Campaign Brief': [
    {'word': 'Brief',           'def': 'Document outlining campaign goals'},
    {'word': 'Target Audience', 'def': 'Group the campaign is aimed at'},
    {'word': 'Deliverable',     'def': 'Output expected from the campaign'},
    {'word': 'KPI',             'def': 'Metric to measure campaign success'},
  ],

  // ── TECH & IT ────────────────────────────────────────────────────────────
  'Agile Meetings': [
    {'word': 'Sprint',    'def': 'Short fixed work cycle (1-2 weeks)'},
    {'word': 'Stand-up',  'def': 'Daily brief team status meeting'},
    {'word': 'Backlog',   'def': 'List of tasks yet to be completed'},
    {'word': 'Velocity',  'def': 'Speed of work completed each sprint'},
  ],
  'Technical Writing': [
    {'word': 'Documentation', 'def': 'Written instructions for a system'},
    {'word': 'API',           'def': 'Interface for software to communicate'},
    {'word': 'README',        'def': 'First file explaining a code project'},
    {'word': 'User Story',    'def': 'Feature described from the user\'s view'},
  ],
  'Code Review Comms': [
    {'word': 'PR',             'def': 'Pull Request, propose code changes'},
    {'word': 'LGTM',           'def': 'Looks Good To Me, approval signal'},
    {'word': 'Refactor',       'def': 'Improve code without changing behavior'},
    {'word': 'Merge Conflict', 'def': 'Clash when two code changes overlap'},
  ],
  'Product Pitch': [
    {'word': 'MVP',      'def': 'Minimum Viable Product, simplest working version'},
    {'word': 'Roadmap',  'def': 'Plan showing future product features'},
    {'word': 'Adoption', 'def': 'Rate at which users take up a product'},
    {'word': 'Scalable', 'def': 'Can grow without losing performance'},
  ],

  // ── LEGAL ────────────────────────────────────────────────────────────────
  'Contract Language': [
    {'word': 'Clause',     'def': 'Specific section within a contract'},
    {'word': 'Liability',  'def': 'Legal responsibility for something'},
    {'word': 'Indemnify',  'def': 'Protect another party from legal costs'},
    {'word': 'Breach',     'def': 'Failure to honour a contract term'},
  ],
  'GDPR Basics': [
    {'word': 'Data Subject',   'def': 'Person whose data is being processed'},
    {'word': 'Consent',        'def': 'Permission given to use personal data'},
    {'word': 'Right to Access','def': 'Right to see your stored data'},
    {'word': 'DPA',            'def': 'Data Protection Agreement between parties'},
  ],
  'Legal Emails': [
    {'word': 'Without Prejudice', 'def': 'Offer can\'t be used as evidence in court'},
    {'word': 'As Per',            'def': 'According to a stated document or term'},
    {'word': 'Pursuant to',       'def': 'In accordance with a rule or law'},
    {'word': 'Hereby',            'def': 'By this document or statement'},
  ],
  'NDAs': [
    {'word': 'NDA',          'def': 'Non-Disclosure Agreement, keeps info secret'},
    {'word': 'Confidential', 'def': 'Information that must be kept private'},
    {'word': 'Trade Secret',  'def': 'Business info kept secret for advantage'},
    {'word': 'Injunction',   'def': 'Court order to stop a specific action'},
  ],
};

// Fallback pairs if a lesson name isn't in the map
const List<Map<String, String>> fallbackVocab = [
  {'word': 'Synergy',      'def': 'Combined effort greater than the sum of parts'},
  {'word': 'Pivot',        'def': 'Shift in strategy or business direction'},
  {'word': 'Bandwidth',    'def': 'Capacity to take on more work'},
  {'word': 'Circle Back',  'def': 'Revisit a topic at a later time'},
];
