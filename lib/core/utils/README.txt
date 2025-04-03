UTILS
sopposed to store utility functions for the app
some examples from gpt:

for input validation

class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
        .hasMatch(email);
  }
}

for data formatting

import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}

etc i guess. 

i dont know if im using this