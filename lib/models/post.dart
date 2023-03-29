import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String start;
    final  String destination;
  final String  vehicle;
     final String timeOfDeparture;
final  String expectedPerHeadCharge;
final String uid;
final String username;
final  datePublished;
final String postId;

  const Post({
    required this.start,
    required this.destination,
    required this.vehicle,
    required this.timeOfDeparture,
    required this.expectedPerHeadCharge,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postId,

  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "uid": uid,
    "start":start,
    "destination":destination,
    "vehicle":vehicle,
    "timeOfDeparture":timeOfDeparture,
    "expectedPerHeadCharge":expectedPerHeadCharge,
    "postId":postId,
    "datePublished":datePublished,
  };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      start: snapshot['start'],
      destination: snapshot['destination'],
      timeOfDeparture: snapshot['timeOfDeparture'],
      vehicle: snapshot['vehicle'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      expectedPerHeadCharge: snapshot['expectedPerHeadCharge'],
    );
  }
}
