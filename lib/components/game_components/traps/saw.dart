import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';

class Saw extends SpriteAnimationComponent with HasGameRef<LightSaverGame> {
  final bool isVertical;
  final bool isSpikeEnemy;
  final double offNeg;
  final double offPos;
  Saw({
    this.isVertical = false,
    this.isSpikeEnemy = false,
    this.offNeg = 0,
    this.offPos = 0,
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  static const double sawSpeed = 0.03;

  static const moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    add(CircleHitbox());

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    animation = isSpikeEnemy == true
        ? SpriteAnimation.fromFrameData(
            game.images
                .fromCache('game_images/Traps/Spike Head/Blink (54x52).png'),
            SpriteAnimationData.sequenced(
              amount: 4,
              stepTime: 0.5,
              textureSize: Vector2.all(54),
            ))
        : SpriteAnimation.fromFrameData(
            game.images.fromCache('game_images/Traps/Saw/On (38x38).png'),
            SpriteAnimationData.sequenced(
              amount: 8,
              stepTime: sawSpeed,
              textureSize: Vector2.all(38),
            ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      _moveVertically(dt);
    } else {
      _moveHorizontally(dt);
    }
    super.update(dt);
  }

  void _moveVertically(double dt) {
    if (position.y >= rangePos) {
      moveDirection = -1;
    } else if (position.y <= rangeNeg) {
      moveDirection = 1;
    }
    position.y += moveDirection * moveSpeed * dt;
  }

  void _moveHorizontally(double dt) {
    if (position.x >= rangePos) {
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      moveDirection = 1;
    }
    position.x += moveDirection * moveSpeed * dt;
  }
}
