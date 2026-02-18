// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:loan_app_mobile/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CMOLoanApp());
    // Verify the app renders without crashing
    expect(find.byType(CMOLoanApp), findsOneWidget);
  });
}
