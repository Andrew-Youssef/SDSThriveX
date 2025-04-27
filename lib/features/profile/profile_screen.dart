import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/providers/user_provider.dart';
import '../../data/data.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final double coverHeight = 280;
  final double profileHeight = 144;

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
    final userProvider = Provider.of<UserProvider>(context);
    final theme = userProvider.getTheme();
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [buildTop(), buildContent(), buildAttributeData()],
          ),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildAttributeButtons(),
              Text(
                'About',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Place holder text for About',
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

  Widget buildAttributeData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            profileAttributes.keys.map((key) {
              if (profileAttributes[key]!) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Place holder text for $key',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 10),
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }).toList(),
      ),
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
}
