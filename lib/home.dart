import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screens/features/dashboard/dashboard_screen.dart';
import 'package:screens/features/notifications/notifications_screen.dart';
import 'package:screens/features/profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;
  final user = FirebaseAuth.instance.currentUser!;
  get userRef =>
      FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        //Might change this if there is no need for User Data might implement it to the other pages
        stream: userRef,
        builder: (context, snapshot) {
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('No user data found. Please report to Admin'),
            );
          } else {
            Widget page;
            switch (currentPageIndex) {
              case 0:
                page = MyNotificationScreen();
                break;
              case 1:
                page = MyDashBoardScreen();
                break;
              case 2:
                page = MyProfileScreen();
                break;
              default:
                throw UnimplementedError("THIS AINT IMPLEMENTED YET\n");
            }
            return page;
          }
        },
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.orange,
          indicatorColor: Colors.orange,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            return const IconThemeData(color: Colors.white, size: 30);
          }),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white),
          ),
        ),
        child: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: currentPageIndex,
          height: 60,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.notifications_none),
              selectedIcon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
