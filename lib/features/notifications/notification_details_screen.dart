import 'package:flutter/material.dart';

class MyNotificationDetailsScreen extends StatelessWidget {
  const MyNotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Details"), centerTitle: true),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Go Back"),
        ),
      ),
    );
  }
}
