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
    await tester.ensureVisible(find.text('Certificates & Degrees'));
    await tester.pumpAndSettle();
    
    // Go to Edit Certificates and Degrees page
    final certsEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Certificates & Degrees'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(certsEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter Certificate details
    await tester.enterText(find.byType(TextField).at(0), 'Test Certificate Name'); // certificate title
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test Certificate Institute'); // certificate institute
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(4), 'A description of the Certificate'); // cert description
    await tester.pumpAndSettle();

    // Adding the certificate
    final addCertButton = find.widgetWithText(ElevatedButton, 'Add new certificate/degree!');
    await tester.tap(addCertButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm certificate appears
    expect(find.text('Test Certificate Name'), findsWidgets);
  });

  testWidgets('Edit an existing Certificate or Degree', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 10));

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

    // Long press the certificate card to open Edit Certificate/Degree page
    final certCardFinder = find.text('Test Certificate Name').first;
    await tester.ensureVisible(certCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(certCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Modify the name and institute
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Certificate Name');
    await tester.enterText(find.byType(TextField).at(4), 'Edited test certificate description');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final confirmButton = find.text("Confirm changes?");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Certificates/Degrees section
    await tester.ensureVisible(find.text('Edited Test Certificate Name'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Certificate Name'), findsWidgets);
  });

  testWidgets('Delete an existing Certificate or Degree', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 10));

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

    // Long press the certificate card to open Edit Certificate/Degree page
    final certCardFinder = find.text('Edited Test Certificate Name').first;
    await tester.ensureVisible(certCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(certCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    final confirmDeleteButton = find.widgetWithText(ElevatedButton, 'Delete');
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the certificate no longer exists in the Certificates/Degrees section
    expect(find.text('Edited Test Certificate Name'), findsNothing);
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