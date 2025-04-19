import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_innatex_student_screens/data/globals.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_innatex_student_screens/features/calendar/calendar_screen.dart';
import 'package:flutter_innatex_student_screens/features/project_approval/project_approval_screen.dart';
import '../../data/globals.dart';
import '../../widgets/search_bar.dart';

class MyDashBoardScreen extends StatefulWidget {
  const MyDashBoardScreen({super.key});

  @override
  State<MyDashBoardScreen> createState() => _MyDashBoardScreenState();
}

class _MyDashBoardScreenState extends State<MyDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                child: Row(
                  children: [buildSearchBar('Search'), buildSearchButton()],
                ),
              ),

              // 🔽 Scrollable content below the fixed header
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    buildMyUserTypeButtons(context),
                    const SizedBox(height: 10),
                    if (userProvider.type == UserType.coach ||
                        userProvider.type == UserType.professor) ...[
                      buildMyCardCertifyProjects(context),
                      const SizedBox(height: 10),
                      if (userProvider.type == UserType.coach) ...[
                        buildMyCardCalendar(context),
                        const SizedBox(height: 10),
                      ],
                    ],
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

Widget buildMyUserTypeButtons(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);

  return Padding(
    padding: const EdgeInsets.only(right: 8, left: 8),
    child: Wrap(
      spacing: 8,
      children:
          UserType.values.map((userType) {
            return ElevatedButton(
              onPressed: () {
                userProvider.setUserType(userType);
              },
              child: Text(userType.name),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    userType == userProvider.type
                        ? Colors.blue
                        : Colors.white70,
              ),
            );
          }).toList(),
    ),
  );
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
                  'Certify Projects', //coaches only
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
                  'Calendar',
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
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
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
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
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
