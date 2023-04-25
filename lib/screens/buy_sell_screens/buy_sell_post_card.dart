import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'buy_sell_post_innerCard.dart';

class BuySellPostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;

  const BuySellPostCard({Key? key, required this.snap, required this.hello})
      : super(key: key);

  @override
  _BuySellPostCardState createState() => _BuySellPostCardState();
}

class _BuySellPostCardState extends State<BuySellPostCard> {
  String name = "name";
  String email = "email";
  String imageUrl = "assets/loading.gif";

  // late String imageUrl;
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

  List<String>? getPic() {
    List<dynamic> dynamicList = widget.snap['pic'];
    List<String>? stringList =
        dynamicList.map((item) => item.toString()).toList();
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
              return AddPopupCard(
                key: UniqueKey(),
                hello: getHello(),
                snap: widget.snap,
                username: name,
                pdtDesc: widget.snap['pdtDesc'],
                pdtName: widget.snap['pdtName'],
                email: email,
                sellingPrice: widget.snap['sellingPrice'],
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
                        // SizedBox(
                        //   width: 100,
                        //   height: 100,
                        //   child: Image(
                        //     image: NetworkImage(imageUrl),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
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
                        const SizedBox(width: 19),
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
                            const SizedBox(height: 6),
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
                            const SizedBox(height: 9),
                            Text(
                              "Rs. ${widget.snap['sellingPrice']}",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
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
