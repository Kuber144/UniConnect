import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/models/FirebaseHelper.dart';
import 'package:uniconnect/models/UserModel.dart';
import 'package:uniconnect/util/slideshow.dart';
import '../chat_room_page.dart';
import '../../main.dart';
import '../profile_screens/user_profile_page.dart';

class AddPopupCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String hello;
  final String uid;
  final String username;
  final String pdtName;
  final String pdtDesc;
  final String sellingPrice;
  final String email;
  final List<String> images;
  final Key key;

  const AddPopupCard(
      {required this.key,
      required this.hello,
      required this.username,
      required this.pdtName,
      required this.pdtDesc,
      required this.sellingPrice,
      required this.email,
      required this.images,
      required this.uid,
      required this.snap})
      : super(key: key);

  @override
  State<AddPopupCard> createState() => _Add_PopupCard(
      key: key,
      hello: hello,
      username: username,
      pdtName: pdtName,
      pdtDesc: pdtDesc,
      sellingPrice: sellingPrice,
      email: email,
      images: images,
      uid: uid);
}

class _Add_PopupCard extends State<AddPopupCard> {
  final String hello;
  final String uid;
  final String username;
  final String pdtName;
  final String pdtDesc;
  final String sellingPrice;
  final String email;
  final List<String> images;
  final Key key;

  _Add_PopupCard(
      {required this.key,
      required this.hello,
      required this.username,
      required this.pdtName,
      required this.pdtDesc,
      required this.sellingPrice,
      required this.email,
      required this.images,
      required this.uid});

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    String curUid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.$curUid", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      var docdata = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docdata as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      User? currentUser = FirebaseAuth.instance.currentUser;
      UserModel? thisUserModel =
          await FirebaseHelper.getUserModelById(currentUser!.uid);
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          thisUserModel!.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
    }
    return chatRoom;
  }

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
                      'Price : Rs. $sellingPrice',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GestureDetector(
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
                        'Seller : $username',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 16),
                                Text('Contacting the seller...'),
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        Map<String, dynamic>? userMap =
                            await getUserDetails(widget.snap['uid'])
                                as Map<String, dynamic>;
                        UserModel sellerUser = UserModel.fromMap(userMap);
                        ChatRoomModel? chatroommodel =
                            await getChatroomModel(sellerUser);
                        User? currentUser = FirebaseAuth.instance.currentUser;
                        UserModel? userModel =
                            await FirebaseHelper.getUserModelById(
                                currentUser!.uid);

                        Navigator.pop(context); // Hide loading indicator

                        if (chatroommodel != null) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Chat_Room_Page(
                              targetUser: sellerUser,
                              userModel: userModel!,
                              firabaseUser: currentUser,
                              chatroom: chatroommodel,
                            );
                          }));
                        }
                      } catch (e) {
                        // print('Error contacting the seller: $e');
                        Fluttertoast.showToast(
                            msg: "Error contacting the seller");
                        Navigator.pop(context); // Hide loading indicator
                      }
                    },
                    child: const Text('Contact the seller'),
                  ),
                  const SizedBox(
                    height: 20,
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
