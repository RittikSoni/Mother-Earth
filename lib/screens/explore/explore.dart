import 'package:eco_collect/api/firebase_apis.dart';
import 'package:eco_collect/components/buttons/reusable_button.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';

import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/settings/settings.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.explore);

    return SafeArea(
      child: Stack(
        children: [
          const ReusableBgImage(assetImageSource: KImages.mountains),
          Column(
            children: [
              ReusableButton(
                label: 'Settings',
                icon: Icons.settings,
                onTap: () =>
                    KRoute.push(context: context, page: const Settings()),
              ),
              ReusableButton(
                  label: 'Donate',
                  onTap: () async {
                    KLoadingToast.showCharacterDialog(
                        title: "Make a Difference",
                        message:
                            "Your generosity can change lives! Your donation will support our efforts to protect the environment and create a sustainable future for all. Thank you for being a part of this important mission.",
                        explorerImage: KExplorers.explorer8,
                        primaryLabel: "Donate Now",
                        secondaryLabel: "Cancel",
                        onSecondaryPressed: () {
                          Navigator.pop(context);
                        },
                        onPrimaryPressed: () async {
                          Navigator.pop(context);
                          try {
                            KLoadingToast.startLoading();
                            await launchUrl(
                              Uri.parse(KStrings.donationLink),
                            );
                          } catch (e) {
                            KLoadingToast.showNotification(
                                msg:
                                    'Something went wrong, please try again later.',
                                toastType: KenumToastType.error);
                          } finally {
                            KLoadingToast.stopLoading();
                          }
                        });
                  }),
              ReusableButton(
                label: 'Logout',
                onTap: () async {
                  KLoadingToast.showCharacterDialog(
                    title: 'Logout?',
                    message: KStrings.logoutMessage,
                    explorerImage: KExplorers.explorer7,
                    secondaryLabel: 'Cancel',
                    onSecondaryPressed: () async {
                      Navigator.pop(context);
                    },
                    primaryLabel: 'Logout',
                    onPrimaryPressed: () async {
                      await FirebaseApis.logout();
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
