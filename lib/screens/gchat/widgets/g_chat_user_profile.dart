import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/models/g_chat_user_model.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/screens/gchat/widgets/gchat_user_details.dart';
import 'package:eco_collect/screens/gchat/widgets/ghcat_user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GChatUserProfile extends StatelessWidget {
  const GChatUserProfile({super.key, required this.gChatUserData});
  final GChatUserModel gChatUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: reusableAppBar(title: gChatUserData.senderName),
      body: Stack(
        children: [
          const ReusableBgImage(
            assetImageSource: KLottie.campfireGuyWithGuitar,
            repeatLottie: false,
            isLottie: true,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0).copyWith(bottom: 70.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Hero(
                      tag: 'heroProfile',
                      child: GChatUserAvatar(
                        userData: gChatUserData,
                        levelProvider:
                            Provider.of<LevelProvider>(context, listen: false),
                      )),
                  GChatUserDetails(
                    userDetails: gChatUserData,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
