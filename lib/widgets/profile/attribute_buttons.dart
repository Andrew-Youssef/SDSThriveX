import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/data/globals.dart';

Widget buildAttributeButtons({
  required Map<String, bool> profileAttributes,
  required void Function(String) onToggle,
}) {
  return Wrap(
    spacing: 8,
    children:
        profileAttributes.keys.map((key) {
          return ElevatedButton(
            onPressed: () {
              onToggle(key);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  profileAttributes[key]! ? Colors.blue : Colors.white70,
            ),
            child: Text(key),
          );
        }).toList(),
  );
}
