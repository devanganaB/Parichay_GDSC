import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';

class Gap extends StatelessWidget {
  const Gap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 30,
          // decoration: BoxDecoration(color: Pallete.bgColor)
        ),
      ],
    );
  }
}
