//           onPressed: () {
//             Navigator.pop(context);
//             // Navigator.pushAndRemoveUntil(context,
//             //     PageRouteBuilder(
//             //       //   YE WALA USE IF YOU NEED THE SCREEN TO POPUP FROM CENTER
//             //       // transitionDuration: Duration(seconds: 2),
//             //       // transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secAnimation,Widget child){
//             //       //   return ScaleTransition(
//             //       //     alignment: Alignment.center,
//             //       //       scale: animation,
//             //       //     child: child,
//             //       //   );
//             //       // },
//             //       transitionDuration: const Duration(milliseconds: 500),
//             //       pageBuilder: (BuildContext context,
//             //           Animation<double> animation,
//             //           Animation<double> secAnimation) {
//             //         return const HomePage();
//             //       },
//             //       transitionsBuilder: (context, animation, secAnimation,
//             //           child) {
//             //         var begin = const Offset(1.0, 0.0);
//             //         var end = Offset.zero;
//             //         var curve = Curves.ease;
//             //         var tween = Tween(begin: begin, end: end).chain(
//             //             CurveTween(curve: curve));
//             //         var curvedAnimation = CurvedAnimation(
//             //             parent: animation, curve: curve);
//             //         return SlideTransition(
//             //           position: tween.animate(curvedAnimation),
//             //           child: child,
//             //         );
//             //       },
//             //     )
//             //     , (route) => false);
//           },
//         ),
//       ),
//   Widget buildTextField(String labelText, String placeholder,
//       bool isPasswordTextField) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 30),
//       child: TextField(
//         obscureText: isPasswordTextField ? isObscurePassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField ?
//             IconButton(
//                 icon: const Icon(Icons.remove_red_eye, color: Colors.grey,),
//                 onPressed: () {
//                   setState(() {
//                     isObscurePassword = !isObscurePassword;
//                   });
//                 }
//             ) : null,
//             contentPadding: const EdgeInsets.only(bottom: 5),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placeholder,
//             hintStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey
//             )
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uniconnect/screens/profile_screens/edit_profile.dart';
import '../../util/colors.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileView> {
  File? _image;
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46";
  String name = '';
  String email = '';
  String bio = "", hostel = " ", degree = "", gradyear = "", phone = "";

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "No Image Selected");
      }
    });

    if (_image != null) {
      Fluttertoast.showToast(msg: "Uploading Image....");
      String uid = FirebaseAuth.instance.currentUser!.uid;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile/$uid.jpg');
      await ref.putFile(_image!);
      String url = await ref.getDownloadURL();

      setState(() {
        imageUrl = url;
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profilepic': url});
    }
  }

  Future<void> getProfilePicture() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profile/$uid.jpg');
    String url = await ref.getDownloadURL();

    setState(() {
      imageUrl = url;
    });
  }

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.white),
                            color: iconcolor,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    )
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
              Card(
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
              Card(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secAnimation) {
                          return const EditProfile();
                        },
                        transitionsBuilder:
                            (context, animation, secAnimation, child) {
                          var begin = const Offset(0.0, 10.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var curvedAnimation =
                              CurvedAnimation(parent: animation, curve: curve);
                          return SlideTransition(
                            position: tween.animate(curvedAnimation),
                            child: child,
                          );
                        },
                      ),
                    );
                    // Action to perform when the button is pressed
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: iconcolor,
                    // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, // Horizontal padding
                      vertical: 10, // Vertical padding
                    ),
                  ),
                  child: const Text(
                    'Edit Details',
                    style: TextStyle(
                      fontSize: 16, // Text size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
