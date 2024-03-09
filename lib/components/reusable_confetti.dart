import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

Stack reusableConfetti({
  required ConfettiController controller,
}) {
  return Stack(
    children: [
      Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality
              .explosive, // don't specify a direction, blast randomly
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
          createParticlePath: drawStar, // define a custom shape/path.
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality
              .explosive, // don't specify a direction, blast randomly
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
          createParticlePath: drawStar, // define a custom shape/path.
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: pi / 2,
          maxBlastForce: 5, // set a lower max blast force
          minBlastForce: 2, // set a lower min blast force
          emissionFrequency: 0.05,
          numberOfParticles: 20, // a lot of particles at once
          gravity: 0.2,
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: pi,
          maxBlastForce: 5, // set a lower max blast force
          minBlastForce: 2, // set a lower min blast force
          emissionFrequency: 0.05,
          numberOfParticles: 50, // a lot of particles at once
          gravity: 1,
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: 0,
          maxBlastForce: 5, // set a lower max blast force
          minBlastForce: 2, // set a lower min blast force
          emissionFrequency: 0.05,
          numberOfParticles: 50, // a lot of particles at once
          gravity: 0.5,
        ),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: 0,
          maxBlastForce: 5, // set a lower max blast force
          minBlastForce: 2, // set a lower min blast force
          emissionFrequency: 0.05,
          numberOfParticles: 50, // a lot of particles at once
          gravity: 0.5,
        ),
      ),
      Align(
        alignment: Alignment.topRight,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: 0,
          maxBlastForce: 5, // set a lower max blast force
          minBlastForce: 2, // set a lower min blast force
          emissionFrequency: 0.05,
          numberOfParticles: 50, // a lot of particles at once
          gravity: 0.5,
        ),
      ),
    ],
  );
}

/// A custom Path to paint stars.
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 1.2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerStep = degToRad(360 / numberOfPoints);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degreesPerStep) {
    path.lineTo(halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
  }
  path.close();
  return path;
}
