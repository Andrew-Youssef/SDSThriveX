import 'package:flutter/material.dart';

class AIModel extends ChangeNotifier {
  String id;
  String summary;

  AIModel({required this.id, required this.summary});

  factory AIModel.convertMap(Map<String, dynamic> map, String id) {
    return AIModel(
      id: id,
      summary: map["summary"],
    );
  }

  void updateUserID(String newID) {
    id = newID;
    notifyListeners();
  }

  void updateDescription(String newSummary) {
    summary = newSummary;
    notifyListeners();
  }

  Map<String, dynamic> toJSON() {
    return {
      'summary': summary,
    };
  }
}
