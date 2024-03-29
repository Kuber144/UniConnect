import 'package:flutter/material.dart';
import 'package:uniconnect/screens/lnf_screens/FoundItemsScreen.dart';
import 'package:uniconnect/screens/lnf_screens/LostItemsScreen.dart';
import 'package:uniconnect/screens/lnf_screens/MyItemsScreen.dart';

class lnfHomePage extends StatefulWidget {
  const lnfHomePage({super.key});

  @override
  State<lnfHomePage> createState() => _lnf_home_page();
}

class _lnf_home_page extends State<lnfHomePage> {
  static int _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    LostItemsScreen(),
    FoundItemsScreen(),
    MyItemsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Lost and Found"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_off, size: 35, color: Colors.red),
              label: 'Lost Items'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle, size: 35, color: Colors.green),
            label: 'Found Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
              size: 35,
              color: Colors.blue,
            ),
            label: 'My Posts',
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
