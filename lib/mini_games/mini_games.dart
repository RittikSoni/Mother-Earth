import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';

import 'package:eco_collect/constants/ktheme.dart';

import 'package:eco_collect/mini_games/data/mini_games_home_data.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MiniGames extends StatelessWidget {
  const MiniGames({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.miniGames);
    return Scaffold(
      appBar: reusableAppBar(title: 'Mini Games'),
      body: Stack(
        children: [
          const ReusableBgImage(
            assetImageSource: KImages.hogwarts,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: LottieBuilder.asset(KLottie.witch)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const ReusableTopCharacterDialogue(
                  message:
                      "Welcome to the Mini-Game Zone! Dive into fun-filled challenges designed to sharpen your eco-skills. Each game is a chance to learn, grow, and make a positive impact. Let's play and change the world, one game at a time!",
                  explorerImagePath: KExplorers.explorer6,
                ),
                Commonfunctions.gapMultiplier(gapMultiplier: 0.5),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: miniGamesHomeData.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                    ),
                    itemBuilder: (context, index) {
                      final currentItr = miniGamesHomeData[index];
                      return Material(
                        color: KTheme.transparencyBlack,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          splashColor: KTheme.globalAppBarBG,
                          onTap: currentItr.onTap,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: AssetImage(
                                    currentItr.imagePath,
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.8,
                                  colorFilter: kIsWeb
                                      ? null
                                      : const ColorFilter.mode(
                                          KTheme.transparencyBlack,
                                          BlendMode.darken)),
                            ),
                            child: Center(
                              child: Text(
                                currentItr.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
