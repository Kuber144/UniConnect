import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/food_order_screens/upload_Announcement.dart';

import '../../main.dart';
import '../../util/colors.dart';
import '../post_card.dart';


class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
            "Offer Announcements"
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Post an Offer Announcement",
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
                    return const upload_Announcement();
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
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Offer Announcement Posts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final Timestamp currentTime = Timestamp.now();
              final filteredDocsLate = snapshot.data!.docs.where((doc) => doc['timeOfDeparture'] is Timestamp && doc['timeOfDeparture'].compareTo(currentTime) < 0).toList();
              if (filteredDocsLate.isNotEmpty) {
                for (final doc in filteredDocsLate) {
                  doc.reference.delete().then((value) {
                    print('Document ${doc.id} deleted successfully.');
                  }).catchError((error) {
                    print('Error deleting document ${doc.id}: $error');
                  });
                }
              }
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
                      PostCard(
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
}
