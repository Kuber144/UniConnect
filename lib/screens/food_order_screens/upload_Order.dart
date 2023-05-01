

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/resources/firestore_methods.dart';
import 'package:uniconnect/util/utils.dart';

import '../../util/colors.dart';

class upload_Order extends StatefulWidget {
  const upload_Order({super.key});

  @override
  State<upload_Order> createState() => _upload_OrderState();
}
class _upload_OrderState extends State<upload_Order> {
  final TextEditingController orderController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late DateTime selectedDateTime = DateTime.now();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController additionalController = TextEditingController();
  final _dateFormat = DateFormat('d MMMM y, h:mm a', 'en_US');
  String userid = "";
  String username = "";
  String profilepic = "";

  @override
  void dispose() {
    super.dispose();
    orderController.dispose();
    placeController.dispose();
    priceController.dispose();
    peopleController.dispose();
    descController.dispose();
    additionalController.dispose();
  }

  void uploadPost(
      String uid,
      String username,
      String profilepic,
      ) async {
    setState(() {});
    try {
      String res = await FirestoreMethods().uploadPostOrder(
        orderController.text,
        placeController.text,
        priceController.text,
        selectedDateTime,
        peopleController.text,
        uid,
        username,
        descController.text,
        additionalController.text,
        profilepic
      );
      if (res == "success") {
        setState(() {});

        orderController.clear();
        placeController.clear();
        priceController.clear();
        peopleController.clear();
        descController.clear();
        additionalController.clear();
        showSnackBar("Uploaded", context);
      } else {
        setState(() {});
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
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('REMINDER!!'),
            content: const Text(
                'Any posts with a order time that has already passed will be automatically deleted.'),
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

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        userid = userSnapshot['uid'];
        username = userSnapshot['username'];
        profilepic = userSnapshot['profilepic'];
      });
    }
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
        title: const Text('Post Bulk Order'),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/home_bg.png'),
              fit: BoxFit.cover,
            )),
          child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  buildTextField("Order:", "Enter the items to be ordered",
                      orderController, false, 50),
                  buildTextField(
                      "From where?:",
                      "Place to order",
                      placeController,
                      false,
                      100),
                  buildTextField("Expected Price:", "Enter the price", priceController, true, 5),
                  buildTextField(
                      "Expected number of people:",
                      "Enter the number of people expected",
                      peopleController,
                      true,
                      2),
                  TextFormField(
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Date and Time',
                    ),
                    controller: _textEditingController,
                    keyboardType: TextInputType.text,
                  ),
                  TextButton(
                    onPressed: () {
                      _showDateTimePicker(context);
                    },
                    child: const Text('Select date and time'),
                  ),
                  buildTextField(
                      " Descriptiom:","Description of order",
                      descController,
                      false,
                      100),
                  buildTextField(
                      "Additional Notes:",
                      "Enter any additional notes",
                      additionalController,
                      false,
                      130),
                  ElevatedButton(
                    onPressed: () {
                      if (checkdetails()) {
                        uploadPost(
                          userid,
                          username,
                          profilepic,
                        );
                      }
                      // Add your post button logic here
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
          ),
        // ],
      ),
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    final initialDate = selectedDateTime;
    final currentTime = TimeOfDay.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2051),
    );
    if (newDate != null) {
      TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: currentTime,
      );
      if (newTime != null) {
        selectedDateTime = DateTime(
          newDate.year,
          newDate.month,
          newDate.day,
          newTime.hour,
          newTime.minute,
        );
        if (selectedDateTime.isBefore(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selected time is before current time.'),
            ),
          );
        } else {
          setState(() {
            selectedDateTime = selectedDateTime;
            _textEditingController.text = _dateFormat.format(selectedDateTime);
          });
        }
      }
    }
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController controller, bool isOnlyDigit, int maxLength) {
    final intFormatter = FilteringTextInputFormatter.digitsOnly;
    final textFormatter = FilteringTextInputFormatter.allow(RegExp(r'.*'));
    TextInputFormatter? formatter;

    if (isOnlyDigit) {
      formatter = intFormatter;
    } else {
      formatter = textFormatter;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        maxLength: maxLength,
        maxLines: null,
        keyboardType: isOnlyDigit ? TextInputType.number : TextInputType.text,
        controller: controller,
        inputFormatters: [formatter],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  bool checkdetails() {
    orderController.text = orderController.text.trim();
    placeController.text = placeController.text.trim();
    priceController.text = priceController.text.trim();
    peopleController.text= peopleController.text.trim();
    descController.text= descController.text.trim();
    additionalController.text= additionalController.text.trim();
    if (orderController.text.isEmpty ||
        placeController.text.isEmpty ||
        priceController.text.isEmpty ||
        peopleController.text.isEmpty ||
        descController.text.isEmpty ||
        additionalController.text.isEmpty) {
      showSnackBar("Fields cannot be empty", context);
      return false;
    }
    if (isLessThanHalfHourFromNow(selectedDateTime)) {
      showSnackBar(
          "Requests should be made at least half an hour before departure",
          context);
      return false;
    }
    return true;
  }

  bool isLessThanHalfHourFromNow(DateTime dateTime) {
    final now = DateTime.now();
    final halfHourFromNow = now.add(const Duration(minutes: 30));
    return dateTime.isBefore(halfHourFromNow);
  }
}
