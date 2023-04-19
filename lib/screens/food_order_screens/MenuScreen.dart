import 'package:flutter/material.dart';

import '../../util/slideshow.dart';
class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<String> images = [
    'assets/slideshow_pics/ss_1.jpg',
    'assets/slideshow_pics/ss_2.jpg',
    'assets/slideshow_pics/ss_3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.5),
      child: SizedBox(

          height: 300,
          child: Slideshow(images: images),

      ),
    );
  }
}
