import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thrivex/features/profile/profile_screen.dart';
import '../../providers/user_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchName = "";
  bool filterEndorsement = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = userProvider.getTheme();
    // padding: EdgeInsetsDirectional.fromSTEB(10, 8, 10, 0),
    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Material(
                color: theme.primaryColor,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Flexible(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchName = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search, color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Endorsed Button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                child: SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterEndorsement = !filterEndorsement;
                      });
                    },
                    child: Text('Endorsed?'),
                  ),
                ),
              ),

              //listview
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      filterEndorsement
                          ? FirebaseFirestore.instance
                              .collection('users')
                              .where('isEndorsed', isEqualTo: true)
                              .orderBy('nameLowerCase')
                              .startAt([searchName.toLowerCase()])
                              .endAt(['${searchName.toLowerCase()}\uf8ff'])
                              // .limit(20)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('users')
                              .orderBy('nameLowerCase')
                              .startAt([searchName.toLowerCase()])
                              .endAt(['${searchName.toLowerCase()}\uf8ff'])
                              // .limit(20)
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
                          key: ValueKey(data.id), // Recommended for stability
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyProfileScreen(
                                      selectedUserId: data.id,
                                    ),
                              ),
                            );
                          },
                          title: Text(data['name']),
                          subtitle: Text(data['email']),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
