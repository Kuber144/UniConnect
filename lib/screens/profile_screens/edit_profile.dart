import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uniconnect/screens/profile_screens/profile_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../util/colors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name = '';
  String email = '';
  String bio = "", gradyear = "", phone = "";
  String _selectedHostel = "Not selected yet";
  String _selectedDegree = "Not selected yet";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _gradyearController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();

  bool _isSendOtp = false;

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        name = userSnapshot['username'];
        email = userSnapshot['email'];
        bio = userSnapshot['bio'];
        _selectedHostel = userSnapshot['hostel'];
        phone = userSnapshot["phone"];
        _selectedDegree = userSnapshot["degree"];
        gradyear = userSnapshot["gradyear"];
        // Create controllers for each text field and set their initial values
        TextEditingController nameController =
            TextEditingController(text: name);
        TextEditingController bioController = TextEditingController(text: bio);
        TextEditingController phoneController =
            TextEditingController(text: phone);
        TextEditingController gradyearController =
            TextEditingController(text: gradyear);

        // Assign the controllers to the corresponding text fields
        _nameController = nameController;
        _bioController = bioController;
        _phoneController = phoneController;
        _gradyearController = gradyearController;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<bool> _sendOtp(String phone) async {
    if (_isSendOtp) {
      return false;
    }
    _isSendOtp = true;
    Completer<bool> completer = Completer<bool>();
    Timer? timeouttimer;

    User? currentUser = FirebaseAuth.instance.currentUser;

    _auth.verifyPhoneNumber(
      phoneNumber: "+91$phone",
      verificationCompleted: (PhoneAuthCredential credential) async {
        if (currentUser != null) {
          try {
            await currentUser.linkWithCredential(credential);
            Fluttertoast.showToast(msg: "Phone number linked successfully!");
            completer.complete(true);
          } catch (e) {
            Navigator.of(context).pop();
            Fluttertoast.showToast(msg: e.toString());
            completer.complete(false);
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        _phoneController.text = phone;
        Fluttertoast.showToast(msg: e.message!);
        completer.complete(false);
        Navigator.of(context).pop();
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            timeouttimer = Timer(Duration(seconds: 60), () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "OTP timeout");
            });
            return AlertDialog(
              title: Text('Enter OTP'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String smsCode = _otpController.text.trim();
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                    if (currentUser != null) {
                      timeouttimer?.cancel();
                      try {
                        await currentUser.unlink("phone");
                      } catch (e) {
                        print(e.toString());
                      }
                      try {
                        await currentUser.linkWithCredential(credential);
                        Fluttertoast.showToast(
                            msg: "Phone number linked successfully!");
                        completer.complete(true);
                        Navigator.of(context).pop();
                      } catch (e) {
                        Fluttertoast.showToast(msg: e.toString());
                        completer.complete(false);
                      }
                    }
                  },
                  child: const Text('Verify'),
                ),
              ],
            );
          },
        ).then((value) {
          timeouttimer?.cancel();
        });
      },
      timeout: const Duration(seconds: 90),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile'),
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
              const SizedBox(
                height: 40,
              ),
              buildTextField("Username: ", "Username", _nameController, false),
              buildTextField("About me: ", "Bio", _bioController, false),
              buildTextField(
                  "Contact: ", "+91-6969696969", _phoneController, true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hostel:",
                    style: TextStyle(fontSize: 12),
                  ),
                  DropdownButton2<String>(
                    value: _selectedHostel,
                    items: <DropdownMenuItem<String>>[
                      if (_selectedHostel == "Not selected yet")
                        const DropdownMenuItem<String>(
                          value: 'Not selected yet',
                          child: Text('Not selected yet'),
                        ),
                      const DropdownMenuItem<String>(
                        value: 'BH-1',
                        child: Text('BH-1'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'BH-2',
                        child: Text('BH-2'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'BH-3',
                        child: Text('BH-3'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'BH-4',
                        child: Text('BH-4'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'BH-5',
                        child: Text('BH-5'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'GH-1',
                        child: Text('GH-1'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'GH-2',
                        child: Text('GH-2'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'GH-3',
                        child: Text('GH-3'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedHostel = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Pursuing:",
                    style: TextStyle(fontSize: 12),
                  ),
                  DropdownButton2<String>(
                    value: _selectedDegree,
                    items: <DropdownMenuItem<String>>[
                      if (_selectedDegree == "Not selected yet")
                        const DropdownMenuItem<String>(
                          value: 'Not selected yet',
                          child: Text('Not selected yet'),
                        ),
                      const DropdownMenuItem<String>(
                        value: 'BTech',
                        child: Text('BTech'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'MTech',
                        child: Text('MTech'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'PhD',
                        child: Text('PhD'),
                      ),
                      const DropdownMenuItem<String>(
                        value: 'MBA',
                        child: Text('MBA'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDegree = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              buildTextField(
                  "Graduation Year: ", "20XX", _gradyearController, true),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await checkUserDetails()) {
                      Fluttertoast.showToast(msg: "Saving Details...");
                      updateUserDetails();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation) {
                              return const ProfileView();
                            },
                            transitionsBuilder:
                                (context, animation, secAnimation, child) {
                              var begin = const Offset(-1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.ease;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var curvedAnimation = CurvedAnimation(
                                  parent: animation, curve: curve);
                              return SlideTransition(
                                position: tween.animate(curvedAnimation),
                                child: child,
                              );
                            },
                          ));
                    }
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
                    'Save Details',
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

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController controller, bool isOnlyDigit) {
    final _intFormatter = FilteringTextInputFormatter.digitsOnly;
    final _textFormatter = FilteringTextInputFormatter.allow(RegExp(r'.*'));
    TextInputFormatter? _formatter;

    if (isOnlyDigit) {
      _formatter = _intFormatter;
    } else {
      _formatter = _textFormatter;
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Future<bool> checkUserDetails() async {
    _nameController.text = _nameController.text.trim();
    _bioController.text = _bioController.text.trim();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _nameController.text)
        .get();
    final QuerySnapshot result2 = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: _phoneController.text)
        .get();
    if (_nameController.text.isEmpty ||
        _bioController.text.isEmpty ||
        _gradyearController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Error: Fields cannot be empty");
      return false;
    }
    final List<DocumentSnapshot> documents = result.docs;
    if (_nameController.text != name && documents.length == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'A user with the username already exists, please choose another username.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return false;
    }
    if (_phoneController.text != phone) {
      if (_phoneController.text != "Not selected yet") {
        final List<DocumentSnapshot> documents2 = result2.docs;
        if (documents2.length == 1 && _phoneController.text != phone) {
          Fluttertoast.showToast(
              msg: "Error: A user with the phone number already exists");
          return false;
        }
        if (_phoneController.text.length != 10) {
          Fluttertoast.showToast(
              msg: "Error: Phone number should be of length 10");
          return false;
        } else {
          bool verify;
          verify = await _sendOtp(_phoneController.text);
          if (!verify) {
            Fluttertoast.showToast(msg: "Error Phone Number not verified");
            Navigator.pop(context);
            Navigator.pop(context);
            return false;
          }
        }
      }
    }
    if (_gradyearController.text != "Not selected yet") {
      if ((int.parse(_gradyearController.text) < 2010 ||
          int.parse(_gradyearController.text) > 2050)) {
        Fluttertoast.showToast(
            msg: "Error: Year should be below 2050 and greater than 2010");
        return false;
      }
    }
    return true;
  }

  void updateUserDetails() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Update the values in the document
      await userDocRef.update({
        'username': _nameController.text,
        'bio': _bioController.text,
        'hostel': _selectedHostel,
        'degree': _selectedDegree,
        'gradyear': _gradyearController.text,
        'phone': _phoneController.text,
      });

      Fluttertoast.showToast(msg: "Details Updated Successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to Update Details!");
      print("efrgwfebn");
      print(e);
    }
  }
}
