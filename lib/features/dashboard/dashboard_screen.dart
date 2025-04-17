import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_innatex_student_screens/features/calendar/calendar_screen.dart';
import 'package:flutter_innatex_student_screens/features/project_approval/project_approval_screen.dart';

class MyDashBoardScreen extends StatefulWidget {
  const MyDashBoardScreen({super.key});

  @override
  State<MyDashBoardScreen> createState() => _MyDashBoardScreenState();
}

class _MyDashBoardScreenState extends State<MyDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // header background
              Container(
                color: theme.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(children: [buildSearchBar(), buildSearchButton()]),
              ),

              // 🔽 Scrollable content below the fixed header
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    buildMyCardCertifyProjects(context),
                    const SizedBox(height: 10),
                    buildMyCardCalendar(context),
                    const SizedBox(height: 10),
                    buildMyCard1(),
                    const SizedBox(height: 10),
                    buildMyCard2(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// COACHES ONLY
Widget buildMyCardCertifyProjects(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color.fromARGB(255, 244, 163, 97), width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certify Projects(C)', //coaches only
                  style: GoogleFonts.bitter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
              style: GoogleFonts.bitter(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}

// COACHES ONLY
Widget buildMyCardCalendar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendar (Coaches)',
                  style: GoogleFonts.bitter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
              style: GoogleFonts.bitter(fontSize: 14),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'View Portfolio',
              style: GoogleFonts.bitter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            ...[
              '- Personal Projects',
              '- Work Experience',
              '- Volunteer Work',
              '- Certifications & Degrees',
              '- Personal Stories',
            ].map(
              (text) => Text(text, style: GoogleFonts.bitter(fontSize: 14)),
            ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Meetings',
              style: GoogleFonts.bitter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.grey),
            ...['- Coaching Sessions', '- Job Interviews', '- Seminars'].map(
              (text) => Text(text, style: GoogleFonts.bitter(fontSize: 14)),
            ),
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
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          Color.fromARGB(255, 255, 255, 255),
        ),
        foregroundColor: WidgetStatePropertyAll<Color>(
          Color.fromARGB(255, 0, 0, 0),
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
            onChanged: (_) {
              controller.openView();
            },
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item, style: GoogleFonts.bitter()),
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
