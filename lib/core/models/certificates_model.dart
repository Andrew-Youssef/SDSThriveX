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

final List<CertDegreesModel> dummyCertificates = [
    CertDegreesModel(
      institutionName: "University of Technology Sydney",
      certificateName: "Bachelor of Software Engineering",
      dateStarted: DateTime(2021, 3),
      dateEnded: DateTime(2025, 12),
      description: "A comprehensive program focusing on real-world software development.",
    ),
    CertDegreesModel(
      institutionName: "Coursera",
      certificateName: "Machine Learning Specialization",
      dateStarted: DateTime(2023, 1),
      dateEnded: DateTime(2023, 6),
      description: "An online certification in machine learning by Andrew Ng.",
    ),
  ];
