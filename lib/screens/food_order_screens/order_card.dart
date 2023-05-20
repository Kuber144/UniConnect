import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';

import '../../main.dart';
import '../../models/ChatRoomModel.dart';
import '../../models/FirebaseHelper.dart';
import '../../models/UserModel.dart';
import '../chat_screens/chat_room_page.dart';
import '../profile_screens/user_profile_page.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;

  const PostCard({Key? key, required this.snap, required this.hello})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    String curUid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.$curUid", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
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
        isseen: false,
        lastuid: "",
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

  String getHello() {
    return widget.hello;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(
            builder: (context) {
              return _AddPopupCard(
                key: UniqueKey(),
                hello: getHello(),
                username: widget.snap['username'],
                addnote: widget.snap['addnote'],
                selectdat:
                (widget.snap['timeOfOrder'] as Timestamp).toDate(),
                uidposter: widget.snap['uid'], desc: widget.snap['desc'], order: widget.snap['order'], people: widget.snap['people'],
                place: widget.snap['place'], price: widget.snap['price'],

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
                        NetworkImage(widget.snap['profilepic'] ?? ''),
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
                            widget.snap['username'] ?? '',
                            style: const TextStyle(
                              fontSize: 19,
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

              // BODY SECTION BEGINS
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              // widget.snap['order'].length>15 ? "defv" : widget.snap['order'],
                              '${widget.snap['order']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.snap['people']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.snap['price'] ?? ''}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${(widget.snap['timeOfOrder'] as Timestamp).toDate().day} ${_getMonth((widget.snap['timeOfOrder'] as Timestamp).toDate().month)} ${(widget.snap['timeOfOrder'] as Timestamp).toDate().year}, ${_formatTime((widget.snap['timeOfOrder'] as Timestamp).toDate())}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}

Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
  ChatRoomModel? chatRoom;

  String curUid = FirebaseAuth.instance.currentUser!.uid;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("chatrooms")
      .where("participants.$curUid", isEqualTo: true)
      .where("participants.${targetUser.uid}", isEqualTo: true)
      .get();
  if (snapshot.docs.isNotEmpty) {
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

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? 'am' : 'pm';
  return '$hour:$minute $period';
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

class _AddPopupCard extends StatelessWidget {
  final String hello;
  final String username,
  desc,
  order,
  people,
  place,
  price,
      addnote,
      uidposter;
  final DateTime selectdat;

  const _AddPopupCard(
      {Key? key,
        required this.desc,
        required this.order,
        required this.people,
        required this.place,
        required this.price,
        required this.hello,
        required this.addnote,
        required this.selectdat,
        required this.username,
        required this.uidposter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => User_Profile_Page(
                            uid: uidposter,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                        '$order',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                          textAlign: TextAlign.center,
                      ),
                      ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Description:\n $desc',
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
                    child: Text(
                      'Ordering from:\n $place',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'People expected: $people \nExpected price: $price',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Text(
                    'Time of order: ${selectdat.day} ${_getMonth(selectdat.month)} ${selectdat.year}, ${_formatTime(selectdat)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      addnote == ""
                          ? 'No additional notes'
                          : 'Additional notes:\n $addnote',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(width: 16),
                                Text('Requesting...'),
                              ],
                            ),
                          );
                        },
                      );

                      try {
                        Map<String, dynamic>? userMap =
                        await getUserDetails(uidposter)
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
                            msg: "Error contacting the user");
                        Navigator.pop(context); // Hide loading indicator
                      }
                    },
                    child: const Text('Request to order together'),
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
