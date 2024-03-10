import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';

import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kshowcase_keys.dart';
import 'package:eco_collect/mini_games/mini_games.dart';

import 'package:eco_collect/providers/solo_level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/gameplay/solo/widgets/solo_levels_grid_builder.dart';
import 'package:eco_collect/services/audio_services.dart';

import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class SoloGameplayScreen extends StatelessWidget {
  const SoloGameplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.solo);

    return Scaffold(
      body: Stack(
        children: [
          ReusableBgImage(
            isLottie: true,
            assetImageSource:
                Commonfunctions.isDay() ? KLottie.day : KLottie.night,
          ),
          LottieBuilder.asset(KLottie.birds),
          Showcase(
              key: KShowcaseKeys.levels,
              title: 'Tasks',
              description:
                  "Get pumped! Dive into our top sustainable goals, pick your mission, and crush them for epic rewards! Let's make a positive impact together! 🌍💥",
              child: LottieBuilder.asset(KLottie.parrots)),
          RefreshIndicator(
            onRefresh: () async {
              await Provider.of<SoloLevelProvider>(context, listen: false)
                  .fetchLevels();
              if (!context.mounted) return;
              await Provider.of<UserDataProvider>(context, listen: false)
                  .fetchUserTaskSubmissions();
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                ReusableTopCharacterDialogue(
                  explorerImagePath: KExplorers.explorer8,
                  message: "soloLevelGamePlayScreen.welcome_to_task_hub".tr(),
                ),
                Commonfunctions.gapMultiplier(gapMultiplier: 0.5),
                ReusableButton(
                  label: 'soloLevelGamePlayScreen.mini_games_zone'.tr(),
                  icon: Icons.gamepad_outlined,
                  onTap: () {
                    KRoute.push(context: context, page: const MiniGames());
                  },
                ),
                Consumer2<SoloLevelProvider, UserDataProvider>(
                  builder: (context, soloLevelProvider, userDataProvider, _) {
                    if (soloLevelProvider.levelNumbers == null ||
                        soloLevelProvider.levelNumbers!.isEmpty) {
                      soloLevelProvider.fetchLevels();
                      return Center(
                          child: LottieBuilder.asset(
                        KLottie.loading,
                        height: 80.0,
                        width: 80.0,
                      ));
                    } else if (userDataProvider.getUserTaskSubmissions ==
                        null) {
                      userDataProvider.fetchUserTaskSubmissions();
                      return Center(
                          child: LottieBuilder.asset(
                        KLottie.loading,
                        height: 80.0,
                        width: 80.0,
                      ));
                    } else {
                      return soloLevelProvider.levelNumbers == null ||
                              soloLevelProvider.levelNumbers!.isEmpty
                          ? LottieBuilder.asset(
                              KLottie.loading,
                              height: 200,
                              width: 200,
                            )
                          : SoloLevelGridBuilder(
                              soloLevelProvider: soloLevelProvider,
                            );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
