import 'package:flutter/material.dart';
import 'package:uniconnect/util/colors.dart';
import 'carpool_feed.dart';
import 'carpool_My_Requests.dart';
import 'carpool_upload_post.dart';

class carpool_home_page extends StatefulWidget {
  const carpool_home_page({super.key});

  @override
  State<carpool_home_page> createState() => _carpool_home_page();
}

class _carpool_home_page extends State<carpool_home_page> {
  static int _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    Carpool_upload_post(),
    My_Requests(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Carpool"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.car_crash_sharp,
                size: 35,
                color: iconcolor,
              ),
              label: 'See Requests'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_outlined,
              size: 35,
              color: iconcolor,
            ),
            label: 'Post Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
              size: 35,
              color: iconcolor,
            ),
            label: 'My Requests',
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
