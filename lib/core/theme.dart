//theme data
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(70, 162, 155, 254),
    brightness: Brightness.light,
  ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: Color.fromARGB(70, 162, 155, 254),
  //     foregroundColor: Colors.purple.shade400,
  //   ),
  // ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(70, 162, 155, 254),
    brightness: Brightness.dark,
  ),
);
