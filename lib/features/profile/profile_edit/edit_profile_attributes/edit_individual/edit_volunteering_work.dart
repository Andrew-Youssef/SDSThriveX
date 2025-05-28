import 'package:flutter/material.dart';
import '../../../../../core/models/volunteering_work_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyEditVolunteeringWorkScreen extends StatefulWidget {
  final VolunteeringWorkModel volunteeringWork;

  const MyEditVolunteeringWorkScreen({
    super.key,
    required this.volunteeringWork,
  });

  @override
  State<MyEditVolunteeringWorkScreen> createState() =>
      _MyEditVolunteeringWorkScreenState();
}

class _MyEditVolunteeringWorkScreenState
    extends State<MyEditVolunteeringWorkScreen> {
  late final TextEditingController _institutionNameController;
  late final TextEditingController _roleController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _descriptionController;

  bool _isOngoing = false;

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
      text:
          widget.volunteeringWork.dateEnded != null
              ? _formatDateToDDMMYYYY(widget.volunteeringWork.dateEnded!)
              : '',
    );
    _isOngoing = widget.volunteeringWork.dateEnded == null;
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
    final theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Volunteering Work', context),
          body: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Volunteering Work"),
                            content: const Text(
                              "Are you sure you want to delete this volunteering work? This action cannot be undone.",
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        userProvider.removeVolunteerWork(
                          widget.volunteeringWork.id,
                        );
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

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLabeledField(
            'Institution Name:',
            _institutionNameController,
            'Enter institution name',
          ),
          const SizedBox(height: 12),
          _buildLabeledField('Role:', _roleController, 'Enter your role'),
          const SizedBox(height: 12),
          _buildLabeledDateField('Date started:', _startDate, context),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField(
                  'Date ended:',
                  _endDate,
                  context,
                  enabled: !_isOngoing,
                ),
              ),
              const SizedBox(width: 8),
              const Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text("Ongoing?"),
                  Checkbox(
                    value: _isOngoing,
                    onChanged: (value) {
                      setState(() {
                        _isOngoing = value!;
                        if (_isOngoing) {
                          _endDate.clear();
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 42, 157, 143),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Description:',
            _descriptionController,
            'Enter a description of your volunteering work',
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _confirmChanges(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 42, 157, 143),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Confirm changes?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDateField(
    String label,
    TextEditingController controller,
    BuildContext context, {
    bool enabled = true,
  }) {
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
              controller.text = _formatDateToDDMMYYYY(picked);
            }
          },
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateToDDMMYYYY(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  DateTime? _parseDateFromDDMMYYYY(String dateString) {
    if (dateString.isEmpty) return null;
    try {
      final parts = dateString.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  Future<void> _confirmChanges() async {
    final userProvder = Provider.of<UserProvider>(context, listen: false);
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final start = dateFormatter.parse(_startDate.text);

    widget.volunteeringWork.updateInstitutionName(
      _institutionNameController.text,
    );
    widget.volunteeringWork.updateRole(_roleController.text);
    widget.volunteeringWork.updateDescription(_descriptionController.text);
    widget.volunteeringWork.updateDateStarted(start);

    if (_endDate.text.isNotEmpty && !_isOngoing) {
      final end = dateFormatter.parse(_endDate.text);
      widget.volunteeringWork.updateDateEnded(end);
    } else {
      widget.volunteeringWork.updateDateEnded(null);
    }

    await userProvder.updateVolunteerWork(widget.volunteeringWork.id, {
      'institutionName': _institutionNameController.text,
      'role': _roleController.text,
      'dateStarted': _parseDateFromDDMMYYYY(_startDate.text),
      'dateEnded': _parseDateFromDDMMYYYY(_endDate.text),
      'description': _descriptionController.text,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes saved")));
  }
}
