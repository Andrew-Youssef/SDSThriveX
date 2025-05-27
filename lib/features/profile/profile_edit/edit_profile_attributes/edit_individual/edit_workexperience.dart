import 'package:flutter/material.dart';
import '../../../../../core/models/workexperience_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';

// class MyEditWorkExperienceScreen extends StatefulWidget {
//   final WorkExperienceModel workExperience;

//   const MyEditWorkExperienceScreen({super.key, required this.workExperience});

//   @override
//   State<MyEditWorkExperienceScreen> createState() =>
//       _MyEditWorkExperienceScreenState();
// }

// class _MyEditWorkExperienceScreenState
//     extends State<MyEditWorkExperienceScreen> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _roleController;
//   late final TextEditingController _descriptionController;
//   late final TextEditingController _startDate;
//   late final TextEditingController _endDate;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.workExperience.name);
//     _roleController = TextEditingController(text: widget.workExperience.role);
//     _descriptionController = TextEditingController(
//       text: widget.workExperience.description,
//     );
//     _startDate = TextEditingController(
//       text: widget.workExperience.dateBegun.toString().split(' ')[0],
//     );
//     _endDate = TextEditingController(
//       text:
//           widget.workExperience.dateEnded?.toString().split(' ')[0] ??
//           'Ongoing',
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _roleController.dispose();
//     _descriptionController.dispose();
//     _startDate.dispose();
//     _endDate.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = Provider.of<UserProvider>(context);
//     ThemeData theme = Theme.of(context);
//     return Container(
//       color: theme.primaryColor,
//       child: SafeArea(
//         child: Scaffold(
//           appBar: myAppBar('Edit Work Experience', context),
//           body: Column(
//             children: [
//               Row(
//                 children: [
//                   Expanded(child: SizedBox()),
//                   IconButton(
//                     onPressed: () {
//                       userProvider.removeWorkExperience(
//                         widget.workExperience.id,
//                       );
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.delete),
//                   ),
//                 ],
//               ),
//               buildInputFields(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildInputFields(BuildContext context) {
//     ThemeData theme = Theme.of(context);

//     return Expanded(
//       child: ListView(
//         padding: EdgeInsets.all(8.0),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: widget.workExperience.updateName,
//               controller: _nameController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Name of project',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: widget.workExperience.updateRole,
//               controller: _roleController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Image URL (figure out later)',
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _startDate,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Start Date (required)',
//                 filled: true,
//                 prefixIcon: Icon(Icons.calendar_today),
//               ),
//               readOnly: true,
//               onTap: () {
//                 _selectDate(_startDate, context);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _endDate,
//               decoration: InputDecoration(
//                 // border: OutlineInputBorder(),
//                 labelText: 'End Date (optional)',
//                 filled: true,
//                 prefixIcon: Icon(Icons.calendar_today),
//                 enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: theme.primaryColor),
//                 ),
//               ),
//               readOnly: true,
//               onTap: () {
//                 _selectDate(_endDate, context);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               onChanged: widget.workExperience.updateDescription,
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Description',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _selectDate(
//     TextEditingController controller,
//     BuildContext context,
//   ) async {
//     final Map<TextEditingController, void Function(DateTime)> updaterMap = {
//       _startDate: widget.workExperience.updateDateBegun,
//       _endDate: widget.workExperience.updateDateEnded,
//     };
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1900),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         controller.text = picked.toString().split(" ")[0];
//         updaterMap[controller]!.call(picked);
//       });
//     }
//   }
// }

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
  late bool isOngoing;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workExperience.name);
    _roleController = TextEditingController(text: widget.workExperience.role);
    _descriptionController = TextEditingController(
      text: widget.workExperience.description,
    );
    _startDate = TextEditingController(
      text: _formatDateToDDMMYYYY(widget.workExperience.dateBegun),
    );
    _endDate = TextEditingController(
      text:
          widget.workExperience.dateEnded != null
              ? _formatDateToDDMMYYYY(widget.workExperience.dateEnded!)
              : '',
    );
    isOngoing = widget.workExperience.dateEnded == null;
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
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Work Experience"),
                            content: const Text(
                              "Are you sure you want to delete this work experience? This action cannot be undone.",
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
                        userProvider.removeWorkExperience(
                          widget.workExperience.id,
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
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLabeledField(
            'Company Name:',
            _nameController,
            'Enter company name',
            onChanged: widget.workExperience.updateName,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Role:',
            _roleController,
            'Enter your role',
            onChanged: widget.workExperience.updateRole,
          ),
          const SizedBox(height: 12),
          _buildLabeledDateField(
            'Date started:',
            _startDate,
            context,
            (date) => widget.workExperience.updateDateBegun(date),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField(
                  'Date ended:',
                  _endDate,
                  context,
                  (date) => widget.workExperience.updateDateEnded(date),
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
                          widget.workExperience.updateDateEnded(null);
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkColor: Colors.white,
                    fillColor: WidgetStateProperty.all(
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
            'Enter a description of your work experience',
            onChanged: widget.workExperience.updateDescription,
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
                color: Colors.white,
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
    void Function(String)? onChanged,
    int maxLines = 1,
  }) {
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
    BuildContext context,
    void Function(DateTime) onDateSelected, {
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
              // Check if end date is before start date
              if (controller == _endDate) {
                final currentStart = DateTime.tryParse(
                  _startDate.text.split('/').reversed.join('-'),
                );
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
    print('comform changes?');
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.updateWorkExperience(widget.workExperience.id, {
      'name': _nameController.text,
      'role': _roleController.text,
      'dateBegun': _parseDateFromDDMMYYYY(_startDate.text),
      'dateEnded': _parseDateFromDDMMYYYY(_endDate.text),
      'description': _descriptionController.text,
    });

    print('updated experience!\n');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Changes saved")));
  }
}

  // late final TextEditingController _nameController;
  // late final TextEditingController _roleController;
  // late final TextEditingController _descriptionController;
  // late final TextEditingController _startDate;
  // late final TextEditingController _endDate;