import 'dart:async';

import 'package:eco_collect/components/game_components/enemies/follower_enemy.dart';
import 'package:eco_collect/components/game_components/enemies/patrol_enemy.dart';
import 'package:eco_collect/components/game_components/hell/hell.dart';
import 'package:eco_collect/components/game_components/traps/saw.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Bullet extends SpriteAnimationComponent
    with HasGameRef<LightSaverGame>, CollisionCallbacks {
  final bool? isLeft;
  Bullet({
    this.isLeft,
    super.position,
    super.size,
  });
  final double _speed = 290;
  final Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));
    animation = _createSpriteAnimation();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    velocity.x = 1 * _speed;
    if (isLeft == true) {
      position.x -= velocity.x * dt;
    } else {
      position.x += velocity.x * dt;
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PatrolEnemy) removeFromParent();
    if (other is Hell) removeFromParent();
    if (other is FollowerEnemy) removeFromParent();
    if (other is Saw) removeFromParent();

    super.onCollisionStart(intersectionPoints, other);
  }

  SpriteAnimation _createSpriteAnimation() {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache("game_images/Items/Fruits/Cherries.png"),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: 0.11,
        textureSize: Vector2.all(32),
      ),
    );
  }
}
