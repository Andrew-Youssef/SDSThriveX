import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/volunteering_work_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditVolunteeringScreen extends StatefulWidget {
  const MyEditVolunteeringScreen({super.key});

  @override
  State<MyEditVolunteeringScreen> createState() => _MyEditVolunteeringScreenState();
}

class _MyEditVolunteeringScreenState extends State<MyEditVolunteeringScreen> {
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
    List<VolunteeringWorkModel> volunteeringList = userProvider.volunteeringWork;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // Allow user to go back without restriction
            return true;
          },
          child: Scaffold(
            appBar: myAppBar('Edit Volunteering Work', context),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: SizedBox()),
                    IconButton(
                      onPressed: selectedVolunteering == null
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Deletion"),
                                    content: Text("Are you sure you want to delete this entry?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          userProvider.removeVolunteeringWork(selectedVolunteering!);
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
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_institutionController.text.isNotEmpty &&
                            _roleController.text.isNotEmpty &&
                            _startDate.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty) {
                          VolunteeringWorkModel newEntry = VolunteeringWorkModel(
                            institutionName: _institutionController.text,
                            role: _roleController.text,
                            dateStarted: DateTime.tryParse(_startDate.text)!,
                            dateEnded: isOngoing ? null : DateTime.tryParse(_endDate.text),
                            description: _descriptionController.text,
                          );
                          userProvider.addVolunteeringWork(newEntry);
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
                      icon: Icon(Icons.add_box),
                    ),
                  ],
                ),
                if (volunteeringList.isEmpty)
                  Center(child: Text('Add a new volunteering entry!'))
                else
                  showExistingVolunteering(context),
                buildInputFields(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showExistingVolunteering(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> list = Provider.of<UserProvider>(context).volunteeringWork;

    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(8),
        children: list.map((v) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedVolunteering = v;
                _institutionController.text = v.institutionName;
                _roleController.text = v.role;
                _descriptionController.text = v.description;
                _startDate.text = v.dateStarted.toString().split(" ")[0];
                _endDate.text = v.dateEnded?.toString().split(" ")[0] ?? '';
                isOngoing = v.dateEnded == null;
              });
            },
            child: Container(
              width: 150,
              margin: EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryColor,
                  width: v == selectedVolunteering ? 5 : 3,
                ),
              ),
              child: Text(
                v.institutionName,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Expanded(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          inputField("Institution:", _institutionController, "Enter organization name", readOnly: selectedVolunteering != null),
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
          inputField("Description:", _descriptionController, "Enter description", multiline: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_institutionController.text.isNotEmpty &&
                    _roleController.text.isNotEmpty &&
                    _startDate.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  VolunteeringWorkModel newEntry = VolunteeringWorkModel(
                    institutionName: _institutionController.text,
                    role: _roleController.text,
                    dateStarted: DateTime.tryParse(_startDate.text)!,
                    dateEnded: isOngoing ? null : DateTime.tryParse(_endDate.text),
                    description: _descriptionController.text,
                  );
                  Provider.of<UserProvider>(context, listen: false).addVolunteeringWork(newEntry);
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
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField(String label, TextEditingController controller, String hint,
      {bool readOnly = false, bool multiline = false}) {
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
            decoration: customInputDecoration(hint).copyWith(
              suffixIcon: readOnly
                  ? Tooltip(
                      message: "$label can't be edited",
                      child: Icon(Icons.lock, color: Colors.grey),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateField(String label, TextEditingController controller, BuildContext context, {bool enabled = true}) {
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

  Future<void> _selectDate(TextEditingController controller, BuildContext context) async {
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

      if (controller == _endDate && startDate != null && picked.isBefore(startDate)) {
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
      hintStyle: TextStyle(fontStyle: FontStyle.italic, color: Colors.black.withOpacity(0.3)),
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
