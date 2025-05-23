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
                    onPressed:
                        selectedCertDegree == null
                            ? null
                            : () {
                              userProvider.removeCertDegree(
                                selectedCertDegree!,
                              );
                              selectedCertDegree = null;
                            },
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {
                      final start = DateTime.tryParse(_startDate.text);
                      final end = _endDate.text.isNotEmpty ? DateTime.tryParse(_endDate.text) : null;

                      if (_institutionNameController.text.isNotEmpty &&
                          _startDate.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        CertDegreesModel newCertDegree = CertDegreesModel(
                          institutionName: _institutionNameController.text,
                          certificateName: _certificationNameController.text,
                          dateStarted: DateTime.tryParse(_startDate.text)!,
                          dateEnded:
                              _endDate.text.isNotEmpty
                                  ? DateTime.tryParse(_startDate.text)
                                  : null,
                          description: _descriptionController.text,
                        );
                        userProvider.addCertDegree(newCertDegree);
                      }

                       if (_institutionNameController.text.isEmpty ||
                          _certificationNameController.text.isEmpty ||
                          _startDate.text.isEmpty ||
                          _descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill in all required fields: institution, certification, start date, and description."),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (start !=null && end != null && end.isBefore(start)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('End date cannot be before start date.'),
                            backgroundColor: Colors.red,
                            ),
                          
                        );
                        return;
                      }

                      CertDegreesModel newCertDegree = CertDegreesModel(
                        institutionName: _institutionNameController.text,
                        certificateName: _certificationNameController.text,
                        dateStarted: start!,
                        dateEnded: end,
                        description: _descriptionController.text,
                      );
                      Provider.of<UserProvider>(context, listen: false).addCertDegree(newCertDegree);

                      // Optional: Clear fields or show success message
                      _institutionNameController.clear();
                      _certificationNameController.clear();
                      _startDate.clear();
                      _endDate.clear();
                      _descriptionController.clear();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Certification/Degree added."),
                          backgroundColor: Colors.green,
                        ),
                      );


                    },
                    icon: Icon(Icons.add_box),
                  ),
                ],
              ),
              if (certDegrees.isEmpty) ...[
                Center(child: Text('Add a new cert or degree!')),
                SizedBox(height: 20),
              ] else ...[
                showExistingCertDegrees(context),
              ],
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
    List<CertDegreesModel> certDegrees = userProvider.certDegrees;

    return SizedBox(
      height: 200,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          for (final p in certDegrees) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCertDegree = p;
                });
                // print('yoooooo');
              },
              onLongPress: () {
                setState(() {
                  selectedCertDegree = p;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MyEditCertDegreeScreen(
                          certDegree: selectedCertDegree!,
                        ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.primaryColor,
                    width: p == selectedCertDegree ? 5 : 3,
                  ),
                ),
                child: Text(
                  p.certificateName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  ), 
                ), 
              ),
            ),
            SizedBox(width: 20),
          ],
        ],
      ),
    );
  }

  void _handleAddCertDegree() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final start = DateTime.tryParse(_startDate.text);
    final end = _endDate.text.isNotEmpty ? DateTime.tryParse(_endDate.text) : null;

    if (_institutionNameController.text.isNotEmpty &&
        _startDate.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      CertDegreesModel newCertDegree = CertDegreesModel(
        institutionName: _institutionNameController.text,
        certificateName: _certificationNameController.text,
        dateStarted: DateTime.tryParse(_startDate.text)!,
        dateEnded: end,
        description: _descriptionController.text,
      );

      userProvider.addCertDegree(newCertDegree);

      // Optional: clear fields after adding
      _institutionNameController.clear();
      _certificationNameController.clear();
      _startDate.clear();
      _endDate.clear();
      _descriptionController.clear();

      setState(() {
        selectedCertDegree = null;
      });
    }

    if (start != null && end != null && end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('End date cannot be before start date.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }
  InputDecoration customInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontStyle: FontStyle.italic,
        // ignore: deprecated_member_use
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
  
  bool isOngoing = false;

  Widget buildInputFields(BuildContext context) {
    ThemeData theme = Theme.of(context);
    

      return Expanded(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Title
            Text("Certificate Name:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _certificationNameController,
              decoration: InputDecoration(
                hintText: 'Enter project name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),

            SizedBox(height: 20),

            Text("Institution:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _institutionNameController,
              decoration: InputDecoration(
                hintText: 'Enter project name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),

            SizedBox(height: 20),

            // Date begun
            Text("Date begun:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _startDate,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'DD / MM / YYYY',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
              onTap: () => _selectDate(_startDate, context),
            ),

            SizedBox(height: 20),

            // Date ended and Ongoing
            Text("Date ended:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _endDate,
                    enabled: !isOngoing,
                    readOnly: true,
                    decoration: customInputDecoration('DD / MM / YYYY'),
                    onTap: () {if (!isOngoing) _selectDate(_endDate, context);}
                  ),
                ),
                SizedBox(width: 10),
                Text("OR", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Text("Ongoing?"),
                SizedBox(width: 8),
                 Checkbox(
                    value: isOngoing,
                    onChanged: (bool? value) {
                      setState(() {
                        isOngoing = value ?? false;
                        if (isOngoing) {
                          _endDate.clear();
                        }
                      });
                    },
                    activeColor: Colors.cyan,
                    side: BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
              ],
            ),

            SizedBox(height: 20),

            // Description
            Text("Description:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter a short description of your project',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                contentPadding: EdgeInsets.all(12),
              ),
            ),

            SizedBox(height: 30),

            

            // Add button
            Center(
              child: ElevatedButton(
                onPressed: () {
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
                        content: Text('End date cannot be before start date.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  CertDegreesModel newCertDegree = CertDegreesModel(
                    institutionName: _institutionNameController.text,
                    certificateName: _certificationNameController.text,
                    dateStarted: start!,
                    dateEnded: end,
                    description: _descriptionController.text,
                  );

                  Provider.of<UserProvider>(context, listen: false).addCertDegree(newCertDegree);

                  _institutionNameController.clear();
                  _certificationNameController.clear();
                  _startDate.clear();
                  _endDate.clear();
                  _descriptionController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Certification/Degree added."),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text("Add Certification/Degree"),
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.toString().split(" ")[0];
      });
    }
  }

  DateTime? getParsedStartDate() {
    if (_startDate.text.isEmpty) return null;
    try {
      return DateTime.parse(_startDate.text);
    } catch (e) {
      return null; // Handle invalid format safely
    }
  }
}
