import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/profile_model.dart';
import 'package:screens/providers/user_provider.dart';
import 'package:screens/widgets/header.dart';

class MyEditProfileDetailsScreen extends StatefulWidget {
  final ProfileModel profile;

  const MyEditProfileDetailsScreen({super.key, required this.profile});

  @override
  State<MyEditProfileDetailsScreen> createState() =>
      _MyEditProfileDetailsScreenState();
}

class _MyEditProfileDetailsScreenState
    extends State<MyEditProfileDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _profilePicUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _titleController = TextEditingController(text: widget.profile.title);
    _descriptionController = TextEditingController(
      text: widget.profile.description,
    );
    _profilePicUrlController = TextEditingController(
      text: widget.profile.profilePicUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _profilePicUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          appBar: myAppBar('Edit Profile Details', context),
          body: Column(
            children: [
              buildInputFields(context),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    userProvider.updateProfile({
                      'name': _nameController.text,
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'profilePicUrl': _profilePicUrlController.text,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // color: theme.primaryColor,
                  child: Text(
                    'Update Details',
                    style: theme.textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),

                // GestureDetector(
                //   onTap: () {
                //     userProvider.updateProfile({
                //       'name': _nameController.text,
                //       'title': _titleController.text,
                //       'description': _descriptionController.text,
                //       'profilePicUrl': _profilePicUrlController.text,
                //     });
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(8.0),
                //     decoration: BoxDecoration(
                //       color: theme.primaryColor,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     // color: theme.primaryColor,
                //     child: Text(
                //       'Update Details',
                //       style: theme.textTheme.displayMedium!.copyWith(
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputFields(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Flexible(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.profile.updateName,
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.profile.updateTitle,
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Brief Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.profile.updateDescription,
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: widget.profile.updateProfilePic,
              controller: _profilePicUrlController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Profile Picture URL',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
