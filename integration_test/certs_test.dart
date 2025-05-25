import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';

import 'package:thrivex/main.dart' as app;
import 'package:thrivex/core/services/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Add a new Certificate or Degree to the profile', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Login
    await tester.enterText(find.byType(TextFormField).first, 'AndrewTest1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'Andrew1!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go to Profile page
    final profileTabFinder = find.byIcon(Icons.person_outlined);
    await tester.pumpUntilFound(profileTabFinder, const Duration(seconds: 10));
    await tester.tap(profileTabFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tester.ensureVisible(find.text('Certificate & Degrees')); // NEEDS TO CHANGE (needs to be plural) ------------------------------------------------------------------------------------------------
    await tester.pumpAndSettle();
    
    // Go to Edit Certificates and Degrees page
    final certsEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Certificate & Degrees'), // NEEDS TO CHANGE  (needs to be plural) ------------------------------------------------------------------------------------------------
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(certsEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter Certificate details
    await tester.enterText(find.byType(TextField).at(0), 'Test Certificate Institute'); // certificate institute
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test Certificate Name'); // certificate title
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.calendar_today).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.calendar_today).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(4), 'A description of the Certificate'); // story description
    await tester.pumpAndSettle();

    // Adding the certificate
    await tester.tap(find.byIcon(Icons.add_box));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm certificate appears
    expect(find.text('Test Certificate Institute'), findsWidgets);
    expect(find.text('A description of the Certificate'), findsWidgets);
  });
}

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpUntilFound(Finder finder, Duration timeout) async {
    final endTime = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(endTime)) {
      await pump(const Duration(milliseconds: 100));
      if (any(finder)) return;
    }
    throw Exception('Timeout waiting for ${finder.description}');
  }
}