import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditProjectsScreen extends StatefulWidget {
  const MyEditProjectsScreen({super.key});

  @override
  State<MyEditProjectsScreen> createState() => _MyEditProjectsScreenState();
}

class _MyEditProjectsScreenState extends State<MyEditProjectsScreen> {
  ProjectModel? selectedProject;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

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
                        selectedProject == null
                            ? null
                            : () {
                              userProvider.removeProject(selectedProject!);
                              selectedProject = null;
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
                                  ? DateTime.tryParse(_endDate.text)
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
              // Expanded(
              //   child: ListView(
              //     children: [
              //       if (projects.isEmpty) ...[
              //         Center(child: Text('Add a new project!')),
              //         SizedBox(height: 20),
              //       ] else ...[
              //         showExistingProjects(context),
              //       ],
              //       buildInputFields(context),
              //     ],
              //   ),
              // ),
              if (projects.isEmpty) ...[
                Center(child: Text('Add a new project!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingProjects(context),
              ],
              buildInputFields(context),
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
              onLongPress: () {
                setState(() {
                  selectedProject = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            MyEditProjectScreen(project: selectedProject!),
                  ),
                );
              },
              child: Container(
                 alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedProject ? 5 : 3,
                  ),
                ),
                child: Text(
                  p.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal, // not bold
                      
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
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
                hintText: 'Name of project',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _imageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Image URL (figure out later)',
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
    DateTime initialDate = DateTime.now();

    // Try to parse the controller's current value for better UX
    try {
      initialDate = DateTime.parse(controller.text);
    } catch (_) {}

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      DateTime? startDate;
      try {
        startDate = DateTime.parse(_startDate.text);
      } catch (_) {}

      if (controller == _endDate &&
          startDate != null &&
          picked.isBefore(startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("End date cannot be before start date."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        controller.text = picked.toString().split(" ")[0];
      });
    }
  }
}
