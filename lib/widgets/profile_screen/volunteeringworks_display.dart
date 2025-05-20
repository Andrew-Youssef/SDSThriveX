import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/volunteering_work_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_volunteering_work.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingVolunteeringWorksWidget extends StatefulWidget {
  final String selectedUserId;

  const MyExistingVolunteeringWorksWidget({
    super.key,
    required this.selectedUserId,
  });

  @override
  State<MyExistingVolunteeringWorksWidget> createState() =>
      _MyExistingVolunteeringWorksWidgetState();
}

class _MyExistingVolunteeringWorksWidgetState
    extends State<MyExistingVolunteeringWorksWidget> {
  VolunteeringWorkModel? selectedVolunteeringWork;
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
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        selectedUserProvider!.volunteeringWorks;

    if (volunteeringWorks.isEmpty) {
      return Text(
        'Add some volunteering work!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            volunteeringWorks.map((work) {
              final String startDate =
                  '${work.dateStarted.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${work.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap:
                    _isLoggedInUser
                        ? () {
                          if (selectedVolunteeringWork == work) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyEditVolunteeringWorkScreen(
                                      volunteeringWork: work,
                                    ),
                              ),
                            );
                          }
                          setState(() {
                            selectedVolunteeringWork = work;
                          });
                        }
                        : null,
                onLongPress:
                    _isLoggedInUser
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MyEditVolunteeringWorkScreen(
                                    volunteeringWork: work,
                                  ),
                            ),
                          );
                        }
                        : null,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        work == selectedVolunteeringWork
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
                              work.institutionName,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                      Text(work.role, style: theme.textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Text(
                        work.description,
                        style: theme.textTheme.displayMedium,
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
