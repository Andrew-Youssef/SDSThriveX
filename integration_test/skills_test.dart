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
    await tester.tap(find.byIcon(Icons.add_box));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Confirm skill appears
    expect(find.text('Test Skill name'), findsWidgets);
    expect(find.text('Test skill description'), findsWidgets);
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