import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/volunteering_work_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_volunteering_work.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingVolunteeringWorksWidget extends StatefulWidget {
  const MyExistingVolunteeringWorksWidget({super.key});

  @override
  State<MyExistingVolunteeringWorksWidget> createState() =>
      _MyExistingVolunteeringWorksWidgetState();
}

class _MyExistingVolunteeringWorksWidgetState
    extends State<MyExistingVolunteeringWorksWidget> {
  VolunteeringWorkModel? selectedVolunteeringWork;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        userProvider.volunteeringWorks;

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
                onTap: () {
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
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditVolunteeringWorkScreen(
                            volunteeringWork: work,
                          ),
                    ),
                  );
                },
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
