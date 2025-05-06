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

List<SkillsStrengthsModel> dummySkillsStrengths = [
  SkillsStrengthsModel(
    skill: 'Problem Solving',
    acquiredAt: 'Google Summer of Code',
    description: 'Developed debugging strategies and improved efficiency of existing modules.',
  ),
  SkillsStrengthsModel(
    skill: 'Team Leadership',
    acquiredAt: 'UTS Programming Club',
    description: 'Led a team of 6 students on a semester-long software engineering project.',
  ),
  SkillsStrengthsModel(
    skill: 'Adaptability',
    acquiredAt: 'Part-time Customer Support Role',
    description: 'Quickly adjusted to changing tools and communication methods during peak seasons.',
  ),
];
