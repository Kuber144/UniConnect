import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../resources/firestore_methods.dart';
import '../../util/colors.dart';
import '../../util/utils.dart';
class upload_Announcement extends StatefulWidget {
  const upload_Announcement({Key? key}) : super(key: key);

  @override
  State<upload_Announcement> createState() => _upload_AnnouncementState();
}

class _upload_AnnouncementState extends State<upload_Announcement> {
  TextEditingController offerDesc = new TextEditingController();
  TextEditingController offerPlace = new TextEditingController();
  TextEditingController offerLink = new TextEditingController();

  late DateTime selectedDateTime= DateTime.now();
  final _dateFormat = DateFormat('d MMMM y, h:mm a', 'en_US');
  String userid="";
  String username="";
  String profilepic="";


  @override
  void dispose() {
    super.dispose();
    offerDesc.dispose();
    offerLink.dispose();
    offerPlace.dispose();
  }

  void uploadPost(
      String uid,
      String username,
      String profilepic,
      ) async {
    setState(() {
    });
    try {

      String res = await FirestoreMethods().uploadAnnouncementPost( offerPlace.text,offerLink.text,offerDesc.text, userid, username, profilepic);
      if (res == "success") {
        setState(() {
        });

        offerPlace.clear();
        offerLink.clear();
        offerDesc.clear();
        showSnackBar("Uploaded", context);
      } else {
        setState(() {
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero,(){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('REMINDER!!'),
            content: const Text('Posts will be automatically deleted after 15 days of posting.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }


  Future<void> getUserDetails() async {
    String uid= FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(userSnapshot.exists){
      setState(() {
        userid=userSnapshot['uid'];
        username=userSnapshot['username'];
        profilepic=userSnapshot['profilepic'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // final model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Post Offer Announcement'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30,),
                  buildTextField("Offer Place:", "Enter the shop or website providing offer", offerPlace, false),
                  buildTextField("Offer Link:", "Enter the link of the offer if available (Optional)", offerLink, false),
                  buildTextField("Offer Description:", "Enter the description of the offer", offerDesc , false),

                  ElevatedButton(
                      onPressed:(){ uploadPost(userid,username,profilepic);},
                      child: Text("Post",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 60,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }







  Widget buildTextField(String labelText, String placeholder, TextEditingController controller,bool isOnlyDigit) {
    final _intFormatter = FilteringTextInputFormatter.digitsOnly;
    final _textFormatter= FilteringTextInputFormatter.allow(RegExp(r'.*'));
    TextInputFormatter? _formatter;

    if(isOnlyDigit)
    {
      _formatter=_intFormatter;
    }
    else {
      _formatter=_textFormatter;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        maxLines: null,
        keyboardType: isOnlyDigit ? TextInputType.number : TextInputType.text,
        controller: controller,
        inputFormatters: [_formatter!],
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            )
        ),
      ),
    );
  }
  bool checkdetails()
  {
    offerDesc.text=offerDesc.text.trim();
    offerPlace.text=offerPlace.text.trim();
    offerLink.text=offerLink.text.trim();
    if(offerDesc.text.isEmpty || offerPlace.text.isEmpty)
    {
      showSnackBar(" offer Description and offer Place cannot be empty", context);
      return false;
    }


    return true;
  }



}
