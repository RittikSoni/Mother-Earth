import 'dart:async';

import 'package:eco_collect/components/reusable_character_dialogue.dart';
import 'package:eco_collect/mini_games/guardian_of_the_forest/widgets/trees_barriers.dart';
import 'package:eco_collect/mini_games/guardian_of_the_forest/widgets/axe.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';

class GotFHome extends StatefulWidget {
  const GotFHome({super.key});

  @override
  State<GotFHome> createState() => _GotFHomeState();
}

class _GotFHomeState extends State<GotFHome> {
  // BARRIERS
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 = height of screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  // GENERAL
  static double birdYaxis = 0.0;
  static double birdHeight = 0.1;
  static double birdWidth = 0.1;

  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;

  int score = 0;

  double gravity = -4.9;
  double velocity = 2.8;

  static double barrierXone = 1;
  double barrierXtwo = barrierXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        birdYaxis = initialHeight - height;
      });

// is bird dead?
      if (isBirdDead()) {
        timer.cancel();
        gameHasStarted = false;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
              canPop: false,
              child: ReusableCharacterDialog(
                title: 'Forest Alert!',
                message:
                    "The forest needs a hero! Your axe slipped, and some trees suffered. But fear not! Every hero faces challenges. Let's learn from this setback and protect even more trees next time!",
                primaryLabel: 'Retry',
                onPrimaryPressed: () {
                  Navigator.pop(context);
                  _restartGame();
                },
                secondaryLabel: 'Back to home.',
                onSecondaryPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      }

// move map
      moveMap();

      time += 0.01;
    });
  }

  bool isBirdDead() {
    if (birdYaxis > 1 || birdYaxis < -1) {
      return true;
    }

    // check if bird hit barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYaxis <= -1 + barrierHeight[i][0] ||
              birdYaxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        // keep barrier moving
        barrierX[i] -= 0.005;
      });

      // if barrier exit the screen, keep it loop
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
        score += 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MyAxe(
                      birdY: birdYaxis,
                      birdHeight: birdHeight,
                      birdWidth: birdWidth,
                    ),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.3),
                    child: gameHasStarted
                        ? const SizedBox()
                        : const Text('TAP TO PLAY'),
                  ),
                  MyTreeBarriers(
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[0][0],
                    barrierX: barrierX[0],
                    isBottomBarrier: false,
                    color: Colors.amber,
                  ),
                  MyTreeBarriers(
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[0][1],
                    barrierX: barrierX[0],
                    isBottomBarrier: true,
                    color: Colors.red,
                  ),
                  MyTreeBarriers(
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[1][0],
                    barrierX: barrierX[1],
                    isBottomBarrier: false,
                    color: Colors.blue.shade800,
                  ),
                  MyTreeBarriers(
                    barrierWidth: barrierWidth,
                    barrierHeight: barrierHeight[1][1],
                    barrierX: barrierX[1],
                    isBottomBarrier: true,
                    color: Colors.green.shade800,
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('SCORE'),
                        Commonfunctions.gapMultiplier(),
                        Text('$score'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _restartGame() {
    setState(() {
      birdYaxis = 0;
      score = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }
}
