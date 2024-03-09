import 'package:flame/game.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/models/game_models/spirite_model.dart';

class GameCollectibles {
  SpriteModel getCollectibleData(KenumGameCollectibles collectible) {
    switch (collectible) {
      case KenumGameCollectibles.light:
        return _light;
      case KenumGameCollectibles.lightCollected:
        return _lightCollected;
      case KenumGameCollectibles.collected:
        return _collected;
      case KenumGameCollectibles.plasticBottle:
        return _plasticBottle;
      case KenumGameCollectibles.banana:
        return _bananas;
      case KenumGameCollectibles.cherries:
        return _cherries;
      case KenumGameCollectibles.apple:
        return _apple;

      default:
        return _plasticBottle;
    }
  }

  static final SpriteModel _plasticBottle = SpriteModel(
    path: "game_images/Items/Plastic/plastic_bottle.png",
    numberOfFrames: 1,
    textureSize: Vector2.all(32),
  );
  static final SpriteModel _apple = SpriteModel(
    path: "game_images/Items/Fruits/Apple.png",
    numberOfFrames: 17,
    textureSize: Vector2.all(32),
  );
  static final SpriteModel _bananas = SpriteModel(
    path: "game_images/Items/Fruits/Bananas.png",
    numberOfFrames: 17,
    textureSize: Vector2.all(32),
  );
  static final SpriteModel _cherries = SpriteModel(
    path: "game_images/Items/Fruits/Cherries.png",
    numberOfFrames: 17,
    textureSize: Vector2.all(32),
  );
  static final SpriteModel _collected = SpriteModel(
    path: "game_images/Items/Fruits/Collected.png",
    numberOfFrames: 6,
    textureSize: Vector2.all(32),
    loop: false,
  );
  static final SpriteModel _light = SpriteModel(
    path: "game_images/Items/Lights/latern_pole_16x64.png",
    numberOfFrames: 1,
    textureSize: Vector2(16, 64),
    loop: false,
  );
  static final SpriteModel _lightCollected = SpriteModel(
    path: "game_images/Items/Lights/off_latern_pole_16x64.png",
    numberOfFrames: 1,
    textureSize: Vector2(16, 64),
    loop: false,
  );
}
