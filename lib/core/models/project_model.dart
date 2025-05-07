import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectModel extends ChangeNotifier {
  String id;
  String name;
  DateTime dateBegun;
  DateTime? dateEnded; // null if ongoing
  String description;
  String? imageUrl; // optional

  ProjectModel({
    required this.id,
    required this.name,
    required this.dateBegun,
    this.dateEnded,
    required this.description,
    this.imageUrl,
  });

  // Optional update methods
  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
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

  void updateImageUrl(String? newUrl) {
    imageUrl = newUrl;
    notifyListeners();
  }

  factory ProjectModel.convertMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      name: map["name"],
      description: map["description"],
      dateBegun: (map['dateBegun'] as Timestamp).toDate(),
      dateEnded:
          map['dateEnded'] != null
              ? (map['DateEnded'] as Timestamp).toDate()
              : null,
      imageUrl: map["Image"] ?? "",
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'dateBegun': dateBegun,
      'dateEnded': dateEnded,
    };
  }

  String toPrompt() {
    return "Project Name: $name, Project Description: $description, Project Starting Date: $dateBegun, Project Ending Date: $dateEnded";
  }
}
