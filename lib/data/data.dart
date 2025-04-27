// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

Map<String, bool> profileAttributes = {
  'AI Summary': false,
  'Projects': false,
  'Work Experience': false,
  'Certificates': false,
  'Degrees': false,
  'Skills/Strengths': false,
  'Personal Stories': false,
  'Volunteering Work': false,
};

// class DataProvider with ChangeNotifier {
//   Map<String, dynamic>? _userData;
//   String? _userID;

//   Map<String, dynamic>? get userData => _userData;
//   String? get userID => _userID;

//   void setUserID(String data) {
//     _userID = data;
//     notifyListeners();
//   }

//   void setUserData(Map<String, dynamic> data) {
//     _userData = data;
//     notifyListeners();
//   }
// }

enum UserType { student, coach, recruiter, professor }
