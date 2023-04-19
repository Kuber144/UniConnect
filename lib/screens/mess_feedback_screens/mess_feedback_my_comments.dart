import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/post_card_mess.dart';
import 'package:uniconnect/util/colors.dart';


class My_Requests_Mess extends StatelessWidget {
  const My_Requests_Mess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
            "My Requests"
        ),
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
            stream: FirebaseFirestore.instance.collection('mess').snapshots(),
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
    );
  }

}
