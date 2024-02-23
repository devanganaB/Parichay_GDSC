import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> images = [
    'assets/images/maharashtra_outline.png',
    'assets/images/maharashtra_outline.png',
    'assets/images/maharashtra_outline.png',
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Image.asset(
            images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
