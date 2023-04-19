import 'package:flutter/material.dart';
import 'package:uniconnect/screens/buy_sell_p2.dart';
import 'package:uniconnect/screens/buy_sell_p4.dart';
import 'buy_sell_p3.dart';
class Buy_sell_p1 extends StatefulWidget {
  const Buy_sell_p1({super.key});
  @override
  State<Buy_sell_p1> createState() => _Buy_sell_p1();
}
class _Buy_sell_p1 extends State<Buy_sell_p1> {
  static int _currentIndex =0;
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
              icon: Icon(Icons.shopping_cart),
              label: 'Buy Items'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'List Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'My Items',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.amber,
      ),
    );
  }


}