import 'package:eco_collect/routes/kroutes.dart';
import 'package:flutter/material.dart';

class KDimens {
  static const int baseXPPerLevel = 50;
  static const int extraXPPerLevel = 5;

  static const int sendNewMessageTimerInSeconds = 30;
  static const double defaultMusicVolume = 0.5;
  static const double dialogImageHeight = 120.0;
  static final double screenHeight =
      MediaQuery.of(navigatorKey.currentContext!).size.height;
  static final double screenWidth =
      MediaQuery.of(navigatorKey.currentContext!).size.width;
}
