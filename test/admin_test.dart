import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:SeekersAndAdvisors/main_admin.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Testing Admin Page Work Flow', () {
    testWidgets('Find Administration Title', (tester) async {
      app.main();

      await Future.delayed(Duration(seconds: 15));

      await tester.pumpAndSettle();

      await Future.delayed(Duration(seconds: 15));

      expect(find.text('Administration'), findsOneWidget);

      expect(find.byKey(ValueKey('card')), findsAtLeastNWidgets(1));

      expect(find.text('leontest1'), findsOneWidget);

      await Future.delayed(Duration(seconds: 5));

      // // Verify the counter starts at 0.
      // expect(find.text('0'), findsOneWidget);

      // // Finds the floating action button to tap on.
      // final Finder fab = find.byTooltip('Increment');

      // // Emulate a tap on the floating action button.
      // await tester.tap(fab);

      // // Trigger a frame.
      // await tester.pumpAndSettle();

      // // Verify the counter increments by 1.
      // expect(find.text('1'), findsOneWidget);
    });
  });
}
