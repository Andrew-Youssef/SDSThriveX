import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/personal_stories_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_personal_story.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditPersonalStoriesScreen extends StatefulWidget {
  const MyEditPersonalStoriesScreen({super.key});

  @override
  State<MyEditPersonalStoriesScreen> createState() =>
      _MyEditPersonalStoriesScreenState();
}

class _MyEditPersonalStoriesScreenState
    extends State<MyEditPersonalStoriesScreen> {
  PersonalStoriesModel? selectedPersonalStory;
  late final TextEditingController _titleController;
  late final TextEditingController _dateController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _dateController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> personalStories = userProvider.personalStories;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Personal Stories', context),
          body: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: selectedPersonalStory == null
                        ? null
                        : () {
                            userProvider.removePersonalStory(
                              selectedPersonalStory!,
                            );
                            setState(() {
                              selectedPersonalStory = null;
                            });
                          },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              if (personalStories.isEmpty) ...[
                const Center(child: Text('Add a new personal story!')),
                const SizedBox(height: 20),
              ] else ...[
                showExistingPersonalStories(context),
              ],
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingPersonalStories(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final stories = userProvider.personalStories;

    return SizedBox(
      height: 180,
      child: ListView(
        padding: const EdgeInsets.all(12),
        scrollDirection: Axis.horizontal,
        children: stories.map((p) {
          return Container(
            width: 180,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: p == selectedPersonalStory
                    ? theme.primaryColor
                    : Colors.grey,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                p.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text("Title:", style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Enter story title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text("Date begun:", style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: "DD-MM-YYYY",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(_dateController, context),
          ),
          const SizedBox(height: 16),
          Text("Description:", style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter a short description of your story",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              final title = _titleController.text.trim();
              final date = _dateController.text.trim();
              final description = _descriptionController.text.trim();

              if (title.isEmpty || date.isEmpty || description.isEmpty) {
                _showSnackBar(context, "Please fill in all fields!", Colors.red);
                return;
              }

              final parts = date.split('/');
              final parsedDate = DateTime.tryParse('${parts[2]}-${parts[1]}-${parts[0]}');

              if (parsedDate == null) {
                _showSnackBar(context, "Invalid date format!", Colors.orange);
                return;
              }

              final newStory = PersonalStoriesModel(
                title: title,
                date: parsedDate,
                description: description,
              );

              Provider.of<UserProvider>(context, listen: false)
                  .addPersonalStory(newStory);

              _titleController.clear();
              _dateController.clear();
              _descriptionController.clear();
              FocusScope.of(context).unfocus();

              _showSnackBar(
                  context, "Personal Story added successfully!", Colors.green);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 42, 157, 143),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2),
              ),
              child: const Text(
                "Add Personal Story",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _selectDate(
  TextEditingController controller,
  BuildContext context,
) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    String formattedDate =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    setState(() {
      controller.text = formattedDate;
    });
  }
}


  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
