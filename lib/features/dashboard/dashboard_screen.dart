// this is the orignal code I wrote that does not use Navigator
import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/theme.dart';
import 'package:flutter_innatex_student_screens/features/calendar/calendar_screen.dart';
import 'package:flutter_innatex_student_screens/features/project_approval/project_approval_screen.dart';

//ISSUES:
//button is currently non functional
//search bar does not really work

class MyDashBoardScreen extends StatefulWidget {
  const MyDashBoardScreen({super.key});

  @override
  State<MyDashBoardScreen> createState() => _MyDashBoardScreenState();
}

class _MyDashBoardScreenState extends State<MyDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Row(children: [buildSearchBar(), buildSearchButton()]),
            buildMyCardCertifyProjects(context),
            SizedBox(height: 10),
            buildMyCardCalender(context),
            SizedBox(height: 10),
            buildMyCard1(),
            SizedBox(height: 10),
            buildMyCard2(),
          ],
        ),
      ),
    );
  }
}

//COACHES ONLY
//figure out how to make it open the certify projects page
Widget buildMyCardCertifyProjects(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Certify Projects (Coaches)'),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPendingProjectScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
            ),
          ],
        ),
      ),
    ),
  );
}

//COACHES ONLY
Widget buildMyCardCalender(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Calender (Coaches)'),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCalendarScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMyCard1() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('View Portfolio'),
            Divider(color: Colors.grey),
            Text('- Personal Projects'),
            Text('- Work Experience'),
            Text('- Volunteer Work'),
            Text('- Certifications & Degrees'),
            Text('- Personal Stories'),
          ],
        ),
      ),
    ),
  );
}

Widget buildMyCard2() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Meetings'),
            Divider(color: Colors.grey),
            Text('- Coaching Sessions'),
            Text('- Job Interviews'),
            Text('- Seminars'),
          ],
        ),
      ),
    ),
  );
}

Widget buildSearchButton() {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: IconButton.filled(
      onPressed: () {},
      icon: const Icon(Icons.search),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          const Color.fromARGB(255, 255, 255, 255),
        ),
        foregroundColor: WidgetStatePropertyAll<Color>(
          const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    ),
  );
}

Widget buildSearchBar() {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            hintText: 'Search',
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            // onTap: () {
            //   controller.openView();
            // },
            onChanged: (_) {
              controller.openView();
            },
            // onSubmitted: (_) {
            //   controller.openView();
            // },
            // leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                controller.closeView(item);
              },
            );
          });
        },
      ),
    ),
  );
}




// //This is essentially gpt code however it does have the functionality to easily 
// //switch screens whilst keeping the appBar persistent througout the project
// //it does this by adding this Navigator widget, which stores routes to widgets
// //and conditionally generates them inside its container depending on what button
// //has been pressed
// //i dont fully understand so is it not yet the current implementation
// import 'package:flutter/material.dart';
// import 'package:flutter_innatex_student_screens/core/theme.dart';
// import 'package:flutter_innatex_student_screens/features/calendar/calendar_screen.dart';
// import 'package:flutter_innatex_student_screens/features/project_approval/project_approval_screen.dart';

// class MyDashBoardScreen extends StatefulWidget {
//   const MyDashBoardScreen({super.key});

//   @override
//   State<MyDashBoardScreen> createState() => _MyDashBoardScreenState();
// }

// class _MyDashBoardScreenState extends State<MyDashBoardScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       initialRoute: 'dashboard/home',
//       onGenerateRoute: (RouteSettings settings) {
//         Widget page;
//         switch (settings.name) {
//           case 'dashboard/home':
//             page = const DashboardHome();
//             break;
//           case 'dashboard/calendar':
//             page = const MyCalendarScreen();
//             break;
//           case 'dashboard/pendingProjects':
//             page = const MyPendingProjectScreen();
//             break;
//           default:
//             page = const Center(child: Text("Page not found"));
//         }

//         return MaterialPageRoute(builder: (_) => page);
//       },
//     );
//   }
// }

// class DashboardHome extends StatelessWidget {
//   const DashboardHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: ListView(
//           children: [
//             Row(children: [buildSearchBar(), buildSearchButton()]),
//             buildMyCardCertifyProjects(context),
//             const SizedBox(height: 10),
//             buildMyCardCalender(context),
//             const SizedBox(height: 10),
//             buildMyCard1(),
//             const SizedBox(height: 10),
//             buildMyCard2(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- CARD WIDGETS ---

// Widget buildMyCardCertifyProjects(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Card(
//       borderOnForeground: true,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Certify Projects (Coaches)'),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(
//                       context,
//                     ).pushNamed('dashboard/pendingProjects');
//                   },
//                   icon: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(255, 118, 195, 247),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward,
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(color: Colors.grey),
//             const Text(
//               'Certify student projects so that they are recognized by employers',
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget buildMyCardCalender(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Card(
//       borderOnForeground: true,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Calender (Coaches)'),
//                 IconButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamed('dashboard/calendar');
//                   },
//                   icon: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: const BoxDecoration(
//                       color: Color.fromARGB(255, 118, 195, 247),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.arrow_forward,
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(color: Colors.grey),
//             const Text(
//               'Certify student projects so that they are recognized by employers',
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget buildMyCard1() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Card(
//       borderOnForeground: true,
//       child: const Padding(
//         padding: EdgeInsets.only(left: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('View Portfolio'),
//             Divider(color: Colors.grey),
//             Text('- Personal Projects'),
//             Text('- Work Experience'),
//             Text('- Volunteer Work'),
//             Text('- Certifications & Degrees'),
//             Text('- Personal Stories'),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget buildMyCard2() {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Card(
//       borderOnForeground: true,
//       child: const Padding(
//         padding: EdgeInsets.only(left: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Upcoming Meetings'),
//             Divider(color: Colors.grey),
//             Text('- Coaching Sessions'),
//             Text('- Job Interviews'),
//             Text('- Seminars'),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// // --- SEARCH BAR ---

// Widget buildSearchButton() {
//   return Padding(
//     padding: const EdgeInsets.all(12),
//     child: IconButton.filled(
//       onPressed: () {},
//       icon: const Icon(Icons.search),
//       style: const ButtonStyle(
//         backgroundColor: WidgetStatePropertyAll<Color>(
//           Color.fromARGB(255, 255, 255, 255),
//         ),
//         foregroundColor: WidgetStatePropertyAll<Color>(
//           Color.fromARGB(255, 0, 0, 0),
//         ),
//       ),
//     ),
//   );
// }

// Widget buildSearchBar() {
//   return Flexible(
//     child: Padding(
//       padding: const EdgeInsets.only(left: 12),
//       child: SearchAnchor(
//         builder: (BuildContext context, SearchController controller) {
//           return SearchBar(
//             hintText: 'Search',
//             controller: controller,
//             padding: const WidgetStatePropertyAll<EdgeInsets>(
//               EdgeInsets.symmetric(horizontal: 16.0),
//             ),
//             onChanged: (_) {
//               controller.openView();
//             },
//           );
//         },
//         suggestionsBuilder: (
//           BuildContext context,
//           SearchController controller,
//         ) {
//           return List<ListTile>.generate(5, (int index) {
//             final String item = 'item $index';
//             return ListTile(
//               title: Text(item),
//               onTap: () {
//                 controller.closeView(item);
//               },
//             );
//           });
//         },
//       ),
//     ),
//   );
// }
