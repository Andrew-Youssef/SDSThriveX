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

  testWidgets('Normal search to find a valid user', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Login
    await tester.enterText(find.byType(TextFormField).first, 'AndrewTest1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'Andrew1!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Go to Search page
    final searchBarFinder = find.widgetWithText(TextField, 'Search');
    await tester.tap(searchBarFinder);
    await tester.pumpAndSettle();

    // Entering the name of the user to search
    const targetName = 'Andrew';
    await tester.enterText(searchBarFinder, targetName);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Wait until the user appears in the list
    final userTileFinder = find.text("Andrew Youssef");
    await tester.pumpUntilFound(userTileFinder, const Duration(seconds: 4));

    // Tap on the user's list tile
    await tester.tap(userTileFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that we are on the correct profile screen by looking for a project that should be on Andrew's profile
    expect(find.text('BFC Playground'), findsWidgets);
  });

  testWidgets('Normal search to find an invalid user', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Login
    await tester.enterText(find.byType(TextFormField).first, 'AndrewTest1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'Andrew1!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Go to Search page
    final searchBarFinder = find.widgetWithText(TextField, 'Search');
    await tester.tap(searchBarFinder);
    await tester.pumpAndSettle();

    // Entering the name of the user to search
    await tester.enterText(searchBarFinder, 'Poop');
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that can not see a name that does not contain "Poop"
    expect(find.text('Andrew Youssef'), findsNothing);
  });

  testWidgets('Search with Endorsed filter to find a valid user', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Login
    await tester.enterText(find.byType(TextFormField).first, 'AndrewTest1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'Andrew1!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Go to Search page
    final searchBarFinder = find.widgetWithText(TextField, 'Search');
    await tester.tap(searchBarFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Tap Endorsed filter
    final endorsedButton = find.text("Endorsed?");
    await tester.tap(endorsedButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Entering the name of the user to search
    await tester.enterText(searchBarFinder, "Andrew");
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Wait until the user appears in the list
    final userTileFinder = find.text("Andrew Youssef");
    await tester.pumpUntilFound(userTileFinder, const Duration(seconds: 4));

    // Tap on the user's list tile
    await tester.tap(userTileFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that we are on the correct profile screen by looking for a project that should be on Andrew's profile
    expect(find.text('BFC Playground'), findsWidgets);
  });

    testWidgets('Search with Endorsed filter to find an invalid user', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Login
    await tester.enterText(find.byType(TextFormField).first, 'AndrewTest1@gmail.com');
    await tester.enterText(find.byType(TextFormField).last, 'Andrew1!');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign in'));
    await tester.pumpAndSettle(const Duration(seconds: 10));

    // Go to Search page
    final searchBarFinder = find.widgetWithText(TextField, 'Search');
    await tester.tap(searchBarFinder);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Tap Endorsed filter
    final endorsedButton = find.text("Endorsed?");
    await tester.tap(endorsedButton);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Entering the name of the user to search
    await tester.enterText(searchBarFinder, "Andrew");
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that can not see a name that is not endorsed
    expect(find.text('Andrew Test (1)'), findsNothing);
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