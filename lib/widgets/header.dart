import 'package:flutter/material.dart';

AppBar myAppBar(String title, BuildContext context) {
  ThemeData theme = Theme.of(context);

  return AppBar(
    backgroundColor: theme.primaryColor,
    toolbarHeight: 45,
    centerTitle: true,
    title: Text(
      title,
      style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
    ),
  );
}
