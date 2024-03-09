import 'package:flame/game.dart';

class SpriteModel {
  String path;
  int numberOfFrames;
  Vector2 textureSize;
  double? stepTime;
  bool? loop;
  String? soundPath;

  SpriteModel({
    required this.path,
    required this.numberOfFrames,
    this.stepTime = 0.05,
    this.loop = true,
    this.soundPath = "collect_fruit.wav",
    required this.textureSize,
  });
}
