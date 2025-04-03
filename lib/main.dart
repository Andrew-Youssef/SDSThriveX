import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart';

//import screens
import 'features/dashboard/dashboard_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      // darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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

    return Scaffold(
      body: Expanded(child: page),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        height: 60,
        backgroundColor: Colors.white,
        indicatorColor: Color.fromARGB(70, 162, 155, 254),

        destinations: [
          NavigationDestination(
            icon: Icon(Icons.notifications_none, size: 30),
            selectedIcon: Icon(Icons.notifications, size: 30),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined, size: 30),
            selectedIcon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined, size: 30),
            selectedIcon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
