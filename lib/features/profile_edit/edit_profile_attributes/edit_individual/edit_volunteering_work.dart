import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/volunteering_work_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
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
      text: _formatDateToDDMMYYYY(widget.volunteeringWork.dateStarted),
    );
    _endDate = TextEditingController(
      text: widget.volunteeringWork.dateEnded != null 
          ? _formatDateToDDMMYYYY(widget.volunteeringWork.dateEnded!)
          : '',
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
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Volunteering Work"),
                            content: const Text("Are you sure you want to delete this volunteering work? This action cannot be undone."),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text("Delete", style: TextStyle(color: Colors.white)),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        userProvider.removeVolunteeringWork(widget.volunteeringWork);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
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
    final theme = Theme.of(context);
    bool isOngoing = _endDate.text.isEmpty;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLabeledField(
            'Institution Name:',
            _institutionNameController,
            'Enter institution name',
            onChanged: widget.volunteeringWork.updateInstitutionName,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Role:',
            _roleController,
            'Enter your role',
            onChanged: widget.volunteeringWork.updateRole,
          ),
          const SizedBox(height: 12),
          _buildLabeledDateField(
            'Date started:',
            _startDate,
            context,
            (date) => widget.volunteeringWork.updateDateStarted(date),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField(
                  'Date ended:',
                  _endDate,
                  context,
                  (date) => widget.volunteeringWork.updateDateEnded(date),
                  enabled: !isOngoing,
                ),
              ),
              const SizedBox(width: 8),
              const Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text("Ongoing?"),
                  Checkbox(
                    value: isOngoing,
                    onChanged: (value) {
                      setState(() {
                        isOngoing = value!;
                        if (isOngoing) {
                          _endDate.clear();
                          widget.volunteeringWork.updateDateEnded(null);
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Color.fromARGB(255, 42, 157, 143)),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Description:',
            _descriptionController,
            'Enter a description of your volunteering work',
            onChanged: widget.volunteeringWork.updateDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _confirmChanges(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 42, 157, 143),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Confirm changes?',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller, String hint,
      {void Function(String)? onChanged, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDateField(String label, TextEditingController controller, BuildContext context,
      void Function(DateTime) onDateSelected, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: true,
          enabled: enabled,
          onTap: () async {
            if (!enabled) return;
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              // Check if end date is before start date
              if (controller == _endDate) {
                final currentStart = DateTime.tryParse(_startDate.text);
                if (currentStart != null && picked.isBefore(currentStart)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('End date cannot be before start date.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
              }
              
              controller.text = _formatDateToDDMMYYYY(picked);
              onDateSelected(picked);
            }
          },
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  String _formatDateToDDMMYYYY(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _confirmChanges() {
    widget.volunteeringWork.updateInstitutionName(_institutionNameController.text);
    widget.volunteeringWork.updateRole(_roleController.text);
    widget.volunteeringWork.updateDescription(_descriptionController.text);
    // Dates are already updated in the date selection methods

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved")),
    );

    Navigator.pop(context);
  }
}