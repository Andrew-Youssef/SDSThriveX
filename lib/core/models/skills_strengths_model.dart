import 'package:flutter/material.dart';

class SkillsStrengthsModel extends ChangeNotifier {
  String skill;
  String acquiredAt; // where it was demonstrated or acquired
  String description;

  SkillsStrengthsModel({
    required this.skill,
    required this.acquiredAt,
    required this.description,
  });

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
}
