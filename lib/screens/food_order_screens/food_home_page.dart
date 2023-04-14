import 'package:flutter/material.dart';
import 'package:uniconnect/screens/food_order_screens/FoodOrderRequests.dart';

import 'AnnouncementScreen.dart';
import 'MenuScreen.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    AnnouncementScreen(),
    FoodOrderRequests(),
    MenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff9ef645),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Announcements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.slideshow),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
