import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';

import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/crush_the_plastic.dart';

import 'package:eco_collect/mini_games/data/mini_games_home_data.dart';
import 'package:eco_collect/mini_games/guardian_of_the_forest/guardian_of_the_forest.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_home.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MiniGames extends StatelessWidget {
  const MiniGames({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.miniGames);

    List<MiniGamesHomeDataModel> miniGamesHomeData = [
      MiniGamesHomeDataModel(
        title: 'mini_games_screen.light_saver_game.title'.tr(),
        descriptionKey: 'mini_games_screen.light_saver_game.message'.tr(),
        buttonLabelKey: 'mini_games_screen.light_saver_game.primaryLabel'.tr(),
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
            page: const LightSaverHome(),
          );
          KLoadingToast.showCharacterDialog(
            canPop: false,
            barrierDismissible: false,
            explorerImageHeight: 100,
            explorerImage: KExplorers.explorer8,
            title: 'mini_games_screen.light_saver_game.title'.tr(),
            message:
                "${'mini_games_screen.light_saver_game.message'.tr()}${kIsWeb ? '\n\nControls:\nUse WSAD or arrow keys to move.\nPress space bar to jump.\nPress X to shoot.' : ''}",
            primaryLabel:
                'mini_games_screen.light_saver_game.primaryLabel'.tr(),
            onPrimaryPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            hideSecondary: true,
          );
        },
      ),
      MiniGamesHomeDataModel(
        title: 'mini_games_screen.recycle_plastic_game.title'.tr(),
        descriptionKey:
            'mini_games_screen.recycle_plastic_game.description'.tr(),
        buttonLabelKey:
            'mini_games_screen.recycle_plastic_game.buttonLabel'.tr(),
        imagePath: KImages.recyclePlastic,
        onTap: () async {
          await SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
          );
          KRoute.push(
            context: navigatorKey.currentContext!,
            page: const CrushThePlasticHome(),
          );
          KLoadingToast.showCharacterDialog(
            canPop: false,
            barrierDismissible: false,
            explorerImageHeight: 100,
            explorerImage: KExplorers.explorer8,
            title: 'mini_games_screen.recycle_plastic_game.title'.tr(),
            message: 'mini_games_screen.recycle_plastic_game.description'.tr(),
            primaryLabel:
                'mini_games_screen.recycle_plastic_game.buttonLabel'.tr(),
            onPrimaryPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            hideSecondary: true,
          );
        },
      ),
      MiniGamesHomeDataModel(
        title: 'mini_games_screen.gotf_game.title'.tr(),
        descriptionKey: 'mini_games_screen.gotf_game.message'.tr(),
        buttonLabelKey: 'mini_games_screen.gotf_game.primaryLabel'.tr(),
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
            title: 'mini_games_screen.gotf_game.title'.tr(),
            message: 'mini_games_screen.gotf_game.message'.tr(),
            primaryLabel: 'mini_games_screen.gotf_game.primaryLabel'.tr(),
            onPrimaryPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            hideSecondary: true,
          );
        },
      ),
      MiniGamesHomeDataModel(
        title: 'mini_games_screen.coming_soon'.tr(),
        descriptionKey: 'mini_games_screen.coming_soon_details'.tr(),
        buttonLabelKey: 'mini_games_screen.count_me_in'.tr(),
        imagePath: KImages.comingSoon,
        onTap: () {
          KLoadingToast.showCharacterDialog(
            title: 'mini_games_screen.coming_soon'.tr(),
            message: 'mini_games_screen.coming_soon_details'.tr(),
            explorerImage: KExplorers.explorer6,
            primaryLabel: 'mini_games_screen.count_me_in'.tr(),
            onPrimaryPressed: () {
              Navigator.pop(navigatorKey.currentContext!);
            },
            hideSecondary: true,
          );
        },
      ),
    ];

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
                ReusableTopCharacterDialogue(
                  message: 'mini_games_screen.welcome_message'.tr(),
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
