import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditPersonalStoriesScreen extends StatefulWidget {
  const MyEditPersonalStoriesScreen({super.key});

  @override
  State<MyEditPersonalStoriesScreen> createState() =>
      _MyEditPersonalStoriesScreenState();
}

class _MyEditPersonalStoriesScreenState
    extends State<MyEditPersonalStoriesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Personal Stories', context)),
      ),
    );
  }
}
