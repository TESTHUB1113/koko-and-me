// ─── WORD CRAFT DATA ──────────────────────────────────────────────────────────
// Infinite-Craft-style combo trees for each department.
// Structure: seeds include the dept name → L1 combos build common concepts →
// L2 builds dept-specific concepts → L3 unlocks the real lesson vocabulary.
// Multiple paths lead to the same vocab word so it feels like discovery.

class WcSeed {
  final String label, icon;
  const WcSeed(this.label, this.icon);
}

class WcCombo {
  final String k1, k2, result, icon, def;
  const WcCombo(this.k1, this.k2, this.result, this.icon, this.def);
}

class WcDeptData {
  final List<WcSeed> seeds;
  final List<WcCombo> combos;
  final int targetCount;
  const WcDeptData({required this.seeds, required this.combos, this.targetCount = 5});
}

class WordCraftData {
  static WcDeptData getData(String deptId) => switch (deptId) {
    'rh'        => _hr,
    'finance'   => _finance,
    'marketing' => _marketing,
    'tech'      => _tech,
    'legal'     => _legal,
    _           => _management,
  };

  // ── MANAGEMENT ────────────────────────────────────────────────────────────────
  // Vocab targets: OKR, KPI, Stakeholder Alignment, Board Narrative, Headcount
  static const _management = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',      '👤'),
      WcSeed('Management', '🎯'),
      WcSeed('Company',    '🏢'),
      WcSeed('Goal',       '🏆'),
      WcSeed('Plan',       '📋'),
      WcSeed('Time',       '⏰'),
    ],
    combos: [
      // ── Level 1: primitives → common business concepts
      WcCombo('Human',      'Management', 'Manager',     '👔', 'A human who practises management = manager.'),
      WcCombo('Human',      'Company',    'Employee',    '💼', 'A human who works for a company.'),
      WcCombo('Human',      'Goal',       'Ambition',    '💪', 'A human with a clear goal becomes ambitious.'),
      WcCombo('Human',      'Human',      'Team',        '👥', 'Two humans with a shared purpose form a team.'),
      WcCombo('Human',      'Plan',       'Role',        '📌', 'A human assigned to a plan = role.'),
      WcCombo('Management', 'Company',    'Strategy',    '♟️', 'Management applied to a whole company = strategy.'),
      WcCombo('Management', 'Goal',       'Objective',   '🎯', 'A management-grade goal = objective.'),
      WcCombo('Management', 'Plan',       'Roadmap',     '🗺️', 'Management turning a plan into a roadmap.'),
      WcCombo('Management', 'Time',       'Meeting',     '🤝', 'Management coordinating over time = meeting.'),
      WcCombo('Company',    'Goal',       'Mission',     '🧭', 'What a company exists to achieve = mission.'),
      WcCombo('Company',    'Plan',       'Budget',      '💰', 'A company allocating its plan to money = budget.'),
      WcCombo('Company',    'Time',       'Growth',      '📈', 'A company measured over time = growth.'),
      WcCombo('Goal',       'Time',       'Deadline',    '⏱️', 'A goal with a time attached = deadline.'),
      WcCombo('Goal',       'Plan',       'Milestone',   '🏁', 'A goal inside a plan = milestone.'),
      WcCombo('Plan',       'Time',       'Forecast',    '🔮', 'A plan extended into the future = forecast.'),

      // ── Level 2: intermediates → dept-specific concepts
      WcCombo('Team',       'Goal',       'OKR',         '🎯', 'A team aligned around goals = Objectives & Key Results framework.'),
      WcCombo('Objective',  'Goal',       'OKR',         '🎯', 'Objectives + measurable Key Results = OKR.'),
      WcCombo('Team',       'Meeting',    'Alignment',   '🤝', 'A team that meets with purpose = aligned team.'),
      WcCombo('Team',       'Plan',       'Headcount',   '👥', 'Planning exactly how many humans a team needs = headcount.'),
      WcCombo('Team',       'Company',    'Department',  '🏢', 'A team formalised inside a company = department.'),
      WcCombo('Manager',    'Team',       'Leadership',  '👑', 'A manager who guides a team = leadership.'),
      WcCombo('Manager',    'Company',    'Executive',   '🏛️', 'A manager elevated to company level = executive.'),
      WcCombo('Objective',  'Time',       'KPI',         '📊', 'An objective tracked over time = Key Performance Indicator.'),
      WcCombo('Goal',       'Meeting',    'KPI',         '📊', 'A goal reviewed in every meeting = KPI.'),
      WcCombo('Mission',    'Strategy',   'Board deck',  '🗂️', 'Mission + strategy packaged in slides = board deck.'),
      WcCombo('Strategy',   'Plan',       'Board deck',  '🗂️', 'A strategy turned into a presentable plan = board deck.'),
      WcCombo('Growth',     'Plan',       'Scaling',     '🚀', 'Planning for company growth = scaling strategy.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('Alignment',  'Strategy',   'Stakeholder Alignment', '🌐', 'Getting every decision-maker to agree before acting. The most underrated management skill.'),
      WcCombo('Team',       'Alignment',  'Stakeholder Alignment', '🌐', 'A fully aligned team = stakeholder alignment achieved.'),
      WcCombo('Board deck', 'Alignment',  'Pre-aligned Board Deck','✅', 'A deck where every stakeholder already said yes. No surprises. No drama.'),
      WcCombo('Board deck', 'Strategy',   'Board Narrative',       '📖', 'The story the board needs: where we are, where we\'re going, what we need.'),
      WcCombo('Headcount',  'Strategy',   'Hiring Plan',           '📋', 'Headcount decisions tied to strategy. Every FTE is a business argument.'),
      WcCombo('OKR',        'KPI',        'Performance Dashboard', '🖥️', 'OKRs set direction; KPIs track health. Together: a live performance dashboard.'),
      WcCombo('KPI',        'Goal',       'Metrics',               '📈', 'Goals measured with KPIs become the metrics that tell the true story.'),
      WcCombo('Leadership', 'Executive',  'C-Suite',               '🏛️', 'The top executives of a company = C-Suite.'),
    ],
  );

  // ── FINANCE ───────────────────────────────────────────────────────────────────
  // Vocab targets: EBITDA, ROI, P&L, Balance Sheet, Cash Flow
  static const _finance = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',   '👤'),
      WcSeed('Finance', '💹'),
      WcSeed('Money',   '💰'),
      WcSeed('Time',    '⏰'),
      WcSeed('Market',  '📊'),
      WcSeed('Company', '🏢'),
    ],
    combos: [
      // ── Level 1: primitives → common finance concepts
      WcCombo('Human',   'Finance',  'Analyst',        '📋', 'A human who works in finance = financial analyst.'),
      WcCombo('Human',   'Company',  'Employee',       '💼', 'A human hired by a company.'),
      WcCombo('Human',   'Money',    'Salary',         '💵', 'What a company pays a human each month.'),
      WcCombo('Finance', 'Company',  'CFO',            '👔', 'The human in charge of Finance at a company = Chief Financial Officer.'),
      WcCombo('Finance', 'Money',    'Fund',           '💰', 'Money structured under a finance vehicle = fund.'),
      WcCombo('Finance', 'Time',     'Fiscal Year',    '📅', 'The 12-month accounting cycle = fiscal year.'),
      WcCombo('Finance', 'Market',   'Portfolio',      '🗂️', 'Finance positions spread across markets = portfolio.'),
      WcCombo('Money',   'Company',  'Revenue',        '💰', 'The money a company brings in from its activity.'),
      WcCombo('Money',   'Money',    'Capital',        '💎', 'Accumulated money becomes capital.'),
      WcCombo('Money',   'Time',     'Interest',       '📈', 'Money left in time generates interest.'),
      WcCombo('Money',   'Market',   'Stock',          '📈', 'Money traded on a market = stock.'),
      WcCombo('Market',  'Time',     'Trend',          '📉', 'A market observed over time reveals a trend.'),
      WcCombo('Company', 'Time',     'Growth Rate',    '📈', 'How fast a company expands over time.'),
      WcCombo('Time',    'Money',    'Budget',         '📋', 'Money allocated across time = budget.'),

      // ── Level 2: dept-specific concepts
      WcCombo('Analyst', 'Finance',  'Financial Model','📊', 'An analyst building finance projections = financial model.'),
      WcCombo('Analyst', 'Time',     'Forecast',       '🔮', 'An analyst projecting revenue into the future = forecast.'),
      WcCombo('Employee','Time',     'Payroll',        '💰', 'All employees paid across a time cycle = payroll.'),
      WcCombo('CFO',     'Finance',  'Balance Sheet',  '📑', 'The CFO\'s core document: assets vs liabilities.'),
      WcCombo('CFO',     'Company',  'Board',          '🏛️', 'The CFO reporting to company leadership = the board.'),
      WcCombo('Fund',    'Market',   'Investment',     '📊', 'A fund deployed across the market = investment.'),
      WcCombo('Capital', 'Market',   'Investment',     '📊', 'Capital put to work in a market = investment.'),
      WcCombo('Capital', 'Time',     'Compound Interest','💫','Capital earning interest on its interest over time.'),
      WcCombo('Revenue', 'Finance',  'P&L',            '📑', 'Revenue tracked inside finance = Profit & Loss statement.'),
      WcCombo('Revenue', 'Company',  'P&L',            '📑', 'A company\'s revenue and costs on one page = P&L.'),
      WcCombo('Interest','Time',     'Debt',           '⛓️', 'Interest that keeps growing over time becomes debt.'),
      WcCombo('Stock',   'Time',     'Return',         '📈', 'A stock measured over time generates a return.'),
      WcCombo('Salary',  'Payroll',  'Operating Costs','🔩', 'All employee costs combined = operating costs.'),
      WcCombo('Trend',   'Finance',  'Cash Flow',      '💧', 'Money moving in and out as a trend over time.'),
      WcCombo('Forecast','Market',   'Cash Flow',      '💧', 'Forecasted money movement in and out = cash flow.'),
      WcCombo('Budget',  'Time',     'Cash Flow',      '💧', 'A budget tracked across time periods = cash flow.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('P&L',         'Time',      'EBITDA',        '📊', 'Earnings Before Interest, Taxes, Depreciation & Amortization. The purest measure of business health.'),
      WcCombo('Cash Flow',   'Finance',   'EBITDA',        '📊', 'Cash flow stripped of non-cash distortions = EBITDA.'),
      WcCombo('Balance Sheet','Finance',  'EBITDA',        '📊', 'What remains when you clean the balance sheet = EBITDA.'),
      WcCombo('Investment',  'Return',    'ROI',           '🎯', 'What you got back ÷ what you put in = Return on Investment.'),
      WcCombo('Capital',     'Return',    'ROI',           '🎯', 'Capital that generated a return = ROI.'),
      WcCombo('Operating Costs','Revenue','Gross Margin',  '💹', 'Revenue minus operating costs = gross margin.'),
      WcCombo('Board',       'Finance',   'Audit',         '🔍', 'The board examining the books = financial audit.'),
      WcCombo('Financial Model','Time',   'Valuation',     '💎', 'A financial model projected forward = company valuation.'),
    ],
  );

  // ── HR ────────────────────────────────────────────────────────────────────────
  // Vocab targets: Onboarding, Culture Fit, Performance Review, Benefits Package, Attrition
  static const _hr = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',   '👤'),
      WcSeed('HR',      '🤝'),
      WcSeed('Company', '🏢'),
      WcSeed('Law',     '⚖️'),
      WcSeed('Time',    '⏰'),
      WcSeed('Money',   '💰'),
    ],
    combos: [
      // ── Level 1: primitives → common HR concepts
      WcCombo('Human',   'HR',      'Candidate',   '🙋', 'A human being evaluated by HR = candidate.'),
      WcCombo('Human',   'Company', 'Employee',    '💼', 'A human who joins a company.'),
      WcCombo('Human',   'Law',     'Rights',      '⚖️', 'What a human is entitled to by law.'),
      WcCombo('Human',   'Money',   'Wage',        '💵', 'What a human earns for their work.'),
      WcCombo('Human',   'Human',   'Team',        '👥', 'Two or more humans working together.'),
      WcCombo('HR',      'Company', 'Department',  '🏢', 'HR formalised inside a company = HR department.'),
      WcCombo('HR',      'Law',     'Policy',      '📜', 'HR rules backed by law = company policy.'),
      WcCombo('HR',      'Time',    'Culture',     '🌱', 'HR practices built and observed over time = culture.'),
      WcCombo('HR',      'Money',   'Benefits',    '🎁', 'Non-salary perks managed by HR = benefits.'),
      WcCombo('Company', 'Law',     'Contract',    '📋', 'A company\'s legal agreement with an employee.'),
      WcCombo('Company', 'Time',    'Tenure',      '⏳', 'How long a human has worked at a company.'),
      WcCombo('Law',     'Money',   'Tax',         '🏛️', 'A legal obligation to pay the government.'),
      WcCombo('Money',   'Time',    'Payroll',     '💰', 'All wages paid across a time cycle = payroll.'),

      // ── Level 2: dept-specific concepts
      WcCombo('Candidate','HR',     'Interview',   '🤝', 'HR evaluating a candidate face-to-face = interview.'),
      WcCombo('Interview','Company','Hire',        '🔑', 'A successful interview ends in a hire.'),
      WcCombo('Hire',    'Company', 'Onboarding',  '🚀', 'The structured welcome of a new hire into the company.'),
      WcCombo('Hire',    'HR',      'Onboarding',  '🚀', 'HR guiding a new hire through their first weeks.'),
      WcCombo('Employee','Money',   'Salary',      '💵', 'The fixed monthly pay of an employee.'),
      WcCombo('Employee','Law',     'Employment Contract','📋','Legal document binding employee and employer.'),
      WcCombo('Employee','Time',    'Experience',  '🎓', 'Time spent in a role builds professional experience.'),
      WcCombo('Team',    'Culture', 'Culture Fit', '✨', 'When a human\'s values match the team\'s culture.'),
      WcCombo('Human',   'Culture', 'Culture Fit', '✨', 'Does this human belong here? That\'s culture fit.'),
      WcCombo('Team',    'HR',      'Org Chart',   '🏗️', 'The visual map of how a team is structured.'),
      WcCombo('Policy',  'Time',    'Compliance',  '✅', 'Following company policy consistently over time.'),
      WcCombo('Salary',  'Benefits','Compensation Package','💫','Total pay + perks = compensation package.'),
      WcCombo('Wage',    'Law',     'Minimum Wage','⚖️', 'The legal floor for how little a human can be paid.'),
      WcCombo('Experience','HR',    'Promotion',   '⬆️', 'HR recognising experience with a step up = promotion.'),
      WcCombo('Hire',    'Time',    'Headcount',   '👥', 'The total count of hired humans at a given moment.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('Compensation Package','Law',  'Benefits Package',     '🎁', 'A salary + perks package protected and structured by law.'),
      WcCombo('Salary',  'Contract',          'Benefits Package',     '🎁', 'What an employee earns + all the extra perks = benefits package.'),
      WcCombo('Employee','HR',                'Performance Review',   '📊', 'HR\'s formal evaluation of an employee\'s contribution.'),
      WcCombo('Employee','Time',              'Attrition',            '📉', 'The rate at which employees leave the company over time.'),
      WcCombo('Team',    'Time',              'Attrition',            '📉', 'Team members lost over time = attrition.'),
      WcCombo('Onboarding','Culture',         'Employee Experience',  '🌈', 'The full journey from hire to thriving team member.'),
      WcCombo('Org Chart','Time',             'Succession Planning',  '♟️', 'Who takes over each role when someone leaves.'),
      WcCombo('Culture Fit','Interview',      'Talent Acquisition',   '🎯', 'Systematically finding humans who match the culture.'),
    ],
  );

  // ── MARKETING ─────────────────────────────────────────────────────────────────
  // Vocab targets: Brand Equity, Customer Journey, Conversion Rate, A/B Testing, KPI
  static const _marketing = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',     '👤'),
      WcSeed('Brand',     '✨'),
      WcSeed('Message',   '💬'),
      WcSeed('Market',    '📊'),
      WcSeed('Money',     '💰'),
      WcSeed('Data',      '📈'),
    ],
    combos: [
      // ── Level 1: primitives → common marketing concepts
      WcCombo('Human',   'Brand',   'Customer',       '🛍️', 'A human who buys from a brand = customer.'),
      WcCombo('Human',   'Message', 'Audience',       '🎯', 'The humans who receive your message = audience.'),
      WcCombo('Human',   'Market',  'Consumer',       '🛒', 'A human making choices in a market = consumer.'),
      WcCombo('Human',   'Data',    'User',           '🖱️', 'A human whose behaviour we track = user.'),
      WcCombo('Brand',   'Message', 'Ad',             '📢', 'A brand\'s message placed in public = advertisement.'),
      WcCombo('Brand',   'Market',  'Positioning',    '♟️', 'Where a brand sits relative to competitors.'),
      WcCombo('Brand',   'Time',    'Reputation',     '🏆', 'A brand\'s perception built over time = reputation.'),
      WcCombo('Message', 'Money',   'Paid Ad',        '💸', 'Paying to distribute your message = paid advertising.'),
      WcCombo('Message', 'Data',    'Campaign',       '📣', 'A message backed and measured by data = campaign.'),
      WcCombo('Market',  'Data',    'Analytics',      '📊', 'Measuring what happens in a market = analytics.'),
      WcCombo('Market',  'Money',   'Budget',         '💰', 'Money allocated to reach a market.'),
      WcCombo('Money',   'Data',    'ROI',            '🎯', 'Money in vs value out = Return on Investment.'),
      WcCombo('Data',    'Time',    'Trend',          '📉', 'Data observed over time reveals a trend.'),

      // ── Level 2: dept-specific concepts
      WcCombo('Customer','Brand',   'Loyalty',        '❤️', 'A customer who keeps returning to the same brand.'),
      WcCombo('Customer','Data',    'Persona',        '🎭', 'A data-built portrait of the ideal customer = persona.'),
      WcCombo('Customer','Message', 'Customer Journey','🗺️','Every touchpoint between a customer and your brand.'),
      WcCombo('Customer','Time',    'Customer Journey','🗺️','The path a customer travels from awareness to purchase.'),
      WcCombo('Audience','Campaign','Reach',          '📡', 'How many in your audience your campaign actually touches.'),
      WcCombo('Ad',      'Data',    'A/B Testing',    '🧪', 'Testing two versions of an ad to see which performs better.'),
      WcCombo('Campaign','Data',    'A/B Testing',    '🧪', 'Running two campaign variants simultaneously = A/B test.'),
      WcCombo('Ad',      'Money',   'Paid Media',     '💸', 'Paid placements spread across media channels.'),
      WcCombo('Campaign','Data',    'Conversion Rate','🔄', 'The % of audience who took the action you wanted.'),
      WcCombo('Audience','Data',    'Conversion Rate','🔄', 'How many of your audience converted to customers.'),
      WcCombo('Reputation','Time',  'Brand Equity',   '💎', 'A brand\'s reputation compounded over time = brand equity.'),
      WcCombo('Positioning','Brand','Brand Equity',   '💎', 'A strong brand position held over time = brand equity.'),
      WcCombo('Analytics','Money',  'ROI',            '🎯', 'What your analytics reveal about your marketing spend.'),
      WcCombo('Paid Ad', 'Analytics','CPC',           '💲', 'Cost Per Click, the atomic unit of paid advertising.'),
      WcCombo('Persona', 'Market',  'Segmentation',   '🗂️', 'Dividing the market into persona groups = segmentation.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('Conversion Rate','Data','KPI',         '📊', 'A conversion rate tracked as an official success metric = KPI.'),
      WcCombo('ROI',     'Data',       'KPI',         '📊', 'An ROI target tracked in every reporting cycle = KPI.'),
      WcCombo('Customer Journey','Brand','Funnel',    '🔻', 'The journey from first touch to purchase = conversion funnel.'),
      WcCombo('Loyalty', 'Campaign',   'Retention',  '🔒', 'Targeted campaigns that keep customers loyal = retention.'),
      WcCombo('A/B Testing','Campaign','Growth Hacking','🚀','Rapid experimentation to find what grows fastest.'),
      WcCombo('Segmentation','Analytics','Target Audience','🎯','Analytics applied to segments = precisely defined target audience.'),
      WcCombo('Funnel',  'Data',       'Attribution', '🔍', 'Knowing exactly which funnel step drove the conversion.'),
      WcCombo('Brand Equity','Market', 'Market Share','📊', 'Brand equity expressed as a % of the total market.'),
    ],
  );

  // ── TECH ──────────────────────────────────────────────────────────────────────
  // Vocab targets: Sprint, Agile, Technical Debt, Deployment, Architecture
  static const _tech = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',  '👤'),
      WcSeed('Code',   '💻'),
      WcSeed('Bug',    '🐛'),
      WcSeed('Data',   '📊'),
      WcSeed('Time',   '⏰'),
      WcSeed('Server', '🖥️'),
    ],
    combos: [
      // ── Level 1: primitives → common tech concepts
      WcCombo('Human',  'Code',    'Developer',      '👨‍💻', 'A human who writes code = software developer.'),
      WcCombo('Human',  'Data',    'Data Analyst',   '📋', 'A human who interprets data for decisions.'),
      WcCombo('Human',  'Server',  'DevOps',         '⚙️', 'A human who manages servers and pipelines = DevOps.'),
      WcCombo('Human',  'Human',   'Team',           '👥', 'Developers working toward a shared goal = engineering team.'),
      WcCombo('Code',   'Time',    'Feature',        '✨', 'Code written and completed over time = product feature.'),
      WcCombo('Code',   'Bug',     'Debug',          '🔍', 'The process of hunting and fixing a bug in code.'),
      WcCombo('Code',   'Data',    'Algorithm',      '🧮', 'Code designed to process and transform data = algorithm.'),
      WcCombo('Code',   'Server',  'Backend',        '⚙️', 'Code that runs on a server, not a screen = backend.'),
      WcCombo('Bug',    'Time',    'Technical Debt', '⛓️', 'Bugs and shortcuts left unfixed accumulate as technical debt.'),
      WcCombo('Bug',    'Code',    'Patch',          '🩹', 'A small targeted code fix for a specific bug.'),
      WcCombo('Data',   'Server',  'Database',       '🗄️', 'Data stored and managed on a server = database.'),
      WcCombo('Data',   'Time',    'Log',            '📝', 'Data recorded moment by moment over time = log.'),
      WcCombo('Server', 'Time',    'Uptime',         '✅', 'How long a server stays running without failing = uptime.'),

      // ── Level 2: dept-specific concepts
      WcCombo('Developer','Time',  'Senior Dev',     '🎓', 'A developer forged through years of experience.'),
      WcCombo('Developer','Developer','Squad',       '👥', 'A small focused cluster of developers = squad.'),
      WcCombo('Feature', 'Time',   'Sprint',         '🏃', 'A fixed time box dedicated to building features = sprint.'),
      WcCombo('Feature', 'Team',   'Sprint',         '🏃', 'A team committing to build a set of features = sprint.'),
      WcCombo('Sprint',  'Team',   'Agile',          '⚡', 'Sprints run by a self-organising team = Agile methodology.'),
      WcCombo('Sprint',  'Time',   'Agile',          '⚡', 'Regular sprints repeated over time = Agile rhythm.'),
      WcCombo('Debug',   'Time',   'Refactoring',    '🔧', 'Improving code structure after fixing bugs = refactoring.'),
      WcCombo('Algorithm','Data',  'Machine Learning','🤖','An algorithm that improves itself by learning from data.'),
      WcCombo('Technical Debt','Code','Legacy Code', '👴', 'Code kept alive only by technical debt = legacy code.'),
      WcCombo('Backend', 'Code',   'API',            '🔌', 'Backend code exposed so other systems can talk to it = API.'),
      WcCombo('Database','Code',   'Query',          '🔍', 'Code that asks a question to a database = query.'),
      WcCombo('Database','API',    'Microservice',   '🔧', 'A small service built around a single database = microservice.'),
      WcCombo('Uptime',  'Server', 'SLA',            '📊', 'An uptime guarantee written into a contract = SLA.'),
      WcCombo('Log',     'Data',   'Monitoring',     '👁️', 'Watching logs and data flow in real time = monitoring.'),
      WcCombo('Feature', 'Server', 'Deployment',     '🚀', 'Shipping a finished feature to the live server = deployment.'),
      WcCombo('Code',    'Server', 'Deployment',     '🚀', 'Sending code from developer machines to production servers.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('Sprint',  'Agile',  'Scrum',          '📋', 'Agile with daily standups and sprint reviews = Scrum framework.'),
      WcCombo('Sprint',  'Data',   'Backlog',        '📝', 'All the features and fixes not yet in a sprint = backlog.'),
      WcCombo('Deployment','Time', 'CI/CD',          '🔄', 'Automated continuous integration and deployment = CI/CD pipeline.'),
      WcCombo('API',     'Server', 'Architecture',   '🏗️', 'How APIs, servers, and databases connect = system architecture.'),
      WcCombo('Microservice','Architecture','Distributed System','🌐','Multiple microservices talking to each other at scale.'),
      WcCombo('Machine Learning','Server','AI Model','🤖', 'A machine learning model deployed on a server = AI model in production.'),
      WcCombo('Refactoring','Technical Debt','Clean Code','✨','Eliminating technical debt through disciplined refactoring.'),
      WcCombo('Monitoring','SLA', 'Incident',        '🚨', 'Monitoring that catches an SLA breach in real time = incident.'),
    ],
  );

  // ── LEGAL ─────────────────────────────────────────────────────────────────────
  // Vocab targets: NDA, Due Diligence, Compliance, Liability, M&A
  static const _legal = WcDeptData(
    targetCount: 5,
    seeds: [
      WcSeed('Human',   '👤'),
      WcSeed('Law',     '⚖️'),
      WcSeed('Company', '🏢'),
      WcSeed('Money',   '💰'),
      WcSeed('Paper',   '📄'),
      WcSeed('Time',    '⏰'),
    ],
    combos: [
      // ── Level 1: primitives → common legal concepts
      WcCombo('Human',   'Law',     'Lawyer',         '⚖️', 'A human who practises law professionally = lawyer.'),
      WcCombo('Human',   'Company', 'Client',         '🤝', 'A human who hires a company for services = client.'),
      WcCombo('Human',   'Paper',   'Signatory',      '✍️', 'A human authorised to sign legal documents.'),
      WcCombo('Human',   'Money',   'Debtor',         '💸', 'A human who legally owes money = debtor.'),
      WcCombo('Law',     'Company', 'Corporate Law',  '🏛️', 'The body of law governing company operations.'),
      WcCombo('Law',     'Paper',   'Contract',       '📋', 'A paper the law will enforce = contract.'),
      WcCombo('Law',     'Money',   'Liability',      '⚠️', 'Who owes what if things go wrong = liability.'),
      WcCombo('Law',     'Time',    'Statute',        '⏳', 'A law written to stand through time = statute.'),
      WcCombo('Company', 'Paper',   'Filing',         '📄', 'A company\'s official document submitted to authorities.'),
      WcCombo('Company', 'Money',   'Shareholder',    '👔', 'A human who legally owns part of a company.'),
      WcCombo('Paper',   'Money',   'Invoice',        '🧾', 'A paper legally requesting payment = invoice.'),
      WcCombo('Paper',   'Time',    'Deadline',       '⏱️', 'A legal document with a binding time limit.'),
      WcCombo('Money',   'Time',    'Interest',       '📈', 'Money that grows over time under a legal obligation.'),

      // ── Level 2: dept-specific concepts
      WcCombo('Lawyer',  'Company', 'Legal Counsel',  '⚖️', 'A lawyer embedded in a company = General Counsel.'),
      WcCombo('Lawyer',  'Paper',   'Legal Opinion',  '📝', 'A lawyer\'s formal written assessment of a legal question.'),
      WcCombo('Client',  'Law',     'Representation', '🤝', 'A lawyer standing for a client before the law.'),
      WcCombo('Contract','Human',   'NDA',            '🤫', 'A contract that legally binds someone to silence = Non-Disclosure Agreement.'),
      WcCombo('Contract','Company', 'NDA',            '🤫', 'A company protecting its secrets through a contract = NDA.'),
      WcCombo('Contract','Money',   'Liability Clause','⚠️','A contract clause defining who pays when things break.'),
      WcCombo('Contract','Time',    'Term',           '📅', 'The duration for which a contract is legally valid.'),
      WcCombo('Liability','Law',    'Indemnity',      '🛡️', 'Legal protection against liability written into a contract.'),
      WcCombo('Corporate Law','Paper','Articles',     '📜', 'The founding legal documents of a company.'),
      WcCombo('Filing',  'Law',     'Compliance',     '✅', 'Filing the right documents consistently = compliance.'),
      WcCombo('Law',     'Company', 'Compliance',     '✅', 'A company following every applicable law = compliance.'),
      WcCombo('Statute', 'Company', 'Jurisdiction',   '🏛️', 'The legal territory where a statute applies to a company.'),
      WcCombo('Shareholder','Law',  'Equity Rights',  '⚖️', 'What a shareholder is legally entitled to = equity rights.'),
      WcCombo('Term',    'Contract','Non-compete',    '🚫', 'A contract term preventing future competition.'),
      WcCombo('Interest','Law',     'Debt',           '⛓️', 'Interest backed by legal obligation = debt.'),

      // ── Level 3: key lesson vocabulary
      WcCombo('NDA',     'Contract','Term Sheet',     '📑', 'The preliminary summary of a deal\'s key terms.'),
      WcCombo('Term Sheet','Law',   'Due Diligence',  '🔍', 'A thorough legal and financial check before signing = due diligence.'),
      WcCombo('Contract','Filing',  'Due Diligence',  '🔍', 'Reviewing all contracts and filings before a deal = due diligence.'),
      WcCombo('Due Diligence','Company','M&A',        '🤝', 'Due diligence on a company\'s books = the start of M&A.'),
      WcCombo('Term Sheet','Company','M&A',           '🤝', 'A term sheet for buying a company = M&A transaction.'),
      WcCombo('Indemnity','Contract','IP Rights',     '💡', 'Intellectual property protected by contract indemnity = IP rights.'),
      WcCombo('Equity Rights','Law','Cap Table',      '📊', 'A legal table showing who owns what % of a company.'),
      WcCombo('Non-compete','NDA', 'Restrictive Covenant','📜','A contract restricting future employment or competition.'),
    ],
  );
}
