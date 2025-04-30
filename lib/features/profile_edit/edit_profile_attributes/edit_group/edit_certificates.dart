import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/widgets/header.dart';

class MyEditCertificatesScreen extends StatefulWidget {
  const MyEditCertificatesScreen({super.key});

  @override
  State<MyEditCertificatesScreen> createState() =>
      _MyEditCertificatesScreenState();
}

class _MyEditCertificatesScreenState extends State<MyEditCertificatesScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(appBar: myAppBar('Edit Certificates', context)),
      ),
    );
  }
}
