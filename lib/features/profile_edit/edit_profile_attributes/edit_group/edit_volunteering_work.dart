import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditVolunteeringWorkScreen extends StatefulWidget {
  const MyEditVolunteeringWorkScreen({super.key});

  @override
  State<MyEditVolunteeringWorkScreen> createState() =>
      _MyEditVolunteeringWorkScreenState();
}

class _MyEditVolunteeringWorkScreenState
    extends State<MyEditVolunteeringWorkScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Volunteering Work', context)),
      ),
    );
  }
}
