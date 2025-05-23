import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class MyExistingProjectsWidget extends StatefulWidget {
  const MyExistingProjectsWidget({super.key});

  @override
  State<MyExistingProjectsWidget> createState() =>
      _MyExistingProjectsWidgetState();
}

class _MyExistingProjectsWidgetState extends State<MyExistingProjectsWidget> {
  ProjectModel? selectedProject;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<ProjectModel> projects = userProvider.projects;

    if (projects.isEmpty) {
      return Text('Add some projects!', style: theme.textTheme.displayMedium);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            projects.map((project) {

              final dateFormatter = DateFormat('dd/MM/yyyy');
              final String startDate = '${dateFormatter.format(project.dateBegun)} - ';
              final String endDate = project.dateEnded != null
                  ? dateFormatter.format(project.dateEnded!)
                  : "Present";

              return GestureDetector(
                onTap: () {
                  if (selectedProject == project) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyEditProjectScreen(project: project),
                      ),
                    );
                  }
                  setState(() {
                    selectedProject = project;
                  });
                },
                onLongPress: () {
                  setState(() {
                    selectedProject = project;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditProjectScreen(project: project),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        project == selectedProject
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              project.name,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                startDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      if (project.imageUrl != null &&
                          project.imageUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              project.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }
}
