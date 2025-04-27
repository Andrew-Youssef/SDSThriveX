// return const Placeholder();
//a row of things that let me see my notification categories
//All - Job offers - endorsments - profile changes

//these are all individual buttons that when selected format my notifications
//the data will be from a database that is yet to be set up but i can add placeholder stuff

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/features/notifications/notification_details_screen.dart';
import 'package:screens/providers/user_provider.dart';

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

  final List<List<String>> l = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = userProvider.getTheme();

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                width: double.infinity, // ensures full width of screen
                color: theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      color: theme.primaryColor,
                      child: Text(
                        'Notifications',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 40,
                      color: theme.primaryColor,
                      child: buildFilterButtons(context),
                    ),
                  ],
                ),
              ),

              Expanded(child: buildNotificationCards(list, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationCards(List<List<String>> list, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          list.add(['New refreshed notification', 'InnateX System']);
        });
      },

      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(8),
        children: [
          if (list.isEmpty) ...[
            SizedBox(
              height: MediaQuery.of(context).size.height - kToolbarHeight - 200,
              child: Center(
                child: Text(
                  'No New Notifications to Display',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ] else
            for (var l in list) buildNotificationCard(list, l, context),
        ],
      ),
    );
  }

  Widget buildNotificationCard(
    List<List<String>> list,
    List<String> l,
    BuildContext context,
  ) {
    return Dismissible(
      key: ValueKey(l),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        setState(() {
          list.remove(l);
        });
      },
      child: Padding(
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontSize: 16),
            ),
            subtitle: Text(
              l[1],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyNotificationDetailsScreen(),
                  ),
                );
              },
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 118, 195, 247),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterButtons(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      // spacing: 8,
      // runSpacing: 8,
      children: [
        SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {},
          child: Text("All", style: Theme.of(context).textTheme.labelSmall),
        ),
        SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "Job Offers",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "Endorsments",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            "Profile Changes",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        SizedBox(width: 5),
      ],
    );
  }
}
