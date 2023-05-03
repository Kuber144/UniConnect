import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../profile_screens/user_profile_page.dart';
import 'lnfInnerPostCard.dart';

class lnfPostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;

  const lnfPostCard({Key? key, required this.snap, required this.hello})
      : super(key: key);

  @override
  _lnfPostCardState createState() => _lnfPostCardState();
}

class _lnfPostCardState extends State<lnfPostCard> {
  String name = "name";
  String email = "email";

  String imageUrl = "assets/loading.gif";
  final storage = firebase_storage.FirebaseStorage.instance;
  String _profilePicUrl="";
  void getProfile() async{
    FirebaseFirestore.instance
        .collection("users")
        .doc( widget.snap['uid'])
        .get()
        .then((doc) {
      if (doc.exists) {
        String profilePicUrl = doc.data()!["profilepic"];
        setState(() {
          _profilePicUrl = profilePicUrl;
        });
      }
    });

  }

  @override
  void initState() {
    super.initState();
    List<String>? PostImages = [];
    setState(() {
      PostImages = getPic();
      imageUrl = PostImages![0];
    });
    getUserDetails(widget.snap['uid']);
    getProfile();
  }

  List<String>? getPic() {
    List<dynamic> dynamicList = widget.snap['pic'];
    List<String>? stringList =
        dynamicList?.map((item) => item.toString())?.toList();
    return stringList;
  }

  Future<void> getUserDetails(String uid) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        name = userSnapshot['username'];
        email = userSnapshot['email'];
      });
    }
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
              return lnfInnerPostCard(
                key: UniqueKey(),
                hello: getHello(),
                snap: widget.snap,
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
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => User_Profile_Page(
                              uid: widget.snap['uid']!,
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                        NetworkImage(_profilePicUrl),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => User_Profile_Page(
                                  uid: widget.snap['uid']!,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat.yMMMd().format(
                            widget.snap['datePublished'].toDate(),
                          ),
                          style: const TextStyle(
                              fontSize: 12, color: mobileSearchColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                                  fontSize: 12, color: mobileSearchColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 9),
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
