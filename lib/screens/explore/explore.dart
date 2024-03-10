import 'package:easy_localization/easy_localization.dart';
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
import 'package:flutter/foundation.dart';
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
                label: 'buttons.settings'.tr(),
                icon: Icons.settings,
                onTap: () =>
                    KRoute.push(context: context, page: const Settings()),
              ),
              ReusableButton(
                  label: 'buttons.donate'.tr(),
                  onTap: () async {
                    KLoadingToast.showCharacterDialog(
                        title: "donate_screen.make_a_difference".tr(),
                        message: 'donate_screen.message'.tr(),
                        explorerImage: KExplorers.explorer8,
                        primaryLabel: "donate_screen.donate_now".tr(),
                        secondaryLabel: "buttons.cancel".tr(),
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
              kIsWeb
                  ? ReusableButton(
                      label: 'Get it on Android',
                      onTap: () async {
                        await launchUrl(
                          Uri.parse(KStrings.gameAndroidLink),
                        );
                      },
                      icon: Icons.android,
                      fg: Colors.green,
                    )
                  : const SizedBox(),
              ReusableButton(
                label: 'buttons.logout'.tr(),
                onTap: () async {
                  KLoadingToast.showCharacterDialog(
                    title: 'buttons.logout'.tr(),
                    message: 'logout_confirmation'.tr(),
                    explorerImage: KExplorers.explorer7,
                    secondaryLabel: 'buttons.cancel'.tr(),
                    onSecondaryPressed: () async {
                      Navigator.pop(context);
                    },
                    primaryLabel: 'buttons.logout'.tr(),
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
