import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkExperienceModel extends ChangeNotifier {
  String id;
  String name; // name of business
  String role;
  DateTime dateBegun;
  DateTime? dateEnded;
  String description;

  WorkExperienceModel({
    required this.id,
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

  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'description': description,
      'role': role,
      'dateBegun': dateBegun,
      'dateEnded': dateEnded,
    };
  }

  String toPrompt() {
    return "Work Experience Name: $role, "
        "Institution Name (Where the experience is acquired): $name"
        "Work Experience Description: $description, "
        "Work Experience Starting Date: $dateBegun"
        "Work Experience Ending Date: $dateEnded";
  }

  factory WorkExperienceModel.convertMap(Map<String, dynamic> map, String id) {
    return WorkExperienceModel(
      id: id,
      name: map["name"],
      description: map["description"],
      role: map["role"],
      dateBegun: (map['dateBegun'] as Timestamp).toDate(),
      dateEnded:
          map['dateEnded'] != null
              ? (map['dateEnded'] as Timestamp).toDate()
              : null,
    );
  }
}
