import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_My_Requests.dart';
import 'package:uniconnect/screens/notes_upload.dart';
import 'package:uniconnect/screens/pdf_viewer_screen.dart';
import 'package:uniconnect/util/colors.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class notesFeedScreen extends StatefulWidget {
  const notesFeedScreen({Key? key}) : super(key: key);

  @override
  State<notesFeedScreen> createState() => _notesFeedScreenState();
}

class _notesFeedScreenState extends State<notesFeedScreen> {
  List<Map<String, dynamic>> pdfData = [];

  void getAllpdfs() async {
    final results = await FirebaseFirestore.instance.collection("notes").get();

    pdfData = results.docs.map((e) => e.data()).toList();
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
    fileName = fileName.substring(5, fileName.length - 4);
    print(fileName);
    String filePath = '/storage/emulated/0/Download/$fileName';
    try {
      // Download the file and save it to the Downloads folder
      await dio.download(url, filePath);
      return filePath;
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
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
          GridView.builder(
              itemCount: pdfData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                                  pdfUrl: pdfData[index]['pdfUrl'],
                                  pdfName: pdfData[index]['name'],
                                )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            // border: Border.all(),
                            ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                var status3 = await Permission.photos.request();
                                if (status.isGranted &&
                                    status2.isGranted &&
                                    status3.isGranted) {
                                  try {
                                    String downloadPath = await downloadFile(
                                        pdfData[index]['pdfUrl']);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'File will be downloaded to $downloadPath')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                                  borderRadius: BorderRadius.circular(20.0),
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
              })
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
          MaterialPageRoute(builder: (context) => const My_Requests()),
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
