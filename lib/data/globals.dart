//types
//student
//professor
//coach
//student

enum UserType { student, coach, recruiter, professor }

enum ProfileAttribute {
  profile,
  projects,
  workExperience,
  certificates,
  degrees,
  skillsStrengths,
  personalStories,
  volunteeringWork,
}

final Map<ProfileAttribute, String> profileAttributeLabels = {
  ProfileAttribute.profile: 'Profile',
  ProfileAttribute.projects: 'Projects',
  ProfileAttribute.workExperience: 'Work Experience',
  ProfileAttribute.certificates: 'Certificates',
  ProfileAttribute.degrees: 'Degrees',
  ProfileAttribute.skillsStrengths: 'Skills & Strengths',
  ProfileAttribute.personalStories: 'Personal Stories',
  ProfileAttribute.volunteeringWork: 'Volunteering Work',
};
