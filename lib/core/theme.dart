//theme data
import 'package:flutter/material.dart';
// Color.fromARGB(255, 255, 255, 255) // first   color white
// Color.fromARGB(255, 162, 155, 254) // second  color blue/purple
// Color.fromARGB(255, 76, 202, 240)  // third   color blue
// Color.fromARGB(255, 244, 162, 97)  // fourth  color orange
// Color.fromARGB(255, 188, 107, 217) // fifth   color purple
// Color.fromARGB(255, 42, 157, 143)  // sixth   color green/blue
// Color.fromARGB(255, 255, 112, 90)  // seventh color red/orange

final ThemeData studentTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 188, 107, 217),
  // primaryColor: Color.fromARGB(255, 255, 112, 90),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 188, 107, 217),
    indicatorColor: Color.fromARGB(255, 188, 107, 217),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
      Set<WidgetState> states,
    ) {
      return const IconThemeData(color: Colors.white, size: 30);
    }),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),
);

final ThemeData coachTheme = ThemeData(
  // colorScheme: ColorScheme.fromSeed(
  //   seedColor: Color.fromARGB(255, 255, 112, 90),
  // ),
  // colorScheme: ColorScheme(
  //   brightness: brightness,
  //   primary: Color.fromARGB(255, 255, 112, 90),
  //   onPrimary: onPrimary,
  //   secondary: secondary,
  //   onSecondary: onSecondary,
  //   error: error,
  //   onError: onError,
  //   surface: surface,
  //   onSurface: onSurface
  // ),
  primaryColor: Color.fromARGB(255, 244, 163, 97),
  // primaryColor: Color.fromARGB(255, 255, 112, 90),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 112, 90),
    indicatorColor: Color.fromARGB(255, 255, 112, 90),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
      Set<WidgetState> states,
    ) {
      return const IconThemeData(color: Colors.white, size: 30);
    }),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),
);

final ThemeData professorTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 76, 202, 240),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 76, 202, 240),
    indicatorColor: Color.fromARGB(255, 76, 202, 240),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
      Set<WidgetState> states,
    ) {
      return const IconThemeData(color: Colors.white, size: 30);
    }),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),
);

final ThemeData recruiterTheme = ThemeData(
  primaryColor: Color.fromARGB(255, 42, 157, 143),

  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 42, 157, 143),
    indicatorColor: Color.fromARGB(255, 42, 157, 143),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
      Set<WidgetState> states,
    ) {
      return const IconThemeData(color: Colors.white, size: 30);
    }),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(color: Colors.white),
    ),
  ),
);

Map<String, ThemeData> userTheme = {
  'student': studentTheme,
  'coach': coachTheme,
  'professor': professorTheme,
  'recruiter': recruiterTheme,
};
