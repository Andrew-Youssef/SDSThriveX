import 'package:flutter/material.dart';

class MyCalenderScreen extends StatefulWidget {
  const MyCalenderScreen({super.key});

  @override
  State<MyCalenderScreen> createState() => _MyCalenderScreenState();
}

class _MyCalenderScreenState extends State<MyCalenderScreen> {
  Map<int, Color> dateColors = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.yellow,
    4: Colors.yellow,
    5: Colors.red,
    6: Colors.green,
    7: Colors.green,
    8: Colors.red,
    9: Colors.green,
    10: Colors.yellow,
    11: Colors.yellow,
    12: Colors.blue,
    13: Colors.green,
    14: Colors.green,
    15: Colors.red,
    16: Colors.green,
    17: Colors.yellow,
    18: Colors.red,
    19: Colors.red,
    20: Colors.green,
    21: Colors.green,
    22: Colors.red,
    23: Colors.yellow,
    24: Colors.yellow,
    25: Colors.yellow,
    26: Colors.blue,
    27: Colors.green,
    28: Colors.green,
    29: Colors.red,
    30: Colors.green,
  };

  int? selectedDay;
  String selectedDate = "Select a date";
  String description = "";

  void onDateSelected(int day) {
    setState(() {
      selectedDay = day;
      selectedDate = "April $day";
      description =
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet urna ornare, faucibus quam vitae, ullamcorper massa. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc eget euismod risus. Morbi ac dui blandit, euismod nisi vitae, bibendum ex. Nullam vel justo eu erat aliquam iaculis. Quisque pulvinar dui non ligula bibendum, a pretium lectus tincidunt. Integer enim diam, pretium vel sagittis id, luctus vel lacus. Quisque quis metus in quam pharetra porta ut eget odio. Proin pulvinar diam at quam viverra malesuada. Proin blandit libero ac hendrerit scelerisque. Curabitur luctus eros metus, et faucibus diam consectetur eu. Donec id arcu placerat, volutpat nisl eget, pretium nunc. Duis mi ante, condimentum commodo ornare eu, mattis ut diam. Nulla aliquam placerat tellus fermentum convallis. Donec dignissim lectus non malesuada posuere. Vestibulum vel interdum nibh, id facilisis justo. Aenean facilisis augue a nisl convallis hendrerit. Cras viverra imperdiet sem quis rhoncus. Nunc suscipit nibh id enim tempus ullamcorper. Donec venenatis tempus nunc, in varius tellus iaculis non. Fusce dolor tortor, pellentesque non tincidunt quis, rhoncus vitae nisl. Sed sagittis sit amet enim vel aliquet. Quisque vulputate diam a facilisis finibus. Donec ac justo semper, consectetur massa quis, elementum orci.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(60.0),
  child: Container(
    color: Colors.orange,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    child: SafeArea(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {Navigator.pop(context);},
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "April 2025",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(30, (index) {
                int day = index + 1;
                return GestureDetector(
                  onTap: () => onDateSelected(day),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          selectedDay == day
                              ? Colors.purple
                              : dateColors[day],
                      shape: BoxShape.circle,
                    ),
                    child: Text("$day", style: TextStyle(color: Colors.white)),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(Colors.red, "Unavailable"),
                    _buildLegend(Colors.yellow, "1-on-1 Session"),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend(Colors.blue, "Seminar"),
                    _buildLegend(Colors.green, "Available"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              selectedDate,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(description, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Container(width: 20, height: 20, color: color),
          SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}