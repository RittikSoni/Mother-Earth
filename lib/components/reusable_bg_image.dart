import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReusableBgImage extends StatelessWidget {
  const ReusableBgImage(
      {super.key,
      required this.assetImageSource,
      this.boxFit,
      this.isLottie,
      this.repeatLottie,
      this.height,
      this.width});
  final String assetImageSource;
  final bool? isLottie;
  final bool? repeatLottie;
  final BoxFit? boxFit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return isLottie == true
            ? LottieBuilder.asset(
                assetImageSource,
                height: height ?? constraints.maxHeight,
                width: width ?? constraints.maxWidth,
                fit: boxFit ?? BoxFit.cover,
                repeat: repeatLottie,
              )
            : Image.asset(
                assetImageSource,
                height: height ?? constraints.maxHeight,
                width: width ?? constraints.maxWidth,
                fit: boxFit ?? BoxFit.cover,
              );
      },
    );
  }
}
