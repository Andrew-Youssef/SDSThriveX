import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home.dart';
import '../../features/login/login_page.dart';

class AuthService {
  Future<String?> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String? userType,
    required BuildContext context,
  }) async {
    try {
      if (password != confirmPassword) {
        return 'Passwords do not match';
      }
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      );

      return null;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future<void> logout({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
    );
  }
}
