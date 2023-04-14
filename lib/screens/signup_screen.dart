import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uniconnect/resources/auth.methods.dart';
import 'package:uniconnect/responsive/mobile_screen_layout.dart';
import 'package:uniconnect/responsive/responsive_layout_screen.dart';
import 'package:uniconnect/responsive/web_screen_layout.dart';
import 'package:uniconnect/screens/login_screen.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';
import 'package:uniconnect/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });

    if(await checkUserDetails()){
    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      username: usernameController.text,
    );
    // if string returned is success, user has been created

    setState(() {
      isLoading = false;
    });
    if (res != "Success") {
      showSnackBar(res, context);
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Do nothing when user tries to dismiss the dialog by pressing back button
              return false;
            },
            child: AlertDialog(
              title: const Text("Sign Up Successful!"),
              content: const Text(
                  "Account Created\nPlease check your E-Mail for a verification link.\nIf it is not present there please check your spam folder.\nPlease verify your email and then login."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context) => const LoginScreen()), (
                        route) => false);
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        },
      );
    }
  }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()), (
        route) => false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/loginbg.jpg'),
                  fit: BoxFit.cover,
                )
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, children: [
              Flexible(flex: 4, child:
              Image.asset(
                'assets/logo_png.png',
                height: 1000,
              )
              ),
              const SizedBox(
                height: 30,
              ),

              // Image.asset('assets/logo_png.png'),
              TextFieldInput(
                  textEditingController: usernameController,
                  hintText: 'Enter your username',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  textEditingController: emailController,
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                textEditingController: passwordController,
                hintText: 'Enter your Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: !isLoading
                      ? const Text(
                    'Sign up',
                  )
                      : const CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                ),
              ),

              const SizedBox(
                height: 12,
              ),
              Flexible(child: Container(), flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Already have an account?"),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              )
            ]),
          )),
    );
  }

  Future<bool> checkUserDetails() async {
    usernameController.text = usernameController.text.trim();
    emailController.text = emailController.text.trim();
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: usernameController.text)
        .get();
    if (usernameController.text.isEmpty || emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Error: Fields cannot be empty");
      return false;
    }
    if(usernameController.text.length>20)
      {
        showSnackBar("Username must be of maximum 20 characters", context);
        return false;
      }
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'A user with the username already exists, please choose another username.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }
}
