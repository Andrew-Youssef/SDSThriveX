import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/core/models/personal_stories_model.dart';
import 'package:thrivex/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_personal_story.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyExistingPersonalStoriesWidget extends StatefulWidget {
  final UserProvider selectedUserProvider;

  const MyExistingPersonalStoriesWidget({
    super.key,
    required this.selectedUserProvider,
  });

  @override
  State<MyExistingPersonalStoriesWidget> createState() =>
      _MyExistingPersonalStoriesWidgetState();
}

class _MyExistingPersonalStoriesWidgetState
    extends State<MyExistingPersonalStoriesWidget>
    with AutomaticKeepAliveClientMixin {
  bool _hadLoadedProfile = false;
  bool _isLoggedInUser = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hadLoadedProfile) {
      UserProvider userProvider = Provider.of<UserProvider>(context);
      _isLoggedInUser =
          userProvider.userId == widget.selectedUserProvider.userId;
      _hadLoadedProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> stories =
        widget.selectedUserProvider.personalStories;

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

              return Column(
                children: [
                  const Divider(thickness: 1),
                  InkWell(
                    onDoubleTap:
                        _isLoggedInUser
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MyEditPersonalStoryScreen(
                                        personalStory: story,
                                      ),
                                ),
                              );
                            }
                            : null,
                    onLongPress:
                        _isLoggedInUser
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => MyEditPersonalStoryScreen(
                                        personalStory: story,
                                      ),
                                ),
                              );
                            }
                            : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ),
                ],
              );
            }).toList(),
      );
    }
  }
}
