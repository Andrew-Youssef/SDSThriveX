import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:screens/core/models/project_model.dart';
import '../core/models/profile_model.dart';
import '../core/theme/theme.dart';
import '../data/globals.dart';

class UserProvider extends ChangeNotifier {
  ProfileModel? _profile;
  List<ProjectModel> _projects = [];
  late MyThemeData _themeData;

  UserProvider() {
    _themeData = MyThemeData(UserType.student);
  }

  ProfileModel? get profile => _profile;
  UserType get type => UserTypeExtension.fromString(_profile!.userType);
  List<ProjectModel> get projects => _projects;

  ThemeData getTheme() {
    return _themeData.getMyTheme();
  }

  void setUserTheme(UserType newType) {
    _themeData.setUserType(newType);
    notifyListeners();
  }

  void setProfile(ProfileModel profileData) {
    _profile = profileData;
    loadProjects(profileData.userId);
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  Future<void> loadProjects(String userId) async {
    final projectDocs =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('Projects')
            .get();

    _projects =
        projectDocs.docs.map((doc) {
          final data = doc.data();
          return ProjectModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> removeProject(String projectId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .delete();
    _projects.removeWhere((project) => project.id == projectId);
  }

  Future<void> addProject(ProjectModel newProject) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .doc();

    newProject.updateUserID(docRef.id);
    await docRef.set(newProject.toJSON());
    _projects.add(newProject);
    notifyListeners();
  }
}
