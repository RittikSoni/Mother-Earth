import 'package:easy_localization/easy_localization.dart';
import 'package:eco_collect/components/reusable_app_bar.dart';
import 'package:eco_collect/components/reusable_bg_image.dart';
import 'package:eco_collect/components/reusable_top_character_dialogue.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/screens/badges/widgets/badge_full_page_preview.dart';
import 'package:eco_collect/services/audio_services.dart';
import 'package:eco_collect/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Badges extends StatelessWidget {
  const Badges({super.key});

  @override
  Widget build(BuildContext context) {
    AudioServices.playAudioAccordingToScreen(KenumScreens.tier);
    return Scaffold(
      appBar: reusableAppBar(title: 'Hero Badges'),
      body: SafeArea(
        child: Consumer<LevelProvider>(
          builder: (context, levelProvider, child) {
            final playerCurrentTier = levelProvider
                .getPlayerCurrentHeroLevelData(
                    currentTrophies:
                        Provider.of<UserDataProvider>(context, listen: false)
                            .getUserData
                            ?.trophies)
                .tier;
            final formattedPlayerCurrentTier =
                Commonfunctions.formattedTierName(playerCurrentTier);
            return Stack(
              children: [
                const ReusableBgImage(assetImageSource: KImages.forest),
                Column(
                  children: [
                    ReusableTopCharacterDialogue(
                      message: tr('badges_screen.congratulations_message',
                          namedArgs: {
                            'formattedPlayerCurrentTier':
                                formattedPlayerCurrentTier.toString()
                          }),
                    ),
                    Commonfunctions.gapMultiplier(gapMultiplier: 0.5),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: minTrophiesToLevelTierData.length,
                        itemBuilder: (context, index) {
                          final xpValue =
                              minTrophiesToLevelTierData.keys.toList()[index];
                          final levelTierModel =
                              minTrophiesToLevelTierData[xpValue];

                          return levelTierModel != null
                              ? TierCard(
                                  tierName: Commonfunctions.formattedTierName(
                                      levelTierModel.tier),
                                  requiredTrophies: xpValue,
                                  tierData: levelTierModel,
                                  tierImage: levelTierModel.image,
                                  isCurrentTier:
                                      playerCurrentTier == levelTierModel.tier,
                                )
                              : Text(minTrophiesToLevelTierData.entries.last.key
                                  .toString());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TierCard extends StatelessWidget {
  final String tierName;
  final int requiredTrophies;
  final String tierImage;
  final bool isCurrentTier;
  final LevelTierModel tierData;

  const TierCard({
    super.key,
    required this.tierName,
    required this.requiredTrophies,
    required this.tierImage,
    required this.isCurrentTier,
    required this.tierData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: KTheme.transparencyBlack,
        border: Border.all(
          color: isCurrentTier == true
              ? KTheme.currentTierBg
              : KTheme.transparencyBlack,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
        onTap: () => KRoute.pushFadeAnimation(
          context: context,
          page: BadgeFullPagePreview(
            tierData: tierData,
            requiredTrophies: requiredTrophies.toString(),
          ),
        ),
        tileColor: isCurrentTier == true
            ? KTheme.currentTierBg
            : const Color.fromARGB(142, 2, 174, 91),
        leading: Hero(
          tag: tierData.tier.name,
          child: Image.asset(
            tierImage,
            width: 50,
            height: 60,
            fit: BoxFit.fill,
          ),
        ),
        title: Text(
          tierName,
          style: KTheme.titleStyle.copyWith(color: Colors.white),
        ),
        subtitle: Text('Required Trophies: $requiredTrophies'),
      ),
    );
  }
}
