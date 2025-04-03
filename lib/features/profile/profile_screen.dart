import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [buildTop(), buildContent()],
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
              // buildExpandableWidgets(),
            ],
          ),
        ),
      ],
    );
  }

  // Widget buildExpandableWidget() {
  //   return
  // }

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
