import 'package:eco_collect/constants/kassets.dart';
import 'package:flutter/material.dart';

class MyAxe extends StatelessWidget {
  const MyAxe(
      {super.key,
      required this.birdHeight,
      required this.birdWidth,
      required this.birdY});
  final double birdHeight;
  final double birdWidth;
  final double birdY;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, ((2 * birdY + birdHeight) / (2 - birdHeight))),
      child: Image.asset(
        KImages.axe,
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
