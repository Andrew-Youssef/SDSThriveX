import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/workexperience_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_workexperience.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingWorkExperiencesWidget extends StatefulWidget {
  final String selectedUserId;

  const MyExistingWorkExperiencesWidget({
    super.key,
    required this.selectedUserId,
  });

  @override
  State<MyExistingWorkExperiencesWidget> createState() =>
      _MyExistingWorkExperiencesWidgetState();
}

class _MyExistingWorkExperiencesWidgetState
    extends State<MyExistingWorkExperiencesWidget> {
  WorkExperienceModel? selectedWorkExperience;
  UserProvider? selectedUserProvider;
  bool _hadLoadedProfile = false;
  bool _isLoggedInUser = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      if (!_hadLoadedProfile) {
        _hadLoadedProfile = true;

        UserProvider userProvider = Provider.of<UserProvider>(context);
        if (widget.selectedUserId == userProvider.userId) {
          selectedUserProvider = userProvider;
          _isLoggedInUser = true;
          _isLoading = false;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            selectedUserProvider = UserProvider();
            await selectedUserProvider!.setTemporaryProfile(
              widget.selectedUserId,
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    List<WorkExperienceModel> workExperiences =
        selectedUserProvider!.workExperiences;
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
                  '${exp.dateBegun.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${exp.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap:
                    _isLoggedInUser
                        ? () {
                          if (selectedWorkExperience == exp) {
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
                          setState(() {
                            selectedWorkExperience = exp;
                          });
                        }
                        : null,
                onLongPress:
                    _isLoggedInUser
                        ? () {
                          setState(() {
                            selectedWorkExperience = exp;
                          });
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
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        exp == selectedWorkExperience
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
              );
            }).toList(),
      );
    }
  }
}
