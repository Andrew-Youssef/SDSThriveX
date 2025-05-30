import 'package:flutter/material.dart';

AppBar myAppBar(String title, BuildContext context) {
  ThemeData theme = Theme.of(context);
  bool canPop = Navigator.canPop(context);

  return AppBar(
    backgroundColor: theme.primaryColor,
    toolbarHeight: 45,
    centerTitle: true,
    title: Text(
      title,
      style: theme.textTheme.titleMedium!.copyWith(color: Colors.white),
    ),
    leading: IconButton(
      icon:
          canPop
              ? const Icon(Icons.arrow_back, color: Colors.white)
              : SizedBox.shrink(),
      onPressed: () {
        if (canPop) {
          Navigator.pop(context);
        }
      },
    ),
  );
}
