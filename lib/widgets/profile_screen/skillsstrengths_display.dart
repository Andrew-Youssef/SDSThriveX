import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/skills_strengths_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_skills_strength.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingSkillsStrengthsWidget extends StatefulWidget {
  const MyExistingSkillsStrengthsWidget({super.key});

  @override
  State<MyExistingSkillsStrengthsWidget> createState() =>
      _MyExistingSkillsStrengthsWidgetState();
}

class _MyExistingSkillsStrengthsWidgetState
    extends State<MyExistingSkillsStrengthsWidget> {
  SkillsStrengthsModel? selectedSkillStrength;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> skills = userProvider.skillsStrengths;

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
                onTap: () {
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
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditSkillStrengthScreen(
                            skillStrength: skillModel,
                          ),
                    ),
                  );
                },
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
