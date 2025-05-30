import 'package:flutter/material.dart';
import '../../../../../core/models/cert_degree_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyEditCertDegreeScreen extends StatefulWidget {
  final CertDegreesModel certDegree;

  const MyEditCertDegreeScreen({super.key, required this.certDegree});

  @override
  State<MyEditCertDegreeScreen> createState() => _MyEditCertDegreeScreenState();
}

class _MyEditCertDegreeScreenState extends State<MyEditCertDegreeScreen> {
  late final TextEditingController _institutionNameController;
  late final TextEditingController _certificationNameController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _descriptionController;
  late bool isOngoing;

  @override
  void initState() {
    super.initState();
    final dateFormatter = DateFormat('dd/MM/yyyy');
    _institutionNameController = TextEditingController(
      text: widget.certDegree.institutionName,
    );
    _certificationNameController = TextEditingController(
      text: widget.certDegree.certificateName,
    );
    _descriptionController = TextEditingController(
      text: widget.certDegree.description,
    );
    _startDate = TextEditingController(
      text: dateFormatter.format(widget.certDegree.dateStarted),
    );
    isOngoing = widget.certDegree.dateEnded == null;
    _endDate = TextEditingController(
      text:
          widget.certDegree.dateEnded != null
              ? dateFormatter.format(widget.certDegree.dateEnded!)
              : '',
    );
  }

  @override
  void dispose() {
    _institutionNameController.dispose();
    _certificationNameController.dispose();
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
          appBar: myAppBar('Edit Cert & Degrees', context),
          body: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Delete Certificate"),
                              content: const Text(
                                "Are you sure you want to delete this item? This action cannot be undone.",
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
                            ),
                      );

                      if (confirm == true) {
                        userProvider.removeCertDegree(widget.certDegree.id);
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
            'Certificate Name:',
            _certificationNameController,
            'Enter certificate name',
            onChanged: widget.certDegree.updateCertificateName,
          ),
          const SizedBox(height: 12),
          _buildLabeledField(
            'Institution Name:',
            _institutionNameController,
            'Enter institution name',
            onChanged: widget.certDegree.updateInstitutionName,
          ),
          const SizedBox(height: 12),
          _buildLabeledDateField('Date begun:', _startDate, (date) {
            widget.certDegree.updateDateStarted(date);
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField('Date ended:', _endDate, (date) {
                  widget.certDegree.updateDateEnded(date);
                }, enabled: !isOngoing),
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
                          widget.certDegree.updateDateEnded(null);
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkColor: Colors.white,
                    fillColor: WidgetStateProperty.all(
                      Color.fromARGB(255, 42, 157, 143),
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
            'Enter a short description',
            onChanged: widget.certDegree.updateDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              print("confirm changes?");

              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              await userProvider.updateCertDegree(widget.certDegree.id, {
                'institutionName': _institutionNameController.text,
                'certificateName': _certificationNameController.text,
                'dateStarted': _parseDateFromDDMMYYYY(_startDate.text),
                'dateEnded': _parseDateFromDDMMYYYY(_endDate.text),
                'description': _descriptionController.text,
              });
            },

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
          onTap: () {
            if (enabled) _selectDate(controller, context);
          },
          decoration: InputDecoration(
            hintText: 'DD / MM / YYYY',
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

  Future<void> _selectDate(
    TextEditingController controller,
    BuildContext context,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatter = DateFormat('dd/MM/yyyy');
      final formattedDate = formatter.format(picked);
      final isEndDate = controller == _endDate;
      final startDate = DateFormat('dd/MM/yyyy').parse(_startDate.text);

      if (isEndDate && picked.isBefore(startDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('End date cannot be before start date.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        controller.text = formattedDate;
        if (controller == _startDate) {
          widget.certDegree.updateDateStarted(picked);
        } else if (controller == _endDate) {
          widget.certDegree.updateDateEnded(picked);
        }
      });
    }
  }
}
