import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:barscan_app/features/auth/login_page.dart';
import 'package:barscan_app/i18n/language_controller.dart';

Widget loginTestApp() {
  return ChangeNotifierProvider<LanguageController>(
    create: (_) => LanguageController(),
    child: const MaterialApp(home: LoginPage()),
  );
}

void main() {
  testWidgets('login screen is shown first', (WidgetTester tester) async {
    await tester.pumpWidget(loginTestApp());
    await tester.pumpAndSettle();

    expect(find.image(const AssetImage('assets/branding/app_icon.png')), findsOneWidget);
    expect(find.text('Log ind for at starte en butikssegmentscanning.'), findsOneWidget);
    expect(find.text('Brugernavn'), findsOneWidget);
    expect(find.text('Adgangskode'), findsOneWidget);
    expect(find.text('Log ind'), findsOneWidget);
  });

  testWidgets('login requires credentials', (WidgetTester tester) async {
    await tester.pumpWidget(loginTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Log ind'));
    await tester.pump();

    expect(find.text('Påkrævet'), findsNWidgets(2));
  });

  testWidgets('login language can switch to English', (WidgetTester tester) async {
    await tester.pumpWidget(loginTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Skift til engelsk'));
    await tester.pump();

    expect(find.text('Sign in to begin a store segment scan.'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });
}
