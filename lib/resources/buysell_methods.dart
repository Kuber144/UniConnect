import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uniconnect/models/buysell_model.dart';
import 'package:uuid/uuid.dart';

class BuySellMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload Post
  Future<String> uploadPost(
    String uid,
    List<String> pic,
    String pdtName,
    String pdtDesc,
    String sellingPrice,
    String postId,
  ) async {
    String res = "some error occurred";
    try {
      Buysell_Model post = Buysell_Model(
        uid: uid,
        pic: pic,
        pdtName: pdtName,
        pdtDesc: pdtDesc,
        sellingPrice: sellingPrice,
        datePublished: DateTime.now(),
        postId: postId,
      );

      // Add the 'pic' array to Firestore using FieldValue.arrayUnion()
      FirebaseFirestore.instance.collection('buy_sell_posts').doc(postId).set(
        {
          'uid': post.uid,
          'pic': FieldValue.arrayUnion(post.pic),
          'pdtName': post.pdtName,
          'pdtDesc': post.pdtDesc,
          'sellingPrice': post.sellingPrice,
          'datePublished': post.datePublished,
          'postId': post.postId,
        },
      );

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
