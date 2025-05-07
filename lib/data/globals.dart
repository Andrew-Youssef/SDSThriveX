//types
//student
//professor
//coach
//student

enum UserType { student, coach, recruiter, professor }

extension UserTypeExtension on UserType {
  static UserType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'coach':
        return UserType.coach;
      case 'student':
        return UserType.student;
      case 'professor':
        return UserType.professor;
      case 'recruiter':
        return UserType.recruiter;
      default:
        throw ArgumentError('Invalid user type: $type');
    }
  }
}

enum ProfileAttribute {
  profile,
  projects,
  workExperience,
  certDegrees,
  skillsStrengths,
  personalStories,
  volunteeringWork,
}

final Map<ProfileAttribute, String> profileAttributeLabels = {
  ProfileAttribute.profile: 'Profile',
  ProfileAttribute.projects: 'Projects',
  ProfileAttribute.workExperience: 'Work Experience',
  ProfileAttribute.certDegrees: 'Certificate & Degrees',
  ProfileAttribute.skillsStrengths: 'Skills & Strengths',
  ProfileAttribute.personalStories: 'Personal Stories',
  ProfileAttribute.volunteeringWork: 'Volunteering Work',
};

final Map<ProfileAttribute, bool> profileAttributes = {
  ProfileAttribute.projects: false,
  ProfileAttribute.workExperience: false,
  ProfileAttribute.certDegrees: false,
  ProfileAttribute.skillsStrengths: false,
  ProfileAttribute.personalStories: false,
  ProfileAttribute.volunteeringWork: false,
};
