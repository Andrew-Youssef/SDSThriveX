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

  testWidgets('Add a new Skill or Strength to the profile', (WidgetTester tester) async {
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
    await tester.ensureVisible(find.text('Skills & Strengths'));
    await tester.pumpAndSettle();
    
    // Go to Edit Skills and Strengths page
    final skillsEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('Skills & Strengths'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(skillsEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter skill details
    await tester.enterText(find.byType(TextField).at(0), 'Test Skill name'); // skill / strength name
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test where I got my skill'); // skill / strength location of attainment
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(2), 'Test skill description'); // skill / strength description
    await tester.pumpAndSettle();

    // Adding the skill
    final addSkillButton = find.widgetWithText(ElevatedButton, 'Add new skill/strength!');
    await tester.tap(addSkillButton);
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Confirm skill appears
    expect(find.text('Test Skill name'), findsWidgets);
  });

  testWidgets('Edit an existing Skill or Strength', (WidgetTester tester) async {
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

    // Long press the skill card to open Edit Skill or Strength page
    final skillCardFinder = find.text('Test Skill name').first;
    await tester.ensureVisible(skillCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(skillCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Modify the name and description
    await tester.enterText(find.byType(TextField).at(0), 'Edited Test Skill name');
    await tester.enterText(find.byType(TextField).at(2), 'Edited test skill description');
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Confirm Details button
    final confirmButton = find.text("Confirm changes?");
    await tester.tap(confirmButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile page
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm the updates appear in the Skills & Strengths section
    await tester.ensureVisible(find.text('Edited Test Skill name'));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    expect(find.text('Edited Test Skill name'), findsWidgets);
  });

  testWidgets('Delete an Skill or Strength', (WidgetTester tester) async {
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

    // Long press the skill card to open Edit Skill or Strength page
    final skillCardFinder = find.text('Edited Test Skill name').first;
    await tester.ensureVisible(skillCardFinder);
    await tester.pumpAndSettle();
    await tester.longPress(skillCardFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Press bin button
    final binButton = find.byIcon(Icons.delete);
    await tester.tap(binButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Press confirm delete button
    final confirmDeleteButton = find.widgetWithText(ElevatedButton, 'Delete');
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm that the skill no longer exists in the Skills & Strengths section
    expect(find.text('Edited Test Skill name'), findsNothing);
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