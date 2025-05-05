import 'package:flutter/material.dart';

class ProjectModel extends ChangeNotifier {
  String name;
  DateTime dateBegun;
  DateTime? dateEnded; // null if ongoing
  String description;
  String? imageUrl; // optional

  ProjectModel({
    required this.name,
    required this.dateBegun,
    this.dateEnded,
    required this.description,
    this.imageUrl,
  });

  // Optional update methods
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
}
