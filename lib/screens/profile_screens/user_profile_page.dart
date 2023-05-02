import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../util/colors.dart';

class User_Profile_Page extends StatefulWidget {
  final String uid;

  const User_Profile_Page({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<User_Profile_Page> {
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46";
  String name = '';
  String email = '';
  String bio = "", hostel = " ", degree = "", gradyear = "", phone = "";

  Future<void> getProfilePicture() async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile/${widget.uid}.jpg');
    String url = await ref.getDownloadURL();

    setState(() {
      imageUrl = url;
    });
  }

  Future<void> getUserDetails() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    if (userSnapshot.exists) {
      setState(() {
        name = userSnapshot['username'];
        email = userSnapshot['email'];
        bio = userSnapshot['bio'];
        hostel = userSnapshot['hostel'];
        phone = userSnapshot["phone"];
        degree = userSnapshot["degree"];
        gradyear = userSnapshot["gradyear"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/home_bg.png'),
          fit: BoxFit.cover,
        )),
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity((0.1)),
                            )
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading.gif',
                            image: imageUrl,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (BuildContext context,
                                Object error, StackTrace? stackTrace) {
                              return Image.asset('assets/loading.gif',
                                  fit: BoxFit.cover);
                            },
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.person, color: iconcolor),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Username"),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onLongPress: () async {
                  ClipboardData data = ClipboardData(text: email);
                  await Clipboard.setData(data);
                  Fluttertoast.showToast(msg: "Email copied to clipboard");
                },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.email_outlined, color: iconcolor),
                  title: Text(email,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("E-Mail"),
                ),
              ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading:
                      const Icon(Icons.info_outline_rounded, color: iconcolor),
                  title: Text(bio,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("About Me"),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onLongPress: () async {
                  if(phone!="Not selected yet") {
                    ClipboardData data = ClipboardData(text: phone);
                    await Clipboard.setData(data);
                    Fluttertoast.showToast(
                        msg: "Phone Number copied to clipboard");
                  }
                  else
                    Fluttertoast.showToast(
                        msg: "User has not given a phone number to copy yet");
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.contact_page, color: iconcolor),
                    title: Text(phone,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text("Contact Number"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading:
                      const Icon(Icons.house_siding_rounded, color: iconcolor),
                  title: Text(hostel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Hostel"),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.school_sharp, color: iconcolor),
                  title: Text(degree,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Pursuing"),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading:
                      const Icon(Icons.calendar_today_sharp, color: iconcolor),
                  title: Text(gradyear,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Graduation Year"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
