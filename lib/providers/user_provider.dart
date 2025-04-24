import 'package:flutter/material.dart';
import '../data/globals.dart';
import '../core/theme.dart';

class UserProvider extends ChangeNotifier {
  UserType _type = UserType.student;
  late MyThemeData _themeData;

  UserProvider() {
    _themeData = MyThemeData(_type);
  }
  //a getter that returns the UserType as an enum
  //can access like UserProvider.type
  UserType get type => _type;

  void setUserType(UserType newType) {
    _type = newType;
    _themeData.setUserType(_type);
    notifyListeners();
  }

  String getTypeName() {
    return _type.name;
  }

  ThemeData getTheme() {
    return _themeData.getMyTheme();
  }
}
