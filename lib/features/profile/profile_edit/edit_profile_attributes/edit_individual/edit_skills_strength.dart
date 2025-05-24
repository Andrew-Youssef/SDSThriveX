import 'package:flutter/material.dart';
import '../../../../../core/models/skills_strengths_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditSkillStrengthScreen extends StatefulWidget {
  final SkillsStrengthsModel skillStrength;

  const MyEditSkillStrengthScreen({super.key, required this.skillStrength});

  @override
  State<MyEditSkillStrengthScreen> createState() =>
      _MyEditSkillStrengthScreenState();
}

class _MyEditSkillStrengthScreenState extends State<MyEditSkillStrengthScreen> {
  late final TextEditingController _skillController;
  late final TextEditingController _acquiredAtController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _skillController = TextEditingController(text: widget.skillStrength.skill);
    _acquiredAtController = TextEditingController(
      text: widget.skillStrength.acquiredAt,
    );
    _descriptionController = TextEditingController(
      text: widget.skillStrength.description,
    );
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Skill & Strength', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      userProvider.removeSkillsStrengths(
                        widget.skillStrength.id,
                      );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              buildInputFields(context),
            ],
          ),
        ),
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
              onChanged: widget.skillStrength.updateSkill,
              controller: _skillController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of Skill or Strength',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.skillStrength.updateAcquiredAt,
              controller: _acquiredAtController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Where was skill acquired',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.skillStrength.updateDescription,
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
