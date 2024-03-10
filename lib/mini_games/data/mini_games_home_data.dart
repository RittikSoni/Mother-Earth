import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MiniGamesHomeDataModel {
  final String title;
  final String descriptionKey;
  final String buttonLabelKey;
  final String imagePath;
  final VoidCallback onTap;

  MiniGamesHomeDataModel({
    required this.title,
    required this.descriptionKey,
    required this.buttonLabelKey,
    required this.imagePath,
    required this.onTap,
  });
}
