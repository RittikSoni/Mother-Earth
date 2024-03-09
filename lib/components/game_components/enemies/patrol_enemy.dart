import 'dart:async';

import 'package:eco_collect/components/game_components/projectiles/bullet.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:eco_collect/components/game_components/player/player.dart';

enum State { idle, run, hit }

class PatrolEnemy extends SpriteAnimationGroupComponent
    with HasGameRef<LightSaverGame>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  final bool? isBird;
  PatrolEnemy({
    super.position,
    super.size,
    this.isBird,
    this.offNeg = 0,
    this.offPos = 0,
  });

  static const stepTime = 0.05;
  static const tileSize = 16;
  static const runSpeed = 50;
  static const _bounceHeight = 260.0;
  final textureSize = Vector2(36, 30);

  Vector2 velocity = Vector2.zero();
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomped = false;

  late final LightSaverPlayer player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    player = game.player;

    add(
      RectangleHitbox(
        position: Vector2(4, 6),
        size: Vector2(24, 26),
      ),
    );
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }

    super.update(dt);
  }

  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation(
        isBird == true ? 'Flying' : 'Idle', isBird == true ? 9 : 9);
    _runAnimation = _spriteAnimation(
        isBird == true ? 'Flying' : 'Run', isBird == true ? 9 : 15);
    _hitAnimation = _spriteAnimation('Hit', isBird == true ? 15 : 5)
      ..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(isBird == true
          ? 'game_images/Enemies/BlueBird/$state (32x32).png'
          : 'game_images/Enemies/AngryPig/$state (36x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: isBird == true ? Vector2(32, 34) : textureSize,
      ),
    );
  }

  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  void _movement(dt) {
    if (position.x >= rangePos) {
      flipHorizontallyAroundCenter();
      moveDirection = -1;
    } else if (position.x <= rangeNeg) {
      flipHorizontallyAroundCenter();
      moveDirection = 1;
    }

    position.x += moveDirection * runSpeed * dt;
  }

  bool playerInRange() {
    double playerOffset = (player.scale.x > 0) ? 0 : -player.width;

    return player.x + playerOffset >= rangeNeg &&
        player.x + playerOffset <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play('bounce.wav', volume: game.soundVolume);
      }
      gotStomped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;
      await animationTicker?.completed;
      removeFromParent();
    } else {
      player.collidedwithEnemy();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Bullet) removeFromParent();

    super.onCollisionStart(intersectionPoints, other);
  }
}
