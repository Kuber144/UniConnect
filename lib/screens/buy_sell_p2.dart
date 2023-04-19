
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniconnect/resources/buysell_methods.dart';
import 'package:uuid/uuid.dart';


import 'profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uniconnect/resources/firestore_methods.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';

import '../models/user.dart' as model;
import '../models/user.dart';
import '../providers/providers.dart';
import '../widgets/text_field_input.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class List_Item extends StatefulWidget {
  const List_Item({super.key});

  @override
  State<List_Item> createState() => _List_Item();
}

class _List_Item extends State<List_Item> {
  //final TextEditingController uid = TextEditingController();
  late String uid;
  List<String> pic=[];
  //final TextEditingController pic = TextEditingController();
  final TextEditingController pdtName = TextEditingController();
  final TextEditingController pdtDesc =
  TextEditingController();
  final TextEditingController sellingPrice =
  TextEditingController();
  // final TextEditingController phno =
  // TextEditingController();

  // final TextEditingController postId =
  //TextEditingController();
  // final TextEditingController datePublished =
  // TextEditingController();

  File? image;

  // XFile image=XFile("assets/left-arrow.png");
  //
  final ImagePicker picker = ImagePicker();

  get imagge => null;

  //
  // //we can upload image from camera or from gallery based on parameter
  // Future getImage(ImageSource media) async {
  //   var img = await picker.pickImage(source: media);
  //   print("kkkkkkkkkkkkkkkkkkkkk  "+img!.path);
  //   setState(() {
  //     image = img;
  //   });
  // }
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];
  List<File>? images=[];
  List<String> paths=[];
  List<String> downloadUrls = []; // List to store download URLs

  void selectImages() async {

    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
      print("dfdfdfdffdfdffdfdfdfdfdffdfdfdfdfdf123456789");
      for (XFile k in selectedImages) {
        print("dfdfdfdffdfdffdfdfdfdfdffdfdfdfdfdf");
        images!.add(File(k.path));
      }
    });








  }


  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  get imageUrl => null;

  @override
  void dispose() {
    super.dispose();
    // uid.dispose();
    //pic.dispose();
    pdtName.dispose();
    pdtDesc.dispose();
    sellingPrice.dispose();
    //phno.dispose();
    // postId.dispose();
    // datePublished.dispose();
  }

  bool _isloading = false;
  late String postId=const Uuid().v1();
  void uploadPost(String uid,
      //List<String> pic,
      String productName,
      String productDesc,
      String sellingprice,
      /*String phoneno,*/) async {
    setState(() {
      _isloading = true;
    });
    try {
      //postId;

      int c = 1;
      for (File image in images!) {
        String temp = postId;

        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance.ref()
            .child('buysell/$temp+$c.jpg');

        paths.add('buysell/$temp+$c.jpg');
        await ref.putFile(image);

        String downloadUrl = await ref.getDownloadURL(); // Get download URL for uploaded image
        downloadUrls.add(downloadUrl); // Add download URL to the list

        c++;
      }
      print("in upload func  $downloadUrls");

      String res = await BuySellMethods().uploadPost(

        // destinationController.text,
        // vehicleController.text,
        // timeOfDepartureController.text,
        //
        // expectedPerHeadChargeController.text,
        // uid,
        //
        // username,
          uid,

          downloadUrls,


          productName, productDesc, sellingprice,postId/* phoneno,*/


      );
      if (res == "success") {
        setState(() {
          _isloading = false;
        });

        // startController.clear();
        // destinationController.clear();
        // vehicleController.clear();
        // timeOfDepartureController.clear();
        // expectedPerHeadChargeController.clear();
        showSnackBar("Uploaded", context);
      } else {
        setState(() {
          _isloading = false;
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
    // Future.delayed(Duration.zero,(){
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('REMINDER!!'),
    //         content: const Text('Any posts with a departure time that has already passed will be automatically deleted.'),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // });
  }

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection(
        'users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        this.uid = userSnapshot['uid'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final model.User? user = Provider
        .of<UserProvider>(context)
        .getUser;
    return Scaffold(

        body: Center(
          child: Column(
            children: [
              MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                      "Pick Images from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold
                      )
                  ),
                  onPressed: () {
                    selectImages();
                  }
              ),
              SizedBox(height: 20,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      itemCount: imageFileList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.file(File(imageFileList![index].path),
                            fit: BoxFit.cover);
                      }
                  ),

                ),

              ),

              buildTextField("Product Name", "Product Name",pdtName, false),
              buildTextField("Product Description", "Describe your product here.",pdtDesc, false),
              buildNumberField("Selling Price", "Estimate Price",sellingPrice, false,6),
              // buildTextField("Hostel Number", "Enter your hostel number", false),
              //buildNumberField("Phone Number", "Enter your phone number",phno, false,10),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),

                ),
                onPressed: () {
                  if(checkdetails()){
                    uploadPost(uid, pdtName.text, pdtDesc.text, sellingPrice.text, /*phno.text,*/);
                  }
                },
                child: const Text('List Item'),
              ),

            ],
          ),
        )
    );
  }
  Widget buildTextField(String labelText, String placeholder,
      TextEditingController editor, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),

      child: TextField(
        //obscureText: isPasswordTextField ? isObscurePassword : false,
        controller: editor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.grey),
              onPressed: () {

              },
            )
                : null,
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


  Widget buildNumberField(String labelText, String placeholder,
      TextEditingController editor, bool isPasswordTextField, int len) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),

      child: TextField(
        controller: editor,
        //obscureText: isPasswordTextField ? isObscurePassword : false,
        keyboardType: TextInputType.number,

        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(len),
        ],

        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              icon: Icon(Icons.remove_red_eye, color: Colors.grey),
              onPressed: () {

              },
            )
                : null,
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

  bool checkdetails() {
    //pic.text = pic.text.trim();
    pdtName.text = pdtName.text.trim();
    pdtDesc.text = pdtDesc.text.trim();
    sellingPrice.text = sellingPrice.text.trim();
    // phno.text = phno.text.trim();
    if (pdtName.text.isEmpty || pdtDesc.text.isEmpty ||
        sellingPrice.text.isEmpty /*|| phno.text.isEmpty*/) {
      showSnackBar("Fields cannot be empty", context);
      return false;
    }

    return true;
  }

}
