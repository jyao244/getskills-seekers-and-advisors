import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:SeekersAndAdvisors/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Login page widgets', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    await Future.delayed(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 1));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Signup'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pump();
    await Future.delayed(const Duration(seconds: 1));

    expect(find.text('Please enter email and password'), findsOneWidget);
    expect(find.text('Email must be an university email'), findsNothing);
  });
}
