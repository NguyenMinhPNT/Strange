import 'package:flutter_test/flutter_test.dart';

import 'package:strange/app/app.dart';

void main() {
  testWidgets('Strange app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StrangeApp());
  });
}
