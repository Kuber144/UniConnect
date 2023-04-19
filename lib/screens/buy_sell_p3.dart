
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_My_Requests.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_upload_post.dart';
import 'package:uniconnect/screens/carpool_screens/post_card.dart';
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
              final filteredDocs = snapshot.data!.docs.where((doc) => doc['uid'] != currentUserId).toList();
              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Text('No data'),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
                child:ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context,index)=> Column(
                    children: [
                      BuySellPostCard(
                        snap: filteredDocs[index].data(), hello: uuid.v4(),
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
