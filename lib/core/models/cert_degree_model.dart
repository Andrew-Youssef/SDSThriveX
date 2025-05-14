import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CertDegreesModel extends ChangeNotifier {
  String id;
  String institutionName;
  String certificateName;
  DateTime dateStarted;
  DateTime? dateEnded; // null if ongoing
  String description;

  CertDegreesModel({
    required this.id,
    required this.institutionName,
    required this.certificateName,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });

  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  void updateInstitutionName(String newInstitution) {
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

  Map<String, dynamic> toJSON() {
    return {
      'institutionName': institutionName,
      'certificateName': certificateName,
      'description': description,
      'dateStarted': dateStarted,
      'dateEnded': dateEnded,
    };
  }

  factory CertDegreesModel.convertMap(Map<String, dynamic> map, String id) {
    return CertDegreesModel(
      id: id,
      institutionName: map["institutionName"],
      certificateName: map["certificateName"],
      description: map["description"],
      dateStarted: (map['dateStarted'] as Timestamp).toDate(),
      dateEnded:
          map['dateEnded'] != null
              ? (map['dateEnded'] as Timestamp).toDate()
              : null,
    );
  }
}
