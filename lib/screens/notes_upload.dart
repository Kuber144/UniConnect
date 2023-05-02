// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:uniconnect/resources/firestore_methods.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/note.dart';
import '../models/user.dart' as model;
// import '../models/user.dart';
import '../providers/providers.dart';
import '../widgets/text_field_input.dart';

class notes_Upload_Post extends StatefulWidget {
  const notes_Upload_Post({super.key});

  @override
  State<notes_Upload_Post> createState() => _notes_Upload_Post();
}

class _notes_Upload_Post extends State<notes_Upload_Post> {

  late String? _semester="";
  late String? _course="";
  final User? user = FirebaseAuth.instance.currentUser;
  String? filename ;
  File? file;


  List<dynamic> semesters=[];
  List<dynamic> courseMasters=[];
  List<dynamic> courses=[];



  @override
  void initState() {
    super.initState();
    semesters.add({"id": 1, "label": "Semester 1"});
    semesters.add({"id": 2, "label": "Semester 2"});
    semesters.add({"id": 3, "label": "Semester 3"});
    semesters.add({"id": 4, "label": "Semester 4"});
    semesters.add({"id": 5, "label": "Semester 5"});
    semesters.add({"id": 6, "label": "Semester 6"});

    courseMasters=[
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

  void uploadAndShowSnackbar(BuildContext context, String filename, File file) async {
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

      await FirebaseFirestore.instance.collection("notes").doc(newnote.noteid).set(newnote.toMap());

      res="success";
    } catch (e) {
      res=e.toString();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(res),
      ),
    );
  }


  Future<String> uploadPdf(String fileName, File file) async{
    final reference = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = reference.putFile(file);

    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickfile() async {

    final pickedfile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(pickedfile != null) {
        filename = pickedfile.files[0].name;
        file = File(pickedfile.files[0].path!);
        setState(() {});
        // final downloadLink = await uploadPdf(filename, file!);
        // Note newnote = Note(
        //   noteid: uuid.v1(),
        //   name: filename,
        //   semester: _semester!,
        //   course: _course!,
        //   pdfUrl: downloadLink,
        //   uploadedby: user?.uid.toString(),
        //   uploadedon: DateTime.now(),
        // );
        //
        // FirebaseFirestore.instance.collection("notes").doc(newnote.noteid).set(newnote.toMap());
      }

    // print("pdf uploaded successfully");

  }


  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider.of<UserProvider>(context).getUser;
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
          actions: [
            TextButton(
              onPressed: () {

              },
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        body: Column(
              children: [

                const SizedBox(height: 10,),
                FormHelper.dropDownWidgetWithLabel(context,
                    "Semester",
                    "Choose semester",
                    _semester,
                    semesters,
                    (onChangedVal){
                      _semester = onChangedVal;
                      print('$onChangedVal');
                      courses=courseMasters
                      .where(
                              (stateItem) =>
                              stateItem["ParentId"].toString()==
                              onChangedVal.toString(),
                      )
                      .toList();
                      _course = "";
                      setState(() {
                      });
                    },
                    (onValidateVal){
                      if(onValidateVal==null){
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
                    (onChangedVal){
                      _course=onChangedVal;
                      print("Selected Course is: $onChangedVal");
                    },
                  (onValidate){
                      return null;
                  },
                  optionValue: "ID",
                  optionLabel: "Name",
                ),
                const SizedBox(height: 25,),
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
                Padding(padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      final downloadLink = await uploadPdf(filename!, file!);
                      Note newnote = Note(
                        noteid: uuid.v1(),
                        name: filename,
                        semester: _semester!,
                        course: _course!,
                        pdfUrl: downloadLink,
                        uploadedby: user?.uid.toString(),
                        uploadedon: DateTime.now(),
                      );

                      FirebaseFirestore.instance.collection("notes").doc(newnote.noteid).set(newnote.toMap());

                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: iconcolor, // Text color
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