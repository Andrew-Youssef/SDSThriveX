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

  testWidgets('Add a new Volunteering experience to the profile', (WidgetTester tester) async {
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
    await tester.ensureVisible(find.text('Volunteering Work'));
    await tester.pumpAndSettle();
    
    // Go to Edit Volunteering Work page
    final volunteeringEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Volunteering Work'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(volunteeringEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter Volunteering details
    await tester.enterText(find.byType(TextField).at(0), 'Test Volunteering Institute'); // volunteering institute
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test Volunteering Role'); // role
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(4), 'A description of the volunteering work'); // volunteering description
    await tester.pumpAndSettle();

    // Adding the volunteering work
    await tester.tap(find.text("Add new volunteering experience!"));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm volunteering work appears
    expect(find.text('Test Volunteering Institute'), findsWidgets);
  });

  testWidgets('Edit an existing Volunteering experience', (WidgetTester tester) async {
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

    // Long press the Volunteering card to open Edit Volunteering Work page
    final volunteeringCardFinder = find.text('Test Volunteering Institute').first;
    await tester.ensureVisible(volunteeringCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(volunteeringCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Modify the name of institute and description
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Volunteering Institute');
    await tester.enterText(find.byType(TextField).at(4), 'Edited test description of the volunteering work');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final confirmButton = find.text("Confirm changes?");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Volunteering Work section
    await tester.ensureVisible(find.text('Edited Test Volunteering Institute'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Volunteering Institute'), findsWidgets);
  });

  testWidgets('Delete an existing Volunteering experience', (WidgetTester tester) async {
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

    // Long press the Volunteering card to open Edit Volunteering Work page
    final volunteeringCardFinder = find.text('Edited Test Volunteering Institute').first;
    await tester.ensureVisible(volunteeringCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(volunteeringCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    await tester.tap(find.text("Delete"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the Volunteering experience no longer exists in the Volunteering Work section
    expect(find.text('Edited Test Volunteering Institute'), findsNothing);
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