import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:barscan_app/app/barscan_app.dart';

void main() {
  testWidgets('login screen is shown first', (WidgetTester tester) async {
    await tester.pumpWidget(const BarscanApp());

    expect(find.image(const AssetImage('assets/branding/app_icon.png')), findsOneWidget);
    expect(find.text('Sign in to begin a store segment scan.'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('login requires credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const BarscanApp());

    await tester.tap(find.text('Log in'));
    await tester.pump();

    expect(find.text('Required'), findsNWidgets(2));
  });
}
