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

  testWidgets('Edit and revert user information', (WidgetTester tester) async {
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
    await tester.ensureVisible(find.text('About'));
    await tester.pumpAndSettle();
    
    // Go to About (User info) page
    final aboutEditButtonFinder = find.descendant(
      of: find.ancestor(
        of: find.text('About'),
        matching: find.byType(Row),
      ),
      matching: find.byIcon(Icons.edit),
    );

    await tester.tap(aboutEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter new user info
    await tester.enterText(find.byType(TextField).at(0), 'NOT Andrew Test (1)'); // user's name
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'A real account!'); // brief title
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(2), 'Definitely a real account!! *wink* *wink*'); // about section
    await tester.pumpAndSettle();

    // Adding the new user info
    final Finder updateButtonFinder = find.text('Update Details');
    await tester.tap(updateButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile screen
    final Finder backButtonFinder = find.byIcon(Icons.arrow_back);
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Scrolling to the top of the Profile screen
    final Finder profileScrollable = find.byType(Scrollable).first;
    await tester.fling(profileScrollable, const Offset(0, 5000.0), 10000.0); // Positive dy scrolls content down (view up)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Confirm user info has been edited
    expect(find.text('NOT Andrew Test (1)'), findsWidgets);
    expect(find.text('Definitely a real account!! *wink* *wink*'), findsWidgets);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    
    // Go to About (User info) page again
    await tester.ensureVisible(find.text('About'));
    await tester.pumpAndSettle();

    await tester.tap(aboutEditButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Enter original user info
    await tester.enterText(find.byType(TextField).at(0), 'Andrew Test (1)'); // user's name
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(1), 'Test Account'); // brief title
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(2), 'This is an account used for testing.'); // about section
    await tester.pumpAndSettle();

    // Adding the original user info
    await tester.tap(updateButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Go back to Profile screen
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Scrolling to the top of the Profile screen
    await tester.fling(profileScrollable, const Offset(0, 5000.0), 10000.0); // Positive dy scrolls content down (view up)
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Confirm user info has been reverted
    expect(find.text('Andrew Test (1)'), findsWidgets);
    expect(find.text('This is an account used for testing.'), findsWidgets);
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