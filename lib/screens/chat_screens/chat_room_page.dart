import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';
import 'package:uniconnect/models/MessageModel.dart';
import 'package:uniconnect/models/UserModel.dart';

import '../../main.dart';
import '../profile_screens/user_profile_page.dart';

class Chat_Room_Page extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firabaseUser;

  const Chat_Room_Page(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firabaseUser})
      : super(key: key);

  @override
  State<Chat_Room_Page> createState() => _Chat_Room_PageState();
}

class _Chat_Room_PageState extends State<Chat_Room_Page> {
  TextEditingController messageController = TextEditingController();

  void CheckSeen()
  async
  {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String? lastuid=widget.chatroom.lastuid;
    if(uid!=lastuid) {
      widget.chatroom.isseen=true;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
    }
  }
  void initState(){
    super.initState();
    CheckSeen();
  }
  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    if (msg != "") {
      //  send the message
      MessageModel newMessage = MessageModel(
          messageid: uuid.v1(),
          sender: widget.userModel.uid,
          createdon: DateTime.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      widget.chatroom.isseen=false;
      widget.chatroom.lastuid=uid;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());
      // log("Message Sent :)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          CheckSeen();
          return true;
        },
    child: Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => User_Profile_Page(
                      uid: widget.targetUser.uid!,
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    NetworkImage(widget.targetUser.profilepic.toString()),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => User_Profile_Page(
                        uid: widget.targetUser.uid!,
                      ),
                    ),
                  );
                },
                child: Text(widget.targetUser.username.toString())),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              //  The chats go here
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatroomid)
                        .collection("messages")
                        .orderBy("createdon", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapshot.docs.length,
                            itemBuilder: (context, index) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);

                              return Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid)
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 300),
                                      // width:200,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 10,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModel.uid)
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Text(
                                        currentMessage.text.toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                                "Some Error Occured :(, Please check your connection ."),
                          );
                        } else {
                          return const Center(
                            child: Text("Say Hello! :)"),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

              Container(
                color: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Message"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}
