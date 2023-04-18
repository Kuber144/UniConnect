// // import 'dart:html';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uniconnect/resources/firestore_methods.dart';
// import 'package:uniconnect/util/colors.dart';
// import 'package:uniconnect/util/utils.dart';
//
// import '../models/user.dart' as model;
// import '../providers/providers.dart';
// import '../widgets/text_field_input.dart';
//
// class Carpool_upload_post extends StatefulWidget {
//   const Carpool_upload_post({super.key});
//
//   @override
//   State<Carpool_upload_post> createState() => _Carpool_upload_postState();
// }
//
// class _Carpool_upload_postState extends State<Carpool_upload_post> {
//   final TextEditingController startController = TextEditingController();
//   final TextEditingController destinationController = TextEditingController();
//   final TextEditingController vehicleController = TextEditingController();
//   final TextEditingController timeOfDepartureController =
//       TextEditingController();
//   final TextEditingController expectedPerHeadChargeController =
//       TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     startController.dispose();
//     destinationController.dispose();
//     vehicleController.dispose();
//     timeOfDepartureController.dispose();
//     expectedPerHeadChargeController.dispose();
//   }
//
//   bool _isloading = false;
//   void uploadPost() async {
//     setState(() {
//       _isloading = true;
//     });
//     try {
//       model.User user = Provider.of<UserProvider>(context).getUser;
//
//       String res = await FirestoreMethods().uploadPost(
//         start: startController.text,
//         destination: destinationController.text,
//         timeOfDeparture: timeOfDepartureController.text,
//         vehicle: vehicleController.text,
//         expectedPerHeadCharge: expectedPerHeadChargeController.text,
//         username: user.username,
//         uid: user.uid,
//       );
//       if (res == "success") {
//         setState(() {
//           _isloading = false;
//         });
//
//         startController.clear();
//         destinationController.clear();
//         vehicleController.clear();
//         timeOfDepartureController.clear();
//         expectedPerHeadChargeController.clear();
//         showSnackBar("Uploaded", context);
//       } else {
//         setState(() {
//           _isloading = false;
//         });
//         showSnackBar(res, context);
//       }
//     } catch (e) {}
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {},
//         ),
//         title: const Text('Post to'),
//         centerTitle: false,
//         actions: [
//           TextButton(
//             onPressed: uploadPost,
//             child: const Text(
//               'Post',
//               style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _isloading
//               ? const LinearProgressIndicator()
//               : const Padding(
//                   padding: EdgeInsets.only(top: 0),
//                 ),
//                 const Divider(),
//           TextFieldInput(
//               textEditingController: startController,
//               hintText: 'Enter the starting point of journey',
//               textInputType: TextInputType.text),
//           const SizedBox(
//             height: 24,
//           ),
//           TextFieldInput(
//               textEditingController: destinationController,
//               hintText: 'Enter the destination',
//               textInputType: TextInputType.text),
//           const SizedBox(
//             height: 24,
//           ),
//           TextFieldInput(
//             textEditingController: timeOfDepartureController,
//             hintText: 'Enter the time and Date of Departure',
//             textInputType: TextInputType.datetime,
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           TextFieldInput(
//             textEditingController: vehicleController,
//             hintText: 'Enter the vehicle ex- Cab or auto',
//             textInputType: TextInputType.text,
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           TextFieldInput(
//             textEditingController: expectedPerHeadChargeController,
//             hintText: 'Enter the Expected per Head Charge',
//             textInputType: TextInputType.number,
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniconnect/resources/firestore_methods.dart';
import 'package:uniconnect/screens/buy_sell_p2.dart';
import 'package:uniconnect/screens/buy_sell_p4.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';

import '../models/user.dart' as model;
import '../models/user.dart';
import '../providers/providers.dart';
import '../widgets/text_field_input.dart';
import 'buy_sell_p3.dart';

class Buy_sell_p1 extends StatefulWidget {
  const Buy_sell_p1({super.key});

  @override
  State<Buy_sell_p1> createState() => _Buy_sell_p1();
}

class _Buy_sell_p1 extends State<Buy_sell_p1> {
  TextEditingController startController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController timeOfDepartureController =
  TextEditingController();
  TextEditingController expectedPerHeadChargeController =
  TextEditingController();

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    destinationController.dispose();
    vehicleController.dispose();
    timeOfDepartureController.dispose();
    expectedPerHeadChargeController.dispose();
  }

  // bool _isloading = false;
  // void uploadPost(
  //     String uid,
  //     String username,
  //     String profilepic,
  //     ) async {
  //   setState(() {
  //     _isloading = true;
  //   });
  //   try {
  //
  //     // String res = await FirestoreMethods().uploadPost(
  //     //   startController.text,
  //     //   destinationController.text,
  //     //   vehicleController.text,
  //     //   //timeOfDepartureController.text,
  //     //
  //     //   expectedPerHeadChargeController.text,
  //     //   uid,
  //     //
  //     //   username,
  //     //   profilepic,
  //     // );
  //     // if (res == "success") {
  //     //   setState(() {
  //     //     _isloading = false;
  //     //   });
  //       //
  //       // startController.clear();
  //       // destinationController.clear();
  //       // vehicleController.clear();
  //       // timeOfDepartureController.clear();
  //       // expectedPerHeadChargeController.clear();
  //       showSnackBar("Uploaded", context);
  //     } else {
  //       setState(() {
  //         _isloading = false;
  //       });
  //       showSnackBar(res, context);
  //     }
  //   } catch (e) {
  //     showSnackBar(e.toString(), context);
  //   }
  // }


  static int _currentIndex =0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    List_Item()
        ,
    FeedScreen2(),
  ];



  @override
  Widget build(BuildContext context) {
    final model.User? user =  Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Buy and Sell"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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








