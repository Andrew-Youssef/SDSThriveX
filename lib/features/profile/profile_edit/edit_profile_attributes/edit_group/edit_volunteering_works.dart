import 'package:flutter/material.dart';
import '../../../../../core/models/volunteering_work_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

import '../../edit_profile_attributes/edit_individual/edit_volunteering_work.dart';

class MyEditVolunteeringWorksScreen extends StatefulWidget {
  const MyEditVolunteeringWorksScreen({super.key});

  @override
  State<MyEditVolunteeringWorksScreen> createState() =>
      _MyEditVolunteeringScreenState();
}

class _MyEditVolunteeringScreenState
    extends State<MyEditVolunteeringWorksScreen> {
  VolunteeringWorkModel? selectedVolunteering;
  late final TextEditingController _institutionController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  bool isOngoing = false;

  @override
  void initState() {
    super.initState();
    _institutionController = TextEditingController();
    _roleController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
  }

  @override
  void dispose() {
    _institutionController.dispose();
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
    List<VolunteeringWorkModel> volunteeringList =
        userProvider.volunteeringWorks;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Volunteering Work', context),
          body: ListView(
            children: [
              if (volunteeringList.isEmpty)
                Center(child: Text('Add a new volunteering entry!'))
              else
                showExistingVolunteeringWorks(context),
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  IconButton deleteButton(VolunteeringWorkModel v) {
    final userProvider = Provider.of<UserProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Deletion"),
              content: Text(
                "Are you sure you want to delete this volunteering work?",
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
                    userProvider.removeVolunteerWork(v.id);
                    setState(() {
                      selectedVolunteering = null;
                      _institutionController.clear();
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
      icon: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 42, 157, 143),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6),
        child: Icon(Icons.delete),
      ),
    );
  }

  Widget showExistingVolunteeringWorks(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> projects = userProvider.volunteeringWorks;

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
              constraints: BoxConstraints(maxWidth: 170),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      // 👈 centers 1- or 2-line text vertically
                      child: Text(
                        p.institutionName,
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
                                  (context) => MyEditVolunteeringWorkScreen(
                                    volunteeringWork: p,
                                  ),
                            ),
                          );
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 42, 157, 143),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.edit),
                        ),
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

  Widget buildInputFields(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        inputField(
          "Institution:",
          _institutionController,
          "Enter organization name",
          readOnly: selectedVolunteering != null,
        ),
        inputField("Role:", _roleController, "Enter your role"),
        dateField("Start Date:", _startDate, context),
        dateField("End Date:", _endDate, context, enabled: !isOngoing),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Text("Ongoing?"),
            SizedBox(width: 8),
            Checkbox(
              value: isOngoing,
              onChanged: (value) {
                setState(() {
                  isOngoing = value ?? false;
                  if (isOngoing) _endDate.clear();
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
        inputField(
          "Description:",
          _descriptionController,
          "Enter description",
          multiline: true,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_institutionController.text.isNotEmpty &&
                    _roleController.text.isNotEmpty &&
                    _startDate.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  VolunteeringWorkModel newEntry = VolunteeringWorkModel(
                    id: '',
                    institutionName: _institutionController.text,
                    role: _roleController.text,
                    dateStarted: DateTime.tryParse(_startDate.text)!,
                    dateEnded:
                        isOngoing ? null : DateTime.tryParse(_endDate.text),
                    description: _descriptionController.text,
                  );
                  Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).addVolunteerWork(newEntry);
                  _institutionController.clear();
                  _roleController.clear();
                  _descriptionController.clear();
                  _startDate.clear();
                  _endDate.clear();
                  setState(() {
                    isOngoing = false;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in all required fields."),
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
                'Add new entry!',
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

  Widget inputField(
    String label,
    TextEditingController controller,
    String hint, {
    bool readOnly = false,
    bool multiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: multiline ? 3 : 1,
            maxLines: multiline ? 5 : 1,
            decoration: customInputDecoration(hint),
          ),
        ],
      ),
    );
  }

  Widget dateField(
    String label,
    TextEditingController controller,
    BuildContext context, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          SizedBox(height: 6),
          TextField(
            controller: controller,
            enabled: enabled,
            readOnly: true,
            onTap: enabled ? () => _selectDate(controller, context) : null,
            decoration: customInputDecoration('DD / MM / YYYY'),
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

  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontStyle: FontStyle.italic,
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
}
