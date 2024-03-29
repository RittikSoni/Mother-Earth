import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BadgeFullPagePreview extends StatelessWidget {
  final LevelTierModel tierData;
  final String requiredTrophies;
  const BadgeFullPagePreview(
      {super.key, required this.tierData, required this.requiredTrophies});

  @override
  Widget build(BuildContext context) {
    final formattedTierName = Commonfunctions.formattedTierName(tierData.tier);
    final currentTrophies =
        Provider.of<UserDataProvider>(context, listen: false)
            .getUserData
            ?.trophies;

    int trophyDifference = int.parse(requiredTrophies) - (currentTrophies ?? 0);

    return Scaffold(
      appBar: reusableAppBar(title: formattedTierName, actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(tierData.image),
        ),
      ]),
      body: Stack(
        children: [
          const ReusableBgImage(
            assetImageSource: KImages.forestHut,
          ),
          Positioned(
              bottom: 15.0,
              left: 5.0,
              right: 5.0,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: KTheme.transparencyBlack,
                      borderRadius: BorderRadius.circular(1000.0),
                    ),
                    child: Text(
                      trophyDifference <= 0
                          ? tr('badges_screen.message_unlocked')
                          : tr('badges_screen.message_progress', namedArgs: {
                              'trophyDifference': trophyDifference.toString()
                            }),
                      style: KTheme.subtitleStyle
                          .copyWith(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                  LottieBuilder.asset(
                    KLottie.hero,
                    width: 400.0,
                    height: 200.0,
                    fit: BoxFit.fill,
                  ),
                ],
              )),
          Positioned(
            top: 15.0,
            left: 15.0,
            right: 15.0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: KTheme.transparencyBlack,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Hero(
                        tag: tierData.tier.name,
                        child: Image.asset(tierData.image)),
                    Text(
                      formattedTierName,
                      style: KTheme.titleStyle.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Current Trophies: $currentTrophies',
                      style: KTheme.subtitleStyle
                          .copyWith(color: Colors.white, fontSize: 15.0),
                    ),
                    Text(
                      'Required Trophies: $requiredTrophies',
                      style: KTheme.subtitleStyle
                          .copyWith(color: Colors.white, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
