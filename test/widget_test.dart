import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cuanquest/main.dart';

void main() {
  testWidgets('CuanQuestApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CuanQuestApp()));
    expect(find.text('CuanQuest'), findsNothing); // router-driven UI
  });
}
