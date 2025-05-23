import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/project_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingProjectsWidget extends StatefulWidget {
  final String selectedUserId;

  const MyExistingProjectsWidget({super.key, required this.selectedUserId});

  @override
  State<MyExistingProjectsWidget> createState() =>
      _MyExistingProjectsWidgetState();
}

class _MyExistingProjectsWidgetState extends State<MyExistingProjectsWidget> {
  ProjectModel? selectedProject;
  UserProvider? selectedUserProvider;
  bool _hadLoadedProfile = false;
  bool _isLoggedInUser = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      if (!_hadLoadedProfile) {
        _hadLoadedProfile = true;

        UserProvider userProvider = Provider.of<UserProvider>(context);
        if (widget.selectedUserId == userProvider.userId) {
          selectedUserProvider = userProvider;
          _isLoggedInUser = true;
          _isLoading = false;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            selectedUserProvider = UserProvider();
            await selectedUserProvider!.setTemporaryProfile(
              widget.selectedUserId,
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    List<ProjectModel> projects = selectedUserProvider!.projects;

    ThemeData theme = Theme.of(context);

    if (projects.isEmpty) {
      return Text('Add some projects!', style: theme.textTheme.displayMedium);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            projects.map((project) {
              final String startDate =
                  '${project.dateBegun.toLocal().toString().split(' ')[0]} - ';
              final String endDate =
                  '${project.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap:
                    _isLoggedInUser
                        ? () {
                          if (selectedProject == project) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MyEditProjectScreen(project: project),
                              ),
                            );
                          }
                          setState(() {
                            selectedProject = project;
                          });
                        }
                        : null,
                onLongPress:
                    _isLoggedInUser
                        ? () {
                          setState(() {
                            selectedProject = project;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MyEditProjectScreen(project: project),
                            ),
                          );
                        }
                        : null,
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
