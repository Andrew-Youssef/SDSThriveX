import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/cert_degree_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_cert_degree.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:provider/provider.dart';

class MyEditCertDegreesScreen extends StatefulWidget {
  const MyEditCertDegreesScreen({super.key});

  @override
  State<MyEditCertDegreesScreen> createState() =>
      _MyEditCertificatesScreenState();
}

class _MyEditCertificatesScreenState extends State<MyEditCertDegreesScreen> {
  CertDegreesModel? selectedCertDegree;
  late final TextEditingController _institutionNameController;
  late final TextEditingController _certificationNameController;
  late final TextEditingController _startDate;
  late final TextEditingController _endDate;
  late final TextEditingController _descriptionController;

  bool isOngoing = false;

  @override
  void initState() {
    super.initState();
    _institutionNameController = TextEditingController();
    _certificationNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _startDate = TextEditingController();
    _endDate = TextEditingController();
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

  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.black.withOpacity(0.3),
      ),
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

  Future<void> _selectDate(TextEditingController controller, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toIso8601String().substring(0, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<CertDegreesModel> certDegrees = userProvider.certDegrees;

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Certs & Degrees', context),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: selectedCertDegree == null
                        ? null
                        : () {
                            userProvider.removeCertDegree(selectedCertDegree!);
                            selectedCertDegree = null;
                          },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: _handleAddCertDegree,
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (certDegrees.isEmpty)
                ...[
                  Center(child: Text('Add a new cert or degree!')),
                  SizedBox(height: 20),
                ]
              else
                showExistingCertDegrees(context),
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingCertDegrees(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    final certDegrees = userProvider.certDegrees;

    return SizedBox(
      height: 180,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        children: certDegrees.map((cert) {
          return GestureDetector(
            onTap: () => setState(() => selectedCertDegree = cert),
            onLongPress: () {
              setState(() => selectedCertDegree = cert);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyEditCertDegreeScreen(certDegree: cert),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: cert == selectedCertDegree
                      ? theme.colorScheme.secondary
                      : Colors.grey,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  cert.certificateName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget buildInputFields(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
    child: ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text("Certificate Name:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: _certificationNameController,
          decoration: customInputDecoration('Enter certificate name'),
        ),
        SizedBox(height: 20),

        Text("Institution:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: _institutionNameController,
          decoration: customInputDecoration('Enter institution name'),
        ),
        SizedBox(height: 20),

        Text("Date begun:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: _startDate,
          readOnly: true,
          decoration: customInputDecoration('DD / MM / YYYY'),
          onTap: () => _selectDate(_startDate, context),
        ),
        SizedBox(height: 20),

        Text("Date ended:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _endDate,
                enabled: !isOngoing,
                readOnly: true,
                decoration: customInputDecoration('DD / MM / YYYY'),
                onTap: () {
                  if (!isOngoing) _selectDate(_endDate, context);
                },
              ),
            ),
            SizedBox(width: 10),
            Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Text("Ongoing?"),
            Checkbox(
              value: isOngoing,
              onChanged: (val) {
                setState(() {
                  isOngoing = val ?? false;
                  if (isOngoing) _endDate.clear();
                });
              },
              activeColor: Color.fromARGB(255, 42, 157, 143),
              side: BorderSide(color: Colors.black, width: 1.5),
            ),
          ],
        ),
        SizedBox(height: 20),

        Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: customInputDecoration('Enter a short description'),
        ),
        SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleAddCertDegree,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: Text("Add Certification/Degree"),
          ),
        ),
      ],
    ),
  );
}

  void _handleAddCertDegree() {
    final start = DateTime.tryParse(_startDate.text);
    final end = _endDate.text.isNotEmpty ? DateTime.tryParse(_endDate.text) : null;

    if (_institutionNameController.text.isEmpty ||
        _certificationNameController.text.isEmpty ||
        _startDate.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in all required fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (start != null && end != null && end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("End date cannot be before start date."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CertDegreesModel newCert = CertDegreesModel(
      institutionName: _institutionNameController.text,
      certificateName: _certificationNameController.text,
      dateStarted: start!,
      dateEnded: end,
      description: _descriptionController.text,
    );

    Provider.of<UserProvider>(context, listen: false).addCertDegree(newCert);

    _institutionNameController.clear();
    _certificationNameController.clear();
    _startDate.clear();
    _endDate.clear();
    _descriptionController.clear();

    setState(() {
      selectedCertDegree = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Certification/Degree added."),
        backgroundColor: Colors.green,
      ),
    );
  }
}
