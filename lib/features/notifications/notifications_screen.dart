// return const Placeholder();
//a row of things that let me see my notification categories
//All - Job offers - endorsments - profile changes

//these are all individual buttons that when selected format my notifications
//the data will be from a database that is yet to be set up but i can add placeholder stuff

import 'package:flutter/material.dart';
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
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text("All")),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Job Offers"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Endorsments"),
                  // style: theme.elevatedButtonTheme.style,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Profile Changes"),
                ),
              ],
            ),

            Expanded(
              child: ListView(
                children: [
                  if (list.isEmpty) Text("no notifications"),

                  for (List<String> l in list)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.person_4_rounded),
                          title: Text(l[0]),
                          subtitle: Text(
                            l[1],
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          trailing: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const MyNotificationDetailsScreen(),
                                ),
                              );
                            },
                            label: const SizedBox.shrink(),
                            icon: Icon(Icons.arrow_forward_ios),
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
