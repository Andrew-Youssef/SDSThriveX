import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PersonalStoriesModel extends ChangeNotifier {
  String id;
  String title;
  DateTime date;
  String description;

  PersonalStoriesModel({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
  });
  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

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

  Map<String, dynamic> toJSON() {
    return {'title': title, 'description': description, 'date': date};
  }

  factory PersonalStoriesModel.convertMap(Map<String, dynamic> map, String id) {
    return PersonalStoriesModel(
      id: id,
      title: map["title"],
      description: map["description"],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
