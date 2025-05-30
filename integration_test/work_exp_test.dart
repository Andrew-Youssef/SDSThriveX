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

  testWidgets('Add a new Work experience to the profile', (WidgetTester tester) async {
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
    await tester.ensureVisible(find.text('Work Experience'));
    await tester.pumpAndSettle();
    
    // Go to Edit Work Experience page
    final workEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Work Experience'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(workEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter Work Experience details
    await tester.enterText(find.byType(TextField).at(0), 'Test Workplace'); // workplace
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test Job Role'); // job role
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(4), 'A description of the job'); // job description
    await tester.pumpAndSettle();

    // Adding the work experience
    await tester.tap(find.text("Add new work experience!"));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm work experience appears
    expect(find.text('Test Workplace'), findsWidgets);
  });

  testWidgets('Edit an existing Work experience', (WidgetTester tester) async {
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

    // Long press the Work card to open Edit Work Experience page
    final workCardFinder = find.text('Test Workplace').first;
    await tester.ensureVisible(workCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(workCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Modify the name of institute and description
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Workplace');
    await tester.enterText(find.byType(TextField).at(4), 'Edited test description of the job');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final confirmButton = find.text("Confirm changes?");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Work Experiences section
    await tester.ensureVisible(find.text('Edited Test Workplace'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Workplace'), findsWidgets);
  });

  testWidgets('Delete an existing Work experience', (WidgetTester tester) async {
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

    // Long press the Work card to open Edit Work Experience page
    final workCardFinder = find.text('Edited Test Workplace').first;
    await tester.ensureVisible(workCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(workCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    await tester.tap(find.text("Delete"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the Work experience no longer exists in the Work Experiences section
    expect(find.text('Edited Test Workplace'), findsNothing);
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