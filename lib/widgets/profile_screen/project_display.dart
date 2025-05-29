import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/core/models/project_model.dart';
import 'package:thrivex/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyExistingProjectsWidget extends StatefulWidget {
  final UserProvider selectedUserProvider;

  const MyExistingProjectsWidget({
    super.key,
    required this.selectedUserProvider,
  });

  @override
  State<MyExistingProjectsWidget> createState() =>
      _MyExistingProjectsWidgetState();
}

class _MyExistingProjectsWidgetState extends State<MyExistingProjectsWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isLoggedInUser = false;
  bool _hadLoadedProfile = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hadLoadedProfile) {
      UserProvider userProvider = Provider.of<UserProvider>(context);
      _isLoggedInUser =
          userProvider.userId == widget.selectedUserProvider.userId;
      _hadLoadedProfile = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<ProjectModel> projects = widget.selectedUserProvider.projects;
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
                  project.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present";

              return Column(
                children: [
                  const Divider(thickness: 1),
                  InkWell(
                    onDoubleTap:
                        _isLoggedInUser
                            ? () {
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
                    onLongPress:
                        _isLoggedInUser
                            ? () {
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
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                  ),
                ],
              );
            }).toList(),
      );
    }
  }
}
