import 'package:flutter/material.dart';
import '../../../../../core/models/skills_strengths_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

import '../edit_individual/edit_skills_strength.dart';

class MyEditSkillsStrengthsScreen extends StatefulWidget {
  const MyEditSkillsStrengthsScreen({super.key});

  @override
  State<MyEditSkillsStrengthsScreen> createState() =>
      _MyEditSkillsStrengthsScreenState();
}

class _MyEditSkillsStrengthsScreenState
    extends State<MyEditSkillsStrengthsScreen> {
  SkillsStrengthsModel? selectedSkillStrength;
  late final TextEditingController _skillController;
  late final TextEditingController _acquiredAtController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _skillController = TextEditingController();
    _acquiredAtController = TextEditingController();
    _descriptionController = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadProjects(userProvider.profile!.userId);
  }

  @override
  void dispose() {
    _skillController.dispose();
    _acquiredAtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> skillsStrengths = userProvider.skillsStrengths;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Skills & Strengths', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed:
                        selectedSkillStrength == null
                            ? null
                            : () {
                              userProvider.removeSkillsStrengths(
                                selectedSkillStrength!.id,
                              );
                              selectedSkillStrength = null;
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_skillController.text.isNotEmpty &&
                          _acquiredAtController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        SkillsStrengthsModel newSkillStrength =
                            SkillsStrengthsModel(
                              id: '',
                              skill: _skillController.text,
                              acquiredAt: _acquiredAtController.text,
                              description: _descriptionController.text,
                            );
                        userProvider.addSkillsStrengths(newSkillStrength);
                      }
                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (skillsStrengths.isEmpty) ...[
                Center(child: Text('Add a new work experience!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingSkillsStrengths(context),
              ],
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingSkillsStrengths(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> workExperiences = userProvider.skillsStrengths;

    return SizedBox(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in workExperiences) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedSkillStrength = p;
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedSkillStrength = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MyEditSkillStrengthScreen(
                          skillStrength: selectedSkillStrength!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedSkillStrength ? 5 : 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.skill),
                    Text(p.acquiredAt),
                    Text(p.description),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
          ],
        ],
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _skillController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name of Skill or Strength',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _acquiredAtController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Where was skill acquired',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Description',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
