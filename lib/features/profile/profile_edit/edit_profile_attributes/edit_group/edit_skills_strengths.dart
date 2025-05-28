import 'package:flutter/material.dart';
import '../../../../../core/models/skills_strengths_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';
import '../../edit_profile_attributes/edit_individual/edit_skills_strength.dart';

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
      id: '',
      skill: _skillController.text,
      acquiredAt: _acquiredAtController.text,
      description: _descriptionController.text,
    );

    userProvider.addSkillsStrengths(newSkillStrength);

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
          body: ListView(
            children: [
              if (skillsStrengths.isNotEmpty)
                showExistingSkillsStrengths(context),
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> projects = userProvider.skillsStrengths;

    return SizedBox(
      height: 160,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in projects) ...[
            Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(maxWidth: 170),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      // 👈 centers 1- or 2-line text vertically
                      child: Text(
                        p.skill,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign:
                            TextAlign.center, // 👈 centers text horizontally
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deleteButton(p),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MyEditSkillStrengthScreen(
                                    skillStrength: p,
                                  ),
                            ),
                          );
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 42, 157, 143),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconButton deleteButton(SkillsStrengthsModel s) {
    final userProvider = Provider.of<UserProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Deletion"),
              content: Text(
                "Are you sure you want to delete this skill/strength",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    userProvider.removeSkillsStrengths(s.id);
                    setState(() {
                      selectedSkillStrength = null;
                      _skillController.clear();
                      _acquiredAtController.clear();
                      _descriptionController.clear();
                    });
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      icon: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 42, 157, 143),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6),
        child: Icon(Icons.delete),
      ),
    );
  }

  Widget buildInputFields(BuildContext context, UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Skill or Strength:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Acquired At:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addSkillStrength(userProvider),
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
              child: const Text("Add New Skill/Strength"),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
