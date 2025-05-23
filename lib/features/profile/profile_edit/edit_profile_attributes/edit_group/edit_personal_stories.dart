import 'package:flutter/material.dart';
import '../../../../../core/models/personal_stories_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

import '../../edit_profile_attributes/edit_individual/edit_personal_story.dart';

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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadPersonalStories(userProvider.profile!.userId);
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
                                selectedPersonalStory!.id,
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
                              id: '',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.title),
                    Text(p.date.toString().split(' ')[0]),
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
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start Date (required)',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_dateController, context);
              },
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
