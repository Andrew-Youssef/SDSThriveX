import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VolunteeringWorkModel extends ChangeNotifier {
  String id;
  String institutionName;
  String role;
  DateTime dateStarted;
  DateTime? dateEnded; // null if ongoing
  String description;

  VolunteeringWorkModel({
    required this.id,
    required this.institutionName,
    required this.role,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });

  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  // Optional update methods
  void updateInstitutionName(String newName) {
    institutionName = newName;
    notifyListeners();
  }

  void updateRole(String newRole) {
    role = newRole;
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
      'role': role,
      'description': description,
      'dateStarted': dateStarted,
      'dateEnded': dateEnded,
    };
  }

  factory VolunteeringWorkModel.convertMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return VolunteeringWorkModel(
      id: id,
      institutionName: map["institutionName"],
      role: map["role"],
      description: map["description"],
      dateStarted: (map['dateStarted'] as Timestamp).toDate(),
      dateEnded:
          map['dateEnded'] != null
              ? (map['dateEnded'] as Timestamp).toDate()
              : null,
    );
  }
}
