import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../../util/colors.dart';
import '../../util/slideshow.dart';
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<String> images = [
    'assets/slideshow_pics/ss_1.jpg',
    'assets/slideshow_pics/ss_2.jpg',
    'assets/slideshow_pics/ss_3.jpg',
  ];

  late String? restaurant="";
  List<dynamic> all_restaurants = [];

  @override
  void initState(){
    super.initState();
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
    all_restaurants.add({"id": 1, "label": "Semester 1"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Order from Locals'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {

            },
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),

          // FormHelper.dropDownWidgetWithLabel(
          //     context,
          //     "Restaurant",
          //     "Choose Restaurant",
          //     restaurant,
          //     all_restaurants,
          //     (onChangedVal){
          //       restaurant = onChangedVal;
          //     },
          //     (onValidateVal){
          //
          //     }
          // )
        ],
      ),
    );
  }
}
