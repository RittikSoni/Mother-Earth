import 'package:eco_collect/constants/kassets.dart';
import 'package:flutter/material.dart';

class MyTreeBarriers extends StatelessWidget {
  const MyTreeBarriers({
    super.key,
    required this.barrierWidth,
    required this.barrierHeight,
    required this.barrierX,
    required this.isBottomBarrier,
    this.color,
  });

  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isBottomBarrier;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(((2 * barrierX + barrierWidth) / (2 - barrierWidth)),
          isBottomBarrier ? 1 : -1),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isBottomBarrier ? KImages.tree : KImages.reverseTree,
            ),
            fit: BoxFit.fill,
          ),
        ),
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
