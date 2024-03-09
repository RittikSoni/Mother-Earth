import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';

class Hell extends SpriteAnimationComponent with HasGameRef<LightSaverGame> {
  final bool isVertical;
  final double offNeg;
  final double offPos;
  Hell({
    this.isVertical = false,
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
    add(RectangleHitbox());

    if (isVertical) {
      rangeNeg = position.y - offNeg * tileSize;
      rangePos = position.y + offPos * tileSize;
    } else {
      rangeNeg = position.x - offNeg * tileSize;
      rangePos = position.x + offPos * tileSize;
    }

    // animation = SpriteAnimation.fromFrameData(
    //     game.images.fromCache('Traps/Saw/On (38x38).png'),
    //     SpriteAnimationData.sequenced(
    //       amount: 8,
    //       stepTime: sawSpeed,
    //       textureSize: Vector2.all(38),
    //     ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isVertical) {
      // _moveVertically(dt);
    } else {
      // _moveHorizontally(dt);
    }
    super.update(dt);
  }
}
