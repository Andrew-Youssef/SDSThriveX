import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditProjectsScreen extends StatefulWidget {
  const MyEditProjectsScreen({super.key});

  @override
  State<MyEditProjectsScreen> createState() => _MyEditProjectsScreenState();
}

class _MyEditProjectsScreenState extends State<MyEditProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Projects', context)),
      ),
    );
  }
}
