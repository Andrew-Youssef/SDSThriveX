import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screens/features/search/search.dart';

Widget buildSearchButton(context) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: IconButton.filled(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
      icon: const Icon(Icons.search),
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(
          Color.fromARGB(255, 255, 255, 255),
        ),
        foregroundColor: WidgetStatePropertyAll<Color>(
          Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    ),
  );
}

Widget buildSearchBar(String text) {
  return Flexible(
    child: Padding(
      padding: const EdgeInsets.only(left: 12),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            hintText: text,
            controller: controller,
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item, style: GoogleFonts.bitter()),
              onTap: () {
                controller.closeView(item);
              },
            );
          });
        },
      ),
    ),
  );
}
