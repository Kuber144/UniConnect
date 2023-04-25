import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/lnf_screens/lnfUploadScreen.dart';
import 'package:uniconnect/util/colors.dart';
import '../../main.dart';
import 'lnf_post_card.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({Key? key}) : super(key: key);

  @override
  LostItemsScreenState createState() => LostItemsScreenState();
}

class LostItemsScreenState extends State<LostItemsScreen> {
  final TextEditingController _searchTextController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredDocs = [];

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final String currentUserId = user?.uid ?? '';
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Post for lost Item ",
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation,
                      Widget child) {
                    return ScaleTransition(
                      alignment: Alignment.bottomRight,
                      scale: animation,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secAnimation) {
                    return const lnfUploadScreen(type: "Lost");
                  }));
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
                    hintText: 'Search by item name',
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
                      .collection('LnFPosts')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final filteredDocs = _searchTextController.text.isEmpty
                        ? snapshot.data!.docs
                            .where((doc) =>
                                doc['uid'] != currentUserId &&
                                doc['postType'] == "Lost")
                            .toList()
                        : snapshot.data!.docs
                            .where((doc) =>
                                doc['uid'] != currentUserId &&
                                doc['postType'] == "Lost" &&
                                doc['pdtName']
                                    .toString()
                                    .toLowerCase()
                                    .contains(_searchTextController.text
                                        .toLowerCase()))
                            .toList();
                    if (filteredDocs.isEmpty) {
                      return const Center(
                        child: Text('No data'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            lnfPostCard(
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
