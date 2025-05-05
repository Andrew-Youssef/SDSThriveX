import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screens/core/theme.dart';
import '../data/globals.dart';
import 'package:screens/core/models/export_models.dart';

class UserProvider extends ChangeNotifier {
  late UserType _type;
  late MyThemeData _themeData;

  AIModel? _aiModel;
  ProfileModel? _profile; //WE NEED THIS FIELD UPDATES WHEN USER IS LOGGED IN

  final List<WorkExperienceModel> _workExperiences = [];
  final List<CertDegreesModel> _certDegrees = [];
  final List<PersonalStoriesModel> _personalStories = [];
  final List<VolunteeringWorkModel> _volunteeringWork = [];
  final List<SkillsStrengthsModel> _skillsStrengths = [];

  AIModel? get aiModel => _aiModel;
  ProfileModel? get profile => _profile;

  List<WorkExperienceModel> get workExperiences => _workExperiences;
  List<CertDegreesModel> get certDegrees => _certDegrees;
  List<PersonalStoriesModel> get personalStories => _personalStories;
  List<VolunteeringWorkModel> get volunteeringWork => _volunteeringWork;
  List<SkillsStrengthsModel> get skillsStrengths => _skillsStrengths;

  UserProvider() {
    //for now, later add load from storage
    //call userProvider when logged in and inisitalize properly
    _profile = ProfileModel(
      userId: '123',
      name: 'John Jones',
      userType: UserType.student,
    );

    _type = _profile!.userType;
    _themeData = MyThemeData(_type);
  }

  UserType get type => _type;

  //this doesnt change ProfileModel because technically it shouldnt be changing
  //this is just a theme changing function i would say
  void setUserType(UserType newType) {
    _type = newType;
    _themeData.setUserType(_type);
    notifyListeners();
  }

  String getTypeName() {
    return _type.name;
  }

  ThemeData getTheme() {
    return _themeData.getMyTheme();
  }

  void setProfile(ProfileModel profileData) {
    _profile = profileData;
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  void setAIModel(AIModel model) {
    _aiModel = model;
    notifyListeners();
  }

  void clearAIModel() {
    _aiModel = null;
    notifyListeners();
  }

  // Projects
  Future<void> addProject(ProjectModel project) async {
    try {
      project.addListener(notifyListeners);
      final currentDoc =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('projects')
              .doc();
      project.id = currentDoc.id;

      await currentDoc.set({
        "Name": project.name,
        "Description": project.description,
        "DateStart": project.dateBegun,
        "DateEnd": project.dateEnded,
        "Image": project.imageUrl,
      });

      notifyListeners();
    } catch (e) {
      return;
    }
  }

  Future<void> removeProject(String projectId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("projects")
          .doc(projectId)
          .delete();
      notifyListeners();
    } catch (e) {
      return;
    }
  }

  // Work Experience
  void addWorkExperience(WorkExperienceModel experience) {
    experience.addListener(notifyListeners);
    _workExperiences.add(experience);
    notifyListeners();
  }

  void removeWorkExperience(WorkExperienceModel experience) {
    experience.removeListener(notifyListeners);
    _workExperiences.remove(experience);
    notifyListeners();
  }

  // Certificates
  void addCertDegree(CertDegreesModel cert) {
    cert.addListener(notifyListeners);
    _certDegrees.add(cert);
    notifyListeners();
  }

  void removeCertDegree(CertDegreesModel cert) {
    cert.removeListener(notifyListeners);
    _certDegrees.remove(cert);
    notifyListeners();
  }

  // Personal Stories
  void addPersonalStory(PersonalStoriesModel story) {
    story.addListener(notifyListeners);
    _personalStories.add(story);
    notifyListeners();
  }

  void removePersonalStory(PersonalStoriesModel story) {
    story.removeListener(notifyListeners);
    _personalStories.remove(story);
    notifyListeners();
  }

  // Volunteering Work
  void addVolunteeringWork(VolunteeringWorkModel work) {
    work.addListener(notifyListeners);
    _volunteeringWork.add(work);
    notifyListeners();
  }

  void removeVolunteeringWork(VolunteeringWorkModel work) {
    work.removeListener(notifyListeners);
    _volunteeringWork.remove(work);
    notifyListeners();
  }

  // Skills & Strengths
  void addSkillStrength(SkillsStrengthsModel skill) {
    skill.addListener(notifyListeners);
    _skillsStrengths.add(skill);
    notifyListeners();
  }

  void removeSkillStrength(SkillsStrengthsModel skill) {
    skill.removeListener(notifyListeners);
    _skillsStrengths.remove(skill);
    notifyListeners();
  }
}
