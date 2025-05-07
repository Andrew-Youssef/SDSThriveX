import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  final String userId;
  String name;
  final String userType;
  String? profilePicUrl;
  String? backgroundPicUrl;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.userType,
    this.profilePicUrl,
  });

  factory ProfileModel.fromDB(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileModel(
      userId: doc.id,
      name: data['name'],
      userType: data['userType'],
    );
  }

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
