import 'package:flutter/material.dart';
import '../../../../../core/models/workexperience_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

import '../edit_individual/edit_workexperience.dart';

class MyEditWorkExperiencesScreen extends StatefulWidget {
  const MyEditWorkExperiencesScreen({super.key});

  @override
  State<MyEditWorkExperiencesScreen> createState() =>
      _MyEditWorkExperiencesScreenState();
}

class _MyEditWorkExperiencesScreenState
    extends State<MyEditWorkExperiencesScreen> {
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
        child: Scaffold(
          appBar: myAppBar('Edit Work Experience', context),
          body: ListView(
            children: [
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
    );
  }

  Widget showExistingWorkExperiences(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> projects = userProvider.workExperiences;

    return SizedBox(
      height: 160,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in projects) ...[
            Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(maxWidth: 130),
              decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      // 👈 centers 1- or 2-line text vertically
                      child: Text(
                        p.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign:
                            TextAlign.center, // 👈 centers text horizontally
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deleteButton(p),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MyEditWorkExperienceScreen(
                                    workExperience: p,
                                  ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconButton deleteButton(WorkExperienceModel w) {
    final userProvider = Provider.of<UserProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Deletion"),
              content: Text(
                "Are you sure you want to delete this work experience?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    userProvider.removeWorkExperience(w.id);
                    setState(() {
                      selectedWorkExperience = null;
                      _nameController.clear();
                      _roleController.clear();
                      _descriptionController.clear();
                      _startDate.clear();
                      _endDate.clear();
                    });
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.delete),
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
    return Column(
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
                decoration: customInputDecoration('Enter company name'),
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
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                  'Enter a short description of your work experience',
                ),
              ),
            ],
          ),
        ),

        // Add button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _roleController.text.isNotEmpty &&
                    _startDate.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  WorkExperienceModel newWorkExperience = WorkExperienceModel(
                    id: '',
                    name: _nameController.text,
                    role: _roleController.text,
                    dateBegun: DateTime.tryParse(_startDate.text)!,
                    dateEnded:
                        isOngoing ? null : DateTime.tryParse(_endDate.text),
                    description: _descriptionController.text,
                  );
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).addWorkExperience(newWorkExperience);

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
                        "Please enter company name, role, description, and start date.",
                      ),
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
        ),
      ],
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
