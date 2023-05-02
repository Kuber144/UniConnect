import 'package:cloud_firestore/cloud_firestore.dart';

class Order_Post {
  final String order;
  final String place;
  final String price;
  final DateTime timeOfOrder;
  final String people;
  final String uid;
  final String profilepic;
  final String username;
  final DateTime datePublished;
  final String postId;
  final String desc;
  final String addnote;

  const Order_Post({
    required this.order,
    required this.place,
    required this.price,
    required this.people,
    required this.desc,
    required this.profilepic,
    required this.timeOfOrder,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postId,
    required this.addnote,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "order": order,
        "place": place,
        "price": price,
        "people": people,
        "desc": desc,
        "postId": postId,
        "datePublished": datePublished,
        "profilepic": profilepic,
        "addnote": addnote,
        "timeOfOrder": timeOfOrder,
      };

  static fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Order_Post(
      order: snapshot['order'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profilepic: snapshot['profilepic'],
      addnote: snapshot['addnote'],
      place: snapshot['place'],
      price: snapshot['price'],
      people: snapshot['people'],
      desc: snapshot['desc'],
      timeOfOrder: snapshot['timeOfOrder'],
    );
  }
}
