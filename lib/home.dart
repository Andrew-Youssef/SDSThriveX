import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screens/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userRef,
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No user data found. Please report to Admin'),
            );
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Signed In As:'),
                Text(userData['email'] ?? 'No email found'),
                Text('You are a:'),
                Text(userData['userType'] ?? 'No email found'),
                ElevatedButton(
                  onPressed: () async {
                    await AuthService().logout(context: context);
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
