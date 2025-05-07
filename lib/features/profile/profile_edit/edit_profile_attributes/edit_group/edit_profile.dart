import 'package:flutter/material.dart';
import '../../../../../widgets/header.dart';

class MyEditProfileAttributesScreen extends StatefulWidget {
  const MyEditProfileAttributesScreen({super.key});

  @override
  State<MyEditProfileAttributesScreen> createState() =>
      _MyEditProfileAttributesScreenState();
}

class _MyEditProfileAttributesScreenState
    extends State<MyEditProfileAttributesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Profile Details', context)),
      ),
    );
  }
}
