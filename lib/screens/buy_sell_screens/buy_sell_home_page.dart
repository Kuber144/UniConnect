import 'package:flutter/material.dart';
import 'package:uniconnect/screens/buy_sell_screens/buy_sell_upload_screen.dart';
import 'package:uniconnect/screens/buy_sell_screens/buy_sell_feed_user.dart';
import 'buy_sell_feed.dart';

class Buy_sell_home_page extends StatefulWidget {
  const Buy_sell_home_page({super.key});

  @override
  State<Buy_sell_home_page> createState() => _Buy_sell_home_page();
}

class _Buy_sell_home_page extends State<Buy_sell_home_page> {
  static int _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    List_Item(),
    FeedScreen2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Buy and Sell"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: 35,
              ),
              label: 'Buy Items'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_outlined,
              size: 35,
            ),
            label: 'List Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
              size: 35,
            ),
            label: 'My Items',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.amber,
      ),
    );
  }
}
