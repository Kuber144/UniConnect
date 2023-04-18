// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class Buysell_Model {
  final String uid;
  final  List<String> pic;
  final String  pdtName;
  final String pdtDesc;
  final  String sellingPrice;
  //final String phno;
  final String postId;
  final datePublished;

  const Buysell_Model({
    required this.uid,
    required this.pic,
    required this.pdtName,
    required this.pdtDesc,
    required this.sellingPrice,
    //required this.phno,
    required this.postId,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {

    "uid": uid,
    "pic":pic,
    "pdtName":pdtName,
    "pdtDesc":pdtDesc,
    "sellingPrice":sellingPrice,
    //"phno":phno,
    "postId":postId,
    "datePublished":datePublished,
  };

  static Buysell_Model fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Buysell_Model(
      uid: snapshot['uid'],
      pic: snapshot['pic'],
      pdtName: snapshot['pdtName'],
      pdtDesc: snapshot['pdtDesc'],
      sellingPrice: snapshot['sellingPrice'],
      //phno: snapshot['phno'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
    );
  }
}
