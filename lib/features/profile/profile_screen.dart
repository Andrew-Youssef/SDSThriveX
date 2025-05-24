import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/core/models/cert_degree_model.dart';
import 'package:flutter_innatex_student_screens/core/models/personal_stories_model.dart';
import 'package:flutter_innatex_student_screens/core/models/project_model.dart';
import 'package:flutter_innatex_student_screens/core/models/skills_strengths_model.dart';
import 'package:flutter_innatex_student_screens/core/models/volunteering_work_model.dart';
import 'package:flutter_innatex_student_screens/core/models/workexperience_model.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_cert_degrees.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_personal_stories.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_profile.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_projects.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_skills_strengths.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_volunteering_works.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_group/edit_workexperiences.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/profile_edit_screen.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:flutter_innatex_student_screens/widgets/profile_screen/export_attribute_display_widgets.dart';
import '../../data/globals.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final double coverHeight = 140;
  final double profileHeight = 130;

  ProjectModel? selectedProject;
  WorkExperienceModel? selectedWorkExperience;
  CertDegreesModel? selectedCertDegree;
  SkillsStrengthsModel? selectedSkillStrength;
  PersonalStoriesModel? selectedPersonalStory;
  VolunteeringWorkModel? selectedVolunteeringWork;

  //***************************** NOTE ********************************/
  // RIGHT NOW THIS IS REALLY BAD
  // The maps need to be put somewhere else. (I DONT KNOW WHERE ELSE)
  // attributeScreens is also used in edit_profile_attributes
  // i dont want to make them global bc only these 2 classes should have access

  // maybe put in the routes.dart? lol probs.

  // profile attributes NEEDS to be synced with the data base.
  // profileAttributes should exist elsewhere where it can be modified by database
  // and then pulled here.

  // This will allow for toggleable sections. for hong to do.
  //****************************** ik ************************************/

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
        (context) => const MyEditVolunteeringScreen(),
  };

  void toggleProfileAttributes(ProfileAttribute key) {
    setState(() {
      if (profileAttributes.containsKey(key)) {
        profileAttributes[key] = !profileAttributes[key]!;
      }
      // print(profileAttributes[key]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // final userProvider = Provider.of<UserProvider>(context);
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Profile', context),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              buildTop(),
              buildContent(context),
              buildAttributeData(context),
            ],
          ),
        ),
      ),
    );
  }

  //projects
  //certDegrees
  //
  Widget buildContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Smith',
                    style: theme.textTheme.titleMedium!.copyWith(fontSize: 28),
                  ),
                  Text('Student at UTS', style: theme.textTheme.displayMedium),
                ],
              ),
              Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyEditProfileScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ),
        Divider(thickness: 3),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildAttributeButtons(),
              // buildAttributeButtons(
              //   profileAttributes: profileAttributes,
              //   onToggle: (key) {
              //     toggleProfileAttributes(key);
              //   },
              // ),
              Text(
                'About',
                textAlign: TextAlign.left,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                'Place holder text for About',
                textAlign: TextAlign.left,
                style: theme.textTheme.displayMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAttributeButtons() {
    return Wrap(
      spacing: 8,
      children:
          profileAttributes.keys.map((key) {
            return ElevatedButton(
              onPressed: () {
                toggleProfileAttributes(key);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    profileAttributes[key]! ? Colors.blue : Colors.white70,
              ),
              child: Text(profileAttributeLabels[key]!),
            );
          }).toList(),
    );
  }

  Widget buildAttributeData(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          profileAttributes.keys.map((key) {
            if (profileAttributes[key]!) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 3),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profileAttributeLabels[key]!,
                              style: theme.textTheme.titleMedium,
                            ),
                            Expanded(child: SizedBox()),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: attributeScreens[key]!,
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),

                        //og
                        // Text(
                        //   'Place holder text for ${profileAttributeLabels[key]}',
                        //   style: theme.textTheme.displayMedium,
                        // ),
                        getAttributeWidgetData(context)[key]!,
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          }).toList(),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: profileHeight / 2),
          child: buildCoverImage(),
        ),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  CircleAvatar buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundImage: NetworkImage(
        'https://cdn-icons-png.flaticon.com/512/80/80561.png',
      ),
    );
  }

  Container buildCoverImage() {
    return Container(
      child: Image.network(
        'https://media.licdn.com/dms/image/v2/D4D12AQF6mW4EuB-99Q/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1692951785182?e=2147483647&v=beta&t=9whX4YpHoNOzyq7CIiNwro17k-ajBH6TM3qo2CyH2Pk',
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  //*****************************WILSON *****************************//
  /*
  work from here downwards

  create ur own models for ui testing, dont use UserProvider
  eg. for WorkExperience
    WorkExperienceModel wkModel = 
      WorkExperienceModel(
        name: name, 
        role: role, 
        dateBegun: dateBegun, 
        description: description
      )
  create a List<WorkExperienceModel> to test it for displaying multiple models
  
  name each function like this:
  Widget showExisting[(section eg WorkExperience)](BuildContext context) {}

  manually create your list of Models, then make the widget scrollable,
  and display conditionally whether the list is empty or not.

  If the list is empty, it should display:
  "Add [section]!" or something.

  
  To test if each of your things is working, go to getAttributeWidgetData()
  and replace the corresponding placeholder TextWidget with ur function name

  also read themes.dart
  
  */

  Map<ProfileAttribute, Widget> getAttributeWidgetData(context) {
    return {
      ProfileAttribute.projects: const MyExistingProjectsWidget(),
      ProfileAttribute.workExperience: const MyExistingWorkExperiencesWidget(),
      ProfileAttribute.certDegrees: const MyExistingCertDegreesWidget(),
      ProfileAttribute.skillsStrengths: const MyExistingSkillsStrengthsWidget(),
      ProfileAttribute.personalStories: const MyExistingPersonalStoriesWidget(),
      ProfileAttribute.volunteeringWork:
          const MyExistingVolunteeringWorksWidget(),
    };
  }
}
