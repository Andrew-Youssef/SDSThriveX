import 'package:flutter/material.dart';

class PersonalStoriesModel extends ChangeNotifier {
  String title;
  DateTime date;
  String description;

  PersonalStoriesModel({
    required this.title,
    required this.date,
    required this.description,
  });

  // Optional update methods
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDate(DateTime newDate) {
    date = newDate;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }
}
