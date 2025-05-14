import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:screens/core/models/export_models.dart';
import '../core/theme/theme.dart';
import '../data/globals.dart';

class UserProvider extends ChangeNotifier {
  late String? _aiSummary;
  late MyThemeData _themeData;
  ProfileModel? _profile;
  List<ProjectModel> _projects = [];
  List<WorkExperienceModel> _workExperiences = [];
  List<CertDegreesModel> _certDegrees = [];
  List<SkillsStrengthsModel> _skillsStrengths = [];
  List<PersonalStoriesModel> _personalStories = [];
  List<VolunteeringWorkModel> _volunteeringWorks = [];

  UserProvider() {
    _aiSummary = "";
    _themeData = MyThemeData(UserType.student);
  }

  String? get aiSummary => _aiSummary;
  ProfileModel? get profile => _profile;
  UserType get type => UserTypeExtension.fromString(_profile!.userType);
  List<ProjectModel> get projects => _projects;
  List<WorkExperienceModel> get workExperiences => _workExperiences;
  List<CertDegreesModel> get certDegrees => _certDegrees;
  List<SkillsStrengthsModel> get skillsStrengths => _skillsStrengths;
  List<PersonalStoriesModel> get personalStories => _personalStories;
  List<VolunteeringWorkModel> get volunteeringWorks => _volunteeringWorks;

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

  Future<void> loadProjects(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .get();

    _projects =
        ref.docs.map((doc) {
          final data = doc.data();
          return ProjectModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> addWorkExperience(WorkExperienceModel newWorkExperience) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('workExperiences')
            .doc();

    newWorkExperience.updateUserID(docRef.id);
    await docRef.set(newWorkExperience.toJSON());
    _workExperiences.add(newWorkExperience);
    notifyListeners();
  }

  Future<void> removeWorkExperience(String workExperienceId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workExperiences')
        .doc(workExperienceId)
        .delete();
    _workExperiences.removeWhere(
      (workExperience) => workExperience.id == workExperienceId,
    );
  }

  Future<void> loadWorkExperiences(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('workExperiences')
            .get();

    _workExperiences =
        ref.docs.map((doc) {
          final data = doc.data();
          return WorkExperienceModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> addCertDegree(CertDegreesModel newCertDegree) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('certDegree')
            .doc();

    newCertDegree.updateUserID(docRef.id);
    await docRef.set(newCertDegree.toJSON());
    _certDegrees.add(newCertDegree);
    notifyListeners();
  }

  Future<void> removeCertDegree(String certDegreeId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('certDegree')
        .doc(certDegreeId)
        .delete();
    _certDegrees.removeWhere((certDegree) => certDegree.id == certDegreeId);
  }

  Future<void> loadCertDegrees(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('certDegree')
            .get();

    _certDegrees =
        ref.docs.map((doc) {
          final data = doc.data();
          return CertDegreesModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> addSkillsStrengths(SkillsStrengthsModel newSkill) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('skills')
            .doc();

    newSkill.updateUserID(docRef.id);
    await docRef.set(newSkill.toJSON());
    _skillsStrengths.add(newSkill);
    notifyListeners();
  }

  Future<void> removeSkillsStrengths(String skillId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('skills')
        .doc(skillId)
        .delete();
    _skillsStrengths.removeWhere((skill) => skill.id == skillId);
  }

  Future<void> loadSkillsStrengths(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('skills')
            .get();

    _skillsStrengths =
        ref.docs.map((doc) {
          final data = doc.data();
          return SkillsStrengthsModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> addPersonalStory(PersonalStoriesModel newStory) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('stories')
            .doc();

    newStory.updateUserID(docRef.id);
    await docRef.set(newStory.toJSON());
    _personalStories.add(newStory);
    notifyListeners();
  }

  Future<void> removePersonalStory(String storyId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('stories')
        .doc(storyId)
        .delete();
    _personalStories.removeWhere((story) => story.id == storyId);
  }

  Future<void> loadPersonalStories(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('stories')
            .get();

    _personalStories =
        ref.docs.map((doc) {
          final data = doc.data();
          return PersonalStoriesModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> addVolunteerWork(VolunteeringWorkModel newVolunteer) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('volunteeringWorks')
            .doc();

    newVolunteer.updateUserID(docRef.id);
    await docRef.set(newVolunteer.toJSON());
    _volunteeringWorks.add(newVolunteer);
    notifyListeners();
  }

  Future<void> removeVolunteerWork(String volunteerId) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('volunteeringWorks')
        .doc(volunteerId)
        .delete();
    _volunteeringWorks.removeWhere((volunteer) => volunteer.id == volunteerId);
  }

  Future<void> loadVolunteeringWorks(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('volunteeringWorks')
            .get();

    _volunteeringWorks =
        ref.docs.map((doc) {
          final data = doc.data();
          return VolunteeringWorkModel.convertMap(data, userId);
        }).toList();

    notifyListeners();
  }

  Future<void> generateSummary() async {
    final gemini = Gemini.instance;
    loadProjects(profile!.userId);
    String combinedInformation = projects
        .map((project) => project.toPrompt())
        .join('\n\n');

    final prompt =
        "Write a short summary based on the following user's details. \n\n $combinedInformation";

    final response = await gemini.prompt(parts: [Part.text(prompt)]);

    _aiSummary = response?.output ?? "No story generated.";
  }
}
