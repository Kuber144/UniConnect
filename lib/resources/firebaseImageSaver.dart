import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseImageSaver extends StatefulWidget {
  final String storagePath;

  FirebaseImageSaver({required this.storagePath});

  @override
  _FirebaseImageSaverState createState() => _FirebaseImageSaverState();
}

class _FirebaseImageSaverState extends State<FirebaseImageSaver> {
  late var _storageRef;

  @override
  void initState() {
    super.initState();
    _storageRef = FirebaseStorage.instance.ref().child(widget.storagePath);
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$fileName.jpg');
  }

  Future<void> _saveImageLocally() async {
    final fileName = widget.storagePath.split('/').last;
    final file = await _getLocalFile(fileName);
    var task = _storageRef.writeToFile(file);
    await task.future;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _saveImageLocally,
          child: Text('Save Image Locally'),
        ),
      ],
    );
  }
}
