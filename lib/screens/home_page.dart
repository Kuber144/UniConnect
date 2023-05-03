import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/models/FirebaseHelper.dart';
import 'package:uniconnect/models/UserModel.dart';
import 'package:uniconnect/screens/carpool_screens/carpool_home_page.dart';
import 'package:uniconnect/screens/chat_screens/chat_home_page.dart';
import 'package:uniconnect/screens/food_order_screens/food_home_page.dart';
import 'package:uniconnect/screens/lnf_screens/lnf_home_page.dart';
import 'package:uniconnect/screens/mess_feedback_screens/mess_feedback_feed.dart';
import 'package:uniconnect/util/slideshow.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/screens/NavBar.dart';
import 'buy_sell_screens/buy_sell_home_page.dart';
import 'notes_screens/notes_home_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<String> images = [];
  String imageUrl="https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46";
  String name='';
  String email='';
  String bio="",hostel=" ",degree="",gradyear="",phone="";


  Future<void> getAllpics() async {
    List<String> images1 = [];
    try {
      DocumentReference documentRef1 =
      FirebaseFirestore.instance.collection('announcement').doc('image1');
      DocumentReference documentRef2 =
      FirebaseFirestore.instance.collection('announcement').doc('image2');
      DocumentReference documentRef3 =
      FirebaseFirestore.instance.collection('announcement').doc('image3');
      DocumentReference documentRef4 =
      FirebaseFirestore.instance.collection('announcement').doc('image4');
      DocumentReference documentRef5 =
      FirebaseFirestore.instance.collection('announcement').doc('image5');
      DocumentSnapshot documentSnapshot1 = await documentRef1.get();
      DocumentSnapshot documentSnapshot2 = await documentRef2.get();
      DocumentSnapshot documentSnapshot3 = await documentRef3.get();
      DocumentSnapshot documentSnapshot4 = await documentRef4.get();
      DocumentSnapshot documentSnapshot5 = await documentRef5.get();
      if (documentSnapshot1.exists && documentSnapshot2.exists && documentSnapshot3.exists) {
        String image1 = documentSnapshot1['url'].toString();
        String image2 = documentSnapshot2['url'].toString();
        String image3 = documentSnapshot3['url'].toString();
        String image4 = documentSnapshot4['url'].toString();
        String image5 = documentSnapshot5['url'].toString();
        images1.add(image1);
        images1.add(image2);
        images1.add(image3);
        images1.add(image4);
        images1.add(image5);
        setState(() {
          images=images1;
        });
      } else {
        print('One or more documents do not exist');
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: "Error in loading images: $error");
    }
  }


  Future<void> getUserDetails() async {
    String uid= FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(userSnapshot.exists){
      setState(() {
        name= userSnapshot['username'];
        email=userSnapshot['email'];
        bio=userSnapshot['bio'];
        hostel=userSnapshot['hostel'];
        phone=userSnapshot["phone"];
        degree=userSnapshot["degree"];
        gradyear=userSnapshot["gradyear"];
      });
    }
  }
  @override
  void initState() {
    super.initState();
    getUserDetails();
    getAllpics();
  }
  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    showAlertDialog(BuildContext context){
      Widget cancelButton = TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: Text("Exit"),
        onPressed: () {
          SystemNavigator.pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Confirm exit"),
        content: Text("Are you sure you want to exit UniConnect?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    return WillPopScope(
      onWillPop: () async {
        showAlertDialog(context);
        return true;
      },
      child:Scaffold(
        drawer: const NavBar(),
        // backgroundColor: Colors.indigo.shade50,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            User? currentUser = FirebaseAuth.instance.currentUser;
            if(currentUser != null) {
              UserModel? thisUserModel =  await FirebaseHelper.getUserModelById(currentUser.uid);
              if(thisUserModel != null){
                if(mounted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat_HomePage(userModel: thisUserModel, firebaseuser: currentUser),
                    ),
                  );}
              }
            }
          },
          child: Icon(Icons.chat),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/home_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Builder(
                            builder: (BuildContext context){
                              return IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          ),
                          const Text(
                            'Home Page',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Builder(
                              builder: (BuildContext context){
                                return GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset('assets/logo_png.png'),
                                    ),
                                  ),
                                );
                              } ),
                        ]
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          const SizedBox(height: 32),
                          SizedBox(
                            height: 300,
                            child: Slideshow(images: images),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'Choose Option',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          const Text(
                            'SERVICES',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyCardMenu(
                                title: 'BUY n SELL',
                                icon:  'assets/inner_icons/buy_sell.png',
                                onTap: () {
                                  if(mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Buy_sell_home_page(),
                                      ),
                                    );}
                                },
                              ),
                              MyCardMenu(
                                title: 'CARPOOL',
                                icon:  'assets/inner_icons/carpool.png',
                                onTap: () {
                                  if(mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const carpool_home_page(),
                                      ),
                                    );}},
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyCardMenu(
                                title: 'FOOD ORDERS',
                                icon:   'assets/inner_icons/food_order.png',
                                onTap:() {
                                  if(mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Food_Home_Page(),
                                      ),
                                    );}
                                },
                              ),
                              MyCardMenu(
                                title: 'LnF',
                                icon:   'assets/inner_icons/games.png',
                                onTap:() {

                                  if(mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const lnfHomePage(),
                                      ),
                                    );}

                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyCardMenu(
                                title: 'MESS',
                                icon:   'assets/inner_icons/mess_feedback.png',
                                onTap:() async {
                                  await getUserDetails();
                                  if(hostel!="Not selected yet")
                                  {
                                    if(mounted){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Mess_Feed(),
                                        ),
                                      );}
                                  }
                                  else{
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            // Do nothing when user tries to dismiss the dialog by pressing back button
                                            return false;
                                          },
                                          child: AlertDialog(
                                            title: const Text("Select hostel first!"),
                                            content: const Text("Please go into your profile and select your hostel by editing your profile."),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }

                                },
                              ),
                              MyCardMenu(
                                title: 'SHARE NOTES',
                                icon:   'assets/inner_icons/notes_sharing.png',
                                onTap:() {
                                  if(mounted){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const notesFeedScreen(),
                                      ),
                                    );}
                                },
                              ),

                            ],
                          ),
                          const SizedBox(height: 35),
                          const SizedBox(height: 35),
                        ],
                      ),
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

class MyCardMenu extends StatefulWidget {
  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Color color;
  final Color fontColor;

  const MyCardMenu({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color = Colors.white,
    this.fontColor = Colors.teal,
  }) : super(key: key);

  @override
  _MyCardMenuState createState() => _MyCardMenuState();
}

class _MyCardMenuState extends State<MyCardMenu> {
  Color _cardColor = Colors.white;
  Color _textColor = Colors.teal;
  void _handleTap() {
    setState(() {
      _cardColor = Colors.grey;
      _textColor = Colors.white;
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
    Timer(const Duration(milliseconds: 50), () {
      setState(() {
        _cardColor = widget.color;
        _textColor = widget.fontColor;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(widget.icon),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
            )
          ],
        ),
      ),
    );
  }
}