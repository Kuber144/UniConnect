
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniconnect/screens/buy_sell_p1.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_My_Requests.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_upload_post.dart';
import 'package:uniconnect/screens/carpool_screens/post_card.dart';
import 'package:uniconnect/screens/lnf_screens/lnf_post_card.dart';
import 'package:uniconnect/util/colors.dart';

import '../../main.dart';

// import 'buy_sell_post_card.dart';
// import 'buy_sell_post_card2.dart';

class MyItemsScreen extends StatelessWidget {
  const MyItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: mobileBackgroundColor,
      //   title: const Text(
      //       "Carpool"
      //   ),
      //   actions: [
      //     _buildPopupMenuButton(context),
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         PageRouteBuilder(
      //             transitionDuration: const Duration(milliseconds: 150),
      //             transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
      //               return ScaleTransition(
      //                 alignment: Alignment.bottomRight,
      //                 scale: animation,
      //                 child: child,
      //               );
      //             },
      //             pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
      //               return const Carpool_upload_post();
      //             }
      //         ));
      //   },
      //   backgroundColor: iconcolor,
      //   child: const Icon(Icons.add),
      // ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('LnFPosts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final filteredDocs = snapshot.data!.docs.where((doc) => doc['uid'] == currentUserId).toList();
              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Text('No data'),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context,index)=> Column(
                    children: [
                      lnfPostCard(
                        snap: filteredDocs[index].data() ?? {},
                        hello: uuid.v4(),
                      ),
                      const SizedBox(height: 0,),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        color: Colors.red, // set the card color to red
                        child: GestureDetector(
                          onTap: () {
                            // This code will be executed when the container is tapped
                            filteredDocs[index].reference.delete().then((value) {

                              print('Document ${filteredDocs[index].id} deleted successfully.');
                            }).catchError((error) {
                              print('Error deleting document ${filteredDocs[index].id}: $error');
                            });
                            print('Container tapped');
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => Buy_sell_p1(),
                            //   ),
                            // );
                          },
                          child: Container(
                            width: 400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white, // set the text color to white
                                  ),
                                ),
                                IconButton(
                                icon: Icon(
                                Icons.delete,
    color: Colors.white, // set the icon color to white
    ),
                                  onPressed: () {
                                    filteredDocs[index].reference.delete()
                                        .then((value) {
                                      const MyItemsScreen();
                                      print('Document ${filteredDocs[index]
                                          .id} deleted successfully.');
                                    }).catchError((error) {
                                      print(
                                          'Error deleting document ${filteredDocs[index]
                                              .id}: $error');
                                    });
                                    print('Container tapped');
                                    //   Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => Buy_sell_p1(),
                                    //     ),
                                    //   );
                                    // },

                                  },),
                              ],
                            ),
                          ),
                        ),






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
    );
  }

}
