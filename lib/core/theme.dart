//theme data

//TUTORIAL
//theme data is automatically assigned so its whatever dont need to worry abt it
//bitter is now the default font

//instead of styling each individual text widget, common text widgets will be grouped
//idk what the grouping is yet but if you go down to setMyTheme => return ThemeData => textTheme
//you will see headlineSmall, displayMedium, etc
//these are the hard coded stylings for this specific textStyle
//to access them in a Text widget:
//Text("text", style: Theme.of(context).textTheme.(the textTheme you want));
//this will apply the specific textTheme styling to that widget
//if you want to change a property eg color without overriding the entire theme:
//Theme.of(context).textTheme.titleMedium?.copyWith(color: myColor);
//copyWith keeps current styling and just overwrites whatever is in the param list

import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/data/globals.dart';
import 'package:google_fonts/google_fonts.dart';

// Color.fromARGB(255, 255, 255, 255) // first   color white
// Color.fromARGB(255, 162, 155, 254) // second  color blue/purple
// Color.fromARGB(255, 76, 202, 240)  // third   color blue         PROFESSOR
// Color.fromARGB(255, 244, 162, 97)  // fourth  color orange
// Color.fromARGB(255, 188, 107, 217) // fifth   color purple       STUDENT
// Color.fromARGB(255, 42, 157, 143)  // sixth   color green/blue   RECRUITER
// Color.fromARGB(255, 255, 112, 90)  // seventh color red/orange   COACH

class MyThemeData {
  late UserType _userType;
  late ThemeData _myTheme;

  final Map<UserType, Color> _myPrimaryColor = {
    UserType.coach: Color.fromARGB(255, 255, 112, 90),
    UserType.student: Color.fromARGB(255, 188, 107, 217),
    UserType.professor: Color.fromARGB(255, 76, 202, 240),
    UserType.recruiter: Color.fromARGB(255, 42, 157, 143),
  };

  MyThemeData(UserType userType) {
    _userType = userType;
    _myTheme = setMyTheme();
  }

  void setUserType(UserType userType) {
    _userType = userType;
    _myTheme = setMyTheme();
  }

  ThemeData getMyTheme() {
    return _myTheme;
  }

  ThemeData setMyTheme() {
    Color thisPrimaryColor = _myPrimaryColor[_userType]!;
    TextTheme myFont = GoogleFonts.bitterTextTheme();

    return ThemeData(
      useMaterial3: true,
      primaryColor: thisPrimaryColor,
      textTheme: myFont.copyWith(
        //the italic in notifications
        headlineSmall: myFont.headlineSmall?.copyWith(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
        //notification titlecard main text -> titleMedium with modifications
        //notification "No new notificaiton" -> same as above

        //notification button text
        labelSmall: myFont.labelSmall?.copyWith(
          fontSize: 14,
          height: 1.5,
          color: thisPrimaryColor,
        ),

        //dashboard main text
        displayMedium: myFont.displayMedium?.copyWith(
          fontSize: 15,
          height: 1.5,
          color: Colors.black,
        ),
        //dashboard title text
        titleMedium: myFont.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.5,
          color: Colors.black,
        ),
      ),

      //for dividers, can manually change thickness
      dividerColor: Colors.black54,

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: thisPrimaryColor,
        indicatorColor: thisPrimaryColor,
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
  }
}
