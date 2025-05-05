import 'package:flutter/material.dart';
import 'package:screens/data/globals.dart';

class ProfileModel extends ChangeNotifier {
  final String
  userId; //like the unique database key or whatever to do queriries
  String name;
  final UserType userType;
  String? profilePicUrl;
  String? backgroundPicUrl;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.userType,
    this.profilePicUrl,
  });

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateProfilePic(String newUrl) {
    profilePicUrl = newUrl;
    notifyListeners();
  }

  void updateBackgroundPicUrl(String newUrl) {
    backgroundPicUrl = newUrl;
    notifyListeners();
  }
}
