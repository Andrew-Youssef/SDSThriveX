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

  static List<ProjectModel> getDummyProjects() {
    return [
      ProjectModel(
        name: "Weather App",
        dateBegun: DateTime(2024, 3, 10),
        dateEnded: DateTime(2024, 4, 5),
        description: "Built a weather forecasting app using Flutter and REST API.",
        imageUrl: null,
      ),
      ProjectModel(
        name: "Portfolio Website",
        dateBegun: DateTime(2023, 11, 1),
        dateEnded: DateTime(2023, 12, 15),
        description: "Created a personal portfolio with responsive design and animations.",
        imageUrl: null,
      ),
      ProjectModel(
        name: "Chat App",
        dateBegun: DateTime(2024, 1, 5),
        description: "Ongoing real-time chat app using Firebase.",
        imageUrl: null,
      ),
    ];
  }
}
