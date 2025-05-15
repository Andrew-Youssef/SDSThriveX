import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../data/globals.dart';
import '../../core/models/export_models.dart';
import '../profile/profile_edit/profile_edit_screen.dart';
import '../profile/profile_edit/edit_profile_attributes/edit_group/export_edit_group.dart';
import '../profile/profile_edit/edit_profile_attributes/edit_individual/export_edit_individual.dart';
import '../../widgets/header.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // currUID = FirebaseAuth.instance.currentUser?.uid
    // selectUID 
    // if currID != selectUID
    // 
    //
    //
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
  //certificates
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

  Image buildCoverImage() {
    return Image.network(
      'https://media.licdn.com/dms/image/v2/D4D12AQF6mW4EuB-99Q/article-cover_image-shrink_720_1280/article-cover_image-shrink_720_1280/0/1692951785182?e=2147483647&v=beta&t=9whX4YpHoNOzyq7CIiNwro17k-ajBH6TM3qo2CyH2Pk',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    );
  }

  Widget showExistingProjects(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<ProjectModel> projects = userProvider.projects;

    if (projects.isEmpty) {
      return Text(
        'Place holder text for Projects',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in projects) ...[
              GestureDetector(
                onTap: () {
                  if (selectedProject == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEditProjectScreen(project: p),
                      ),
                    );
                  }
                  setState(() {
                    selectedProject = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyEditProjectScreen(project: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedProject ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.name),
                      Text(p.dateBegun.toString().split(' ')[0]),
                      Text(
                        p.dateEnded != null
                            ? p.dateEnded!.toString().split(' ')[0]
                            : 'Unknown',
                      ),
                      Text(p.description),
                      Text(p.imageUrl != null ? p.imageUrl! : 'Unknown'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Widget showExistingWorkExperiences(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<WorkExperienceModel> workExperiences = userProvider.workExperiences;

    if (workExperiences.isEmpty) {
      return Text(
        'Place holder text for Work Experience',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in workExperiences) ...[
              GestureDetector(
                onTap: () {
                  if (selectedWorkExperience == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditWorkExperienceScreen(workExperience: p),
                      ),
                    );
                  }
                  setState(() {
                    selectedWorkExperience = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditWorkExperienceScreen(workExperience: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedWorkExperience ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.name),
                      Text(p.dateBegun.toString().split(' ')[0]),
                      Text(
                        p.dateEnded != null
                            ? p.dateEnded!.toString().split(' ')[0]
                            : 'Unknown',
                      ),
                      Text(p.description),
                      Text(p.role),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Widget showExistingCertDegrees(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<CertDegreesModel> certDegrees = userProvider.certDegrees;

    if (certDegrees.isEmpty) {
      return Text(
        'Place holder text for Certs & Degrees',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in certDegrees) ...[
              GestureDetector(
                onTap: () {
                  if (selectedCertDegree == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyEditCertDegreeScreen(certDegree: p),
                      ),
                    );
                  }
                  setState(() {
                    selectedCertDegree = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MyEditCertDegreeScreen(certDegree: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedCertDegree ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.institutionName),
                      Text(p.certificateName),
                      Text(p.dateStarted.toString().split(' ')[0]),
                      Text(
                        p.dateEnded != null
                            ? p.dateEnded!.toString().split(' ')[0]
                            : 'Unknown',
                      ),
                      Text(p.description),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Widget showExistingSkillsStrengths(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<SkillsStrengthsModel> skillsStrengths = userProvider.skillsStrengths;

    if (skillsStrengths.isEmpty) {
      return Text(
        'Place holder text for Skills & Strengths',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in skillsStrengths) ...[
              GestureDetector(
                onTap: () {
                  if (selectedSkillStrength == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditSkillStrengthScreen(skillStrength: p),
                      ),
                    );
                  }
                  setState(() {
                    selectedSkillStrength = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditSkillStrengthScreen(skillStrength: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedSkillStrength ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.skill),
                      Text(p.acquiredAt),
                      Text(p.description),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Widget showExistingPersonalStories(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<PersonalStoriesModel> stories = userProvider.personalStories;

    if (stories.isEmpty) {
      return Text(
        'Place holder text for Personal Stories',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in stories) ...[
              GestureDetector(
                onTap: () {
                  if (selectedPersonalStory == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MyEditPersonalStoryScreen(personalStory: p),
                      ),
                    );
                  }
                  setState(() {
                    selectedPersonalStory = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditPersonalStoryScreen(personalStory: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedPersonalStory ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.title),
                      Text(p.date.toString().split(' ')[0]),
                      Text(p.description),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Widget showExistingVolunteeringWorks(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);
    List<VolunteeringWorkModel> voluteers = userProvider.volunteeringWorks;

    if (voluteers.isEmpty) {
      return Text(
        'Place holder text for Volunteering Work',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return SizedBox(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            for (final p in voluteers) ...[
              GestureDetector(
                onTap: () {
                  if (selectedVolunteeringWork == p) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MyEditVolunteeringWorkScreen(
                              volunteeringWork: p,
                            ),
                      ),
                    );
                  }
                  setState(() {
                    selectedVolunteeringWork = p;
                  });
                },
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              MyEditVolunteeringWorkScreen(volunteeringWork: p),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.primaryColor,
                      width: p == selectedVolunteeringWork ? 5 : 3,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(p.institutionName),
                      Text(p.role),
                      Text(p.dateStarted.toString().split(' ')[0]),
                      Text(
                        p.dateEnded != null
                            ? p.dateEnded!.toString().split(' ')[0]
                            : 'Unknown',
                      ),
                      Text(p.description),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
          ],
        ),
      );
    }
  }

  Map<ProfileAttribute, Widget> getAttributeWidgetData(context) {
    return {
      ProfileAttribute.projects: showExistingProjects(context),
      ProfileAttribute.workExperience: showExistingWorkExperiences(context),
      ProfileAttribute.certDegrees: showExistingCertDegrees(context),
      ProfileAttribute.skillsStrengths: showExistingSkillsStrengths(context),
      ProfileAttribute.personalStories: showExistingPersonalStories(context),
      ProfileAttribute.volunteeringWork: showExistingVolunteeringWorks(context),
    };
  }
}
