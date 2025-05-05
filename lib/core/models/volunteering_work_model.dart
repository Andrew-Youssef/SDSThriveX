import 'package:flutter/material.dart';

class VolunteeringWorkModel extends ChangeNotifier {
  String institutionName;
  String role;
  DateTime dateStarted;
  DateTime? dateEnded; // null if ongoing
  String description;

  VolunteeringWorkModel({
    required this.institutionName,
    required this.role,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });

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
}
