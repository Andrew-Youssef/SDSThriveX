import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/data/globals.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_certificates.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_degrees.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_personal_stories.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_profile.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_projects.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_skills_strengths.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_volunteering_work.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_workexperience.dart';
import 'package:flutter_innatex_student_screens/features/project_approval/project_approval_screen.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditProfileScreen extends StatefulWidget {
  const MyEditProfileScreen({super.key});

  @override
  State<MyEditProfileScreen> createState() => _MyEditProfileScreenState();
}

class _MyEditProfileScreenState extends State<MyEditProfileScreen> {
  // enum ProfileAttribute {
  //   profile,
  //   projects,
  //   workExperience,
  //   certificates,
  //   degrees,
  //   skillsStrengths,
  //   personalStories,
  //   volunteeringWork
  // }

  //NOTE:
  //also used in profile_screen
  Map<ProfileAttribute, WidgetBuilder> attributeScreens = {
    ProfileAttribute.profile:
        (context) => const MyEditProfileAttributesScreen(),
    ProfileAttribute.projects: (context) => const MyEditProjectsScreen(),
    ProfileAttribute.workExperience:
        (context) => const MyEditWorkExperienceScreen(),
    ProfileAttribute.certificates:
        (context) => const MyEditCertificatesScreen(),
    ProfileAttribute.degrees: (context) => const MyEditDegreesScreen(),
    ProfileAttribute.skillsStrengths:
        (context) => const MyEditSkillsStrengthsScreen(),
    ProfileAttribute.personalStories:
        (context) => const MyEditPersonalStoriesScreen(),
    ProfileAttribute.volunteeringWork:
        (context) => const MyEditVolunteeringWorkScreen(),
  };

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Profile', context),
          body: ListView(
            children: [
              for (final p in attributeScreens.keys) ...[
                buildSetting(context, p),
                Divider(height: 3),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // profile picture
  // profile name
  // profile description

  // Projects
  // Work Experience
  // Certificates
  // Desgrees
  // Skills/Strengths
  // Personal Stories
  // Volunteering Work

  Widget buildSetting(BuildContext context, ProfileAttribute attribute) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: attributeScreens[attribute]!),
        );
      },
      child: Text(profileAttributeLabels[attribute]!),
    );
  }
}
