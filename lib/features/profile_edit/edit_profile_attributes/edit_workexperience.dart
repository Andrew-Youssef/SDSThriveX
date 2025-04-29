import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditWorkExperienceScreen extends StatefulWidget {
  const MyEditWorkExperienceScreen({super.key});

  @override
  State<MyEditWorkExperienceScreen> createState() =>
      _MyEditWorkExperienceScreenState();
}

class _MyEditWorkExperienceScreenState
    extends State<MyEditWorkExperienceScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Work Experience', context)),
      ),
    );
  }
}
