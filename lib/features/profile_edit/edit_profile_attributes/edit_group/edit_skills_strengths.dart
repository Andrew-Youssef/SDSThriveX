import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditSkillsStrengthsScreen extends StatefulWidget {
  const MyEditSkillsStrengthsScreen({super.key});

  @override
  State<MyEditSkillsStrengthsScreen> createState() =>
      _MyEditSkillsStrengthsScreenState();
}

class _MyEditSkillsStrengthsScreenState
    extends State<MyEditSkillsStrengthsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Skills and Strengths', context)),
      ),
    );
  }
}
