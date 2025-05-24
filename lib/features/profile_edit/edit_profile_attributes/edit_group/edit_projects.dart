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
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            final hasNamedProject = userProvider.projects.any((p) => p.name.trim().isNotEmpty);

            if (!hasNamedProject) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please add at least one project with a name before going back."),
                  backgroundColor: Colors.red,
                ),
              );
              return false; // Prevent back navigation
            }

            return true; // Allow back navigation
          },
          child: Scaffold(
            appBar: myAppBar('Edit Projects', context),
            body: Column(
      children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: selectedProject == null
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text("Are you sure you want to delete this project?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close dialog
                                      userProvider.removeProject(selectedProject!);
                                      setState(() {
                                        selectedProject = null;
                                        _nameController.clear();
                                        _descriptionController.clear();
                                        _imageController.clear();
                                        _startDate.clear();
                                        _endDate.clear();
                                      });
                                    },
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
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
                        
                        // Clear fields and show success message
                        _nameController.clear();
                        _descriptionController.clear();
                        _imageController.clear();
                        _startDate.clear();
                        _endDate.clear();
                        setState(() {
                          isOngoing = false;
                        });
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Project added successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }

                      if (_nameController.text.isEmpty ||
                        _startDate.text.isEmpty ||
                        _descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter name, description, and start date."),
                          backgroundColor: Colors.red,
                        ),
                      );
                        };
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
                  _nameController.text = p.name;
                  _descriptionController.text = p.description;
                  _imageController.text = p.imageUrl ?? '';
                  _startDate.text = p.dateBegun.toString().split(' ')[0];
                  _endDate.text = p.dateEnded?.toString().split(' ')[0] ?? '';
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

  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontStyle: FontStyle.italic,
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.3),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  bool isOngoing = false; // toggles ongoing checkbox

  Widget buildInputFields(BuildContext context) {
  ThemeData theme = Theme.of(context);

  return Expanded(
    child: ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        // Title field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Name:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _nameController,
                readOnly: selectedProject != null,
                decoration: customInputDecoration('Enter project name').copyWith(
                  suffixIcon: selectedProject != null
                      ? Tooltip(
                          message: "Project name can't be edited",
                          child: Icon(Icons.lock, color: Colors.grey),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),

        // Start Date
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date begun:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _startDate,
                decoration: customInputDecoration('DD / MM / YYYY'),
                readOnly: true,
                onTap: () {
                  _selectDate(_startDate, context);
                },
              ),
            ],
          ),
        ),

        // End Date + Ongoing checkbox
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date ended:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _endDate,
                enabled: !isOngoing,
                decoration: customInputDecoration('DD / MM / YYYY'),
                readOnly: true,
                onTap: () {
                  if (!isOngoing) _selectDate(_endDate, context);
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  Text("Ongoing?"),
                  SizedBox(width: 8),
                  Checkbox(
                    value: isOngoing,
                    onChanged: (bool? value) {
                      setState(() {
                        isOngoing = value ?? false;
                        if (isOngoing) {
                          _endDate.clear();
                        }
                      });
                    },
                    activeColor: Colors.cyan,
                    side: BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Description
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: customInputDecoration(
                    'Enter a short description of your project'),
              ),
            ],
          ),
        ),

        // Add button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _startDate.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty) {
                ProjectModel newProject = ProjectModel(
                  name: _nameController.text,
                  dateBegun: DateTime.tryParse(_startDate.text)!,
                  dateEnded: isOngoing ? null : DateTime.tryParse(_endDate.text),
                  description: _descriptionController.text,
                  imageUrl: _imageController.text,
                );
                Provider.of<UserProvider>(context, listen: false)
                    .addProject(newProject);
                
                // Clear fields and show success message
                _nameController.clear();
                _descriptionController.clear();
                _imageController.clear();
                _startDate.clear();
                _endDate.clear();
                setState(() {
                  isOngoing = false;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Project added successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Please enter name, description, and start date."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.black, width: 2),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Add new project!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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