// ─── 4 PICS 1 WORD — DATA ─────────────────────────────────────────────────────
// Each entry: the target word (uppercase), its definition, and exactly 4 image
// asset paths. Images live in assets/images/four_pics/.

class FourPicsWord {
  final String word;
  final String hint;
  final List<String> images;
  const FourPicsWord(this.word, this.hint, this.images);
}

const List<FourPicsWord> fourPicsManagement = [
  FourPicsWord('AGENDA', 'List of topics to discuss in a meeting', [
    'assets/images/four_pics/agenda_1.jpg',
    'assets/images/four_pics/agenda_2.jpg',
    'assets/images/four_pics/agenda_3.jpg',
    'assets/images/four_pics/agenda_4.jpg',
  ]),
  FourPicsWord('MINUTES', 'Written record of what was said in a meeting', [
    'assets/images/four_pics/minutes_1.jpg',
    'assets/images/four_pics/minutes_2.jpg',
    'assets/images/four_pics/minutes_3.jpg',
    'assets/images/four_pics/minutes_4.jpg',
  ]),
  FourPicsWord('FORECAST', 'Prediction of future performance', [
    'assets/images/four_pics/forecast_1.jpg',
    'assets/images/four_pics/forecast_2.jpg',
    'assets/images/four_pics/forecast_3.jpg',
    'assets/images/four_pics/forecast_4.jpg',
  ]),
  FourPicsWord('LEVERAGE', 'Advantage used in a negotiation', [
    'assets/images/four_pics/leverage_1.jpg',
    'assets/images/four_pics/leverage_2.jpg',
    'assets/images/four_pics/leverage_3.jpg',
    'assets/images/four_pics/leverage_4.jpg',
  ]),
  FourPicsWord('DEADLOCK', 'Standstill where no progress is made', [
    'assets/images/four_pics/deadlock_1.jpg',
    'assets/images/four_pics/deadlock_2.jpg',
    'assets/images/four_pics/deadlock_3.jpg',
    'assets/images/four_pics/deadlock_4.jpg',
  ]),
  FourPicsWord('BENCHMARK', 'Standard used for comparison', [
    'assets/images/four_pics/benchmark_1.jpg',
    'assets/images/four_pics/benchmark_2.jpg',
    'assets/images/four_pics/benchmark_3.jpg',
    'assets/images/four_pics/benchmark_4.jpg',
  ]),
  FourPicsWord('BASELINE', 'Starting point used for comparison', [
    'assets/images/four_pics/baseline_1.jpg',
    'assets/images/four_pics/baseline_2.jpg',
    'assets/images/four_pics/baseline_3.jpg',
    'assets/images/four_pics/baseline_4.jpg',
  ]),
  FourPicsWord('CONCESSION', 'Something given up to reach a deal', [
    'assets/images/four_pics/concession_1.jpg',
    'assets/images/four_pics/concession_2.jpg',
    'assets/images/four_pics/concession_3.jpg',
    'assets/images/four_pics/concession_4.jpg',
  ]),
];
