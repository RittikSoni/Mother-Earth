import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:flutter/material.dart';

class ReusableTopCharacterDialogue extends StatelessWidget {
  const ReusableTopCharacterDialogue({
    super.key,
    this.explorerImagePath,
    required this.message,
  });
  final String? explorerImagePath;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Image.asset(
              explorerImagePath ?? KExplorers.explorer6,
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: KTheme.transparencyBlack,
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
