import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/core/models/workexperience_model.dart';
import 'package:thrivex/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_workexperience.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyExistingWorkExperiencesWidget extends StatefulWidget {
  final UserProvider selectedUserProvider;

  const MyExistingWorkExperiencesWidget({
    super.key,
    required this.selectedUserProvider,
  });

  @override
  State<MyExistingWorkExperiencesWidget> createState() =>
      _MyExistingWorkExperiencesWidgetState();
}

class _MyExistingWorkExperiencesWidgetState
    extends State<MyExistingWorkExperiencesWidget>
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
    List<WorkExperienceModel> workExperiences =
        widget.selectedUserProvider.workExperiences;
    ThemeData theme = Theme.of(context);

    if (workExperiences.isEmpty) {
      return Text(
        'Add some work experience!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            workExperiences.map((exp) {
              final String startDate =
                  exp.dateBegun.toLocal().toString().split(' ')[0];
              final String endDate =
                  exp.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present";

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
                                      (context) => MyEditWorkExperienceScreen(
                                        workExperience: exp,
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
                                      (context) => MyEditWorkExperienceScreen(
                                        workExperience: exp,
                                      ),
                                ),
                              );
                            }
                            : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  exp.name,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    startDate,
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    endDate,
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(exp.role, style: theme.textTheme.displayMedium),
                          const SizedBox(height: 4),
                          Text(
                            exp.description,
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
