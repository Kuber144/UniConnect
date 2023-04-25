
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_My_Requests.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_upload_post.dart';
import 'package:uniconnect/screens/notes_upload.dart';
import 'package:uniconnect/screens/pdf_viewer_screen.dart';
import 'package:uniconnect/screens/carpool_screens/post_card.dart';
import 'package:uniconnect/util/colors.dart';

import '../main.dart';

class notesFeedScreen extends StatefulWidget {
  const notesFeedScreen({Key? key}) : super(key: key);



  @override
  State<notesFeedScreen> createState() => _notesFeedScreenState();
}

class _notesFeedScreenState extends State<notesFeedScreen> {

  List<Map<String, dynamic>> pdfData = [];
  
  void getAllpdfs() async {
    final results = await FirebaseFirestore.instance.collection("notes").get();

    pdfData = results.docs.map((e)=>e.data()).toList() ;
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    getAllpdfs();
  }


  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
            "Notes Sharing"
        ),
        actions: [
          _buildPopupMenuButton(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                    return ScaleTransition(
                      alignment: Alignment.bottomRight,
                      scale: animation,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                    return const notes_Upload_Post();
                  }
              ));
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
              itemCount: pdfData.length ,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
              itemBuilder: (context, index){
                return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfUrl: pdfData[index]['pdfUrl'],pdfName: pdfData[index]['name'],)));
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
                          ],
                        ),
                      ),
                    )
                );
              }
          )

          // StreamBuilder(
          //   stream: FirebaseFirestore.instance.collection('notes').snapshots(),
          //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }
          //     final filteredDocs = snapshot.data!.docs.where((doc) => doc['uid'] != currentUserId).toList();
          //     if (filteredDocs.isEmpty) {
          //       return const Center(
          //         child: Text('No data'),
          //       );
          //     }
          //     return Padding(
          //       // width: MediaQuery.of(context).size.width*0.7,
          //       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
          //       child: ListView.builder(
          //         physics: const BouncingScrollPhysics(),
          //         itemCount: filteredDocs.length,
          //         itemBuilder: (context,index)=> Column(
          //           children: [
          //             PostCard(
          //               snap: filteredDocs[index].data() ?? {}, hello: uuid.v4(),
          //             ),
          //             const SizedBox(height: 13,),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // ),
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




