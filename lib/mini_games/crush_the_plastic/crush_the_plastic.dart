import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/crush_the_plastic_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class CrushThePlasticHome extends StatelessWidget {
  const CrushThePlasticHome({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GameWidget(
                loadingBuilder: (p0) {
                  return Center(
                    child: LottieBuilder.asset(
                      KLottie.loading,
                      height: 80.0,
                      width: 80.0,
                    ),
                  );
                },
                game: PlasticCrusher(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
