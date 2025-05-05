import 'package:flutter/material.dart';
import 'package:screens/data/globals.dart';
import 'package:screens/features/profile_edit/edit_profile_attributes/edit_group/export_edit_group.dart';
import 'package:screens/widgets/header.dart';

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
  //also used in profile_screen read more there
  Map<ProfileAttribute, WidgetBuilder> attributeScreens = {
    ProfileAttribute.profile:
        (context) => const MyEditProfileAttributesScreen(),
    ProfileAttribute.projects: (context) => const MyEditProjectsScreen(),
    ProfileAttribute.workExperience:
        (context) => const MyEditWorkExperiencesScreen(),
    ProfileAttribute.certDegrees: (context) => const MyEditCertDegreesScreen(),
    ProfileAttribute.skillsStrengths:
        (context) => const MyEditSkillsStrengthsScreen(),
    ProfileAttribute.personalStories:
        (context) => const MyEditPersonalStoriesScreen(),
    ProfileAttribute.volunteeringWork:
        (context) => const MyEditVolunteeringWorksScreen(),
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
              for (ProfileAttribute p in attributeScreens.keys) ...[
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
