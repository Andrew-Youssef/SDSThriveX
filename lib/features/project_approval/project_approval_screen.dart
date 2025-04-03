import 'package:flutter/material.dart';

class MyPendingProjectScreen extends StatefulWidget {
  const MyPendingProjectScreen({super.key});

  @override
  State<MyPendingProjectScreen> createState() => _MyPendingProjectPageState();
}

class _MyPendingProjectPageState extends State<MyPendingProjectScreen> {
  int currentPage = 1;

  final List<Map<String, String>> projectData = [
    {
      "title": "Pending Project 1",
      "subtitle": "Music App by Paul Matthews",
      "image":
          "https://studio.code.org/shared/images/courses/logo_tall_dance-2022.png",
    },
    {
      "title": "Pending Project 2",
      "subtitle": "Encrypter by Sarah Lee",
      "image":
          "https://www.sciencefriday.com/wp-content/uploads/2015/08/hello.png?w=490&h=300&crop=1",
    },
    {
      "title": "Pending Project 3",
      "subtitle": "Lebron Music Studio by John Doe",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8cO_splHG1lQ8nlHPNvv1zNxZX9ZOSNBiqw&s",
    },
    // Add more projects if needed
  ];

  int get totalPages => projectData.length;

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  @override //like CSS
  Widget build(BuildContext context) {
    final projectIndex = (currentPage - 1).clamp(
      0,
      totalPages - 1,
    ); //ensure value stays within range or red
    final project = projectData[projectIndex];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple,
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
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: previousPage,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: nextPage,
                          ),
                        ],
                      ),
                      Text("$currentPage/$totalPages"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                project["title"]!,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(project["subtitle"]!),
              SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(project["image"]!, fit: BoxFit.cover),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(icon: Icon(Icons.cancel), onPressed: () {}),
                      Text("Reject"),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {},
                      ),
                      Text("Certify"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
