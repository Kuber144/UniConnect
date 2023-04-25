import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uniconnect/resources/buysell_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/util/utils.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class List_Item extends StatefulWidget {
  const List_Item({super.key});

  @override
  State<List_Item> createState() => _List_Item();
}

class _List_Item extends State<List_Item> {
  late String uid;
  List<String> pic = [];
  final TextEditingController pdtName = TextEditingController();
  final TextEditingController pdtDesc = TextEditingController();
  final TextEditingController sellingPrice = TextEditingController();
  File? image;
  final ImagePicker picker = ImagePicker();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<File>? images = [];
  List<String> paths = [];
  List<String> downloadUrls = []; // List to store download URLs
  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
      for (XFile k in selectedImages) {
        images!.add(File(k.path));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    pdtName.dispose();
    pdtDesc.dispose();
    sellingPrice.dispose();
  }

  late String postId = const Uuid().v1();

  void uploadPost(
    String uid,
    String productName,
    String productDesc,
    String sellingprice,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Uploading post.\nThis might take a while.'),
            ],
          ),
        );
      },
    );

    try {
      int c = 1;
      for (File image in images!) {
        String temp = postId;
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('buysell/$temp+$c.jpg');
        paths.add('buysell/$temp+$c.jpg');
        await ref.putFile(image);
        String downloadUrl =
            await ref.getDownloadURL(); // Get download URL for uploaded image
        downloadUrls.add(downloadUrl); // Add download URL to the list
        c++;
      }
      print("in upload func  $downloadUrls");
      String res = await BuySellMethods().uploadPost(uid, downloadUrls,
          productName, productDesc, sellingprice, postId /* phoneno,*/
          );
      if (res == "success") {
        setState(() {
          pdtName.clear();
          pdtDesc.clear();
          sellingPrice.clear();
          images!.clear();
          imageFileList!.clear();
          paths.clear();
          downloadUrls.clear();
          pic.clear();
        });
        Navigator.pop(context); // Hide loading indicator
        pdtName.clear();
        pdtDesc.clear();
        sellingPrice.clear();
        images!.clear();
        imageFileList!.clear();
        paths.clear();
        downloadUrls.clear();
        pic.clear();

        showSnackBar("Uploaded", context);
      } else {
        setState(() {});
        Navigator.pop(context); // Hide loading indicator
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
  }

  Future<void> getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      setState(() {
        this.uid = userSnapshot['uid'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              // Wrap with Column
              Expanded(
                // Wrap with Expanded to take up remaining space
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible:
                            imageFileList == null || imageFileList!.isEmpty,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                            ),
                            MaterialButton(
                              color: Colors.blue,
                              child: const Text(
                                "Pick Images from Gallery",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                selectImages();
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible:
                            imageFileList != null && imageFileList!.isNotEmpty,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          // Set a fixed height for the GridView
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                              itemCount: imageFileList?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                  File(imageFileList![index].path),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTextField(
                          "Product Name", "Product Name", pdtName, false, 50),
                      buildTextField("Product Description",
                          "Describe Product Here", pdtDesc, false, 300),
                      buildTextField("Selling Price", "Estimate Price",
                          sellingPrice, true, 6),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (checkdetails()) {
                            uploadPost(
                              uid,
                              pdtName.text,
                              pdtDesc.text,
                              sellingPrice.text,
                            );
                          }
                        },
                        child: const Text('List Item'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      padding: const EdgeInsets.only(bottom: 30),
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
    pdtName.text = pdtName.text.trim();
    pdtDesc.text = pdtDesc.text.trim();
    sellingPrice.text = sellingPrice.text.trim();
    if (pdtName.text.isEmpty ||
        pdtDesc.text.isEmpty ||
        sellingPrice.text.isEmpty) {
      showSnackBar("Fields cannot be empty", context);
      return false;
    }
    if (pdtDesc.text.length > 300) {
      showSnackBar("Description can have max length 300", context);
      return false;
    }
    if (pdtName.text.length > 50) {
      showSnackBar("Product name can have max length 50", context);
      return false;
    }
    if (sellingPrice.text.length > 8) {
      showSnackBar("Product price can have max length 8", context);
      return false;
    }
    if (images!.isEmpty) {
      showSnackBar("Please select at least one image.", context);
      return false; // Return from the method without proceeding with the upload
    }
    return true;
  }
}
