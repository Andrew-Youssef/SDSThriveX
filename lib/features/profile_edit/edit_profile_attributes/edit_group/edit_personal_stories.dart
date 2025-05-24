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
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed:
                        selectedPersonalStory == null
                            ? null
                            : () {
                              userProvider.removePersonalStory(
                                selectedPersonalStory!,
                              );
                              selectedPersonalStory = null;
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_titleController.text.isNotEmpty &&
                          _dateController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        PersonalStoriesModel newPersonalStory =
                            PersonalStoriesModel(
                              title: _titleController.text,
                              date: DateTime.tryParse(_dateController.text)!,
                              description: _descriptionController.text,
                            );
                        userProvider.addPersonalStory(newPersonalStory);
                      }
                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (personalStories.isEmpty) ...[
                Center(child: Text('Add a new personal story!')),
                SizedBox(height: 20),
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> personalStories = userProvider.personalStories;

    return SizedBox(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in personalStories) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedPersonalStory = p;
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedPersonalStory = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MyEditPersonalStoryScreen(
                          personalStory: selectedPersonalStory!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedPersonalStory ? 5 : 3,
                  ),
                ),
                child: Text(
                  p.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                
                  ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text("Title:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Enter project name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Date begun:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(
              hintText: "DD / MM / YYYY",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 2),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(_dateController, context),
          ),
          const SizedBox(height: 16),
          const Text("Description:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter a short description of your project",
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Please fill in all fields!"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
                return;
              }

              try {
                final parsedDate = DateTime.tryParse(date);
                if (parsedDate == null) throw Exception("Invalid date");

                PersonalStoriesModel newStory = PersonalStoriesModel(
                  title: title,
                  date: parsedDate,
                  description: description,
                );

                Provider.of<UserProvider>(context, listen: false)
                    .addPersonalStory(newStory);

                // Clear inputs
                _titleController.clear();
                _dateController.clear();
                _descriptionController.clear();
                FocusScope.of(context).unfocus();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Project added successfully!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Invalid date format!"),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2),
              ),
              child: const Text(
                "Add new project!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
      setState(() {
        controller.text = picked.toString().split(" ")[0];
      });
    }
  }
}
