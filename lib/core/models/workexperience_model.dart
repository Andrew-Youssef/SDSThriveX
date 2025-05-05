import 'package:flutter/material.dart';

class WorkExperienceModel extends ChangeNotifier {
  String name; // name of business
  String role;
  DateTime dateBegun;
  DateTime? dateEnded;
  String description;

  WorkExperienceModel({
    required this.name,
    required this.role,
    required this.dateBegun,
    this.dateEnded,
    required this.description,
  });

  // Optional update methods
  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateRole(String newRole) {
    role = newRole;
    notifyListeners();
  }

  void updateDateBegun(DateTime newDate) {
    dateBegun = newDate;
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
