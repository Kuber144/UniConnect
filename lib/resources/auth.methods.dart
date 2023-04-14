import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uniconnect/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = auth.currentUser!;

    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //sign up user

  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    String profilepic="https://firebasestorage.googleapis.com/v0/b/uniconnect-62628.appspot.com/o/default_prof.jpg?alt=media&token=2488a918-e680-4445-a04b-5627c62dcf46",
    String bio="Look at me, I am a beautiful butterfly!",
    String hostel="Not selected yet",
    String degree="Not selected yet",
    String gradyear="Not selected yet",
    String phone="Not selected yet",
    // required Uint8List file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        //register user
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          password: password,
          profilepic: profilepic,
          phone: phone,
          bio: bio,
          hostel: hostel,
          degree: degree,
          gradyear: gradyear,
        );

        // Send verification email
        await cred.user!.sendEmailVerification();

        //add user to our database
        await firestore.collection('users').doc(cred.user!.uid).set(
          user.toJson(),
        );

        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }


  // logging in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred =
        await auth.signInWithEmailAndPassword(email: email, password: password);

        if (cred.user!.emailVerified) {
          res = "Success";
        } else {
          await auth.signOut(); // Sign out the user
          res = "Please verify your email before logging in.";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}
