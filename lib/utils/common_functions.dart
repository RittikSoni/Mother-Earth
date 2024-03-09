import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/constants/kstrings.dart';
import 'package:eco_collect/models/language_model.dart';
import 'package:eco_collect/providers/user_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Commonfunctions {
  static bool isDay() {
    return DateTime.now().isBefore(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 00));
  }

  /// Default `gapMultiplier = 1.0`,
  /// Default `gap = 20.0`,
  /// Default is vertical Gapping
  static Widget gapMultiplier({bool? isHorizontal, double? gapMultiplier}) {
    if (isHorizontal == true) {
      return SizedBox(
        width: 20.0 * (gapMultiplier ?? 1.0),
      );
    }
    return SizedBox(
      height: 20.0 * (gapMultiplier ?? 1.0),
    );
  }

  static String formattedTierName(KenumTiers tier) {
    switch (tier) {
      case KenumTiers.wood:
        return 'Wood';
      case KenumTiers.bronze1:
        return 'Bronze I';
      case KenumTiers.bronze2:
        return 'Bronze II';
      case KenumTiers.bronze3:
        return 'Bronze III';
      case KenumTiers.bronze4:
        return 'Bronze IV';
      case KenumTiers.bronze5:
        return 'Bronze V';
      case KenumTiers.silver1:
        return 'Silver I';
      case KenumTiers.silver2:
        return 'Silver II';
      case KenumTiers.silver3:
        return 'Silver III';
      case KenumTiers.silver4:
        return 'Silver IV';
      case KenumTiers.silver5:
        return 'Silver V';
      case KenumTiers.gold1:
        return 'Gold I';
      case KenumTiers.gold2:
        return 'Gold II';
      case KenumTiers.gold3:
        return 'Gold III';
      case KenumTiers.gold4:
        return 'Gold IV';
      case KenumTiers.gold5:
        return 'Gold V';
      case KenumTiers.platinum1:
        return 'Platinum I';
      case KenumTiers.platinum2:
        return 'Platinum II';
      case KenumTiers.platinum3:
        return 'Platinum III';
      case KenumTiers.platinum4:
        return 'Platinum IV';
      case KenumTiers.platinum5:
        return 'Platinum V';
      case KenumTiers.diamond1:
        return 'Diamond I';
      case KenumTiers.diamond2:
        return 'Diamond II';
      case KenumTiers.diamond3:
        return 'Diamond III';
      case KenumTiers.diamond4:
        return 'Diamond IV';
      case KenumTiers.diamond5:
        return 'Diamond V';
      case KenumTiers.hero:
        return 'Hero';
      case KenumTiers.ultimateHero:
        return 'Unstopabble Ultimate Hero';

      default:
        return "Loading";
    }
  }

  static String getThumbnail({
    required String videoId,
    String quality = ThumbnailQuality.standard,
    bool webp = true,
  }) =>
      webp
          ? 'https://i3.ytimg.com/vi_webp/$videoId/$quality.webp'
          : 'https://i3.ytimg.com/vi/$videoId/$quality.jpg';

  static String? convertUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static String trimString({required String text, int? maxLength}) {
    if (text.length > (maxLength ?? 70)) {
      return '${text.substring(0, 65)}...';
    }
    return text;
  }

  static String generateJwt({
    required Map<String, dynamic> payload,
  }) {
    final jwt = JWT(payload);
    final String token = jwt.sign(
      SecretKey(KStrings.secretKey),
    );
    return token;
  }

  static LanguageModel getLanguageCodes() {
    final userData = Provider.of<UserDataProvider>(navigatorKey.currentContext!,
        listen: true);
    final String country = userData.currentUserTempCountry ??
        userData.getUserData?.country ??
        "Loading";
    switch (country.toLowerCase()) {
      case "japan":
        return LanguageModel(countryCode: 'JP', languageCode: 'jp');
      default:
        return LanguageModel(countryCode: 'US', languageCode: 'en');
    }
  }
}
