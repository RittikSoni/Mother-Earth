import 'package:eco_collect/constants/ktheme.dart';
import 'package:eco_collect/models/g_chat_user_model.dart';
import 'package:eco_collect/providers/level_provider.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class GChatUserAvatar extends StatelessWidget {
  const GChatUserAvatar({
    super.key,
    required this.userData,
    required this.levelProvider,
    this.avatarRadius = 90.0,
    this.isBadgeVisible = true,
    this.badgeLabel,
  });
  final GChatUserModel userData;
  final LevelProvider levelProvider;
  final double? avatarRadius;
  final String? badgeLabel;
  final bool? isBadgeVisible;

  @override
  Widget build(BuildContext context) {
    final levelData = levelProvider.getXpLevelDetails(currentXP: userData.xp);
    return CircularPercentIndicator(
      radius: avatarRadius!,
      lineWidth: 3.0,
      animation: true,
      rotateLinearGradient: true,
      percent: levelData.percentToNextLevel,
      animateFromLastPercent: true,
      linearGradient: const LinearGradient(colors: [
        KTheme.fg,
        Colors.amber,
        Colors.green,
        Colors.blue,
      ]),
      circularStrokeCap: CircularStrokeCap.round,
      center: Badge(
        alignment: Alignment.bottomRight,
        offset: const Offset(-10, -10),
        backgroundColor: KTheme.transparencyBlack,
        textColor: Colors.white,
        isLabelVisible: isBadgeVisible!,
        label: Text(badgeLabel ??
            '${userData.xp} / ${levelData.xpRequiredForNextLevel} XP'),
        // 'XP ${(NumberFormat.compact()..maximumFractionDigits = 2).format(1000)}'),
        child: CircleAvatar(
          radius: (avatarRadius! - ((avatarRadius! / 100) * 10)),
          backgroundColor: KTheme.transparencyBlack,
          child: Text(
            levelData.currentLevel.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (avatarRadius! - ((avatarRadius! / 100) * 35)),
            ),
          ),
        ),
      ),
    );
  }
}
