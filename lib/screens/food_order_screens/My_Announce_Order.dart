import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/main.dart';
import '../../util/colors.dart';
import 'my_order_card.dart';


class My_Announce_Order extends StatefulWidget{
  const My_Announce_Order({Key? key}) : super(key: key);

  @override
  MyAnnouncementOrderState createState() => MyAnnouncementOrderState();
}
class MyAnnouncementOrderState extends State<My_Announce_Order> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("My Order Announcements"),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/home_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Orderposts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final filteredDocs = snapshot.data!.docs
                        .where((doc) => doc['uid'] == currentUserId)
                        .toList();
                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }
                    return Padding(
                      // width: MediaQuery.of(context).size.width*0.7,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            PostCard(
                              snap: filteredDocs[index].data(), hello: uuid.v4(),
                            ),
                            GestureDetector(
                              onTap: () {
                                filteredDocs[index]
                                    .reference
                                    .delete()
                                    .then((value) {})
                                    .catchError((error) {});
                              },
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.red, // set the card color to red
                                child: SizedBox(
                                  width: 800,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors
                                              .white, // set the text color to white
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors
                                              .white, // set the icon color to white
                                        ),
                                        onPressed: () {
                                          // Delete the Firestore document
                                          filteredDocs[index]
                                              .reference
                                              .delete()
                                              .then((value) {})
                                              .catchError((error) {
                                            // print('Error deleting document ${filteredDocs[index].id}: $error');
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

}
