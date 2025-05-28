import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/core/models/skills_strengths_model.dart';
import 'package:thrivex/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_skills_strength.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyExistingSkillsStrengthsWidget extends StatefulWidget {
  final UserProvider selectedUserProvider;

  const MyExistingSkillsStrengthsWidget({
    super.key,
    required this.selectedUserProvider,
  });

  @override
  State<MyExistingSkillsStrengthsWidget> createState() =>
      _MyExistingSkillsStrengthsWidgetState();
}

class _MyExistingSkillsStrengthsWidgetState
    extends State<MyExistingSkillsStrengthsWidget>
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
    List<SkillsStrengthsModel> skills =
        widget.selectedUserProvider.skillsStrengths;

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
              return InkWell(
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
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
