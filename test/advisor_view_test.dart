import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:SeekersAndAdvisors/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testing Advisor View Workflow', () {
    app.main();
    testWidgets('Test Log In and switch to advisor View', (tester) async {
      await Future.delayed(Duration(seconds: 5));

      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 5));

      expect(find.text('Login'), findsOneWidget);

      await tester.tap(find.byKey(ValueKey('switch_register')));

      await tester.pumpAndSettle();
      await Future.delayed(Duration(seconds: 5));

      expect(find.text('Signup'), findsOneWidget);

      await tester.scrollUntilVisible(
          find.text('Already Have an Account? Login'), 10);
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text('Already Have an Account? Login'));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(ValueKey('email_text_field')), 'test2@test.com');

      await Future.delayed(Duration(seconds: 1));

      await tester.enterText(
          find.byKey(ValueKey('password_text_field')), '123456');

      await tester.tap(find.byKey(ValueKey('login_button')));

      await Future.delayed(Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(find.text('Hello, Raymond'), findsOneWidget);

      await tester.tap(find.byKey(ValueKey('switch_advisor_view')));

      await Future.delayed(Duration(seconds: 5));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ValueKey('avatar')));

      await Future.delayed(Duration(seconds: 5));
      await tester.pumpAndSettle();

      tester.printToConsole('opening advisor profile page');

      await Future.delayed(Duration(seconds: 5));
    });
  });
}
