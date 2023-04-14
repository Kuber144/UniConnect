import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uniconnect/screens/login_screen.dart';
import 'package:uniconnect/screens/profile_view.dart';
import "package:share_plus/share_plus.dart";

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("Exit"),
        onPressed: () {
          SystemNavigator.pop();
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Confirm exit"),
        content: const Text("Are you sure you want to exit UniConnect?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    showAlertDialogLogout(BuildContext context) {
      Widget cancelButton = TextButton(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("Logout"),
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const LoginScreen()
              ), (route) => false);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    User? user = FirebaseAuth.instance.currentUser;
    String accountEmail = "example@gmail.com";

    // If the user is not null, update the account name and email
    if (user != null) {
      accountEmail = user.email ?? "";
    }
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<
                      DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Text(snapshot.data!['username']);
              },
            ),
            accountEmail: Text(accountEmail),
            currentAccountPicture: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<
                      DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final profileImageUrl = snapshot.data!['profilepic'];
                return CircleAvatar(
                  child: ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            PageRouteBuilder(
                              transitionDuration: Duration(milliseconds: 500),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation) {
                                return const ProfileView();
                              },
                              transitionsBuilder: (context, animation,
                                  secAnimation, child) {
                                var begin = Offset(-1.0, 0.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end).chain(
                                    CurveTween(curve: curve));
                                var curvedAnimation = CurvedAnimation(
                                    parent: animation, curve: curve);
                                return SlideTransition(
                                  position: tween.animate(curvedAnimation),
                                  child: child,
                                );
                              },
                            )
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: profileImageUrl,
                        width: 90,
                        height: 90,
                        placeholder: (context, url) =>
                            ClipOval(
                              child: Image.asset(
                                'assets/loading.gif',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    'assets/background/navbar_bg.jpg',)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_sharp),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secAnimation) {
                      return const ProfileView();
                    },
                    transitionsBuilder: (context, animation, secAnimation,
                        child) {
                      var begin = Offset(-1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve));
                      var curvedAnimation = CurvedAnimation(
                          parent: animation, curve: curve);
                      return SlideTransition(
                        position: tween.animate(curvedAnimation),
                        child: child,
                      );
                    },
                  )
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Friends'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Share.share(
                  "Check out this app!\nYou can download it from here: https://drive.google.com/drive/folders/1i3bdZ1h2DDMpYw6tI4jGEOlUsdY1Gu9m?usp=sharing !!\nShared from UniConnect");
            },
          ),
          const ListTile(
            leading: Icon(Icons.lightbulb_outline),
            title: Text('Request a feature'),
          ),
          const ListTile(
            leading: Icon(Icons.bug_report),
            title: Text('Report a bug'),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              showAlertDialogLogout(context);
            },
          ),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              showAlertDialog(context);
            },
          ),
        ],
      ),
    );
  }
}