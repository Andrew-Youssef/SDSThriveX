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

List<VolunteeringWorkModel> dummyVolunteeringWork = [
    VolunteeringWorkModel(
      institutionName: "Red Cross",
      role: "Event Organizer",
      dateStarted: DateTime(2023, 3),
      dateEnded: DateTime(2023, 6),
      description: "Helped organize blood donation events and manage logistics.",
    ),
    VolunteeringWorkModel(
      institutionName: "Green Earth",
      role: "Community Volunteer",
      dateStarted: DateTime(2022, 1),
      dateEnded: null, // Ongoing
      description: "Involved in local clean-up drives and sustainability awareness.",
    ),
  ];