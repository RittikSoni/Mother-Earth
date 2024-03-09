import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/providers/audio_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.settings);
    return Scaffold(
      appBar: reusableAppBar(title: 'Settings'),
      body: Consumer2<AudioProvider, UserDataProvider>(
        builder: (context, settingsProvider, userData, child) => Stack(
          children: [
            const ReusableBgImage(assetImageSource: KImages.sea2),
            LottieBuilder.asset(KLottie.birds),
            LottieBuilder.asset(KLottie.parrots),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _volumeCard(settingsProvider),
                      Commonfunctions.gapMultiplier(),
                      Material(
                        color: KTheme.transparencyBlack,
                        borderRadius: BorderRadius.circular(10.0),
                        child: DropdownButton(
                          isExpanded: true,
                          icon: const Icon(Icons.translate),
                          iconSize: 20.0,
                          borderRadius: BorderRadius.circular(10.0),
                          padding: const EdgeInsets.all(10.0),
                          dropdownColor: KTheme.transparencyBlack,
                          value: userData.currentUserTempCountry == 'japan'
                              ? '日本語'
                              : 'English',
                          hint: const Text("Change language"),
                          items: const [
                            DropdownMenuItem(
                              value: "日本語",
                              child: Text("日本語"),
                            ),
                            DropdownMenuItem(
                              value: "English",
                              child: Text("English"),
                            ),
                          ],
                          onChanged: (value) {
                            final userData = Provider.of<UserDataProvider>(
                                navigatorKey.currentContext!,
                                listen: false);
                            switch (value) {
                              case "日本語":
                                userData.setCurrentUserTempCountry =
                                    KenumPlayerTempCountry.japan;

                                break;
                              default:
                                userData.setCurrentUserTempCountry =
                                    KenumPlayerTempCountry.other;
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const Text(
                    KStrings.disclaimer,
                    style: TextStyle(fontSize: 8.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _volumeCard(AudioProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: KTheme.transparencyBlack,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          const Text(
            "Music Volume",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
          ),
          Slider(
            value: settingsProvider.getBgMusicVolume,
            onChanged: (value) {
              // Change volume of overall game bg music
              settingsProvider.setBgMusicVolume(value);
            },
            max: 1.0,
            min: 0.0,
            divisions: 10,
            label: (settingsProvider.getBgMusicVolume * 100).toString(),
            thumbColor: KTheme.globalAppBarBG,
            activeColor: KTheme.activeBg,
            inactiveColor: KTheme.inactiveBg,
            overlayColor: const MaterialStatePropertyAll(KTheme.globalAppBarBG),
          ),
        ],
      ),
    );
  }
}
