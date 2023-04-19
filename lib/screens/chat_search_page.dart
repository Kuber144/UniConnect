// import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/screens/chat_room_page.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';

import '../main.dart';
import 'home_page.dart';

class Chat_searchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseuser;

  const Chat_searchPage({Key? key, required this.userModel, required this.firebaseuser}) : super(key: key);

  @override
  State<Chat_searchPage> createState() => _Chat_searchPageState();
}

class _Chat_searchPageState extends State<Chat_searchPage> {

  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {

    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();
    if(snapshot.docs.length>0){
    //  Fetch the existing chatroom
    //   log("Chatroom already exists");
       var docdata = snapshot.docs[0].data();
       ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docdata as Map<String , dynamic>);
       chatRoom = existingChatroom;
    }
    else{
    //  create a new chatroom
    //   log("Chatroom does not exist");
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },

      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());
      chatRoom = newChatroom;
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search User"),
        actions: [
          IconButton(
            onPressed:(){

              // Navigator.pop(context);

              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context){
                  return const HomePage();
                }),
              );

            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
               TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: "Enter Email Address"
                ),
              ),
              const SizedBox(height: 20,),

              CupertinoButton(
                  onPressed: (){
                    setState(() {});
                  },
                  color: Theme.of(context).colorScheme.secondary,
                  child: const Text("Search"),
              ),

              const SizedBox(height: 20,),

            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").where("email",isEqualTo: searchController.text).where("email", isNotEqualTo: widget.firebaseuser.email).snapshots(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.active){
                  if(snapshot.hasData){
                    QuerySnapshot dataSnapShot = snapshot.data as
                    QuerySnapshot;

                    if(dataSnapShot.docs.isNotEmpty){
                      Map<String, dynamic> userMap = dataSnapShot.docs[0].data() as Map<String, dynamic>;

                      UserModel searchedUser = UserModel.fromMap(userMap);

                      return ListTile(
                        onTap: () async {

                          ChatRoomModel? chatroomModel = await getChatroomModel(searchedUser);

                          if(chatroomModel != null){

                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Chat_Room_Page(
                                targetUser: searchedUser,
                                userModel: widget.userModel,
                                firabaseUser: widget.firebaseuser,
                                chatroom: chatroomModel,
                              );
                            })
                            );

                          }

                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(searchedUser.profilepic!),
                          backgroundColor: Colors.grey[500],
                        ),
                        title: Text(searchedUser.username!),
                        subtitle: Text(searchedUser.email!),
                        trailing: const Icon(Icons.keyboard_arrow_right),

                      );

                    }
                    else{
                      return const Text("No results Found !");
                    }


                  }
                  else if(snapshot.hasError){
                    return const Text("An error Occured !");
                  }
                  else{
                    return const Text("No results found !");
                  }

                }
                else {
                    return const CircularProgressIndicator();
                  }
              }
            )


            ],
          ),
        )
      )
    );
  }
}
