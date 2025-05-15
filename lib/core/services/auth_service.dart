import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home.dart';
import '../models/profile_model.dart';
import '../../providers/user_provider.dart';
import '../../features/signin_screen.dart';

class AuthService {
  Future<String?> signup({
    required String name,
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

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({'name': name, 'email': email, 'userType': userType});

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setProfileAndDetails(ProfileModel.fromDB(doc));

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

      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .get();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setProfileAndDetails(ProfileModel.fromDB(doc));

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
      MaterialPageRoute(builder: (BuildContext context) => const SigninPage()),
    );
  }
}
