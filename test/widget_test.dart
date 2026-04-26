import 'package:flutter_test/flutter_test.dart';

import 'package:my_portfolio/app.dart';

void main() {
  testWidgets('Portfolio app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const PortfolioApp());
    expect(find.text('Home Section'), findsOneWidget);
  });
}
