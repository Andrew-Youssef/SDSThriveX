import 'package:flutter/material.dart';
import 'package:screens/core/models/workexperience_model.dart';
import 'package:screens/providers/user_provider.dart';
import 'package:screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditWorkExperienceScreen extends StatefulWidget {
  final WorkExperienceModel workExperience;

  const MyEditWorkExperienceScreen({super.key, required this.workExperience});

  @override
  State<MyEditWorkExperienceScreen> createState() =>
      _MyEditWorkExperienceScreenState();
}

class _MyEditWorkExperienceScreenState
    extends State<MyEditWorkExperienceScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workExperience.name);
    _roleController = TextEditingController(text: widget.workExperience.role);
    _descriptionController = TextEditingController(
      text: widget.workExperience.description,
    );
    _startDate = TextEditingController(
      text: widget.workExperience.dateBegun.toString().split(' ')[0],
    );
    _endDate = TextEditingController(
      text:
          widget.workExperience.dateEnded?.toString().split(' ')[0] ??
          'Ongoing',
    );
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Work Experience', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      userProvider.removeWorkExperience(widget.workExperience);
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
              buildInputFields(context),
            ],
          ),
        ),
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
              onChanged: widget.workExperience.updateName,
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of project',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.workExperience.updateRole,
              controller: _roleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Image URL (figure out later)',
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
              onChanged: widget.workExperience.updateDescription,
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
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
    final Map<TextEditingController, void Function(DateTime)> updaterMap = {
      _startDate: widget.workExperience.updateDateBegun,
      _endDate: widget.workExperience.updateDateEnded,
    };
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(" ")[0];
        updaterMap[controller]!.call(picked);
      });
    }
  }
}
