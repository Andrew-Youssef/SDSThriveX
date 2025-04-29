import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditDegreesScreen extends StatefulWidget {
  const MyEditDegreesScreen({super.key});

  @override
  State<MyEditDegreesScreen> createState() => _MyEditDegreesScreenState();
}

class _MyEditDegreesScreenState extends State<MyEditDegreesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Degrees', context)),
      ),
    );
  }
}
