import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/ai_model.dart';
import 'package:flutter_innatex_student_screens/core/models/cert_degree_model.dart';
import 'package:flutter_innatex_student_screens/core/models/personal_stories_model.dart';
import 'package:flutter_innatex_student_screens/core/models/profile_model.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/core/models/skills_strengths_model.dart';
import 'package:flutter_innatex_student_screens/core/models/volunteering_work_model.dart';
import 'package:flutter_innatex_student_screens/core/models/workexperience_model.dart';
import '../data/globals.dart';
import '../core/theme.dart';

class UserProvider extends ChangeNotifier {
  late UserType _type;
  late MyThemeData _themeData;

  AIModel? _aiModel;
  ProfileModel? _profile; //WE NEED THIS FIELD UPDATES WHEN USER IS LOGGED IN

  final List<ProjectModel> _projects = [];
  final List<WorkExperienceModel> _workExperiences = [];
  final List<CertDegreesModel> _certDegrees = [];
  final List<PersonalStoriesModel> _personalStories = [];
  final List<VolunteeringWorkModel> _volunteeringWork = [];
  final List<SkillsStrengthsModel> _skillsStrengths = [];

  AIModel? get aiModel => _aiModel;
  ProfileModel? get profile => _profile;

  List<ProjectModel> get projects => _projects;
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
  void addProject(ProjectModel project) {
    project.addListener(notifyListeners);
    _projects.add(project);
    notifyListeners();
  }

  void removeProject(ProjectModel project) {
    project.removeListener(notifyListeners);
    _projects.remove(project);
    notifyListeners();
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

  //funtcions to load and upload to database probably... have to do for all
}
