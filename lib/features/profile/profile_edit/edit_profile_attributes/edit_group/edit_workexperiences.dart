import 'package:flutter/material.dart';
import 'package:screens/core/models/workexperience_model.dart';
import 'package:screens/providers/user_provider.dart';
import 'package:screens/widgets/header.dart';
import 'package:provider/provider.dart';

import '../../edit_profile_attributes/edit_individual/edit_workexperience.dart';

class MyEditWorkExperiencesScreen extends StatefulWidget {
  const MyEditWorkExperiencesScreen({super.key});

  @override
  State<MyEditWorkExperiencesScreen> createState() =>
      _MyEditWorkExperienceScreenState();
}

class _MyEditWorkExperienceScreenState
    extends State<MyEditWorkExperiencesScreen> {
  WorkExperienceModel? selectedWorkExperience;
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadWorkExperiences(userProvider.profile!.userId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Work Experience', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed:
                        selectedWorkExperience == null
                            ? null
                            : () {
                              userProvider.removeWorkExperience(
                                selectedWorkExperience!.id,
                              );
                              selectedWorkExperience = null;
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _startDate.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        WorkExperienceModel newWorkExperience =
                            WorkExperienceModel(
                              id: '',
                              name: _nameController.text,
                              dateBegun: DateTime.tryParse(_startDate.text)!,
                              dateEnded:
                                  _endDate.text.isNotEmpty
                                      ? DateTime.tryParse(_startDate.text)
                                      : null,
                              description: _descriptionController.text,
                              role: _roleController.text,
                            );
                        userProvider.addWorkExperience(newWorkExperience);
                      }
                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (workExperiences.isEmpty) ...[
                Center(child: Text('Add a new work experience!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingWorkExperiences(context),
              ],
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingWorkExperiences(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

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
                  selectedWorkExperience = p;
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedWorkExperience = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MyEditWorkExperienceScreen(
                          workExperience: selectedWorkExperience!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedWorkExperience ? 5 : 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.name),
                    Text(p.dateBegun.toString().split(' ')[0]),
                    Text(
                      p.dateEnded != null
                          ? p.dateEnded!.toString().split(' ')[0]
                          : 'Unknown',
                    ),
                    Text(p.description),
                    Text(p.role),
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
    ThemeData theme = Theme.of(context);

    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name of work experience',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _roleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Role in work experience',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _startDate,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start Date (required)',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_startDate, context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _endDate,
              decoration: InputDecoration(
                // border: OutlineInputBorder(),
                labelText: 'End Date (optional)',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectDate(_endDate, context);
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

  DateTime? getParsedStartDate() {
    if (_startDate.text.isEmpty) return null;
    try {
      return DateTime.parse(_startDate.text);
    } catch (e) {
      return null; // Handle invalid format safely
    }
  }
}
