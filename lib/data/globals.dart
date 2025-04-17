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

//types
//student
//professor
//coach
//student

class UserProfile {
  final String type;

  UserProfile(this.type);

  String getType() {
    return type;
  }
}
