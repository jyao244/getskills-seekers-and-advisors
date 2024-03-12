import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:SeekersAndAdvisors/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Testing Seeker View Workflow', () {
    testWidgets('Test seeker view', (tester) async {
      app.main();

      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));

      expect(find.text('Login'), findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey('email_text_field')),
          'test3@test.com.ac.nz');
      await Future.delayed(const Duration(seconds: 1));
      await tester.enterText(
          find.byKey(const ValueKey('password_text_field')), '123123');
      await Future.delayed(const Duration(seconds: 1));
      await tester.tap(find.byKey(const ValueKey('login_button')));

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      expect(find.text('Favorite'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('avatar')));

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      expect(find.text('Bio'), findsOneWidget);

      await tester.pageBack();

      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      expect(find.text('Favorite'), findsOneWidget);
    });
  });
}
