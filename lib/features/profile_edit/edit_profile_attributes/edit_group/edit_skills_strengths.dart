import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/skills_strengths_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_skills_strength.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditSkillsStrengthsScreen extends StatefulWidget {
  const MyEditSkillsStrengthsScreen({super.key});

  @override
  State<MyEditSkillsStrengthsScreen> createState() =>
      _MyEditSkillsStrengthsScreenState();
}

class _MyEditSkillsStrengthsScreenState
    extends State<MyEditSkillsStrengthsScreen> {
  SkillsStrengthsModel? selectedSkillStrength;
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _acquiredAtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _skillController.dispose();
    _acquiredAtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addSkillStrength(UserProvider userProvider) {
  if (_skillController.text.isEmpty ||
      _acquiredAtController.text.isEmpty ||
      _descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please fill in all the fields.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  SkillsStrengthsModel newSkillStrength = SkillsStrengthsModel(
    skill: _skillController.text,
    acquiredAt: _acquiredAtController.text,
    description: _descriptionController.text,
  );

  userProvider.addSkillStrength(newSkillStrength);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('Skill/Strength added successfully!'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );

  _skillController.clear();
  _acquiredAtController.clear();
  _descriptionController.clear();

  setState(() => selectedSkillStrength = null);
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
              if (skillsStrengths.isNotEmpty) showExistingSkillsStrengths(context),
              if (skillsStrengths.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Add a new skill or strength!'),
                ),
              buildInputFields(context, userProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingSkillsStrengths(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return SizedBox(
      height: 180,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        children: userProvider.skillsStrengths.map((p) {
          return GestureDetector(
            onTap: () {
              setState(() => selectedSkillStrength = p);
            },
            onLongPress: () {
              setState(() => selectedSkillStrength = p);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MyEditSkillStrengthScreen(skillStrength: p),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: p == selectedSkillStrength
                      ? theme.colorScheme.secondary
                      : Colors.grey,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  p.skill,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildInputFields(BuildContext context, UserProvider userProvider) {
    return Expanded(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text("Skill or Strength:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: _skillController,
            decoration: InputDecoration(
              hintText: "e.g. Time management",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Acquired At:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: _acquiredAtController,
            decoration: InputDecoration(
              hintText: "Where or how you acquired this skill",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Explain how this skill helps you",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _addSkillStrength(userProvider),
              icon: const Icon(Icons.add),
              label: const Text("Add New Skill/Strength"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
  }
}
