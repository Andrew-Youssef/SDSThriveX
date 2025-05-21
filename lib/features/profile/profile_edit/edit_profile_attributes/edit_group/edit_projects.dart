import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/project_model.dart';
import '../../edit_profile_attributes/edit_individual/edit_project.dart';
import '../../../../../widgets/header.dart';
import '../../../../../providers/user_provider.dart';

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
    //it should be impossible for new data to have been loaded,
    //ie projects list is still valid.
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.loadProjects(userProvider.profile!.userId);
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
    // userProvider.loadProjects(userProvider.profile!.userId);
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
                              print(
                                "selectedProject trash Id: ${selectedProject!.id}\n",
                              );
                              userProvider.removeProject(selectedProject!.id);
                              // userProvider.loadProjects(
                              //   userProvider.profile!.userId,
                              // );
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
                          id: '',
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
                  print("onTap selectedProject Id: ${selectedProject!.id}\n");
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedProject = p;
                  print(
                    "onLongPress selectedProject Id: ${selectedProject!.id}\n",
                  );
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
