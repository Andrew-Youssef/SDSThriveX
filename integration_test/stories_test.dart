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

  testWidgets('Add a new Personal Story to the profile', (WidgetTester tester) async {
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
    await tester.ensureVisible(find.text('Personal Stories'));
    await tester.pumpAndSettle();
    
    // Go to Edit Personal Stories page
    final storiesEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Personal Stories'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(storiesEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter story details
    await tester.enterText(find.byType(TextField).at(0), 'Test Personal Story'); // story title
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(2), 'A test story from integration test'); // story description
    await tester.pumpAndSettle();

    // Adding the story
    await tester.tap(find.text("Add new personal story!"));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm story appears
    expect(find.text('Test Personal Story'), findsWidgets);
  });

  testWidgets('Edit an existing Personal Story', (WidgetTester tester) async {
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

    // Long press the Personal Story card to open Edit Personal Story page
    final storyCardFinder = find.text('Test Personal Story').first;
    await tester.ensureVisible(storyCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(storyCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Modify the name and description
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Personal Story');
    await tester.enterText(find.byType(TextField).at(2), 'Edited test story from integration test');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final confirmButton = find.text("Confirm changes?");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Personal Stories section
    await tester.ensureVisible(find.text('Edited Test Personal Story'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Personal Story'), findsWidgets);
  });

  testWidgets('Delete an existing Personal Story', (WidgetTester tester) async {
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

    // Long press the Personal Story card to open Edit Personal Story page
    final storyCardFinder = find.text('Edited Test Personal Story').first;
    await tester.ensureVisible(storyCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(storyCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    // final confirmDeleteButton = find.widgetWithText(ElevatedButton, 'Delete');
    // await tester.tap(confirmDeleteButton);
    await tester.tap(find.text("Delete"));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the Personal Story no longer exists in the Personal Story section
    expect(find.text('Edited Test Personal Story'), findsNothing);
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