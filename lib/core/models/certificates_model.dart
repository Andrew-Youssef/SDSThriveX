import 'package:flutter/material.dart';

class CertDegreesModel extends ChangeNotifier {
  String institutionName;
  String certificateName;
  DateTime dateStarted;
  DateTime? dateEnded; // null if ongoing
  String description;

  CertDegreesModel({
    required this.institutionName,
    required this.certificateName,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });

  void updateInstitution(String newInstitution) {
    institutionName = newInstitution;
    notifyListeners();
  }

  void updateCertificateName(String newName) {
    certificateName = newName;
    notifyListeners();
  }

  void updateDateStarted(DateTime newDate) {
    dateStarted = newDate;
    notifyListeners();
  }

  void updateDateEnded(DateTime? newDate) {
    dateEnded = newDate;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }
}
