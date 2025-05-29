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

  testWidgets('Add a new project to the profile', (WidgetTester tester) async {
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
    
    // Go to Edit Projects page
    final projectsEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Projects'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(projectsEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter project details
    await tester.enterText(find.byType(TextField).at(0), 'Test Project'); // project title
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK')); // letting it default to today's date
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(3), 'A project from integration test'); // project description
    await tester.pumpAndSettle();

    // Adding the project
    final addProjectButton = find.widgetWithText(ElevatedButton, 'Add new project!');
    await tester.tap(addProjectButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm project appears
    expect(find.text('Test Project'), findsWidgets);
  });

  testWidgets('Edit an existing project', (WidgetTester tester) async {
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

    // Long press the project card to open Edit Project page
    final projectCardFinder = find.text('Test Project').first;
    await tester.ensureVisible(projectCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(projectCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Modify the name and description
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Project Title');
    await tester.enterText(find.byType(TextField).at(3), 'Edited test project description');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final endorsedButton = find.text("Confirm changes?");
    await tester.tap(endorsedButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Projects section
    await tester.ensureVisible(find.text('Edited Test Project Title'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Project Title'), findsWidgets);
  });

  testWidgets('Delete an existing project', (WidgetTester tester) async {
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

    // Long press the project card to open Edit Project page
    final projectCardFinder = find.text('Edited Test Project Title').first;
    await tester.ensureVisible(projectCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(projectCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    final confirmDeleteButton = find.widgetWithText(ElevatedButton, 'Delete');
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the project no longer exists in the Projects section
    expect(find.text('Edited Test Project Title'), findsNothing);
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