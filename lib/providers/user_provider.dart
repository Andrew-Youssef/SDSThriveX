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

  Future<String> getUserType(String userId) async {
    final ref =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return ref.data()?['userType'];
  }

  void setUserTheme(UserType newType) {
    _themeData.setUserType(newType);
    notifyListeners();
  }

  void setProfile(ProfileModel profileData) {
    _profile = profileData;
    loadProjects(profileData.userId);
    loadCertDegrees(profileData.userId);
    loadPersonalStories(profileData.userId);
    loadSkillsStrengths(profileData.userId);
    loadVolunteeringWorks(profileData.userId);
    loadWorkExperiences(profileData.userId);
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

  Future<void> updateProject(
    String projectId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<void> updateWorkExperience(
    String workExperienceId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('workExperiences')
        .doc(workExperienceId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<void> updateCertDegree(
    String certDegreeId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('certDegree')
        .doc(certDegreeId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<void> updateSkillsStrengths(
    String skillId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('skills')
        .doc(skillId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<void> updatePersonalStory(
    String storyId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('stories')
        .doc(storyId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<void> updateVolunteerWork(
    String volunteerId,
    Map<String, dynamic> fieldsToUpdate,
  ) async {
    final userId = _profile?.userId;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('volunteeringWorks')
        .doc(volunteerId);
    await docRef.update(fieldsToUpdate);
    notifyListeners();
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

  Future<String> generateSummary() async {
    final gemini = Gemini.instance;
    await loadProjects(profile!.userId);
    await loadCertDegrees(profile!.userId);
    await loadSkillsStrengths(profile!.userId);
    await loadWorkExperiences(profile!.userId);
    await loadVolunteeringWorks(profile!.userId);

    String combinedInformation = [
      projects.map((p) => p.toPrompt()).join('\n\n'),
      certDegrees.map((c) => c.toPrompt()).join('\n\n'),
      skillsStrengths.map((s) => s.toPrompt()).join('\n\n'),
      workExperiences.map((w) => w.toPrompt()).join('\n\n'),
      volunteeringWorks.map((v) => v.toPrompt()).join('\n\n'),
    ].join('\n\n===\n\n');

    final prompt =
        "You are an expert career assistant helping job seekers present themselves professionally. \n\n"
        "I will give you a list of information about a person, including their education, work experience, volunteer work, achievements, and other relevant background. \n\n"
        "Your task is to write a professional and engaging summary of 250 words that could appear on a professional profile page such as LinkedIn or a job application site. \n\n"
        "The summary should: \n\n"
        "- Focus on the most important facts a recruiter who are looking for fresh talents would care about. \n\n"
        "- Highlight skills, experience, achievements, and personality traits relevant to employability. \n\n"
        "- Be written in the third person (Example: Hong is a Software Engineering Student...). \n\n"
        "- Be clear, concise, and professional. \n\n"
        "- Be appropriate for a reader who is quickly scanning a candidate profile. \n\n"
        "Please do not include headings or bullet points, just a well-written paragraph summary. \n\n"
        "Do not give any advice on how to improve it, Do not mention about insufficient data and Do not critise it since this is for the recruiter and not for the student usage. \n\n"
        "If there is not enough information, do not give a summary and says to view the profile themselves"
        "Here's the list of information: $combinedInformation  \n\n";

    final response = await gemini.prompt(parts: [Part.text(prompt)]);

    return response?.output ?? "No story generated.";
  }
}
