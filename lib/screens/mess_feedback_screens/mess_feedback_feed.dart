import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_My_Requests.dart';
import 'package:uniconnect/models/post_card_mess.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';

import '../../main.dart';
import '../../resources/firestore_methods_mess.dart';
import 'mess_feedback_my_comments.dart';

class Mess_Feed extends StatefulWidget {
  const Mess_Feed({Key? key}) : super(key: key);

  @override
  _MessFeedState createState() => _MessFeedState();
}

class _MessFeedState extends State<Mess_Feed> {
  String name = '';
  String email = '';
  String hostel = " ";
  String userid = " ";
  String profilepic = " ";
  String bh1_4 = "", bh2_3 = "", bh5 = "", gh1_2_3 = "";

  Future<void> getAllpics() async {
    try {
      DocumentReference documentRef1 =
          FirebaseFirestore.instance.collection('mess_menu').doc('bh1_4');
      DocumentReference documentRef2 =
          FirebaseFirestore.instance.collection('mess_menu').doc('bh2_3');
      DocumentReference documentRef3 =
          FirebaseFirestore.instance.collection('mess_menu').doc('bh5');
      DocumentReference documentRef4 =
          FirebaseFirestore.instance.collection('mess_menu').doc('gh1_2_3');
      DocumentSnapshot documentSnapshot1 = await documentRef1.get();
      DocumentSnapshot documentSnapshot2 = await documentRef2.get();
      DocumentSnapshot documentSnapshot3 = await documentRef3.get();
      DocumentSnapshot documentSnapshot4 = await documentRef4.get();
      if (documentSnapshot1.exists &&
          documentSnapshot2.exists &&
          documentSnapshot3.exists) {
        bh1_4 = documentSnapshot1['url'].toString();
        bh2_3 = documentSnapshot2['url'].toString();
        bh5 = documentSnapshot3['url'].toString();
        gh1_2_3 = documentSnapshot4['url'].toString();
        setState(() {
          bh1_4;
          bh2_3;
          gh1_2_3;
          bh5;
        });
      } else {
        print('One or more documents do not exist');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error in loading images: $error");
    }
  }

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        userid = userSnapshot['uid'];
        name = userSnapshot['username'];
        email = userSnapshot['email'];
        hostel = userSnapshot['hostel'];
        profilepic = userSnapshot['profilepic'];
      });
    }
  }

  String currentPhase() {
    DateTime now = DateTime.now();
    int hour = now.hour;
    if (hour >= 6 && hour < 13) // 6 am to 1 pm
      return "Breakfast";
    else if (hour >= 13 && hour < 20) // 1 pm to 8 pm
      return "Lunch";
    else
      return "Dinner";
  }

  TextEditingController commentController = TextEditingController();
  String phase = "";

  bool checkComment() {
    if (commentController.text.isEmpty) {
      showSnackBar("Comment cannot be empty", context);
      return false;
    }
    if (commentController.text.length > 300) {
      showSnackBar("Max comment length is 300", context);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    phase = currentPhase();
    getUserDetails();
    getAllpics();
  }

  void uploadPost(
    String uid,
  ) async {
    try {
      print(profilepic);
      String res = await FirestoreMethods().uploadPost(userid, name, email,
          commentController.text, hostel, phase, profilepic);
      if (res == "success") {
        setState(() {});
        commentController.clear();
        showSnackBar("Uploaded", context);
      } else {
        setState(() {});
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  bool checkHostel(String hostelus) {
    if ((hostel == "BH-1" || hostel == "BH-4") &&
        (hostelus == "BH-1" || hostelus == "BH-4")) return true;
    if ((hostel == "BH-2" || hostel == "BH-3") &&
        (hostelus == "BH-2" || hostelus == "BH-3")) return true;
    if ((hostel == "GH-1" || hostel == "GH-2" || hostel == "GH-3") &&
        (hostelus == "GH-1" || hostelus == "GH-2" || hostelus == "GH-3"))
      return true;
    if ((hostel == "BH-5") && (hostelus == "BH-5")) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Mess Feedback"),
        actions: [
          _buildPopupMenuButton(context),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Stack(
              children: [
                GestureDetector(
                  child: Container(
                    height: 250,
                    color: cardcolor,
                    child: InteractiveViewer(
                      maxScale: 4.0,
                      boundaryMargin: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          Image.network(
                            (hostel == "BH-1" || hostel == "BH-4")
                                ? bh1_4
                                : (hostel == "BH-3" || hostel == "BH-2")
                                    ? bh2_3
                                    : (hostel == "BH-5")
                                        ? bh5
                                        : gh1_2_3,
                            fit: BoxFit.contain,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/loading.gif',
                                // replace with your default image file path
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      (hostel == "BH-1" || hostel == "BH-4")
                          ? 'BH-1 / BH-4'
                          : (hostel == "BH-3" || hostel == "BH-2")
                              ? 'BH-3 / BH-2'
                              : (hostel == "BH-5")
                                  ? 'BH-5'
                                  : 'GH-1 / GH-2 / GH-3',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'assets/home_bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Current phase: $phase',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('mess').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final filteredDocsLate = snapshot.data!.docs
                        .where((doc) => doc['phase'] != phase)
                        .toList();
                    if (filteredDocsLate.isNotEmpty) {
                      for (final doc in filteredDocsLate) {
                        doc.reference.delete().then((value) {
                          print('Document ${doc.id} deleted successfully.');
                        }).catchError((error) {
                          print('Error deleting document ${doc.id}: $error');
                        });
                      }
                    }
                    final filteredDocs = snapshot.data!.docs.where((doc) {
                      // Check if the uid is not equal to currentUserId and the document is active
                      return doc['phase'] == phase &&
                          checkHostel(doc['hostel']);
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }
                    return Padding(
                      // width: MediaQuery.of(context).size.width*0.7,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            PostCard(
                              snap: filteredDocs[index].data() ?? {},
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            color: cardcolor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Add a comment for ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (checkComment()) {
                      uploadPost(
                        userid,
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
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
          MaterialPageRoute(builder: (context) => const My_Requests_Mess()),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'my-requests',
          child: Text('My Comments'),
        ),
      ],
    );
  }
}
