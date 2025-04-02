import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Signed In As:'),
          Text(user.email!),
          ElevatedButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
