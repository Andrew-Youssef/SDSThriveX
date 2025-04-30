import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditProjectsScreen extends StatefulWidget {
  const MyEditProjectsScreen({super.key});

  @override
  State<MyEditProjectsScreen> createState() => _MyEditProjectsScreenState();
}

class _MyEditProjectsScreenState extends State<MyEditProjectsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  ProjectModel? selectedProject;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<ProjectModel> projects = userProvider.projects;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Projects', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed:
                        projects.isEmpty
                            ? null
                            : () {
                              userProvider.removeProject(selectedProject!);
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_nameController.text.isNotEmpty &&
                          _startDate.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        ProjectModel newProject = ProjectModel(
                          name: _nameController.text,
                          dateBegun: DateTime.tryParse(_startDate.text)!,
                          dateEnded:
                              _endDate.text.isNotEmpty
                                  ? DateTime.tryParse(_startDate.text)
                                  : null,
                          description: _descriptionController.text,
                          imageUrl: _imageController.text,
                        );
                        userProvider.addProject(newProject);
                      }
                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (projects.isEmpty) ...[
                Center(child: Text('Add a new project!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingProjects(context),
              ],
              Expanded(child: buildInputFields(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingProjects(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<ProjectModel> projects = userProvider.projects;

    return SizedBox(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in projects) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedProject = p;
                });
                // print('yoooooo');
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedProject ? 5 : 3,
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
                    Text(p.imageUrl != null ? p.imageUrl! : 'Unknown'),
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

    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Name of project',
          ),
        ),
        TextField(
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
        TextField(
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
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Description',
          ),
        ),
        TextField(
          controller: _imageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Image URL (figure out later)',
          ),
        ),
      ],
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
