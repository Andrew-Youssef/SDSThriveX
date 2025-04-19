import 'package:flutter/material.dart';
import 'package:flutter_innatex_student_screens/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/search_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = userProvider.getTheme();
    final projectIndex = (currentPage - 1).clamp(0, totalPages - 1);
    final project = projectData[projectIndex];

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // header background
              Container(
                color: theme.primaryColor,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    buildSearchBar('Search'),
                    buildSearchButton(),
                  ],
                ),
              ),

              buildSwitchProjectButtons(),

              const SizedBox(height: 20),

              Text(
                project["title"]!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(project["subtitle"]!),
              const SizedBox(height: 20),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.network(project["image"]!, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: const [Icon(Icons.cancel), Text("Reject")]),
                  const SizedBox(width: 40),
                  Column(
                    children: const [Icon(Icons.check_circle), Text("Certify")],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSwitchProjectButtons() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: previousPage,
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.black),
              onPressed: nextPage,
            ),
          ],
        ),
        Text("$currentPage/$totalPages", style: TextStyle(color: Colors.black)),
      ],
    );
  }
}


//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       body: SafeArea(
//         child: Column(
//           children: [
//             buildSearchBar('Enter a project'),
//             buildSearchButton(),
//             // FULL-WIDTH ORANGE HEADER (NO CORNERS)

//             // Container(
//             //   width: double.infinity,
//             //   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//             //   color: Colors.orange, // <- solid edge-to-edge background
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       IconButton(
//             //         icon: Icon(Icons.arrow_back, color: Colors.black),
//             //         onPressed: () {
//             //           Navigator.pop(context);
//             //         },
//             //       ),
//             //       Column(
//             //         children: [
//             //           Row(
//             //             children: [
//             //               IconButton(
//             //                 icon: Icon(
//             //                   Icons.arrow_back_ios,
//             //                   color: Colors.black,
//             //                 ),
//             //                 onPressed: previousPage,
//             //               ),
//             //               IconButton(
//             //                 icon: Icon(
//             //                   Icons.arrow_forward_ios,
//             //                   color: Colors.black,
//             //                 ),
//             //                 onPressed: nextPage,
//             //               ),
//             //             ],
//             //           ),
//             //           Text(
//             //             "$currentPage/$totalPages",
//             //             style: TextStyle(color: Colors.black),
//             //           ),
//             //         ],
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             SizedBox(height: 20),
//             Text(
//               project["title"]!,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             Text(project["subtitle"]!),
//             SizedBox(height: 20),
//             Container(
//               height: 200,
//               width: 200,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Image.network(project["image"]!, fit: BoxFit.cover),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     IconButton(icon: Icon(Icons.cancel), onPressed: () {}),
//                     Text("Reject"),
//                   ],
//                 ),
//                 SizedBox(width: 40),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.check_circle),
//                       onPressed: () {},
//                     ),
//                     Text("Certify"),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }