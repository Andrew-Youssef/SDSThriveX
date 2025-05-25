import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/skills_strengths_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
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
    _acquiredAtController =
        TextEditingController(text: widget.skillStrength.acquiredAt);
    _descriptionController =
        TextEditingController(text: widget.skillStrength.description);
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
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Skill & Strength', context),
          body: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Skill"),
                            content: const Text(
                                "Are you sure you want to delete this skill? This action cannot be undone."),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        userProvider.removeSkillStrength(widget.skillStrength);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
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
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLabeledField(
            'Name of Skill or Strength:',
            _skillController,
            'Enter skill or strength name',
            onChanged: widget.skillStrength.updateSkill,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Where was skill acquired:',
            _acquiredAtController,
            'Enter where skill was acquired',
            onChanged: widget.skillStrength.updateAcquiredAt,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Description:',
            _descriptionController,
            'Describe the skill briefly',
            onChanged: widget.skillStrength.updateDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Save logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 42, 157, 143),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Confirm changes?',
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller,
      String hint, {
        void Function(String)? onChanged,
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
