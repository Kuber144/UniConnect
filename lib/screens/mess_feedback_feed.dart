
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniconnect/screens/carpool_My_Requests.dart';
import 'package:uniconnect/models/post_card_mess.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';

import '../main.dart';
import '../resources/firestore_methods_mess.dart';
import 'mess_feedback_my_comments.dart';


class Mess_Feed extends StatefulWidget {
  const Mess_Feed({Key? key}) : super(key: key);

  @override
  _MessFeedState createState() => _MessFeedState();

}


class _MessFeedState extends State<Mess_Feed> {

  String name='';
  String email='';
  String hostel=" ";
  String userid=" ";


  Future<void> getUserDetails() async {
    String uid= FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(userSnapshot.exists){
      setState(() {
        userid=userSnapshot['uid'];
        name= userSnapshot['username'];
        email=userSnapshot['email'];
        hostel=userSnapshot['hostel'];
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


  TextEditingController commentController= TextEditingController();
  String phase="";
  bool checkComment()
  {
    if(commentController.text.isEmpty)
      {
        showSnackBar("Comment cannot be empty", context);
        return false;
      }
    if(commentController.text.length>300)
    {
      showSnackBar("Max comment length is 300", context);
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    phase=currentPhase();
    getUserDetails();
  }
  void uploadPost(
      String uid,
      ) async {
    setState(() {
    });
    try {
      print(userid);
      String res = await FirestoreMethods().uploadPost(userid,name,email,commentController.text,hostel,phase);
      if (res == "success") {
        setState(() {
        });
        commentController.clear();
        showSnackBar("Uploaded", context);
      } else {
        setState(() {
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  bool checkHostel(String hostelus)
  {
    if((hostel=="BH-1" || hostel=="BH-4") && (hostelus=="BH-1" || hostelus=="BH-4"))
      return true;
    if((hostel=="BH-2" || hostel=="BH-3") && (hostelus=="BH-2" || hostelus=="BH-43"))
      return true;
    if((hostel=="GH-1" || hostel=="GH-2" || hostel=="GH-3") && (hostelus=="GH-1" || hostelus=="GH-2" ||hostelus=="GH-3"))
      return true;
    if((hostel=="BH-5") && (hostelus=="BH-5"))
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
            "Mess Feedback"
        ),
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
                                ? 'https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/mess%2Fmess_bh1_bh4.jpg?alt=media&token=5ae8103b-763b-4244-b583-9c74673f50c1'
                                : (hostel == "BH-3" || hostel == "BH-2")
                                ? 'https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/mess%2Fmess_bh2_bh3.jpg?alt=media&token=473f17c3-3bb2-42fc-a113-fe258c1e2c3c'
                                : (hostel == "BH-5")
                                ? 'https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/mess%2Fmess_bh5.jpg?alt=media&token=b45fb5a8-1530-4d80-b736-521fc967fcaf'
                                : 'https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/mess%2Fmess_gh.jpg?alt=media&token=cfbab27c-dbde-4a2d-bd7a-d7dd3ef74756',
                            fit: BoxFit.contain,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                ),
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
                      padding: EdgeInsets.symmetric(vertical: 10,),

                      child: Text(
                        (hostel == "BH-1" || hostel == "BH-4")
                            ? 'BH-1 / BH-4'
                            : (hostel == "BH-3" || hostel == "BH-2")
                            ? 'BH-3 / BH-2'
                            : (hostel == "BH-5") ? 'BH-5' : 'GH-1 / GH-2 / GH-3',
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
                  stream: FirebaseFirestore.instance.collection('mess').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final filteredDocsLate = snapshot.data!.docs.where((doc) => doc['phase']!=phase).toList();
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
                      return  doc['phase'] ==phase && checkHostel(doc['hostel']);
                    }).toList();

                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }
                    return Padding(
                      // width: MediaQuery.of(context).size.width*0.7,
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context,index)=> Column(
                          children: [
                            PostCard(
                              snap: filteredDocs[index].data() ?? {},
                            ),
                            const SizedBox(height: 13,),
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
      if(checkComment())
        {
          uploadPost(
            userid,
          );
        }
    },
    child: Text('Submit'),
    ),
    ],
    ),
         ) ,
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
