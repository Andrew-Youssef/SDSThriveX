import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import '../test/test_util.dart'; // Utility for test context

import 'package:thrivex/core/services/auth_service.dart';
import 'package:thrivex/core/services/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  final authService = AuthService();

  testWidgets('Login should work for valid user', (WidgetTester tester) async {
    final context = await getTestContext(tester);

    const email = 'AndrewTest1@gmail.com';
    const password = 'Andrew1!';

    final result = await authService.login(
      email: email,
      password: password,
      context: context,
    );

    expect(result, isNull, reason: 'Login should return null on success');
  });

  testWidgets('Login should fail for invalid user', (WidgetTester tester) async {
    final context = await getTestContext(tester);

    const email = 'EmailDoesntExistInFirebase@gmail.com';
    const password = 'NeitherDoesThisPassword1!';

    final result = await authService.login(
      email: email,
      password: password,
      context: context,
    );

    expect(result, isNotNull, reason: 'Login should return an error string');
  });
}