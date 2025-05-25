import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditProjectScreen extends StatefulWidget {
  final ProjectModel project;

  const MyEditProjectScreen({super.key, required this.project});

  @override
  State<MyEditProjectScreen> createState() => _MyEditProjectScreenState();
}

class _MyEditProjectScreenState extends State<MyEditProjectScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late bool _isOngoing;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(text: widget.project.description);
    _imageController = TextEditingController(text: widget.project.imageUrl ?? '');
    _startDate = TextEditingController(text: _formatDateToDDMMYYYY(widget.project.dateBegun));
    _endDate = TextEditingController(
      text: widget.project.dateEnded != null ? _formatDateToDDMMYYYY(widget.project.dateEnded!) : '',
    );
    _isOngoing = widget.project.dateEnded == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
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
          appBar: myAppBar('Edit Project', context),
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
                            title: const Text("Delete Project"),
                            content: const Text("Are you sure you want to delete this project? This action cannot be undone."),
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
                        userProvider.removeProject(widget.project);
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
          _buildLabeledField('Project Name:', _nameController, 'Enter project name', onChanged: widget.project.updateName),
          const SizedBox(height: 12),
          _buildLabeledDateField('Date begun:', _startDate, context, (date) => widget.project.updateDateBegun(date)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField(
                  'Date ended:',
                  _endDate,
                  context,
                  (date) => widget.project.updateDateEnded(date),
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
                          widget.project.updateDateEnded(null);
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
            'Enter a short description of your project',
            onChanged: widget.project.updateDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _confirmChanges(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 42, 157, 143),
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
      void Function(DateTime) onDateSelected,
      {bool enabled = true}) {
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
              if (controller == _endDate) {
                final currentStart = _parseDateFromDDMMYYYY(_startDate.text);
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Colors.grey.shade300),
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

  void _confirmChanges() {
    widget.project.updateName(_nameController.text);
    widget.project.updateDescription(_descriptionController.text);
    // Dates are already updated through date pickers

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved")),
    );

    Navigator.pop(context);
  }
}
