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
    String profilepic,
  ) async {
    String res = "some error occurred";
    try {
      String postId = const Uuid().v1();
      Post post = Post(
        profilepic: profilepic,
        datePublished: DateTime.now(),
        uid: uid,
        username: username,
        postId: postId,
        email: email,
        comment: comment,
        hostel: hostel,
        phase: phase,
      );

      FirebaseFirestore.instance.collection('mess').doc(postId).set(
            post.toJson(),
          );

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
