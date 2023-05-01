

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/models/Offer_Announcement_Post.dart';
import 'package:uniconnect/models/lnfModel.dart';
import 'package:uuid/uuid.dart';


import '../models/orderModel.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Upload FoundPost
  Future<String> uploadLnFPost(
      String uid,
      String postType,
      List<String> pic,
      String pdtName,
      String pdtDesc,

      String postId,
      ) async {
    String res = "some error occurred";
    try {
      lnfModel post = lnfModel(
        uid: uid,
        pic: pic,
        pdtName: pdtName,
        pdtDesc: pdtDesc,
        datePublished: DateTime.now(),
        postId: postId,
        postType: postType,
      );

      // Add the 'pic' array to Firestore using FieldValue.arrayUnion()
      FirebaseFirestore.instance.collection('LnFPosts').doc(postId).set(
        {
          'uid': post.uid,
          'pic': FieldValue.arrayUnion(post.pic),
          'pdtName': post.pdtName,
          'pdtDesc': post.pdtDesc,
          'datePublished': post.datePublished,
          'postId': post.postId,
          'postType':post.postType,
        },
      );

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }


  //upload lostPost

  // Future<String> uploadLostPost(
  //     String uid,
  //     String postType,
  //     List<String> pic,
  //     String pdtName,
  //     String pdtDesc,
  //
  //     String postId,
  //     ) async {
  //   String res = "some error occurred";
  //   try {
  //     lnfModel post = lnfModel(
  //       uid: uid,
  //       pic: pic,
  //       pdtName: pdtName,
  //       pdtDesc: pdtDesc,
  //       datePublished: DateTime.now(),
  //       postId: postId,
  //       postType: postType,
  //     );
  //
  //     // Add the 'pic' array to Firestore using FieldValue.arrayUnion()
  //     FirebaseFirestore.instance.collection('lostItemsPosts').doc(postId).set(
  //       {
  //         'uid': post.uid,
  //         'pic': FieldValue.arrayUnion(post.pic),
  //         'pdtName': post.pdtName,
  //         'pdtDesc': post.pdtDesc,
  //         'datePublished': post.datePublished,
  //         'postId': post.postId,
  //         'postType':post.postType,
  //       },
  //     );
  //
  //     res = "success";
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  //upload OfferAnnouncement
  Future<String> uploadAnnouncementPost(
      String offerPlace,
      String offerLink,
      String offerDesc,
      String uid,
      String username,
      String profilepic

      ) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      print(postId);
      print(uid);
      Offer_Announcement_Post post = Offer_Announcement_Post(

        datePublished: DateTime.now(),
        uid: uid,
        username: username,
        postId: postId,
        profilepic: profilepic,
        offerPlace: offerPlace,
        offerDesc: offerDesc,
        offerLink: offerLink,
      );

      FirebaseFirestore.instance.collection('Offer Announcement Posts').doc(postId).set(
        post.toJson(),
      );

      res="success";
    } catch (e) {
      res=e.toString();

    }
    return res;
  }


  //upload CarpoolPost
  Future<String> uploadPost(
      String start,
      String destination,
      String vehicle,
      DateTime timeOfDeparture,
      String expectedPerHeadCharge,
      String uid,
      String username,
      String exacstart,
      String exacdest,
      String addnote,
      String profilepic

      ) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      print(postId);
      print(uid);
      Post post = Post(
        exacdest: exacdest,
        exacstart: exacstart,
        addnote: addnote,
        start: start,
        destination: destination,
        vehicle: vehicle,
        timeOfDeparture: timeOfDeparture,
        expectedPerHeadCharge: expectedPerHeadCharge,
        datePublished: DateTime.now(),
        uid: uid,
        username: username,
        postId: postId,
        profilepic: profilepic,
      );

      FirebaseFirestore.instance.collection('posts').doc(postId).set(
        post.toJson(),
      );

      res="success";
    } catch (e) {
      res=e.toString();

    }
    return res;
  }



  Future<String> uploadPostOrder(
      String order,
      String place,
      String price,
      DateTime timeOfOrder,
      String people,
      String uid,
      String username,
      String desc,
      String addnote,
      String profilepic

      ) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      print(postId);
      print(uid);
      Order_Post post = Order_Post(
          order: order,
        place: place,
        price: price,
        people: people,
        desc: desc,
        profilepic: profilepic,
        timeOfOrder: timeOfOrder,
        uid: uid, username: username, datePublished: DateTime.now(), postId: postId, addnote: addnote,

      );

      FirebaseFirestore.instance.collection('Orderposts').doc(postId).set(
        post.toJson(),
      );
      res="success";
    } catch (e) {
      res=e.toString();

    }
    return res;
  }
}
