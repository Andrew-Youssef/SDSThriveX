import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/skills_strengths_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_skills_strength.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingSkillsStrengthsWidget extends StatefulWidget {
  final String selectedUserId;

  const MyExistingSkillsStrengthsWidget({
    super.key,
    required this.selectedUserId,
  });

  @override
  State<MyExistingSkillsStrengthsWidget> createState() =>
      _MyExistingSkillsStrengthsWidgetState();
}

class _MyExistingSkillsStrengthsWidgetState
    extends State<MyExistingSkillsStrengthsWidget> {
  SkillsStrengthsModel? selectedSkillStrength;
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
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> skills = selectedUserProvider!.skillsStrengths;

    if (skills.isEmpty) {
      return Text(
        'Add some skills & strengths!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            skills.map((skillModel) {
              return GestureDetector(
                onTap:
                    _isLoggedInUser
                        ? () {
                          if (selectedSkillStrength == skillModel) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyEditSkillStrengthScreen(
                                      skillStrength: skillModel,
                                    ),
                              ),
                            );
                          }
                          setState(() {
                            selectedSkillStrength = skillModel;
                          });
                        }
                        : null,
                onLongPress:
                    _isLoggedInUser
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MyEditSkillStrengthScreen(
                                    skillStrength: skillModel,
                                  ),
                            ),
                          );
                        }
                        : null,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        skillModel == selectedSkillStrength
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
                          // No ellipsis — allow wrapping
                          Flexible(
                            child: Text(
                              skillModel.skill,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            skillModel.acquiredAt,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skillModel.description,
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
