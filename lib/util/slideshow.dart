import 'dart:async';
import 'package:flutter/material.dart';

class Slideshow extends StatefulWidget {
  final List<String> images;

  const Slideshow({required this.images});

  @override
  _SlideshowState createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.images.length,
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            Center(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/logo_png.png',
                image: widget.images[index],
                fit: BoxFit.contain,
                imageErrorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset('assets/logo_png.png', // Specify your default image or error message widget here
                      fit: BoxFit.contain
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
