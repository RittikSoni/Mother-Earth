import 'dart:async';

import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/crush_the_plastic_game.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/widgets/player.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Checkpoint extends SpriteAnimationComponent
    with HasGameRef<PlasticCrusher>, CollisionCallbacks {
  Checkpoint({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    add(RectangleHitbox(
      position: Vector2(18, 56),
      size: Vector2(12, 8),
      collisionType: CollisionType.passive,
    ));

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'game_images/Items/Checkpoints/Checkpoint/Checkpoint (No Flag).png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(64),
      ),
    );
    return super.onLoad();
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Player) _reachedCheckpoint();
    super.onCollisionStart(intersectionPoints, other);
  }

  void _reachedCheckpoint() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'game_images/Items/Checkpoints/Checkpoint/Checkpoint (Flag Out) (64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 26,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );

    await animationTicker?.completed;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'game_images/Items/Checkpoints/Checkpoint/Checkpoint (Flag Idle)(64x64).png'),
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.05,
        textureSize: Vector2.all(64),
      ),
    );
    KLoadingToast.showCharacterDialog(
      title: 'Congratulations!',
      message:
          "You've successfully completed the level. Your dedication to cleaning up the environment is making a real difference. Keep up the fantastic work as you progress through the game and continue your journey to save the planet!",
      explorerImage: KExplorers.explorer8,
      explorerImageHeight: 100,
      primaryLabel: "Next Challenge!",
      onPrimaryPressed: () {
        Navigator.pop(navigatorKey.currentContext!);
      },
      secondaryLabel: "Home",
      onSecondaryPressed: () {
        Navigator.pop(navigatorKey.currentContext!);
        Navigator.pop(navigatorKey.currentContext!);
      },
    );
  }
}
