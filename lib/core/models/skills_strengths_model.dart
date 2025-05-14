import 'package:flutter/material.dart';

class SkillsStrengthsModel extends ChangeNotifier {
  String id;
  String skill;
  String acquiredAt; // where it was demonstrated or acquired
  String description;

  SkillsStrengthsModel({
    required this.id,
    required this.skill,
    required this.acquiredAt,
    required this.description,
  });
  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  // Optional update methods
  void updateSkill(String newSkill) {
    skill = newSkill;
    notifyListeners();
  }

  void updateAcquiredAt(String newLocation) {
    acquiredAt = newLocation;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }

  Map<String, dynamic> toJSON() {
    return {
      'skill': skill,
      'description': description,
      'acquiredAt': acquiredAt,
    };
  }

  factory SkillsStrengthsModel.convertMap(Map<String, dynamic> map, String id) {
    return SkillsStrengthsModel(
      id: id,
      skill: map["skill"],
      description: map["description"],
      acquiredAt: map["acquiredAt"],
    );
  }
}
