import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';
import '../test/test_util.dart';

import 'package:screens/core/services/auth_service.dart';
import 'package:screens/core/services/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  final authService = AuthService();

  testWidgets('Signup should work with valid new user info', (WidgetTester tester) async {
    final context = await getTestContext(tester);

    // We use these 2 lines for the "email" initialised variable line, because we are actually adding the user to firebase
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final email = 'TestValidUser_$timestamp@test.com';
    final password = 'TestUser1!';
    final name = 'Test User';
    final userType = 'Student';

    final result = await authService.signup(
      name: name,
      email: email,
      password: password,
      confirmPassword: password,
      userType: userType,
      context: context,
    );

    expect(result, isNull, reason: 'Signup should return null on success');
  });

  testWidgets('Signup should fail with passwords that dont match', (WidgetTester tester) async {
    final context = await getTestContext(tester);

    final result = await authService.signup(
      name: 'Mismatching Passwords User',
      email: 'MismatchingPasswords@test.com',
      password: 'Password1!',
      confirmPassword: 'Password1111!!!!',
      userType: 'Coach',
      context: context,
    );

    expect(result, isNotNull, reason: 'Signup should fail when passwords do not match');
    expect(result, contains('Passwords do not match'));
  });
}