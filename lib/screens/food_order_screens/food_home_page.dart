import 'package:flutter/material.dart';
import 'package:uniconnect/screens/food_order_screens/FoodOrderRequests.dart';

import 'AnnouncementScreen.dart';
import 'MenuScreen.dart';



class Food_Home_Page extends StatefulWidget {
  const Food_Home_Page({Key? key}) : super(key: key);

  @override
  _Food_Home_PageState createState() => _Food_Home_PageState();
}

class _Food_Home_PageState extends State<Food_Home_Page> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    AnnouncementScreen(),
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
            icon: Icon(Icons.menu_book_outlined),
            label: 'Menu',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.slideshow),
          //   label: 'Menu',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
