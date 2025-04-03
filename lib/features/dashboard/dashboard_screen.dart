import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/theme.dart';
import 'package:flutter_innatex_student_screens/features/calender/calender_screen.dart';
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
                  icon: Icon(Icons.arrow_forward),
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
              children: [
                Text('Calender (Coaches)'),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCalenderScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward),
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
      icon: Icon(Icons.search),
      color: Color.fromARGB(255, 255, 255, 255),
      focusColor: Color.fromARGB(70, 162, 155, 254),
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
