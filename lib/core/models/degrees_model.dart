import 'package:flutter/widgets.dart';

class DegreeModel extends ChangeNotifier {
  String institutionName;
  String degreeName;
  DateTime dateStarted;
  DateTime? dateEnded; // null if ongoing
  String description;

  DegreeModel({
    required this.institutionName,
    required this.degreeName,
    required this.dateStarted,
    this.dateEnded,
    required this.description,
  });

  void updateInstitutionName(String newName) {
    institutionName = newName;
    notifyListeners();
  }

  void updateDegreeName(String newDegree) {
    degreeName = newDegree;
    notifyListeners();
  }

  void updateDateStarted(DateTime newDate) {
    dateStarted = newDate;
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
}
