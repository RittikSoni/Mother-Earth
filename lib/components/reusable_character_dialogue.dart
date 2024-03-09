import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ReusableCharacterDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? explorerImage;
  final String? primaryLabel;
  final String? secondaryLabel;
  final double? explorerImageHeight;
  final bool? hidePrimary;
  final bool? hideSecondary;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const ReusableCharacterDialog({
    super.key,
    this.title,
    this.message,
    this.explorerImageHeight,
    this.explorerImage,
    this.hidePrimary,
    this.hideSecondary,
    this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dialog at the bottom
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  explorerImage ?? KExplorers.explorer1,
                  height: explorerImageHeight ??
                      getExplorerHeight(
                          explorerImage: explorerImage ?? KExplorers.explorer1),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                    color: KTheme.appBg,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LottieBuilder.asset(
                          KLottie.earth,
                          height: 100.0,
                          width: 100.0,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                title ?? "Hi, I'm your eco-guide!",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: KTheme.appFg,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                message ??
                                    "Greetings, Earthling! Ready to embark on your eco-adventure?",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: KTheme.appFg,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    hidePrimary == true && hideSecondary == true
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment:
                                hidePrimary == true || hideSecondary == true
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              hidePrimary == true
                                  ? const SizedBox()
                                  : TextButton(
                                      onPressed: onPrimaryPressed,
                                      child: Text(primaryLabel ??
                                          'Yes,\nShow Me Around!'),
                                    ),
                              hideSecondary == true
                                  ? const SizedBox()
                                  : TextButton(
                                      onPressed: onSecondaryPressed,
                                      child: Text(secondaryLabel ??
                                          'Not Now, \nI\'ll Explore Later'),
                                    ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

double getExplorerHeight({required String explorerImage}) {
  switch (explorerImage) {
    case KExplorers.explorer1:
      return 200;
    case KExplorers.explorer2:
      return 200;
    case KExplorers.explorer3:
      return 200;

    default:
      return 200;
  }
}
