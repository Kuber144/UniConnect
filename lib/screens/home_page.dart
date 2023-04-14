

import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
import 'notes_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> images = [
    'assets/slideshow_pics/ss_1.jpg',
    'assets/slideshow_pics/ss_2.jpg',
    'assets/slideshow_pics/ss_3.jpg',
  ];

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
                            // if(mounted){
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => const Buy_sell_p1(),
                            //     ),
                            //   );}
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
                                  builder: (context) => const FeedScreen(),
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

                          },
                        ),
                        MyCardMenu(
                          title: 'GAMES',
                          icon:   'assets/inner_icons/games.png',
                          onTap:() {},
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
                          onTap:() {},
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
                    // const SizedBox(height: 28),
                    // const SizedBox(height: 28),
                    // const SizedBox(height: 28),
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

