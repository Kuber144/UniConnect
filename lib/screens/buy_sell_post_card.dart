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
import 'package:uniconnect/screens/carpool_feed.dart';
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
import 'package:uniconnect/screens/carpool_upload_post.dart';

//import '../models/user.dart';
import 'buy_sell_p1.dart';
import '../models/user.dart' as MyUser;
import 'buy_sell_post_innerCard.dart';
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

class BuySellPostCard extends StatefulWidget {
  final Map<String, dynamic> snap;

  final String hello;
  const BuySellPostCard({Key? key, required this.snap, required this.hello}) : super(key: key);

  @override
  _BuySellPostCardState createState() => _BuySellPostCardState();
}

class _BuySellPostCardState extends State<BuySellPostCard> {
  String name="name";
  String email="email";
  String phone="phone";
  String hostel="hostel";

  static late UserModel u1;
  //String imageUrl="https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46";
  late String imageUrl;
  final storage=firebase_storage.FirebaseStorage.instance;
  @override
  void initState(){
    super.initState();
    imageUrl="https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46";
    getImageUrl();
    getUserDetails(widget.snap['uid']);
  }
  Future<void> getImageUrl() async{
    String postId=widget.snap['postId'];
    final ref=storage.ref().child('buysell/$postId+1.jpg');
    final url = await ref.getDownloadURL();
    setState(() {
      imageUrl=url;
    });
  }
  Future<void> getUserDetails(String uid)  async {
    //String uid= FirebaseAuth.instance.currentUser!.uid;
    print("Call  111111111111");
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(userSnapshot.exists){
      setState(() {
        name= userSnapshot['username'];
        email=userSnapshot['email'];
///////////////////////////////////////////////////////////////////////////////
        hostel=userSnapshot['hostel'];
        phone=userSnapshot["phone"];
        u1.uid=uid;
        u1.username=name;
        u1.email=email;
        u1.profilepic=userSnapshot['profilepic'];
        // print("$u1 UUUUUUUUUUUUUUUUU11111111111111111");
      });
    }
  }

  Future<void> getProfilePicture(String postId) async {
    //String uid= FirebaseAuth.instance.currentUser!.uid;
    print("Call 22222222222");
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('buysell%2F$postId%2B1.jpg');

    String url = await ref.getDownloadURL();

    setState(() {
      print("Urlllllllllll= $url");
      imageUrl = url;
    });
  }


  String getHello()
  {
    return widget.hello;
  }
  bool _isProcessing = true;
  bool _isProcessing2 = true;
  void _handleAsyncFunction() async {
    if (_isProcessing) {
      return; // the function is already being processed, so exit early
    }
    _isProcessing = true; // set the flag to prevent multiple calls
    try {
      // perform your asynchronous operation here
      await getUserDetails(widget.snap['uid']);
    } finally {
      //_isProcessing = false; // reset the flag so the function can be called again
    }
  }
  void _handleAsyncFunction2() async {
    if (_isProcessing2) {
      return; // the function is already being processed, so exit early
    }
    _isProcessing = true; // set the flag to prevent multiple calls
    try {
      // perform your asynchronous operation here
      await getProfilePicture(widget.snap['postId']);
    }catch(e){print("Nhi ho rha hai bc !!!");} finally {
     // _isProcessing2 = false; // reset the flag so the function can be called again
    }
  }

  @override
  Widget build(BuildContext context) {

   // _isProcessing=false;
   // _isProcessing2=false;
   // @override
   // void initState(){
     // super.initState();
      _handleAsyncFunction();
      _handleAsyncFunction2();
      getUserDetails(widget.snap['uid']);
   // }




    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(builder: (context){
          List<dynamic> dynamicList = widget.snap['pic'];
          List<String> stringList = dynamicList.map((e) => e.toString()).toList();

          return _AddPopupCard(key: UniqueKey(), hello: getHello(),username: name,pdtDesc: widget.snap['pdtDesc'],pdtName: widget.snap['pdtName'],email: email,sellingPrice: widget.snap['sellingPrice'],images: stringList,uid: widget.snap['uid'],);
        }, settings:const RouteSettings(name: "add_popup_card")));
      },
      child: Hero(
        tag: widget.hello,
        createRectTween: (begin,end){
          return CustomRectTween(begin: begin!,end: end!);
        },
        child:Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 22,
                    //   backgroundImage: NetworkImage(
                    //       profile ?? ''),
                    // ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          // child: ClipOval(
                          //   child: FadeInImage.assetNetwork(
                          //     placeholder: 'assets/prof_pic3.jpg',
                          //     //image: imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46",
                          //     image: "https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/buysell%2F${widget.snap}%2B1.jpg?alt=media&token=05c1abc5-493c-439d-96f3-b17fd1318a63",
                          //     fit: BoxFit.cover,
                          //     imageErrorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          //       return Image.asset('assets/loading.gif',
                          //           fit: BoxFit.cover
                          //       );
                          //     },
                          //   ),
                          // ),
                          child: Image(image: NetworkImage(imageUrl),fit:BoxFit.cover,),
                        ),SizedBox(width: 19),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap['pdtName']?? '',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.snap['pdtDesc'].substring(0,5)+"...",
                              style: const TextStyle(fontSize: 12, color: mobileSearchColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),SizedBox(height: 9),
                            Text(
                              'Rs.'+(widget.snap['sellingPrice']),
                              style: const TextStyle(fontSize: 12, color: mobileSearchColor),
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              // BODY SECTION BEGINS
              Card(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(15),
                // ),
                // elevation: 0,
                // color: Colors.white,
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Flex(
                //       direction: Axis.horizontal,
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Expanded(
                //           child: Padding(
                //             padding: const EdgeInsets.only(left:28.0,top: 15),
                //             child: Text(
                //               '${widget.snap['start']} \u27A4 ${widget.snap['destination']}',
                //               style: const TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 15,
                //               ),
                //             ),
                //           ),
                //         ),
                //         Padding(
                //           padding: const EdgeInsets.only(right: 30,bottom: 20),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 '${widget.snap['vehicle'] ?? ''}',
                //                 style: const TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //               const SizedBox(height: 8),
                //               Text(
                //                 '${widget.snap['expectedPerHeadCharge'] ?? ''}',
                //                 style: const TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //               const SizedBox(height: 8),
                //               Text(
                //                 '${(widget.snap['timeOfDeparture'] as Timestamp).toDate().day} ${_getMonth((widget.snap['timeOfDeparture'] as Timestamp).toDate().month)} ${(widget.snap['timeOfDeparture'] as Timestamp).toDate().year}, ${_formatTime((widget.snap['timeOfDeparture'] as Timestamp).toDate())}',
                //                 style: const TextStyle(fontWeight: FontWeight.bold),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
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

void setUpChat(String uid){

}

String _formatTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? 'am' : 'pm';
  return '$hour:$minute $period';
}
class _AddPopupCard extends StatefulWidget {
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
  const _AddPopupCard({required this.key,required this.hello,required this.username, required this.pdtName, required this.pdtDesc, required this.sellingPrice, required this.email, required this.images, required this.uid}) : super(key: key);
  @override
  State<_AddPopupCard> createState() => _Add_PopupCard(key: key,hello: hello,username: username,pdtName: pdtName,pdtDesc: pdtDesc,sellingPrice:sellingPrice,email: email,images: images,uid: uid);
}
class _Add_PopupCard extends State<_AddPopupCard>{


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

  @override
  Widget build(BuildContext context) {
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
                    //child: func(),
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