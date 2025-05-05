import 'package:flutter/material.dart';

//provider stuff
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

//import screens
import 'features/dashboard/dashboard_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/profile/profile_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final ThemeData appTheme = userProvider.getTheme();

    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Test'),
      // home: const MyProfileScreen(),
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
      body: page,

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        height: 55,
        destinations: [
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
    );
  }
}

// //CHAT GPT CODE TO KEEP THE BOTTOM APP BAR THROUGH THE WHOLE APP (NOT NEEDED)

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int currentPageIndex = 1;

//   final List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];

//   void _onTap(int index) {
//     if (index == currentPageIndex) {
//       _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
//     } else {
//       setState(() => currentPageIndex = index);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: List.generate(3, (index) {
//           return Offstage(
//             offstage: currentPageIndex != index,
//             child: Navigator(
//               key: _navigatorKeys[index],
//               onGenerateRoute: (settings) {
//                 Widget page;
//                 switch (index) {
//                   case 0:
//                     page = const MyNotificationScreen();
//                     break;
//                   case 1:
//                     page = const MyDashBoardScreen();
//                     break;
//                   case 2:
//                     page = const MyProfileScreen();
//                     break;
//                   default:
//                     throw Exception("Invalid index");
//                 }
//                 return MaterialPageRoute(builder: (_) => page);
//               },
//             ),
//           );
//         }),
//       ),
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: currentPageIndex,
//         onDestinationSelected: _onTap,
//         labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//         height: 60,
//         destinations: const [
//           NavigationDestination(
//             icon: Icon(Icons.notifications_none),
//             selectedIcon: Icon(Icons.notifications),
//             label: 'Notifications',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.home_outlined),
//             selectedIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: Icon(Icons.person_outlined),
//             selectedIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
