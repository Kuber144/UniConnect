import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:uniconnect/screens/notes_screens/notes_upload.dart';
import 'package:uniconnect/screens/notes_screens/pdf_viewer_screen.dart';
import 'package:uniconnect/util/colors.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'my_notes.dart';

class notesFeedScreen extends StatefulWidget {
  const notesFeedScreen({Key? key}) : super(key: key);

  @override
  State<notesFeedScreen> createState() => _notesFeedScreenState();
}

class _notesFeedScreenState extends State<notesFeedScreen> {
  List<Map<String, dynamic>> pdfData = [];
  late String? _semester = "";
  late String? _course = "";

  void getAllpdfs({String? semester, String? course}) async {
    final query = FirebaseFirestore.instance.collection("notes");

    if (semester != null && semester.isNotEmpty) {
      query.where("semester", isEqualTo: semester);
    }
    if (course != null && course.isNotEmpty) {
      query.where("course", isEqualTo: course);
    }

    final results = await query.get();

    if (semester == null || semester.isEmpty) {
      // Display all PDFs
      pdfData = results.docs.map((e) => e.data()).toList();
    } else {
      // Filter based on semester (and course, if provided)
      pdfData = results.docs
          .where((doc) =>
              doc["semester"] == semester &&
              (course == null || course.isEmpty || doc["course"] == course))
          .map((e) => e.data())
          .toList();
    }

    setState(() {});
  }

  Future<String> downloadFile(String url) async {
    Directory? storageDirectory = await getExternalStorageDirectory();
    String downloadsPath = '${storageDirectory!.path}/Download';
    Directory downloadsDirectory = Directory(downloadsPath);
    if (!downloadsDirectory.existsSync()) {
      downloadsDirectory.createSync();
    }
    Dio dio = Dio();
    String fileName = Uri.decodeFull(url.split('/').last.split('?')[0]);
    fileName = fileName.substring(5);
    // print(fileName);
    String filePath = '/storage/emulated/0/Download/$fileName';
    try {
      // Download the file and save it to the Downloads folder
      await dio.download(url, filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  List<dynamic> semesters = [];
  List<dynamic> courseMasters = [];
  List<dynamic> courses = [];

  @override
  void initState() {
    super.initState();
    semesters.add({"id": 1, "label": "Semester 1"});
    semesters.add({"id": 2, "label": "Semester 2"});
    semesters.add({"id": 3, "label": "Semester 3"});
    semesters.add({"id": 4, "label": "Semester 4"});
    semesters.add({"id": 5, "label": "Semester 5"});
    semesters.add({"id": 6, "label": "Semester 6"});
    courseMasters = [
      {"ID": 1, "Name": "LAL", "ParentId": 1},
      {"ID": 2, "Name": "FEE", "ParentId": 1},
      {"ID": 3, "Name": "POM", "ParentId": 1},
      {"ID": 4, "Name": "PFC", "ParentId": 1},
      {"ID": 5, "Name": "PHY", "ParentId": 1},
      {"ID": 6, "Name": "ITP", "ParentId": 1},
      {"ID": 1, "Name": "UMC", "ParentId": 2},
      {"ID": 2, "Name": "DMS", "ParentId": 2},
      {"ID": 3, "Name": "DST", "ParentId": 2},
      {"ID": 4, "Name": "PCE", "ParentId": 2},
      {"ID": 5, "Name": "IOM", "ParentId": 2},
      {"ID": 6, "Name": "COA", "ParentId": 2},
      {"ID": 1, "Name": "OS", "ParentId": 3},
      {"ID": 2, "Name": "OOM", "ParentId": 3},
      {"ID": 3, "Name": "PS", "ParentId": 3},
      {"ID": 4, "Name": "IF", "ParentId": 3},
      {"ID": 5, "Name": "IM", "ParentId": 3},
      {"ID": 6, "Name": "TOC", "ParentId": 3},
      {"ID": 1, "Name": "DBMS", "ParentId": 4},
      {"ID": 2, "Name": "SE", "ParentId": 4},
      {"ID": 3, "Name": "DAA", "ParentId": 4},
      {"ID": 4, "Name": "PPL", "ParentId": 4},
      {"ID": 5, "Name": "CN", "ParentId": 4},
    ];
    getAllpdfs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Notes Sharing"),
        actions: [
          _buildPopupMenuButton(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    return ScaleTransition(
                      alignment: Alignment.bottomRight,
                      scale: animation,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation) {
                    return const notes_Upload_Post();
                  }));
        },
        backgroundColor: iconcolor,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              FormHelper.dropDownWidgetWithLabel(
                context,
                "Semester",
                "Choose semester",
                _semester,
                semesters,
                (onChangedVal) {
                  _semester = onChangedVal;
                  getAllpdfs(semester: _semester, course: _course);
                  // print('$onChangedVal');
                  courses = courseMasters
                      .where(
                        (stateItem) =>
                            stateItem["ParentId"].toString() ==
                            onChangedVal.toString(),
                      )
                      .toList();
                  _course = "";
                  setState(() {});
                },
                (onValidateVal) {
                  if (onValidateVal == null) {
                    return 'Please select semester';
                  }
                  return null;
                },
                optionValue: "id",
                optionLabel: "label",
              ),
              FormHelper.dropDownWidgetWithLabel(
                context,
                "Course",
                "Select Course",
                _course,
                courses,
                (onChangedVal) {
                  _course = onChangedVal;
                  getAllpdfs(semester: _semester, course: _course);
                  // print("Selected Course is: $onChangedVal");
                },
                (onValidate) {
                  return null;
                },
                optionValue: "ID",
                optionLabel: "Name",
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: GridView.builder(
                    itemCount: pdfData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PdfViewerScreen(
                                        pdfUrl: pdfData[index]['pdfUrl'],
                                        pdfName: pdfData[index]['name'],
                                      )));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  // border: Border.all(),
                                  ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/pdf_1.png",
                                    height: 75,
                                    width: 75,
                                  ),
                                  Text(
                                    pdfData[index]['name'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // final status0 =
                                      // await Permission.storage.request();
                                      var status = await Permission
                                          .manageExternalStorage
                                          .request();
                                      var status2 = await Permission
                                          .accessMediaLocation
                                          .request();
                                      var status3 =
                                          await Permission.photos.request();
                                      if (status.isGranted &&
                                          status2.isGranted &&
                                          status3.isGranted) {
                                        try {
                                          String downloadPath =
                                              await downloadFile(
                                                  pdfData[index]['pdfUrl']);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'File will be downloaded to $downloadPath')),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error occurred while downloading file: $e')),
                                          );
                                        }
                                      } else if (status.isPermanentlyDenied) {
                                        openAppSettings();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const Text(
                                        'Download',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        // navigate to MyRequestsScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const myNotes()),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'My_Notes',
          child: Text('My Notes'),
        ),
      ],
    );
  }
}
