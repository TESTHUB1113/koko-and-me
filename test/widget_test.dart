import 'package:flutter_test/flutter_test.dart';
import 'package:koko_and_me/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KokoMeApp());
    expect(find.text('WELCOME TO'), findsNothing); // loaded async
  });
}
