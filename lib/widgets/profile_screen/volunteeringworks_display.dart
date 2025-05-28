import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/core/models/volunteering_work_model.dart';
import 'package:thrivex/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_volunteering_work.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyExistingVolunteeringWorksWidget extends StatefulWidget {
  final UserProvider selectedUserProvider;

  const MyExistingVolunteeringWorksWidget({
    super.key,
    required this.selectedUserProvider,
  });

  @override
  State<MyExistingVolunteeringWorksWidget> createState() =>
      _MyExistingVolunteeringWorksWidgetState();
}

class _MyExistingVolunteeringWorksWidgetState
    extends State<MyExistingVolunteeringWorksWidget>
    with AutomaticKeepAliveClientMixin {
  bool _hadLoadedProfile = false;
  bool _isLoggedInUser = false;

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
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        widget.selectedUserProvider.volunteeringWorks;

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

              return InkWell(
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
                borderRadius: BorderRadius.circular(12),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1),
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
