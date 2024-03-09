import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/crush_the_plastic.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_home.dart';
import 'package:eco_collect/mini_games/guardian_of_the_forest/guardian_of_the_forest.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<MiniGamesHomeDataModel> miniGamesHomeData = [
  MiniGamesHomeDataModel(
      title: 'Light Saver',
      description:
          "Welcome to Light Saver! Your mission is to switch off all the lights to conserve energy and protect the planet. Every light switched off is a step towards a greener future. Are you ready to illuminate the path to sustainability?",
      buttonLabel: "Let's Save Energy!",
      imagePath: KImages.lightSaverBg,
      onTap: () async {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
        );
        Provider.of<GameStateProvider>(navigatorKey.currentContext!,
                listen: false)
            .reset();
        KRoute.push(
            context: navigatorKey.currentContext!,
            page: const LightSaverHome());
        KLoadingToast.showCharacterDialog(
          canPop: false,
          barrierDismissible: false,
          explorerImageHeight: 100,
          explorerImage: KExplorers.explorer8,
          title: "Light Saver: The Energy Guardian",
          message:
              "Welcome to Light Saver! Your mission is to switch off all the lights to conserve energy and protect the planet. Every light switched off is a step towards a greener future. Are you ready to illuminate the path to sustainability?${kIsWeb ? '\n\nControls:\nUse WSAD or arrow keys to move.\nPress space bar to jump.\nPress X to shoot.' : ''}",
          hideSecondary: true,
          primaryLabel: "Let's Save Energy!",
          onPrimaryPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
        );
      }),
  MiniGamesHomeDataModel(
      title: 'Recycle Plastic',
      description:
          "Welcome to Plastic Patrol, where you embark on an eco-adventure to clean up the environment! Your mission is to collect and recycle as many plastic bottles as possible while dodging traps and outsmarting enemies. The fate of our planet rests in your hands. Are you up for the challenge?",
      buttonLabel: "Let's Clean Up!",
      imagePath: KImages.recyclePlastic,
      onTap: () async {
        await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
        );
        KRoute.push(
            context: navigatorKey.currentContext!,
            page: const CrushThePlasticHome());
        KLoadingToast.showCharacterDialog(
          canPop: false,
          barrierDismissible: false,
          explorerImageHeight: 100,
          explorerImage: KExplorers.explorer8,
          title: "Recycle Plastic",
          message:
              "Welcome to Plastic Patrol, where you embark on an eco-adventure to clean up the environment! Your mission is to collect and recycle as many plastic bottles as possible while dodging traps and outsmarting enemies. The fate of our planet rests in your hands. Are you up for the challenge?",
          hideSecondary: true,
          primaryLabel: "Let's Clean Up!",
          onPrimaryPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
        );
      }),
  MiniGamesHomeDataModel(
      title: 'Guardian of the Forest',
      description:
          "Welcome to GotF, where you become the guardian of the forest! Help protect our precious trees by guiding the axe safely through the forest, avoiding any contact that could harm them. Your skills will determine the fate of our green allies. Are you ready to embark on this noble quest?",
      buttonLabel: "Let's Save Trees!",
      imagePath: KImages.hugTrees,
      onTap: () {
        KRoute.push(
          context: navigatorKey.currentContext!,
          page: const GotFHome(),
        );
        KLoadingToast.showCharacterDialog(
          canPop: false,
          barrierDismissible: false,
          explorerImage: KExplorers.explorer8,
          title: "Guardian of the Forest",
          message:
              "Welcome to GotF, where you become the guardian of the forest! Help protect our precious trees by guiding the axe safely through the forest, avoiding any contact that could harm them. Your skills will determine the fate of our green allies. Are you ready to embark on this noble quest?",
          hideSecondary: true,
          primaryLabel: "Let's Save Trees!",
          onPrimaryPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
        );
      }),
  MiniGamesHomeDataModel(
      title: 'Coming Soon!',
      description: '',
      imagePath: KImages.comingSoon,
      onTap: () {
        KLoadingToast.showCharacterDialog(
          title: 'Exciting News Ahead!',
          message:
              "Hey there, eco-champion! I've got thrilling news to share. We're gearing up to unleash a wave of new mini-games soon! Get ready to embark on exciting eco-adventures and expand your impact. Stay tuned for updates!",
          explorerImage: KExplorers.explorer6,
          hideSecondary: true,
          primaryLabel: 'Count Me In!',
          onPrimaryPressed: () {
            Navigator.pop(navigatorKey.currentContext!);
          },
        );
      }),
];

class MiniGamesHomeDataModel {
  String title;
  String description;
  String imagePath;
  String? buttonLabel;
  Function() onTap;

  MiniGamesHomeDataModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.buttonLabel,
    required this.onTap,
  });
}
