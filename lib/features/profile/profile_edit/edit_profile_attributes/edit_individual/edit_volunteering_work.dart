import 'package:flutter/material.dart';
import '../../../../../core/models/volunteering_work_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditVolunteeringWorkScreen extends StatefulWidget {
  final VolunteeringWorkModel volunteeringWork;

  const MyEditVolunteeringWorkScreen({
    super.key,
    required this.volunteeringWork,
  });

  @override
  State<MyEditVolunteeringWorkScreen> createState() =>
      _MyEditVolunteeringWorksScreenState();
}

class _MyEditVolunteeringWorksScreenState
    extends State<MyEditVolunteeringWorkScreen> {
  late final TextEditingController _institutionNameController;
  late final TextEditingController _roleController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _institutionNameController = TextEditingController(
      text: widget.volunteeringWork.institutionName,
    );
    _roleController = TextEditingController(text: widget.volunteeringWork.role);
    _descriptionController = TextEditingController(
      text: widget.volunteeringWork.description,
    );
    _startDate = TextEditingController(
      text: widget.volunteeringWork.dateStarted.toString().split(' ')[0],
    );
    _endDate = TextEditingController(
      text:
          widget.volunteeringWork.dateEnded?.toString().split(' ')[0] ??
          'Ongoing',
    );
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
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
                    onPressed: () {
                      userProvider.removeVolunteerWork(
                        widget.volunteeringWork.id,
                      );
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
              onChanged: widget.volunteeringWork.updateInstitutionName,
              controller: _institutionNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of Institution',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.volunteeringWork.updateRole,
              controller: _roleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Role in Insitution',
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
              onChanged: widget.volunteeringWork.updateDescription,
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
      _startDate: widget.volunteeringWork.updateDateStarted,
      _endDate: widget.volunteeringWork.updateDateEnded,
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
