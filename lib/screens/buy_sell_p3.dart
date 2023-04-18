
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/carpool_My_Requests.dart';
import 'package:uniconnect/screens/carpool_upload_post.dart';
import 'package:uniconnect/screens/post_card.dart';
import 'package:uniconnect/util/colors.dart';

import '../main.dart';
import 'buy_sell_post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

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
            stream: FirebaseFirestore.instance.collection('buy_sell_posts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // final Timestamp currentTime = Timestamp.now();
              // final filteredDocsLate = snapshot.data!.docs.where((doc) => doc['timeOfDeparture'] is Timestamp && doc['timeOfDeparture'].compareTo(currentTime) < 0).toList();
              // if (filteredDocsLate.isNotEmpty) {
              //   for (final doc in filteredDocsLate) {
              //     doc.reference.delete().then((value) {
              //       print('Document ${doc.id} deleted successfully.');
              //     }).catchError((error) {
              //       print('Error deleting document ${doc.id}: $error');
              //     });
              //   }
              // }
              final filteredDocs = snapshot.data!.docs.where((doc) => doc['uid'] != currentUserId).toList();
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
                      BuySellPostCard(
                        snap: filteredDocs[index].data() ?? {}, hello: uuid.v4(),
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
          value: 'my-requests',
          child: Text('My Requests'),
        ),
      ],
    );
  }

}
