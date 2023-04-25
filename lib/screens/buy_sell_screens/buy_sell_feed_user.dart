import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import 'buy_sell_post_card_user.dart';

class FeedScreen2 extends StatelessWidget {
  const FeedScreen2({Key? key}) : super(key: key);

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
            stream: FirebaseFirestore.instance
                .collection('buy_sell_posts')
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      BuySellPostCard2(
                        snap: filteredDocs[index].data(),
                        hello: uuid.v4(),
                      ),
                      GestureDetector(
                        onTap: () {
                          List<String> pictures = List<String>.from(
                              filteredDocs[index].data()['pic'] ?? []);
                          // Delete the Firestore document
                          filteredDocs[index].reference.delete().then((value) {
                            // print('Document ${filteredDocs[index].id} deleted successfully.');

                            // Delete the pictures from Firebase Storage
                            for (String pictureUrl in pictures) {
                              Reference pictureRef = FirebaseStorage.instance
                                  .refFromURL(pictureUrl);
                              pictureRef
                                  .delete()
                                  .then((value) {})
                                  .catchError((error) {});
                            }
                          }).catchError((error) {});
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
                                    List<String> pictures = List<String>.from(
                                        filteredDocs[index].data()['pic'] ??
                                            []);
                                    // Delete the Firestore document
                                    filteredDocs[index]
                                        .reference
                                        .delete()
                                        .then((value) {
                                      // print('Document ${filteredDocs[index].id} deleted successfully.');

                                      // Delete the pictures from Firebase Storage
                                      for (String pictureUrl in pictures) {
                                        // Create a reference to the picture in Firebase Storage
                                        Reference pictureRef = FirebaseStorage
                                            .instance
                                            .refFromURL(pictureUrl);

                                        // Delete the picture
                                        pictureRef.delete().then((value) {
                                          // print('Picture deleted successfully: $pictureUrl');
                                        }).catchError((error) {
                                          // print('Error deleting picture: $error');
                                        });
                                      }
                                    }).catchError((error) {
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
        ],
      ),
    );
  }
}
