import 'package:flutter/material.dart';
import '../../../../../core/models/cert_degree_model.dart';
import '../../../../../providers/user_provider.dart';
import '../../../../../widgets/header.dart';
import 'package:provider/provider.dart';
import '../edit_individual/edit_cert_degree.dart';

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

  Future<void> _selectDate(
    TextEditingController controller,
    BuildContext context,
  ) async {
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
          body: ListView(
            children: [
              if (certDegrees.isEmpty) ...[
                Center(child: Text('Add a new cert or degree!')),
                SizedBox(height: 20),
              ] else
                showExistingCertDegrees(context),
              buildInputFields(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget showExistingCertDegrees(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<CertDegreesModel> projects = userProvider.certDegrees;

    return SizedBox(
      height: 160,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in projects) ...[
            Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(maxWidth: 170),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      // 👈 centers 1- or 2-line text vertically
                      child: Text(
                        p.certificateName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign:
                            TextAlign.center, // 👈 centers text horizontally
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      deleteButton(p),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MyEditCertDegreeScreen(certDegree: p),
                            ),
                          );
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 42, 157, 143),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconButton deleteButton(CertDegreesModel w) {
    final userProvider = Provider.of<UserProvider>(context);
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Deletion"),
              content: Text(
                "Are you sure you want to delete this certificate/degree?",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(); // Close dialog
                    userProvider.removeWorkExperience(w.id);
                    setState(() {
                      selectedCertDegree = null;
                      _institutionNameController.clear();
                      _certificationNameController.clear();
                      _startDate.clear();
                      _endDate.clear();
                      _descriptionController.clear();
                    });
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      icon: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 42, 157, 143),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6),
        child: Icon(Icons.delete),
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Certificate Name:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _certificationNameController,
                  decoration: customInputDecoration('Enter certificate name'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Institution:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _institutionNameController,
                  decoration: customInputDecoration('Enter institution name'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date begun:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _startDate,
                  readOnly: true,
                  decoration: customInputDecoration('DD / MM / YYYY'),
                  onTap: () => _selectDate(_startDate, context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date ended:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: customInputDecoration(
                    'Enter a short description',
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
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
                child: Text('Add Certification/Degree'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddCertDegree() {
    final start = DateTime.tryParse(_startDate.text);
    final end =
        _endDate.text.isNotEmpty ? DateTime.tryParse(_endDate.text) : null;

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
      id: '',
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
