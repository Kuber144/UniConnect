import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uniconnect/resources/firestore_methods.dart';
import 'package:uniconnect/util/utils.dart';

class Carpool_upload_post extends StatefulWidget {
  const Carpool_upload_post({super.key});

  @override
  State<Carpool_upload_post> createState() => _Carpool_upload_postState();
}

class _Carpool_upload_postState extends State<Carpool_upload_post> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  late DateTime selectedDateTime = DateTime.now();
  final TextEditingController expectedPerHeadChargeController =
      TextEditingController();
  final TextEditingController exactstartController = TextEditingController();
  final TextEditingController exactdestinationController =
      TextEditingController();
  final TextEditingController additionalController = TextEditingController();
  final _dateFormat = DateFormat('d MMMM y, h:mm a', 'en_US');
  String userid = "";
  String username = "";
  String profilepic = "";

  @override
  void dispose() {
    super.dispose();
    startController.dispose();
    destinationController.dispose();
    vehicleController.dispose();
    expectedPerHeadChargeController.dispose();
    exactdestinationController.dispose();
    exactstartController.dispose();
    additionalController.dispose();
  }

  void uploadPost(
    String uid,
    String username,
    String profilepic,
  ) async {
    setState(() {});
    try {
      String res = await FirestoreMethods().uploadPost(
          startController.text,
          destinationController.text,
          vehicleController.text,
          selectedDateTime,
          expectedPerHeadChargeController.text,
          uid,
          username,
          exactstartController.text,
          exactdestinationController.text,
          additionalController.text,
          profilepic);
      if (res == "success") {
        setState(() {});

        startController.clear();
        destinationController.clear();
        vehicleController.clear();
        exactdestinationController.clear();
        exactstartController.clear();
        additionalController.clear();
        expectedPerHeadChargeController.clear();
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
                'Any posts with a departure time that has already passed will be automatically deleted.'),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
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
                  buildTextField("Start:", "Enter the starting point",
                      startController, false, 15),
                  buildTextField(
                      "Exact start address:",
                      "Enter the exact starting address",
                      exactstartController,
                      false,
                      100),
                  buildTextField("Destination:", "Enter the destination point",
                      destinationController, false, 15),
                  buildTextField(
                      "Exact destination address:",
                      "Enter the exact destination address",
                      exactdestinationController,
                      false,
                      100),
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
                      "Vehicle of Choice:",
                      "Enter the vehicle of choice",
                      vehicleController,
                      false,
                      10),
                  buildTextField(
                      "Expected charge per head:",
                      "Enter the expected charge",
                      expectedPerHeadChargeController,
                      true,
                      4),
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
        ],
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
    startController.text = startController.text.trim();
    exactdestinationController.text = exactdestinationController.text.trim();
    exactstartController.text = exactstartController.text.trim();
    vehicleController.text = vehicleController.text.trim();
    if (startController.text.isEmpty ||
        exactstartController.text.isEmpty ||
        destinationController.text.isEmpty ||
        exactdestinationController.text.isEmpty ||
        vehicleController.text.isEmpty ||
        expectedPerHeadChargeController.text.isEmpty) {
      showSnackBar("Fields cannot be empty", context);
      return false;
    }
    if (isLessThanHalfHourFromNow(selectedDateTime)) {
      showSnackBar(
          "Requests should be made at least half an hour before departure",
          context);
      return false;
    }
    if (startController.text.length > 15) {
      showSnackBar("Starting point should be of max 15 characters", context);
      return false;
    }
    if (destinationController.text.length > 15) {
      showSnackBar("Ending point should be of max 15 characters", context);
      return false;
    }
    if (vehicleController.text.length > 10) {
      showSnackBar(
          "Vehicle of choice should be of maximum 10 characters", context);
      return false;
    }
    if (additionalController.text.length > 130) {
      showSnackBar(
          "Additional Notes should be of maximum 130 characters", context);
      return false;
    }
    if (exactstartController.text.length > 100 ||
        exactdestinationController.text.length > 100) {
      showSnackBar(
          "Exact address should be of maximum 100 characters", context);
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
