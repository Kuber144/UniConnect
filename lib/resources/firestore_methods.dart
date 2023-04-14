

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/models/Offer_Announcement_Post.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
