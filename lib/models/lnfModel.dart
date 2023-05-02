// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class lnfModel {
  final String uid;
  final List<String> pic;
  final String pdtName;
  final String pdtDesc;
  final postType;

  //final String phno;
  final String postId;
  final datePublished;

  const lnfModel({
    required this.postType,
    required this.uid,
    required this.pic,
    required this.pdtName,
    required this.pdtDesc,
    //required this.phno,
    required this.postId,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "pic": pic,
        "pdtName": pdtName,
        "pdtDesc": pdtDesc,
        //"phno":phno,
        "postId": postId,
        "postType": postType,
        "datePublished": datePublished,
      };

  static lnfModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return lnfModel(
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      pdtName: snapshot['pdtName'],
      pdtDesc: snapshot['pdtDesc'],
      postType: snapshot['postType'],
      //phno: snapshot['phno'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
    );
  }
}
