import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/cert_degree_model.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
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

  @override
  void initState() {
    super.initState();
    _institutionNameController = TextEditingController(
      text: widget.certDegree.institutionName,
    );
    _certificationNameController = TextEditingController(
      text: widget.certDegree.certificateName,
    );
    _descriptionController = TextEditingController(
      text: widget.certDegree.description,
    );
    final dateFormatter = DateFormat('dd/MM/yyyy');
      _startDate = TextEditingController(
        text: dateFormatter.format(widget.certDegree.dateStarted),
      );
      _endDate = TextEditingController(
        text: widget.certDegree.dateEnded != null
            ? dateFormatter.format(widget.certDegree.dateEnded!)
            : 'Ongoing',
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Cert & Degrees', context),
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
                      userProvider.removeCertDegree(widget.certDegree);
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
    ThemeData theme = Theme.of(context);
    bool isOngoing = _endDate.text.isEmpty;

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildLabeledField('Certificate Name:', _certificationNameController, 'Enter project name', onChanged: widget.certDegree.updateCertificateName),
          const SizedBox(height: 12),
            _buildLabeledField('Institution Name:', _institutionNameController, 'Enter project name', onChanged: widget.certDegree.updateInstitutionName),
          const SizedBox(height: 12),
          _buildLabeledDateField('Date begun:', _startDate, context, (date) => widget.certDegree.updateDateStarted(date)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildLabeledDateField(
                  'Date ended:',
                  _endDate,
                  context,
                  (date) => widget.certDegree.updateDateEnded(date),
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
                          widget.certDegree.updateDateEnded(null);
                        }
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Colors.cyan),
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
            onChanged: widget.certDegree.updateDescription,
            maxLines: 4,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // save logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
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
              final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
              controller.text = formattedDate;
              onDateSelected(picked);
            }

          },
          decoration: InputDecoration(
            hintText: 'DD / MM / YYYY',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }





  Future<void> _selectDate(
    TextEditingController controller,
    BuildContext context,
  ) async {
    final Map<TextEditingController, void Function(DateTime)> updaterMap = {
      _startDate: widget.certDegree.updateDateStarted,
      _endDate: widget.certDegree.updateDateEnded,
    };
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        controller.text = formattedDate;
        updaterMap[controller]!.call(picked);
      });
    }
    
    if(picked != null) {
      final isEndDate = controller == _endDate;
      final currentStart = DateTime.tryParse(_startDate.text);

      if (isEndDate && currentStart != null && picked.isBefore(currentStart)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('End date cannot be before start date.'), backgroundColor: Colors.red,),
        );
        return;
      }
    }
    
  }
}
