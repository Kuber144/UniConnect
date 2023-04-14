// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:uuid/uuid.dart';
//
// import '../models/post.dart';
//
// class FirestoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   //upload Post
//   Future<String> uploadPost({
//     required String start,
//    required String destination,
//    required String vehicle,
//    required String timeOfDeparture,
//    required  String expectedPerHeadCharge,
//     required String uid,
//    required String username,
//
//   }) async {
//     String res = "some error occurred";
//     try {
//       String postId = const Uuid().v1();
//
//       Post post = Post(
//         start: start!,
//         destination: destination!,
//         vehicle: vehicle!,
//         timeOfDeparture: timeOfDeparture!,
//         expectedPerHeadCharge: expectedPerHeadCharge!,
//         datePublished: DateTime.now(),
//         uid: uid,
//         username: username!,
//         postId: postId,
//       );
//
//       FirebaseFirestore.instance.collection('posts').doc(postId).set(
//             post.toJson(),
//           );
//
//       res="success";
//     } catch (e) {
//       res=e.toString();
//
//     }
//     return res;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/post_mess.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload Post
  Future<String> uploadPost(
      String uid,
      String username,
      String email,
      String comment,
      String hostel,
      String phase,

      ) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      print(postId);
      print(uid);
      Post post = Post(
        datePublished: DateTime.now(),
        uid: uid,
        username: username,
        postId: postId,
        email: email, comment: comment,
        hostel: hostel,
        phase: phase,
      );

      FirebaseFirestore.instance.collection('mess').doc(postId).set(
        post.toJson(),
      );

      res="success";
    } catch (e) {
      res=e.toString();

    }
    return res;
  }
}
