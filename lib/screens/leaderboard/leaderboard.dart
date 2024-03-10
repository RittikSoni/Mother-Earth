import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/providers/leaderboard_data_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/leaderboard/widgets/full_page_leaderboard.dart';

import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.hero);
    return SafeArea(
      child: Stack(
        children: [
          const ReusableBgImage(
            assetImageSource: KLottie.forest,
            isLottie: true,
            repeatLottie: false,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ReusableTopCharacterDialogue(
                  message: "leaderboard_screen.welcome_message".tr(),
                  explorerImagePath: KExplorers.explorer4,
                ),
                Commonfunctions.gapMultiplier(gapMultiplier: 0.5),
                Consumer<LeaderboardDataProvider>(
                  builder: (context, leaderBoardProvider, child) {
                    if (leaderBoardProvider.leaderBoardData == null) {
                      leaderBoardProvider.fetchLeaderBoardData();
                      return Center(
                        child: LottieBuilder.asset(
                          KLottie.loading,
                          height: 80,
                        ),
                      );
                    }
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          leaderBoardProvider.fetchLeaderBoardData();
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              leaderBoardProvider.leaderBoardData?.length,
                          itemBuilder: (context, usernamesIndex) {
                            final curretnItr = leaderBoardProvider
                                .leaderBoardData?[usernamesIndex];

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: leaderBoardProvider
                                  .leaderBoardData?[usernamesIndex]
                                  .tasks
                                  .length,
                              itemBuilder: (context, taskIndex) {
                                final currentTask = leaderBoardProvider
                                    .leaderBoardData?[usernamesIndex]
                                    .tasks[taskIndex];

                                return _customTile(
                                    context: context,
                                    taskTitle: currentTask?.taskTitle,
                                    name: curretnItr?.name,
                                    username: curretnItr?.username,
                                    messageToWorld: currentTask?.message,
                                    url: currentTask?.videoUrl);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _customTile({
    required BuildContext context,
    String? messageToWorld,
    required String? taskTitle,
    required String? name,
    required String? username,
    required String? url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Material(
          elevation: 1.0,
          borderRadius: BorderRadius.circular(10.0),
          color: KTheme.transparencyBlack,
          child: ListTile(
            onTap: () => KRoute.push(
                context: context,
                page: FullPageLeaderboard(
                  messageToWorld: messageToWorld == "" || messageToWorld == null
                      ? 'dear_world_message'.tr()
                      : messageToWorld,
                  url: url ?? KStrings.defaultVideoUrl,
                  username: username ?? KStrings.defaultUsername,
                  name: name ?? KStrings.defaultName,
                  taskTitle: taskTitle,
                )),
            leading: CircleAvatar(
              backgroundColor: KTheme.otherMessageBG,
              child: Text(
                  name != null ? name.substring(0, 2).toUpperCase() : 'EC'),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskTitle ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  messageToWorld == "" || messageToWorld == null
                      ? Commonfunctions.trimString(
                          text: 'dear_world_message'.tr())
                      : Commonfunctions.trimString(text: messageToWorld),
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            subtitle: Text('@${username ?? "eco_collect"}'),
          )),
    );
  }
}
