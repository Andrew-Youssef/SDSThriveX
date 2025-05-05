import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screens/core/models/project_model.dart';
import 'package:screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:screens/providers/user_provider.dart';
import 'package:screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditProjectsScreen extends StatefulWidget {
  const MyEditProjectsScreen({super.key});

  @override
  State<MyEditProjectsScreen> createState() => _MyEditProjectsScreenState();
}

class _MyEditProjectsScreenState extends State<MyEditProjectsScreen> {
  String? selectedProjectId;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  final String userId = FirebaseAuth.instance.currentUser!.uid;

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

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('projects')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No projects found.', style: theme.textTheme.displayMedium),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditProjectScreen(
                            project: ProjectModel(
                              id: '',
                              name: '',
                              dateBegun: DateTime.now(),
                              dateEnded: null,
                              description: '',
                              imageUrl: '',
                            ),
                          ),
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add Your First Project'),
              ),
            ],
          );
        } else {
          final projects =
              snapshot.data!.docs
                  .map(
                    (doc) => ProjectModel.convertMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();

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
                              selectedProjectId == null
                                  ? null
                                  : () {
                                    userProvider.removeProject(
                                      selectedProjectId!,
                                    );

                                    setState(() {
                                      selectedProjectId = null;
                                    });
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
      },
    );
  }

  Widget showExistingProjects(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('projects')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            'No projects found.',
            style: theme.textTheme.displayMedium,
          );
        } else {
          final projects =
              snapshot.data!.docs
                  .map(
                    (doc) => ProjectModel.convertMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ),
                  )
                  .toList();
          return SizedBox(
            height: 200,
            child: ListView(
              padding: EdgeInsets.all(8.0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                for (final project in projects) ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedProjectId = project.id;
                      });
                      // print('yoooooo');
                    },
                    onLongPress: () {
                      setState(() {
                        selectedProjectId = project.id;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  MyEditProjectScreen(project: project),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: theme.primaryColor,
                          width: project.id == selectedProjectId ? 5 : 3,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(project.name),
                          Text(project.dateBegun.toString().split(' ')[0]),
                          Text(
                            project.dateEnded != null
                                ? project.dateEnded!.toString().split(' ')[0]
                                : 'Unknown',
                          ),
                          Text(project.description),
                          Text(
                            project.imageUrl != null
                                ? project.imageUrl!
                                : 'Unknown',
                          ),
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
      },
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
