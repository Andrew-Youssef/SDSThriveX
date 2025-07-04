import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../../../../../core/models/export_models.dart';
import '../core/theme/theme.dart';
import '../data/globals.dart';

//this user provider SHOULD be split into smaller providers/controllers,
//one for each attribute
class UserProvider extends ChangeNotifier {
  // AIModel? _aiSummary;
  String? _aiSummary;
  late MyThemeData _themeData;
  ProfileModel? _profile;
  List<ProjectModel> _projects = [];
  List<WorkExperienceModel> _workExperiences = [];
  List<CertDegreesModel> _certDegrees = [];
  List<SkillsStrengthsModel> _skillsStrengths = [];
  List<PersonalStoriesModel> _personalStories = [];
  List<VolunteeringWorkModel> _volunteeringWorks = [];

  //used by the ProfileScreen UI to track what profileattributes to display
  //eg. the UI will not show empty profile attributes when viewing another users profile
  //map is managed locally in load/add/remove methods,
  final Map<ProfileAttribute, bool> _profileAttributes = {
    ProfileAttribute.projects: false,
    ProfileAttribute.workExperience: false,
    ProfileAttribute.certDegrees: false,
    ProfileAttribute.skillsStrengths: false,
    ProfileAttribute.personalStories: false,
    ProfileAttribute.volunteeringWork: false,
  };

  UserProvider() {
    _themeData = MyThemeData(UserType.student);
  }

  // AIModel? get aiSummary => _aiSummary;
  String? get aiSummary => _aiSummary;
  ProfileModel? get profile => _profile;
  UserType get type => UserTypeExtension.fromString(_profile!.userType);
  List<ProjectModel> get projects => _projects;
  List<WorkExperienceModel> get workExperiences => _workExperiences;
  List<CertDegreesModel> get certDegrees => _certDegrees;
  List<SkillsStrengthsModel> get skillsStrengths => _skillsStrengths;
  List<PersonalStoriesModel> get personalStories => _personalStories;
  List<VolunteeringWorkModel> get volunteeringWorks => _volunteeringWorks;
  String get userId => _profile!.userId;
  Map<ProfileAttribute, bool> get profileAttributes => _profileAttributes;

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

  void setProfileAndDetails(ProfileModel profileData) {
    _profile = profileData;
    _themeData = MyThemeData(
      UserTypeExtension.fromString(profileData.userType),
    );
    loadProjects(profileData.userId);
    loadCertDegrees(profileData.userId);
    loadPersonalStories(profileData.userId);
    loadSkillsStrengths(profileData.userId);
    loadVolunteeringWorks(profileData.userId);
    loadWorkExperiences(profileData.userId);
    generateSummary();
    notifyListeners();
  }

  void testPrint() {
    print("yooooooo");
  }

  //see profile_screen or widgets/profile_screen/ for how to use
  Future<void> setTemporaryProfile(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    _profile = ProfileModel.fromDB(doc);
    await loadProjects(userId);
    await loadWorkExperiences(userId);
    await loadCertDegrees(userId);
    await loadPersonalStories(userId);
    await loadSkillsStrengths(userId);
    await loadVolunteeringWorks(userId);
    // await generateSummary();
  }

  void clearProfile() {
    _profile = null;
    notifyListeners();
  }

  Future<void> toggleEndorsement(String userId) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(userId);
    final snapshot = await ref.get();

    if (snapshot.exists) {
      await ref.update({'isEndorsed': !snapshot.data()?['isEndorsed']});
      _profile!.updateEndorsement();
    }
    print('endorsment updates');
    notifyListeners();
  }

  void updateProfileAttributes() {
    profileAttributes[ProfileAttribute.projects] = _projects.isNotEmpty;
    profileAttributes[ProfileAttribute.workExperience] =
        _workExperiences.isNotEmpty;
    profileAttributes[ProfileAttribute.certDegrees] = _certDegrees.isNotEmpty;
    profileAttributes[ProfileAttribute.skillsStrengths] =
        _skillsStrengths.isNotEmpty;
    profileAttributes[ProfileAttribute.personalStories] =
        _personalStories.isNotEmpty;
    profileAttributes[ProfileAttribute.volunteeringWork] =
        _volunteeringWorks.isNotEmpty;
  }

  Future<void> updateProfile(Map<String, dynamic> fieldsToUpdate) async {
    if (_profile?.userId == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_profile?.userId);

    await docRef.update(fieldsToUpdate);
    generateSummary();
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
    _projects.sort((a, b) => a.dateBegun.compareTo(b.dateBegun));

    // print("addProject projectid: ${docRef.id}\n");
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
  }

  Future<void> removeProject(String projectId) async {
    final userId = _profile?.userId;
    if (userId == null) {
      // print("removeProject userid null\n");
      return;
    }

    // print("removeProject userId: {$userId}\n");
    // print("trying to delete project ID: $projectId\n");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('projects')
        .doc(projectId)
        .delete();
    _projects.removeWhere((project) => project.id == projectId);
    // print("isProjects empty: ${_projects.isEmpty}\n");
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
    notifyListeners();
  }

  Future<void> loadProjects(String userId) async {
    print("inside loadProjects\n");
    print("$userId\n");
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('projects')
            .orderBy('dateBegun')
            .get();
    int count = 1;
    _projects =
        ref.docs.map((doc) {
          print('Found: ${count++}');
          final data = doc.data();
          doc.id;
          return ProjectModel.convertMap(data, doc.id);
        }).toList();
    if (_projects.isEmpty) print('what the skibidi\n');
    updateProfileAttributes();
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
    _workExperiences.sort((a, b) => a.dateBegun.compareTo(b.dateBegun));
    updateProfileAttributes();
    await generateSummary();
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
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
    notifyListeners();
  }

  Future<void> loadWorkExperiences(String userId) async {
    print("in load work experiences\n");
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('workExperiences')
            .orderBy('dateBegun')
            .get();

    _workExperiences =
        ref.docs.map((doc) {
          final data = doc.data();
          return WorkExperienceModel.convertMap(data, doc.id);
        }).toList();
    updateProfileAttributes();
    notifyListeners();
    if (_workExperiences.isEmpty) print("this is empty in workexp\n");
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
    _certDegrees.sort((a, b) => a.dateStarted.compareTo(b.dateStarted));

    updateProfileAttributes();
    await generateSummary();
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
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
    notifyListeners();
  }

  Future<void> loadCertDegrees(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('certDegree')
            .orderBy('dateStarted')
            .get();

    _certDegrees =
        ref.docs.map((doc) {
          final data = doc.data();
          return CertDegreesModel.convertMap(data, doc.id);
        }).toList();
    updateProfileAttributes();
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
    updateProfileAttributes();
    await generateSummary();
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
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
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
          return SkillsStrengthsModel.convertMap(data, doc.id);
        }).toList();
    updateProfileAttributes();
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
    updateProfileAttributes();
    await generateSummary();
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
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
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
          return PersonalStoriesModel.convertMap(data, doc.id);
        }).toList();
    updateProfileAttributes();
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
    _volunteeringWorks.sort((a, b) => a.dateStarted.compareTo(b.dateStarted));
    updateProfileAttributes();
    await generateSummary();
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
    updateProfileAttributes();
    await generateSummary();
    notifyListeners();
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
    await generateSummary();
    notifyListeners();
  }

  Future<void> loadVolunteeringWorks(String userId) async {
    final ref =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('volunteeringWorks')
            .orderBy('dateStarted')
            .get();

    _volunteeringWorks =
        ref.docs.map((doc) {
          final data = doc.data();
          return VolunteeringWorkModel.convertMap(data, doc.id);
        }).toList();
    updateProfileAttributes();
    notifyListeners();
  }

  Future<void> generateSummary() async {
    final gemini = Gemini.instance;
    String combinedInformation = [
      {'Role/Title: ${_profile!.title}\n\n'},
      {'About Me: ${_profile!.description}\n\n'},
      projects.map((p) => p.toPrompt()).join('\n\n'),
      certDegrees.map((c) => c.toPrompt()).join('\n\n'),
      skillsStrengths.map((s) => s.toPrompt()).join('\n\n'),
      workExperiences.map((w) => w.toPrompt()).join('\n\n'),
      volunteeringWorks.map((v) => v.toPrompt()).join('\n\n'),
    ].join('\n\n===\n\n');

    final prompt =
        "You are an expert career assistant helping job seekers present themselves professionally. \n\n"
        "I will give you a list of information about a person, including their education, work experience, volunteer work, achievements, and other relevant background. \n\n"
        "Your task is to write a professional and engaging summary of 100 words that could appear on a professional profile page such as LinkedIn or a job application site. \n\n"
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

    _aiSummary = response?.output ?? "No story generated.";
    print('GENERATE SUMMARY FINISHED\n');
  }

  // Future<void> addAISummary(AIModel newSummary) async {
  //   final userId = _profile?.userId;
  //   if (userId == null) return;

  //   final docRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('summary')
  //       .doc('AI');

  //   await docRef.set(newSummary.toJSON());
  //   _aiSummary = newSummary;
  //   notifyListeners();
  // }

  // //load summary
  // Future<void> loadSummary(String userId) async {
  //   final ref =
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .collection('summary')
  //           .doc('AI')
  //           .get();

  //   _aiSummary = AIModel.convertMap(ref.data()!, 'AI');

  //   notifyListeners();
  // }
}
