import 'dart:math';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/widgets/custom_rect_tween.dart';
import 'package:uniconnect/widgets/hero_dialog_route.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:uniconnect/screens/carpool_feed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/models/FirebaseHelper.dart';
import 'package:uniconnect/models/UserModel.dart';
import 'package:uniconnect/screens/chat_home_page.dart';
import 'package:uniconnect/util/slideshow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniconnect/providers/providers.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:uniconnect/responsive/mobile_screen_layout.dart';
import 'package:uniconnect/screens/NavBar.dart';
// import 'package:uniconnect/models/user.dart' as model;
// import 'package:uniconnect/screens/carpool_upload_post.dart';

//import '../models/user.dart';
import 'buy_sell_p1.dart';
import '../models/user.dart' as MyUser;
import 'notes_home_page.dart';
import '../models/FirebaseHelper.dart';
import '../models/UserModel.dart';
import '../util/slideshow.dart';
import 'chat_home_page.dart';
import 'chat_room_page.dart';
import 'chat_search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/screens/chat_room_page.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';

import '../main.dart';
import 'home_page.dart';

import 'package:uniconnect/screens/chat_room_page.dart';
import 'package:uniconnect/models/ChatRoomModel.dart';

import '../main.dart';
import 'home_page.dart';




class AddPopupCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  /// {@macro add_todo_popup_card}
  final String hello;
  final String uid;
  final String username/*,start,destination,charge,vehicle,exstart,exdest,addnote*/;
  final String pdtName;
  final String pdtDesc;
  final String sellingPrice;
  final String email;
  final List<String> images;
  final Key key;
  /*final DateTime selectdat;*/
  const AddPopupCard({required this.key,required this.hello,required this.username, required this.pdtName, required this.pdtDesc, required this.sellingPrice, required this.email, required this.images, required this.uid, required this.snap}) : super(key: key);
  @override
  State<AddPopupCard> createState() => _Add_PopupCard(key: key,hello: hello,username: username,pdtName: pdtName,pdtDesc: pdtDesc,sellingPrice:sellingPrice,email: email,images: images,uid: uid);
}
class _Add_PopupCard extends State<AddPopupCard>{

//CHATGPT


  // List<String> imageUrls = []; // List to store image URLs
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // fetchImages(); // Fetch images when widget is initialized
  // }
  //
  // Future<void> fetchImages() async {
  //   try {
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('buy_sell_posts').get();
  //
  //     setState(() {
  //       // Update the list of image URLs
  //       List<dynamic> myDynamicList = querySnapshot.docs.map((doc) => doc['pic']).toList(); // Fetch the 'pic' array from the document
  //       List<String> myStringList = [];
  //       for (var item in myDynamicList) {
  //         if (item is String) {
  //           myStringList.addAll(item as List<String>); // Add all the items in the 'pic' array to the list of image URLs
  //         }
  //       }
  //       imageUrls = myStringList;
  //
  //       print("thgvufugifug $images");
  //     });
  //   } catch (e) {
  //     print('Error fetching images: $e');
  //   }
  // }

  final String hello;
  final String uid;
  final String username/*,start,destination,charge,vehicle,exstart,exdest,addnote*/;
  final String pdtName;
  final String pdtDesc;
  final String sellingPrice;
  final String email;
  final List<String> images;
  final Key key;
  _Add_PopupCard({required this.key,required this.hello,required this.username, required this.pdtName, required this.pdtDesc, required this.sellingPrice, required this.email, required this.images, required this.uid}) ;
  // bool? get mounted => null;
  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {

    ChatRoomModel? chatRoom;

    //var widget;
    print("UUUUUUUUUIIIIIIIIIIIIIDDDDDDDDDDDDDDd   =  $uid");
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.$uid", isEqualTo: true).where("participants.${targetUser.uid}", isEqualTo: true).get();
    if(snapshot.docs.length>0){
      //  Fetch the existing chatroom
      //   log("Chatroom already exists");
      var docdata = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docdata as Map<String , dynamic>);
      chatRoom = existingChatroom;
    }
    else{
      User? currentUser = FirebaseAuth.instance.currentUser;
      UserModel? thisUserModel =  await FirebaseHelper.getUserModelById(currentUser!.uid);
      //  create a new chatroom
      //   log("Chatroom does not exist");
      //var widget;
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          thisUserModel!.uid.toString(): true,
          targetUser.uid.toString(): true,
        },

      );

      await FirebaseFirestore.instance.collection("chatrooms").doc(newChatroom.chatroomid).set(newChatroom.toMap());
      chatRoom = newChatroom;
    }

    return chatRoom;
  }
  Future<String> downloadAndSaveImage(String firebaseStoragePath) async {
    final ref = FirebaseStorage.instance.ref(firebaseStoragePath);
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = firebaseStoragePath.split('/').last;
    final File localImage = File('${tempDir.path}/$fileName');

    if (localImage.existsSync()) {
      return localImage.path;
    }

    final task = ref.writeToFile(localImage);
    //await task.noSuchMethod();
    return localImage.path;
  }
  late List<String> tempimages = [];
  bool b=false;
  Future<Slideshow> func() async {
    b=false;
    for(String s in images) {
      String temp = await downloadAndSaveImage(s);
      print("Temp = $temp");
      tempimages.add(temp);
      //print(tempimages);
    }
    b=true;
    return Slideshow(images: tempimages);
  }

  Slideshow func3(){
    Slideshow temp=func() as Slideshow;
    return temp;
  }

  void func2() async{
    //while(true){
    //print("Temp imsges $tempimages");
    //print("Images $images");
    //}
  }

  List<String>? getPic() {
    List<dynamic> dynamicList = widget.snap['pic'];
    List<String>? stringList = dynamicList?.map((item) => item.toString())?.toList();
    return stringList;
  }



  @override
  Widget build(BuildContext context) {
    List<String>?PostImages=[];
    setState(() {
      PostImages=getPic();
    });
    print("About to enter the functionnnnnnnnnnnnnnnnnnnnn");
    //func();
    print("Exit of the functionnnnnnnnnnnnnnnnnnnnnnnn");
    //func2();
    //while(!b);
    print(tempimages);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Hero(
          tag: 'hello',
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
                  const SizedBox(height: 40,),
                  Text(
                    pdtName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 300,
                    child:  CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        enableInfiniteScroll: true,
                        autoPlay: true,
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
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text(
                        'Description : $pdtDesc',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Seller : $username',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  ElevatedButton(
                    onPressed: ()  async {
                      // // User? currentUser = FirebaseAuth.instance.currentUser;
                      // // if(currentUser != null) {
                      // //   UserModel? thisUserModel =  await FirebaseHelper.getUserModelById(currentUser.uid);
                      // //   if(thisUserModel != null){
                      // //     //if(mounted!){
                      // //       Navigator.push(
                      // //         context,
                      // //         MaterialPageRoute(
                      // //           builder: (context) => Chat_HomePage(userModel: thisUserModel, firebaseuser: currentUser),
                      // //         ),
                      // //       );//}
                      // //   }
                      // // }
                      // DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                      // UserModel u1=UserModel(
                      //     uid: userSnapshot['uid'],
                      //     username: userSnapshot['username'],
                      //     email: userSnapshot['email'],
                      //     profilepic: userSnapshot['profilepic']
                      // );
                      // //StreamBuilder(
                      // stream:QuerySnapshot dataSnapShot = FirebaseFirestore.instance.collection("users").where("email",isEqualTo: u1.email).where("email", isNotEqualTo: FirebaseAuth.instance.currentUser?.email).snapshots().data as QuerySnapshot;
                      //
                      //
                      // ChatRoomModel? chatroomModel = await getChatroomModel(u1);
                      //
                      // if(chatroomModel != null){
                      //   User? currentUser = FirebaseAuth.instance.currentUser;
                      //   UserModel? thisUserModel =  await FirebaseHelper.getUserModelById(currentUser!.uid);
                      //
                      //   Navigator.pop(context);
                      //   Navigator.push(context, MaterialPageRoute(builder: (context){
                      //     //var widget;
                      //     return Chat_Room_Page(
                      //       targetUser: u1,
                      //       userModel: thisUserModel!,
                      //       firabaseUser: currentUser,
                      //       chatroom: chatroomModel,
                      //     );
                      //   }));
                      //
                      // }

                    },
                    child: Text('Contact Seller !!'),
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