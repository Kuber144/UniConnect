import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uniconnect/models/UserModel.dart';

class lnfPostCardUser extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;

  const lnfPostCardUser({Key? key, required this.snap, required this.hello})
      : super(key: key);

  @override
  _lnfPostCard createState() => _lnfPostCard();
}

class _lnfPostCard extends State<lnfPostCardUser> {
  String name = "name";
  String email = "email";
  static late UserModel u1;
  String imageUrl = "assets/loading.gif";
  final storage = firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    List<String>? PostImages = [];
    setState(() {
      PostImages = getPic();
      imageUrl = PostImages![0];
    });
    getUserDetails(widget.snap['uid']);
  }

  Future<void> getUserDetails(String uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        name = userSnapshot['username'];
        email = userSnapshot['email'];
        u1.uid = uid;
        u1.username = name;
        u1.email = email;
        u1.profilepic = userSnapshot['profilepic'];
      });
    }
  }

  List<String>? getPic() {
    List<dynamic> dynamicList = widget.snap['pic'];
    List<String>? stringList =
        dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  String getHello() {
    return widget.hello;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
            builder: (context) {
              List<dynamic> dynamicList = widget.snap['pic'];
              List<String> stringList =
                  dynamicList.map((e) => e.toString()).toList();

              return _AddPopupCard(
                snap: widget.snap,
                key: UniqueKey(),
                hello: getHello(),
                username: name,
                pdtDesc: widget.snap['pdtDesc'],
                pdtName: widget.snap['pdtName'],
                email: email,
                images: stringList,
                uid: widget.snap['uid'],
              );
            },
            settings: const RouteSettings(name: "add_popup_card")));
      },
      child: Hero(
        tag: widget.hello,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            // Add a placeholder image while loading or error
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/loading.gif',
                                fit: BoxFit.cover,
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                        SizedBox(width: 19),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap['pdtName']?.length > 19
                                  ? widget.snap['pdtName']?.substring(0, 15) +
                                      "..."
                                  : widget.snap['pdtName'] ?? '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.snap['pdtDesc']?.length > 29
                                  ? widget.snap['pdtDesc']?.substring(0, 25) +
                                      "..."
                                  : widget.snap['pdtDesc'] ?? '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 9),
                            Text(
                              widget.snap['postType'] == 'Found'
                                  ? 'Found Item'
                                  : 'Lost Item',
                              style: const TextStyle(
                                  fontSize: 12, color: mobileSearchColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPopupCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String hello;
  final String uid;
  final String username;

  final String pdtName;
  final String pdtDesc;
  final String email;
  final List<String> images;
  final Key key;

  /*final DateTime selectdat;*/
  const _AddPopupCard(
      {required this.key,
      required this.hello,
      required this.username,
      required this.pdtName,
      required this.pdtDesc,
      required this.snap,
      required this.email,
      required this.images,
      required this.uid})
      : super(key: key);

  @override
  State<_AddPopupCard> createState() => _Add_PopupCard(
      key: key,
      hello: hello,
      username: username,
      pdtName: pdtName,
      pdtDesc: pdtDesc,
      email: email,
      images: images,
      uid: uid);
}

class _Add_PopupCard extends State<_AddPopupCard> {
  final String hello;
  final String uid;
  final String username;
  final String pdtName;
  final String pdtDesc;
  final String email;
  final List<String> images;
  final Key key;

  _Add_PopupCard(
      {required this.key,
      required this.hello,
      required this.username,
      required this.pdtName,
      required this.pdtDesc,
      required this.email,
      required this.images,
      required this.uid});

  List<String>? getPic() {
    List<dynamic> dynamicList = widget.snap['pic'];
    List<String>? stringList =
        dynamicList.map((item) => item.toString()).toList();
    return stringList;
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    // Create a reference to the "users" collection in Firestore
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection("users");

    // Use the "where" method to filter the documents by "uid"
    final QuerySnapshot<Object?> querySnapshot =
        await usersRef.where("uid", isEqualTo: uid).get();

    // Check if any documents are returned
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document (assuming "uid" is unique)
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          querySnapshot.docs[0] as DocumentSnapshot<Map<String, dynamic>>;

      // Retrieve the data from the document
      final Map<String, dynamic>? userMap = documentSnapshot.data();

      // Return the user data as a Map<String, dynamic>
      return userMap;
    } else {
      // No document found for the given uid, return null
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String>? PostImages = [];
    setState(() {
      PostImages = getPic();
    });
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Hero(
          tag: hello,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: cardcolor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Text(
                      pdtName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 300,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250.0,
                        enableInfiniteScroll: true,
                        autoPlay: false,
                      ),
                      items: PostImages!.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Description : $pdtDesc',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      widget.snap['postType'] == 'Found'
                          ? 'Post Type: Found'
                          : 'Post Type: Lost',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
