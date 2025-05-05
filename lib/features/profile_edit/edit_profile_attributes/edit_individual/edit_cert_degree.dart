import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/cert_degree_model.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

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
    _startDate = TextEditingController(
      text: widget.certDegree.dateStarted.toString().split(' ')[0],
    );
    _endDate = TextEditingController(
      text: widget.certDegree.dateEnded?.toString().split(' ')[0] ?? 'Ongoing',
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
                    onPressed: () {
                      userProvider.removeCertDegree(widget.certDegree);
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
              onChanged: widget.certDegree.updateInstitutionName,
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
              onChanged: widget.certDegree.updateCertificateName,
              controller: _certificationNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name of Certification',
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
              onChanged: widget.certDegree.updateDescription,
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
        controller.text = picked.toString().split(" ")[0];
        updaterMap[controller]!.call(picked);
      });
    }
  }
}
