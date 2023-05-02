import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
class _MenuScreenState extends State<MenuScreen> {
  List<String> chillout=[];
  String selectedMenu = 'Chillout';
  List<String> kings=[];
  Future<void> getAllpics() async {
    try {
      DocumentReference documentRef1 = FirebaseFirestore.instance.collection('food_menu').doc('chillout1');
      DocumentReference documentRef2 = FirebaseFirestore.instance.collection('food_menu').doc('chillout2');
      DocumentReference documentRef3 = FirebaseFirestore.instance.collection('food_menu').doc('kings1');
      DocumentReference documentRef4 = FirebaseFirestore.instance.collection('food_menu').doc('kings2');
      DocumentReference documentRef5 = FirebaseFirestore.instance.collection('food_menu').doc('kings3');
      DocumentReference documentRef6 = FirebaseFirestore.instance.collection('food_menu').doc('kings4');
      DocumentSnapshot documentSnapshot1 = await documentRef1.get();
      DocumentSnapshot documentSnapshot2 = await documentRef2.get();
      DocumentSnapshot documentSnapshot3 = await documentRef3.get();
      DocumentSnapshot documentSnapshot4 = await documentRef4.get();
      DocumentSnapshot documentSnapshot5 = await documentRef5.get();
      DocumentSnapshot documentSnapshot6 = await documentRef6.get();
      if (documentSnapshot1.exists &&
          documentSnapshot2.exists &&
          documentSnapshot3.exists &&
          documentSnapshot4.exists &&
          documentSnapshot5.exists &&
          documentSnapshot6.exists) {
        chillout.add(documentSnapshot1['url'].toString());
        chillout.add(documentSnapshot2['url'].toString());
        kings.add(documentSnapshot3['url'].toString());
        kings.add(documentSnapshot4['url'].toString());
        kings.add(documentSnapshot5['url'].toString());
        kings.add(documentSnapshot6['url'].toString());


        setState(() {
          chillout;
          kings;
        });
      } else {
        print('One or more documents do not exist');
      }
    } catch (error) {
      // Fluttertoast.showToast(msg: "Error in loading images: $error");
    }
  }
  @override
  void initState(){
    super.initState();
    getAllpics();
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text('Menu'),
      actions: [
        DropdownButton<String>(
          value: selectedMenu,
          dropdownColor: Colors.black,
          items: ['Chillout', 'Kings'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedMenu = newValue!;
            });
          },
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text('Call Restaurant'),
                value: 'call',
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'call' && selectedMenu=='Chillout') {
              // Use the url_launcher package to make a phone call
              launch('tel:+919871059001');
            }
            else if (value == 'call' && selectedMenu=='Kings') {
              // Use the url_launcher package to make a phone call
              launch('tel:+917897800995');
            }
          },
        ),
      ],
    ),
    body: selectedMenu == 'Chillout'
        ? ListView.builder(
      itemCount: chillout.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(chillout[index],
          loadingBuilder: (BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          errorBuilder: (BuildContext context,
              Object exception, StackTrace? stackTrace) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                ),
              ),
            );
          },);
      },
    )
        : ListView.builder(
      itemCount: kings.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(kings[index],
          loadingBuilder: (BuildContext context,
              Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          errorBuilder: (BuildContext context,
              Object exception, StackTrace? stackTrace) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.error),
                ),
              ),
            );
          },);
      },
    ),
  );
}
}
