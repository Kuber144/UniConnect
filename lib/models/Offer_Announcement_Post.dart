import 'package:cloud_firestore/cloud_firestore.dart';

class Offer_Announcement_Post {
  final String offerPlace;
  String? offerLink;
  final String offerDesc;
  final String uid;
  final String username;
  final String profilepic;
  final  datePublished;
  final String postId;


   Offer_Announcement_Post({
    required this.offerPlace,
    required this.offerDesc,
    this.offerLink,
    required this.profilepic,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postId,


  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "postId":postId,
    "datePublished":datePublished,
    "profilepic":profilepic,
    "offerLink":offerLink,
    "offerDesc":offerDesc,
    "offerPlace":offerPlace,

  };

  static  fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Offer_Announcement_Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profilepic: snapshot['profilepic'],
      offerDesc: snapshot['offerDesc'],
      offerPlace: snapshot['offerPlace'],
      offerLink: snapshot['offerLink'],

    );
  }
}
