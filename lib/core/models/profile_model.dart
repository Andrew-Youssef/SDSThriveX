import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  final String userId;
  String name;
  final String userType;
  String title;
  String description;
  String? profilePicUrl;
  String? backgroundPicUrl;
  bool isEndorsed;

  ProfileModel({
    required this.userId,
    required this.name,
    required this.userType,
    required this.title,
    required this.description,
    this.profilePicUrl,
    required this.isEndorsed,
  });

  factory ProfileModel.fromDB(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProfileModel(
      userId: doc.id,
      name: data['name'],
      userType: data['userType'],
      title: data['title'] ?? 'No title',
      description: data['description'] ?? 'No Description',
      isEndorsed: data['isEndorsed'] ?? false,
    );
  }

  void updateEndorsement() {
    isEndorsed = !isEndorsed;
    notifyListeners();
  }

  void updateName(String newName) {
    name = newName;
    notifyListeners();
  }

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
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
