import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uniconnect/resources/auth.methods.dart';
import 'package:uniconnect/responsive/responsive_layout_screen.dart';
import 'package:uniconnect/responsive/web_screen_layout.dart';
import 'package:uniconnect/screens/home_page.dart';
import 'package:uniconnect/screens/signup_screen.dart';
import 'package:uniconnect/util/colors.dart';
import 'package:uniconnect/util/utils.dart';
import 'package:uniconnect/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: HomePage()),
        ),
      );
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/loginbg.jpg'),
          fit: BoxFit.cover,
        )),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
              flex: 3,
              child: SvgPicture.asset(
                'assets/logo.svg',
                // height: 1000,
                // matchTextDirection: false,
                // allowDrawingOutsideViewBox: true,
                // height: 3205,
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
                // fit: BoxFit.contain,
                // alignment: Alignment.center,
              )),

          // const SizedBox(height: 0),
          TextFieldInput(
              textEditingController: emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress),
          const SizedBox(height: 20),
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
            onTap: loginUser,
            child: Container(
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String email = '';
                      return AlertDialog(
                        title: const Text('Forgot Password'),
                        content: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Call Firebase Auth API to send forgot password email
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);
                              showSnackBar(
                                  "Email Sent! Please check your span folder if not recieved.",
                                  context);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Forgot Password? Click here!'),
              )),
          const SizedBox(
            height: 12,
          ),
          Flexible(flex: 2, child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: const Text("Don't have an account?"),
              ),
              GestureDetector(
                onTap: navigateToSignUp,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )
        ]),
      )),
    );
  }
}
