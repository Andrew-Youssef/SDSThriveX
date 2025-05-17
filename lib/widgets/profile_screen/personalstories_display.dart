import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/personal_stories_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_personal_story.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingPersonalStoriesWidget extends StatefulWidget {
  const MyExistingPersonalStoriesWidget({super.key});

  @override
  State<MyExistingPersonalStoriesWidget> createState() =>
      _MyExistingPersonalStoriesWidgetState();
}

class _MyExistingPersonalStoriesWidgetState
    extends State<MyExistingPersonalStoriesWidget> {
  PersonalStoriesModel? selectedPersonalStory;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> stories = userProvider.personalStories;

    if (stories.isEmpty) {
      return Text(
        'Add a personal story!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            stories.map((story) {
              final String formattedDate =
                  story.date.toLocal().toString().split(' ')[0];

              return GestureDetector(
                onTap: () {
                  if (selectedPersonalStory == story) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditPersonalStoryScreen(personalStory: story),
                      ),
                    );
                  }
                  setState(() {
                    selectedPersonalStory = story;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditPersonalStoryScreen(personalStory: story),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        story == selectedPersonalStory
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              story.title,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }
}
