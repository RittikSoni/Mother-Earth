import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/constants/kdimens.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:flutter/material.dart';

class LevelProvider extends ChangeNotifier {
  int _currentHeroXP = 0;
  LevelTierModel _currentLevelData = LevelTierModel(
    level: 0,
    tier: KenumTiers.wood,
    image: KTiers.woodTier,
  );

  XPProgressModel getXpLevelDetails({required int currentXP}) {
    return XPProgressModel.calculate(currentXP: currentXP);
  }

  int get getPlayerCurrentHeroXP {
    return _currentHeroXP;
  }

  LevelTierModel getPlayerCurrentHeroLevelData({required currentTrophies}) {
    // MATCHING NEW XP IN TIERS COLLECTION
    MapEntry<int, LevelTierModel> levelData =
        minTrophiesToLevelTierData.entries.lastWhere(
      (element) => currentTrophies >= element.key,
      orElse: () => minTrophiesToLevelTierData.entries.first,
    );
    _currentLevelData = levelData.value;
    return _currentLevelData;
  }

  set setPlayerCurrentTrophiesTierLevel(int newXP) {
    // MATCHING NEW XP IN TIERS COLLECTION
    MapEntry<int, LevelTierModel> levelData =
        minTrophiesToLevelTierData.entries.lastWhere(
      (element) => newXP >= element.key,
      orElse: () => minTrophiesToLevelTierData.entries.first,
    );

    _currentHeroXP = newXP;
    _currentLevelData = levelData.value;
    notifyListeners();
  }

  void reset() {
    _currentLevelData =
        LevelTierModel(level: 0, tier: KenumTiers.wood, image: KTiers.woodTier);
    _currentHeroXP = 0;
    notifyListeners();
  }
}

Map<int, LevelTierModel> minTrophiesToLevelTierData = {
// WOOD TIER
  0: LevelTierModel(level: 0, tier: KenumTiers.wood, image: KTiers.woodTier),
// BRONZE TIER
  100:
      LevelTierModel(level: 1, tier: KenumTiers.bronze1, image: KTiers.bronze1),
  150:
      LevelTierModel(level: 2, tier: KenumTiers.bronze2, image: KTiers.bronze2),
  200:
      LevelTierModel(level: 3, tier: KenumTiers.bronze3, image: KTiers.bronze3),
  250:
      LevelTierModel(level: 4, tier: KenumTiers.bronze4, image: KTiers.bronze4),
  300:
      LevelTierModel(level: 5, tier: KenumTiers.bronze5, image: KTiers.bronze5),
// SILVER TIER
  350:
      LevelTierModel(level: 6, tier: KenumTiers.silver1, image: KTiers.silver1),
  400:
      LevelTierModel(level: 7, tier: KenumTiers.silver2, image: KTiers.silver2),
  450:
      LevelTierModel(level: 8, tier: KenumTiers.silver3, image: KTiers.silver3),
  500:
      LevelTierModel(level: 9, tier: KenumTiers.silver4, image: KTiers.silver4),
  550: LevelTierModel(
      level: 10, tier: KenumTiers.silver5, image: KTiers.silver5),
// GOLD TIER
  600: LevelTierModel(level: 11, tier: KenumTiers.gold1, image: KTiers.gold1),
  650: LevelTierModel(level: 12, tier: KenumTiers.gold2, image: KTiers.gold2),
  700: LevelTierModel(level: 13, tier: KenumTiers.gold3, image: KTiers.gold3),
  750: LevelTierModel(level: 14, tier: KenumTiers.gold4, image: KTiers.gold4),
  800: LevelTierModel(level: 15, tier: KenumTiers.gold5, image: KTiers.gold5),
// PLATINUM TIER
  850: LevelTierModel(
      level: 16, tier: KenumTiers.platinum1, image: KTiers.platinum1),
  900: LevelTierModel(
      level: 17, tier: KenumTiers.platinum2, image: KTiers.platinum2),
  950: LevelTierModel(
      level: 18, tier: KenumTiers.platinum3, image: KTiers.platinum3),
  1100: LevelTierModel(
      level: 19, tier: KenumTiers.platinum4, image: KTiers.platinum4),
  1200: LevelTierModel(
      level: 20, tier: KenumTiers.platinum5, image: KTiers.platinum5),
// DIAMOND TIER
  1300: LevelTierModel(
      level: 21, tier: KenumTiers.diamond1, image: KTiers.diamond1),
  1400: LevelTierModel(
      level: 22, tier: KenumTiers.diamond2, image: KTiers.diamond2),
  1500: LevelTierModel(
      level: 23, tier: KenumTiers.diamond3, image: KTiers.diamond3),
  1600: LevelTierModel(
      level: 24, tier: KenumTiers.diamond4, image: KTiers.diamond4),
  1700: LevelTierModel(
      level: 25, tier: KenumTiers.diamond5, image: KTiers.diamond5),
// HERO TIER
  2000: LevelTierModel(level: 26, tier: KenumTiers.hero, image: KTiers.hero),
// ULTIMATE HERO TIER
  4000: LevelTierModel(
      level: 27, tier: KenumTiers.ultimateHero, image: KTiers.ultimateHero),
};

class LevelTierModel {
  int level;
  KenumTiers tier;
  String image;

  LevelTierModel(
      {required this.level, required this.tier, required this.image});
}

class XPProgressModel {
  final int currentXP;
  final int previousLevelXP;
  final int currentLevel;
  final int xpRequiredForNextLevel;
  final int xpDifference;
  final double percentToNextLevel;
  final double percentToCurrentLevel;

  XPProgressModel({
    required this.currentLevel,
    required this.currentXP,
    required this.xpDifference,
    required this.previousLevelXP,
    required this.xpRequiredForNextLevel,
    required this.percentToNextLevel,
    required this.percentToCurrentLevel,
  });

  factory XPProgressModel.calculate({required int currentXP}) {
    int currentLevel = 0;
    int totalXPRequired = 0;
    int previousLevelXP = 0;
    int xpRequiredForNextLevel = 0;
    double percentToNextLevel = 0.0;

    while (currentXP >= totalXPRequired) {
      currentLevel++;
      previousLevelXP = totalXPRequired;
      totalXPRequired += (KDimens.baseXPPerLevel * currentLevel) +
          (KDimens.extraXPPerLevel * currentLevel);
      if (currentXP < totalXPRequired) {
        xpRequiredForNextLevel = totalXPRequired;
        percentToNextLevel = currentXP / totalXPRequired.toDouble();
        break;
      }
    }

    return XPProgressModel(
      currentXP: currentXP,
      xpDifference: xpRequiredForNextLevel - currentXP,
      currentLevel: currentLevel,
      percentToCurrentLevel: 1 - percentToNextLevel,
      previousLevelXP: previousLevelXP,
      xpRequiredForNextLevel: xpRequiredForNextLevel,
      percentToNextLevel: percentToNextLevel,
    );
  }
}
