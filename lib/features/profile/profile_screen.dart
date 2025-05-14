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
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_cert_degree.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_personal_story.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_project.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_skills_strength.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_volunteering_work.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/edit_profile_attributes/edit_individual/edit_workexperience.dart';
import 'package:flutter_innatex_student_screens/features/profile_edit/profile_edit_screen.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';
import 'package:flutter_innatex_student_screens/widgets/profile_screen/project_display.dart';
import 'package:flutter_innatex_student_screens/widgets/profile_screen/workexperiences_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/certdegrees_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/personalstories_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/project_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/skillsstrengths_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/volunteeringworks_display.dart';
// import 'package:flutter_innatex_student_screens/widgets/profile_screen/workexperiences_display.dart';
import 'package:provider/provider.dart';
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
        (context) => const MyEditVolunteeringWorksScreen(),
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

  // Widget showExistingProjects(BuildContext context) {
  //   UserProvider userProvider = Provider.of<UserProvider>(context);
  //   ThemeData theme = Theme.of(context);
  //   List<ProjectModel> projects = userProvider.projects;

  //   if (projects.isEmpty) {
  //     return Text('Add some projects!', style: theme.textTheme.displayMedium);
  //   } else {
  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children:
  //           projects.map((project) {
  //             final String startDate =
  //                 '${project.dateBegun.toLocal().toString().split(' ')[0]} - ';
  //             final String endDate =
  //                 '${project.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

  //             return GestureDetector(
  //               onTap: () {
  //                 if (selectedProject == project) {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder:
  //                           (context) => MyEditProjectScreen(project: project),
  //                     ),
  //                   );
  //                 }
  //                 setState(() {
  //                   selectedProject = project;
  //                 });
  //               },
  //               onLongPress: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder:
  //                         (context) => MyEditProjectScreen(project: project),
  //                   ),
  //                 );
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border:
  //                       project == selectedProject
  //                           ? Border.all(color: theme.primaryColor, width: 3)
  //                           : null,
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Divider(thickness: 1),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Flexible(
  //                           child: Text(
  //                             project.name,
  //                             style: theme.textTheme.bodyMedium!.copyWith(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ),
  //                         Column(
  //                           children: [
  //                             Text(
  //                               startDate,
  //                               style: theme.textTheme.bodyMedium!.copyWith(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             Text(
  //                               endDate,
  //                               style: theme.textTheme.bodyMedium!.copyWith(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       project.description,
  //                       style: theme.textTheme.displayMedium,
  //                     ),
  //                     if (project.imageUrl != null &&
  //                         project.imageUrl!.isNotEmpty)
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 8.0),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(8),
  //                           child: Image.network(
  //                             project.imageUrl!,
  //                             fit: BoxFit.cover,
  //                             errorBuilder: (context, error, stackTrace) {
  //                               return const Icon(Icons.broken_image);
  //                             },
  //                           ),
  //                         ),
  //                       ),
  //                     const SizedBox(height: 10),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }).toList(),
  //     );
  //   }
  // }

  Widget showExistingWorkExperiences(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

    if (workExperiences.isEmpty) {
      return Text(
        'Add some work experience!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            workExperiences.map((exp) {
              final String startDate =
                  '${exp.dateBegun.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${exp.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap: () {
                  if (selectedWorkExperience == exp) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditWorkExperienceScreen(workExperience: exp),
                      ),
                    );
                  }
                  setState(() {
                    selectedWorkExperience = exp;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditWorkExperienceScreen(workExperience: exp),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        exp == selectedWorkExperience
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              exp.name,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                startDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(exp.role, style: theme.textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Text(
                        exp.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Widget showExistingCertDegrees(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<CertDegreesModel> certDegrees = userProvider.certDegrees;

    if (certDegrees.isEmpty) {
      return Text(
        'Add some certDegrees!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            certDegrees.map((cert) {
              final String startDate =
                  '${cert.dateStarted.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${cert.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap: () {
                  if (selectedCertDegree == cert) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditCertDegreeScreen(certDegree: cert),
                      ),
                    );
                  }
                  setState(() {
                    selectedCertDegree = cert;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditCertDegreeScreen(certDegree: cert),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        cert == selectedCertDegree
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              cert.certificateName,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                startDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.institutionName,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Widget showExistingSkillsStrengths(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> skills = userProvider.skillsStrengths;

    if (skills.isEmpty) {
      return Text(
        'Add some skills & strengths!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            skills.map((skillModel) {
              return GestureDetector(
                onTap: () {
                  if (selectedSkillStrength == skillModel) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyEditSkillStrengthScreen(
                              skillStrength: skillModel,
                            ),
                      ),
                    );
                  }
                  setState(() {
                    selectedSkillStrength = skillModel;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditSkillStrengthScreen(
                            skillStrength: skillModel,
                          ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        skillModel == selectedSkillStrength
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // No ellipsis — allow wrapping
                          Flexible(
                            child: Text(
                              skillModel.skill,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            skillModel.acquiredAt,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skillModel.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Widget showExistingPersonalStories(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> stories = userProvider.personalStories;

    if (stories.isEmpty) {
      return Text(
        'Add a personal story!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            stories.map((story) {
              final String formattedDate =
                  story.date.toLocal().toString().split(' ')[0];

              return GestureDetector(
                onTap: () {
                  if (selectedPersonalStory == story) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditPersonalStoryScreen(personalStory: story),
                      ),
                    );
                  }
                  setState(() {
                    selectedPersonalStory = story;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditPersonalStoryScreen(personalStory: story),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        story == selectedPersonalStory
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              story.title,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        story.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Widget showExistingVolunteeringWorks(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> volunteeringWorks =
        userProvider.volunteeringWork;

    if (volunteeringWorks.isEmpty) {
      return Text(
        'Add some volunteering work!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            volunteeringWorks.map((work) {
              final String startDate =
                  '${work.dateStarted.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${work.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap: () {
                  if (selectedVolunteeringWork == work) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyEditVolunteeringWorkScreen(
                              volunteeringWork: work,
                            ),
                      ),
                    );
                  }
                  setState(() {
                    selectedVolunteeringWork = work;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditVolunteeringWorkScreen(
                            volunteeringWork: work,
                          ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        work == selectedVolunteeringWork
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              work.institutionName,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                startDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(work.role, style: theme.textTheme.displayMedium),
                      const SizedBox(height: 4),
                      Text(
                        work.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }

  Map<ProfileAttribute, Widget> getAttributeWidgetData(context) {
    ThemeData theme = Theme.of(context);

    return {
      ProfileAttribute.projects: const MyExistingProjectsWidget(),
      ProfileAttribute.workExperience: const MyExistingWorkExperiencesWidget(),
      ProfileAttribute.certDegrees: showExistingCertDegrees(context),
      ProfileAttribute.skillsStrengths: showExistingSkillsStrengths(context),
      ProfileAttribute.personalStories: showExistingPersonalStories(context),
      ProfileAttribute.volunteeringWork: showExistingVolunteeringWorks(context),
    };
  }
}
