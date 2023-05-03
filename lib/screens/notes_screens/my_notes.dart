import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/notes_screens/pdf_viewer_screen.dart';
import 'package:uniconnect/util/colors.dart';

class myNotes extends StatefulWidget {
  const myNotes({Key? key}) : super(key: key);

  @override
  State<myNotes> createState() => myNotesState();
}

class myNotesState extends State<myNotes> {
  List<Map<String, dynamic>> pdfData = [];

  void getAllpdfs() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    final results = await FirebaseFirestore.instance
        .collection("notes")
        .where("uploadedby", isEqualTo: currentUserId)
        .get();
    pdfData = results.docs.map((e) => e.data()).toList();
    setState(() {});
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
        title: const Text("My Notes"),
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
                                // Get the filename from the Firestore document.
                                final filename = pdfData[index]['name'];

                                // Get the reference to the PDF file in Firebase storage.
                                final ref = FirebaseStorage.instance
                                    .ref()
                                    .child('pdfs/$filename');

                                try {
                                  // Delete the PDF file from Firebase storage.
                                  await ref.delete();

                                  // Delete the corresponding entry from Firestore database.
                                  await FirebaseFirestore.instance
                                      .collection("notes")
                                      .doc(pdfData[index]['noteid'])
                                      .delete();

                                  // Remove the deleted item from the pdfData list.
                                  setState(() {
                                    pdfData.removeAt(index);
                                  });
                                } catch (e) {
                                  // print(e.toString());
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Text(
                                  'Delete',
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
}
