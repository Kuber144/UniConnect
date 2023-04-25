import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/carpool_screens/post_card.dart';
import 'package:uniconnect/util/colors.dart';
import '../../main.dart'; // Importing main.dart with an alias

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs = [];

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
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: TextField(
                  controller: _searchTextController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by start or destination',
                    hintStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: iconcolor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final Timestamp currentTime = Timestamp.now();
                    final filteredDocsLate = snapshot.data!.docs
                        .where((doc) =>
                            doc['timeOfDeparture'] is Timestamp &&
                            doc['timeOfDeparture'].compareTo(currentTime) < 0)
                        .toList();
                    if (filteredDocsLate.isNotEmpty) {
                      for (final doc in filteredDocsLate) {
                        doc.reference
                            .delete()
                            .then((value) {})
                            .catchError((error) {
                          // print('Error deleting document ${doc.id}: $error');
                        });
                      }
                    }
                    // final filteredDocs = snapshot.data!.docs.where((doc) => doc['uid'] != currentUserId).toList();
                    final filteredDocs = _searchTextController.text.isEmpty
                        ? snapshot.data!.docs
                            .where((doc) => doc['uid'] != currentUserId)
                            .toList()
                        : snapshot.data!.docs
                            .where((doc) =>
                                doc['uid'] != currentUserId &&
                                (doc['start'].toString().toLowerCase().contains(
                                        _searchTextController.text
                                            .toLowerCase()) ||
                                    doc['destination']
                                        .toString()
                                        .toLowerCase()
                                        .contains(_searchTextController.text
                                            .toLowerCase())))
                            .toList();
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
                              snap: filteredDocs[index].data(),
                              hello: uuid.v4(),
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
