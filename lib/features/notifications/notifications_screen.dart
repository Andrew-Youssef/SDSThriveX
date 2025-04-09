// return const Placeholder();
//a row of things that let me see my notification categories
//All - Job offers - endorsments - profile changes

//these are all individual buttons that when selected format my notifications
//the data will be from a database that is yet to be set up but i can add placeholder stuff

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_innatex_student_screens/core/theme.dart';
import 'package:flutter_innatex_student_screens/features/notifications/notification_details_screen.dart';

class MyNotificationScreen extends StatefulWidget {
  const MyNotificationScreen({super.key});

  @override
  State<MyNotificationScreen> createState() => _MyNotificationScreenState();
}

class _MyNotificationScreenState extends State<MyNotificationScreen> {
  //type eg. project, endorsment, feedback, job offer
  //person eg. coach, professor, self
  //name eg. if project, name is of project, else name of endorsment

  final List<List<String>> list = [
    ["You've been endorsed", "John Smith"],
    ["New job offer", "Innate X"],
    ["Upcoming coaching session", "Steve Smith"],
    ["New feedback from", "James David"],
    ["You added a new project to your portfolio", "'My First Game'"],
    ["Your project 'Sample Website' was endorsed by", "John Smith"],
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = lightTheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity, // ensures full width of screen
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8), // Optional inner margin
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("All", style: GoogleFonts.bitter()),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Job Offers", style: GoogleFonts.bitter()),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Endorsments", style: GoogleFonts.bitter()),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Profile Changes", style: GoogleFonts.bitter()),
                    ),
                  ],
                ),
              ),
            ),

             Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  if (list.isEmpty)
                    Text("no notifications", style: GoogleFonts.bitter()),

                  for (List<String> l in list)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.orange, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.person_4_rounded),
                          title: Text(
                            l[0],
                            style: GoogleFonts.bitter(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            l[1],
                            style: GoogleFonts.bitter(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MyNotificationDetailsScreen(),
                                ),
                              );
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 118, 195, 247),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}