import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final double coverHeight = 280;
  final double profileHeight = 144;

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

  void toggleProfileAttributes(String key) {
    setState(() {
      if (profileAttributes.containsKey(key)) {
        profileAttributes[key] = !profileAttributes[key]!;
      }
      print(profileAttributes[key]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [buildTop(), buildContent(), buildAttributeContents()],
      ),
    );
  }

  //projects
  //certificates
  //
  Widget buildContent() {
    return Column(
      children: [
        Column(
          children: [
            Text('John Smith', style: TextStyle(fontSize: 28)),
            Text('Student at UTS', style: TextStyle(fontSize: 15)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAttributeButtons(),
              Text(
                'About',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'I am a passionate individual who enjoys learning new technologies and exploring creative ways to solve complex problems. With a strong background in software development, I thrive in challenging environments and love collaborating with others. Outside of work, I enjoy hiking, photography, and reading about advancements in AI and machine learning.',
                // softWrap: true,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15),
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
              child: Text(key),
            );
          }).toList(),
    );
  }

  Widget buildAttributeContents() {
    bool allFalse = profileAttributes.values.every((value) => value = false);

    if (allFalse) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profileAttributes['AI Summary']!) buildAISummary(),
        if (profileAttributes['Projects']!) buildProjects(),
        if (profileAttributes['Work Experience']!) buildWorkExperience(),
        if (profileAttributes['Certificates']!) buildCertificates(),
        if (profileAttributes['Degrees']!) buildDegrees(),
        if (profileAttributes['Skills/Strengths']!) buildSkillsStrengths(),
        if (profileAttributes['Personal Stories']!) buildPersonalStories(),
        if (profileAttributes['Volunteering Work']!) buildVolunteeringWork(),
      ],
    );
  }

  Widget buildAISummary() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for AI Summary',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildProjects() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Projects',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Projects',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildWorkExperience() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Work Experience',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Work Experience',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildCertificates() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Certificates',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Certificates',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildDegrees() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Degrees',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Degrees',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildSkillsStrengths() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills/Strengths',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Skills/Strengths',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildPersonalStories() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Stories',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Personal Stories',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget buildVolunteeringWork() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Volunteering Work',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Place holder text for Volunteering Work',
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  //   'AI Summary': false,
  // 'Projects': false,
  // 'Work Experience': false,
  // 'Certificates': false,
  // 'Degrees': false,
  // 'Skills/Strengths': false,
  // 'Personal Stories': false,
  // 'Volunteering Work': false,

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
}
