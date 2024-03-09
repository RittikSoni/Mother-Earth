import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LightSaverHome extends StatelessWidget {
  const LightSaverHome({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(
              loadingBuilder: (p0) {
                return Center(
                  child: LottieBuilder.asset(
                    KLottie.loading,
                    height: 80.0,
                    width: 80.0,
                  ),
                );
              },
              game: LightSaverGame(),
            ),
            Consumer<GameStateProvider>(builder: (context, gameProvider, chid) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _customContainer(
                    gameProvider: gameProvider,
                    text: "🍒 ${gameProvider.bulletsCollected ?? 0}",
                  ),
                  _customContainer(gameProvider: gameProvider),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Container _customContainer(
      {required GameStateProvider gameProvider, String? text}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: KTheme.transparencyBlack,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text ??
            "💡Energy Saved: ${gameProvider.lightsCollected ?? 0} / ${gameProvider.lightsRequired ?? 'Loading...'}",
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 18.0),
      ),
    );
  }
}
