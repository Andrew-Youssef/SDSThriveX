import 'package:flutter/material.dart';
import 'package:screens/core/models/volunteering_work_model.dart';
import 'package:screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_volunteering_work.dart';
import 'package:screens/providers/user_provider.dart';
import 'package:screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditVolunteeringWorksScreen extends StatefulWidget {
  const MyEditVolunteeringWorksScreen({super.key});

  @override
  State<MyEditVolunteeringWorksScreen> createState() =>
      _MyEditVolunteeringWorkScreenState();
}

class _MyEditVolunteeringWorkScreenState
    extends State<MyEditVolunteeringWorksScreen> {
  VolunteeringWorkModel? selectedVolunteeringWork;
  late final TextEditingController _institutionNameController;
  late final TextEditingController _roleController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _institutionNameController = TextEditingController();
    _roleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
  }

  @override
  void dispose() {
    _institutionNameController.dispose();
    _roleController.dispose();
    _startDate.dispose();
    _endDate.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        userProvider.volunteeringWork;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Volunteering Work', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed:
                        selectedVolunteeringWork == null
                            ? null
                            : () {
                              userProvider.removeVolunteeringWork(
                                selectedVolunteeringWork!,
                              );
                              selectedVolunteeringWork = null;
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_institutionNameController.text.isNotEmpty &&
                          _startDate.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        VolunteeringWorkModel newVolunteeringWork =
                            VolunteeringWorkModel(
                              institutionName: _institutionNameController.text,
                              dateStarted: DateTime.tryParse(_startDate.text)!,
                              dateEnded:
                                  _endDate.text.isNotEmpty
                                      ? DateTime.tryParse(_startDate.text)
                                      : null,
                              description: _descriptionController.text,
                              role: _roleController.text,
                            );
                        userProvider.addVolunteeringWork(newVolunteeringWork);
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
              if (volunteeringWorks.isEmpty) ...[
                Center(child: Text('Add new volunteering experience!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingVolunteeringWorks(context),
              ],
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingVolunteeringWorks(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        userProvider.volunteeringWork;

    return SizedBox(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in volunteeringWorks) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedVolunteeringWork = p;
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedVolunteeringWork = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MyEditVolunteeringWorkScreen(
                          volunteeringWork: selectedVolunteeringWork!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedVolunteeringWork ? 5 : 3,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p.institutionName),
                    Text(p.role),
                    Text(p.dateStarted.toString().split(' ')[0]),
                    Text(
                      p.dateEnded != null
                          ? p.dateEnded!.toString().split(' ')[0]
                          : 'Unknown',
                    ),
                    Text(p.description),
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
              controller: _institutionNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name of Institution',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _roleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Role in Institution',
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

  DateTime? getParsedStartDate() {
    if (_startDate.text.isEmpty) return null;
    try {
      return DateTime.parse(_startDate.text);
    } catch (e) {
      return null; // Handle invalid format safely
    }
  }
}
