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

final List<WorkExperienceModel> dummyWorkExperiences = [
  WorkExperienceModel(
    name: 'Tech Solutions Inc.',
    role: 'Software Developer Intern',
    dateBegun: DateTime(2022, 6, 1),
    dateEnded: DateTime(2022, 12, 1),
    description: 'Worked on backend services with Node.js and improved API response times by 20%.',
  ),
  WorkExperienceModel(
    name: 'ByteCorp',
    role: 'Frontend Engineer',
    dateBegun: DateTime(2023, 1, 15),
    dateEnded: null,
    description: 'Building mobile-first UIs in Flutter for client projects.',
  ),
];