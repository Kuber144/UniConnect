import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreatorsPage extends StatefulWidget {
  const CreatorsPage({Key? key}) : super(key: key);
  static const List<String> imagePaths = [
    'assets/cats/cat1.jpeg',
    'assets/cats/cat2.jpeg',
    'assets/cats/cat3.jpeg',
    'assets/cats/cat4.jpeg',
    'assets/cats/cat5.jpeg',
    'assets/cats/cat6.jpeg',
    'assets/cats/cat7.jpeg',
    'assets/cats/cat8.jpeg',
    'assets/cats/cat9.jpeg',
    'assets/cats/cat10.jpeg',
    'assets/cats/cat11.jpeg',
    'assets/cats/cat12.jpeg',
    'assets/cats/cat13.jpeg',
    'assets/cats/cat14.jpeg',
    'assets/cats/cat15.jpeg',
    'assets/cats/cat16.jpeg',
    'assets/cats/cat17.jpeg',
    'assets/cats/cat18.jpeg',
    'assets/cats/cat19.jpeg',
    'assets/cats/cat20.jpeg',
    'assets/cats/cat21.jpeg',
    'assets/cats/cat22.jpeg',
    'assets/cats/cat23.jpeg',
    'assets/cats/cat24.jpeg',
    'assets/cats/cat25.jpeg',
    'assets/cats/cat26.jpeg',
    'assets/cats/cat27.jpeg',
    'assets/cats/cat28.jpeg',
    'assets/cats/cat29.jpeg',
    'assets/cats/cat30.jpeg',
    'assets/cats/cat31.jpeg',
    'assets/cats/cat32.jpeg',
    'assets/cats/cat33.jpeg',
    'assets/cats/cat34.jpeg',
    'assets/cats/cat35.jpeg',
    'assets/cats/cat36.jpeg',
    'assets/cats/cat37.jpeg',
    'assets/cats/cat38.jpeg',
    'assets/cats/cat39.jpeg',
    'assets/cats/cat40.jpeg',
  ];

  @override
  _CreatorsPageState createState() => _CreatorsPageState();
}

class _CreatorsPageState extends State<CreatorsPage> {
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = CreatorsPage
        .imagePaths[Random().nextInt(CreatorsPage.imagePaths.length)];
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/home_bg.png'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Creators'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                child: const Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 20, // Change the font size to your desired size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.white, // Change the text color to white
                  ),
                ),
                onPressed: () async {
                  // Replace with the email address you want to send the mail to
                  const emailId = 'replytouniconnect@gmail.com';
                  // Open the default mail app with a pre-filled email addressed to the specified email id
                  const url = 'mailto:$emailId';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Rajat Srivastava',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _launchURL('https://github.com/rajat397'),
                                child: Image.asset(
                                  'assets/github.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.linkedin.com/in/rajat397/'),
                                child: Image.asset(
                                  'assets/linkedin.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.instagram.com/rajat_397/'),
                                child: Image.asset(
                                  'assets/instagram.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Kaushik Mullick',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _launchURL('https://github.com/Cromyl'),
                                child: Image.asset(
                                  'assets/github.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.linkedin.com/in/kaushik-mullick-0b575b217/'),
                                child: Image.asset(
                                  'assets/linkedin.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.instagram.com/kaushik.mullick/'),
                                child: Image.asset(
                                  'assets/instagram.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Viraj Jagtap',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://github.com/VirajJagtap001'),
                                child: Image.asset(
                                  'assets/github.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.linkedin.com/in/kaushik-mullick-0b575b217/'),
                                child: Image.asset(
                                  'assets/linkedin.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.instagram.com/kaushik.mullick/'),
                                child: Image.asset(
                                  'assets/instagram.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Kuber Jain',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _launchURL('https://github.com/Kuber144'),
                                child: Image.asset(
                                  'assets/github.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.linkedin.com/in/kuber-jain-8aa8a4231/'),
                                child: Image.asset(
                                  'assets/linkedin.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.instagram.com/kuber.jn/'),
                                child: Image.asset(
                                  'assets/instagram.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                'Dhairya Bhadani',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _launchURL('https://github.com/dhairya996'),
                                child: Image.asset(
                                  'assets/github.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.linkedin.com/in/dhairya-bhadani-5a0960198/'),
                                child: Image.asset(
                                  'assets/linkedin.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _launchURL(
                                    'https://www.instagram.com/__dhairya_b__/'),
                                child: Image.asset(
                                  'assets/instagram.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Image.asset(_selectedImagePath!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
