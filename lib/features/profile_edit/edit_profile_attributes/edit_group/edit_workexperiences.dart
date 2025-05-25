import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/workexperience_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditWorkExperiencesScreen extends StatefulWidget {
  const MyEditWorkExperiencesScreen({super.key});

  @override
  State<MyEditWorkExperiencesScreen> createState() => _MyEditWorkExperiencesScreenState();
}

class _MyEditWorkExperiencesScreenState extends State<MyEditWorkExperiencesScreen> {
  WorkExperienceModel? selectedWorkExperience;
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _roleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _descriptionController.dispose();
    _startDate.dispose();
    _endDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: () async {
            final hasNamedWorkExperience = userProvider.workExperiences.any((w) => w.name.trim().isNotEmpty);

            if (!hasNamedWorkExperience) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please add at least one work experience with a name before going back."),
                  backgroundColor: Colors.red,
                ),
              );
              return false; // Prevent back navigation
            }

            return true; // Allow back navigation
          },
          child: Scaffold(
            appBar: myAppBar('Edit Work Experience', context),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: selectedWorkExperience == null
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Deletion"),
                                  content: Text("Are you sure you want to delete this work experience?"),
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
                                        userProvider.removeWorkExperience(selectedWorkExperience!);
                                        setState(() {
                                          selectedWorkExperience = null;
                                          _nameController.clear();
                                          _roleController.clear();
                                          _descriptionController.clear();
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
                            _roleController.text.isNotEmpty &&
                            _startDate.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
                          WorkExperienceModel newWorkExperience = WorkExperienceModel(
                            name: _nameController.text,
                            role: _roleController.text,
                            dateBegun: DateTime.tryParse(_startDate.text)!,
                            dateEnded:
                                _endDate.text.isNotEmpty
                                    ? DateTime.tryParse(_endDate.text)
                                    : null,
                            description: _descriptionController.text,
                          );
                          userProvider.addWorkExperience(newWorkExperience);
                        }

                        if (_nameController.text.isEmpty ||
                          _roleController.text.isEmpty ||
                          _startDate.text.isEmpty ||
                          _descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter company name, role, description, and start date."),
                            backgroundColor: Colors.red,
                          ),
                        );
                          };
                      },
                      icon: Icon(Icons.add_box),
                    ),
                  ],
                ),
                if (workExperiences.isEmpty) ...[
                  Center(child: Text('Add a new work experience!')),
                  SizedBox(height: 20),
                ] else ...[
                  showExistingWorkExperiences(context),
                ],
                buildInputFields(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showExistingWorkExperiences(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context);
  ThemeData theme = Theme.of(context);
  List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

  return SizedBox(
    height: 200,
    child: ListView(
      padding: EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      children: [
        for (final w in workExperiences) ...[
          Container(
            width: 160,
            padding: EdgeInsets.all(12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: theme.primaryColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  w.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
              ],
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
        // Company Name field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company Name:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _nameController,
                readOnly: selectedWorkExperience != null,
                decoration: customInputDecoration('Enter company name').copyWith(
                  suffixIcon: selectedWorkExperience != null
                      ? Tooltip(
                          message: "Company name can't be edited",
                          child: Icon(Icons.lock, color: Colors.grey),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),

        // Role field
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Role:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 6),
              TextField(
                controller: _roleController,
                decoration: customInputDecoration('Enter your role'),
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
                    activeColor: Color.fromARGB(255, 42, 157, 143),
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
                    'Enter a short description of your work experience'),
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
                  _roleController.text.isNotEmpty &&
                  _startDate.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty) {
                WorkExperienceModel newWorkExperience = WorkExperienceModel(
                  name: _nameController.text,
                  role: _roleController.text,
                  dateBegun: DateTime.tryParse(_startDate.text)!,
                  dateEnded: isOngoing ? null : DateTime.tryParse(_endDate.text),
                  description: _descriptionController.text,
                );
                Provider.of<UserProvider>(context, listen: false)
                    .addWorkExperience(newWorkExperience);
                
                // Clear fields and show success message
                _nameController.clear();
                _roleController.clear();
                _descriptionController.clear();
                _startDate.clear();
                _endDate.clear();
                setState(() {
                  isOngoing = false;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Work experience added successfully!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        "Please enter company name, role, description, and start date."),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 42, 157, 143),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.black, width: 2),
              ),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Add new work experience!',
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