import 'dart:async';

import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:eco_collect/constants/game_constants.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/models/game_models/custom_hitbox_model.dart';
import 'package:eco_collect/models/game_models/spirite_model.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:provider/provider.dart';

class Collectible extends SpriteAnimationComponent
    with HasGameRef<LightSaverGame>, CollisionCallbacks {
  final KenumGameCollectibles collectible;
  Collectible({
    this.collectible = KenumGameCollectibles.cherries,
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;
  late final SpriteModel collectibleData;

  final hitbox = CustomHitboxModel(
    offsetX: 10,
    offsetY: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    collectibleData = GameCollectibles().getCollectibleData(collectible);

    // debugMode = true;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );
    animation = SpriteAnimation.fromFrameData(
      // game.images.fromCache('Items/Fruits/$fruit.png'),
      game.images.fromCache(collectibleData.path),
      SpriteAnimationData.sequenced(
        amount: collectibleData.numberOfFrames,
        stepTime: collectibleData.stepTime!,
        textureSize: collectibleData.textureSize,
      ),
    );
    return super.onLoad();
  }

  void collidedWithPlayer({bool? isBulletCollect}) async {
    final collectedData =
        GameCollectibles().getCollectibleData(KenumGameCollectibles.collected);
    final gameStateProvider = Provider.of<GameStateProvider>(
        navigatorKey.currentContext!,
        listen: false);
    if (!collected) {
      if (isBulletCollect == true) {
        gameStateProvider.addBulletsCollected = 1;
      }
      collected = true;
      if (game.playSounds) {
        FlameAudio.play(collectedData.soundPath!, volume: game.soundVolume);
      }
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(collectedData.path),
        SpriteAnimationData.sequenced(
          amount: collectedData.numberOfFrames,
          stepTime: collectedData.stepTime!,
          textureSize: collectedData.textureSize,
          loop: collectedData.loop!,
        ),
      );

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
