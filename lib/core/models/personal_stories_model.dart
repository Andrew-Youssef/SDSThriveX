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

final List<PersonalStoriesModel> dummyStories = [
  PersonalStoriesModel(
    title: 'Overcoming Presentation Anxiety',
    date: DateTime(2023, 6),
    description: 'Delivered a confident final pitch after weeks of practice.',
  ),
  PersonalStoriesModel(
    title: 'Solo Travel Learning Experience',
    date: DateTime(2022, 11),
    description: 'Gained independence and adaptability while backpacking in NZ.',
  ),
];
