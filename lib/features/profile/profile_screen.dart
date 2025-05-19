import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/providers/user_provider.dart';
import '../../data/globals.dart';
import '../../core/models/export_models.dart';
import '../profile/profile_edit/profile_edit_screen.dart';
import '../profile/profile_edit/edit_profile_attributes/edit_group/export_edit_group.dart';
import '../../widgets/header.dart';
import '../../widgets/profile_screen/export_attribute_display_widgets.dart';

class MyProfileScreen extends StatefulWidget {
  final String selectedUserId;

  const MyProfileScreen({super.key, required this.selectedUserId});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool isLoggedInUser = false;

  final double coverHeight = 140;
  final double profileHeight = 130;

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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);
    String currUID = userProvider.userId;

    isLoggedInUser = (currUID == widget.selectedUserId);

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
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
                  Row(
                    children: [
                      Text(
                        'John Smith',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 28,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            isLoggedInUser
                                ? () {
                                  userProvider.profile!.updateEndorsement();
                                }
                                : null,
                        icon: Icon(Icons.check_circle_outline_outlined),
                      ),
                    ],
                  ),
                  Text('Student at UTS', style: theme.textTheme.displayMedium),
                ],
              ),
              Expanded(child: SizedBox()),
              IconButton(
                onPressed:
                    isLoggedInUser
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyEditProfileScreen(),
                            ),
                          );
                        }
                        : null,
                icon: isLoggedInUser ? Icon(Icons.edit) : SizedBox.shrink(),
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
              // buildAttributeButtons(),
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

  // Widget buildAttributeButtons() {
  //   return Wrap(
  //     spacing: 8,
  //     children:
  //         profileAttributes.keys.map((key) {
  //           return ElevatedButton(
  //             onPressed: () {
  //               toggleProfileAttributes(key);
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor:
  //                   profileAttributes[key]! ? Colors.blue : Colors.white70,
  //             ),
  //             child: Text(profileAttributeLabels[key]!),
  //           );
  //         }).toList(),
  //   );
  // }

  Widget buildAttributeData(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final attributes = userProvider.profileAttributes;
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          attributes.keys.map((key) {
            //displays all attributes to logged in user
            //only displays filled attributes when viewing other user
            if (attributes[key]! || isLoggedInUser) {
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
                              onPressed:
                                  isLoggedInUser
                                      ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: attributeScreens[key]!,
                                          ),
                                        );
                                      }
                                      : null,
                              icon:
                                  isLoggedInUser
                                      ? Icon(Icons.edit)
                                      : SizedBox.shrink(),
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
