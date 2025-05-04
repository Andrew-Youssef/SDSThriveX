import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditCertDegreesScreen extends StatefulWidget {
  const MyEditCertDegreesScreen({super.key});

  @override
  State<MyEditCertDegreesScreen> createState() =>
      _MyEditCertificatesScreenState();
}

class _MyEditCertificatesScreenState extends State<MyEditCertDegreesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Cert & Degrees', context)),
      ),
    );
  }
}
