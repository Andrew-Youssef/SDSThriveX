import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:screens/providers/user_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchName = "";

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = userProvider.getTheme();

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: SizedBox(
            height: 40,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchName = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ),

        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('name')
                  .startAt([searchName])
                  .endAt([
                    '$searchName\uf8ff',
                  ]) // Allow you to get all character after the searched name
                  .limit(10)
                  .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return ListTile(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyProfileScreen(userId: data['id']),
                    //   ),
                    // );
                  },
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
