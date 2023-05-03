import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:uniconnect/util/colors.dart';
import '../../main.dart';
import '../../models/note.dart';

class notes_Upload_Post extends StatefulWidget {
  const notes_Upload_Post({super.key});

  @override
  State<notes_Upload_Post> createState() => _notes_Upload_Post();
}

class _notes_Upload_Post extends State<notes_Upload_Post> {
  late String? _semester = "";
  late String? _course = "";
  final User? user = FirebaseAuth.instance.currentUser;
  String? filename;

  File? file;

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
  }

  void uploadAndShowSnackbar(
      BuildContext context, String filename, File file) async {
    String res = "some error occurred";
    try {
      final downloadLink = await uploadPdf(filename, file);
      Note newnote = Note(
        noteid: uuid.v1(),
        name: filename,
        semester: _semester!,
        course: _course!,
        pdfUrl: downloadLink,
        uploadedby: user?.uid.toString(),
        uploadedon: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("notes")
          .doc(newnote.noteid)
          .set(newnote.toMap());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res),
      ),
    );
  }

  Future<String> uploadPdf(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("pdfs/$fileName");
    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  bool checkdetails() {
    if (_course!.isEmpty || _semester!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a course/semester");
      // showSnackBar("Please select the semester/course", context);
      return false;
    }
    if (filename == null) {
      Fluttertoast.showToast(msg: "Please select a file to upload");
      // showSnackBar("Please select the semester/course", context);
      return false;
    }
    return true;
  }

  void pickfile() async {
    final pickedfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (pickedfile != null) {
      filename = pickedfile.files[0].name;
      file = File(pickedfile.files[0].path!);
      setState(() {});
    }

    // print("pdf uploaded successfully");
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    // final model.User? user = Provider.of<UserProvider>(context).getUser;
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Upload Notes'),
          centerTitle: false,
        ),
        body: Column(
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
            SizedBox(
              height: 75.0,
              width: 200.0,
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Select File',
                  border: OutlineInputBorder(),
                ),
                onTap: pickfile,
                controller: TextEditingController(text: filename),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () async {
                  if (checkdetails()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text("Uploading PDF..."),
                            ],
                          ),
                        );
                      },
                    );

                    final downloadLink = await uploadPdf(filename!, file!);

                    Note newnote = Note(
                      noteid: uuid.v1(),
                      name: filename,
                      semester: _semester!,
                      course: _course!,
                      pdfUrl: downloadLink,
                      uploadedby: currentUserId,
                      uploadedon: DateTime.now(),
                    );

                    FirebaseFirestore.instance
                        .collection("notes")
                        .doc(newnote.noteid)
                        .set(newnote.toMap());
                    Navigator.of(context).pop(); // dismiss the loading dialog
                    Fluttertoast.showToast(msg: "File successfully uploaded");
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: iconcolor,
                  // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, // Horizontal padding
                    vertical: 10, // Vertical padding
                  ),
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 16, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
