// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:uniconnect/util/colors.dart';
// import 'package:uniconnect/widgets/text_field_input.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Screen"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(top:8),
//               child: TextButton(
//                 style: ButtonStyle(
//                   foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//                 ), onPressed: () { }, child: Text('Carpool'),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/rendering.dart';
// import 'package:uniconnect/responsive/mobile_screen_layout.dart';
import 'package:uniconnect/screens/NavBar.dart';
// import 'package:uniconnect/util/colors.dart';
// import 'package:flutter_smart_home/temperature.dart';

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Smart Home App',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: const HomePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
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
                              print('The Sizedbox is tapped');
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
                    Center(
                      child: Image.asset(
                        'assets/prof_pic3.jpg',
                        scale: 1.2,
                      ),
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
                          onTap:() {},
                        ),
                        MyCardMenu(
                          title: 'CARPOOL',
                          icon:  'assets/inner_icons/carpool.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NavBar(),
                              ),
                            );},
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
                          onTap:() {},
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
                          onTap:() {},
                        ),

                      ],
                    ),

                    const SizedBox(height: 28),
                    const SizedBox(height: 28),
                    const SizedBox(height: 28),
                    const SizedBox(height: 28),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardMenu({
    required String title,
    required String icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.teal,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            )
          ],
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
    Timer(Duration(milliseconds: 50), () {
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

// onTap: () {
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => const MobileScreenLayout(),
// ),
// );
// },