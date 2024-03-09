import 'dart:async';

import 'package:eco_collect/components/game_components/projectiles/bullet.dart';
import 'package:eco_collect/constants/kassets.dart';
import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:eco_collect/utils/kloading.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:eco_collect/components/game_components/collectibles/collectibles_light.dart';
import 'package:eco_collect/components/game_components/win/checkpoint.dart';
import 'package:eco_collect/components/game_components/collectibles/collectibles.dart';
import 'package:eco_collect/components/game_components/game_miscs/collision_block.dart';
import 'package:eco_collect/models/game_models/custom_hitbox_model.dart';
import 'package:eco_collect/components/game_components/enemies/follower_enemy.dart';

import 'package:eco_collect/components/game_components/hell/hell.dart';
import 'package:eco_collect/components/game_components/enemies/patrol_enemy.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:eco_collect/components/game_components/traps/saw.dart';
import 'package:eco_collect/components/game_components/game_miscs/utils.dart';
import 'package:provider/provider.dart';

enum PlayerState {
  idle,
  running,
  runningBack,
  jumping,
  falling,
  hit,
  appearing,
  disappearing
}

class LightSaverPlayer extends SpriteAnimationGroupComponent
    with HasGameRef<LightSaverGame>, KeyboardHandler, CollisionCallbacks {
  String character;
  LightSaverPlayer({
    position,
    this.character = 'Virtual Guy',
  }) : super(position: position);

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation backrunningAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isShooting = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];
  CustomHitboxModel hitbox = CustomHitboxModel(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    // debugMode = true;

    startingPosition = Vector2(position.x, position.y);

    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions();
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    isShooting = keysPressed.contains(LogicalKeyboardKey.keyX);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Collectible) other.collidedWithPlayer(isBulletCollect: true);
      if (other is CollectibleLight) {
        other.collidedWithPlayer(isLightCollect: true);
      }

      if (other is PatrolEnemy) other.collidedWithPlayer();
      if (other is Saw) _respawn();
      if (other is Hell) _respawn();
      if (other is FollowerEnemy) other.collidedWithPlayer();
      if (other is Checkpoint) _reachedCheckpoint(isAllLightsRequired: true);
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    backrunningAnimation = _spriteAnimation('BackRun', 12);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Desappearing', 7);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.runningBack: backrunningAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(
          'game_images/Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('game_images/Main Characters/$state (96x96).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(96),
        loop: false,
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      // DO NOTHING.
      // flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // Check if moving, set running
    if (velocity.x > 0) playerState = PlayerState.running;
    // Check if moving, set running
    if (velocity.x < 0) playerState = PlayerState.runningBack;

    // check if Falling set to falling
    if (velocity.y > 0) playerState = PlayerState.falling;

    // Checks if jumping, set to jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);
    if (isShooting) _shoot();
    // if (velocity.y > _gravity) isOnGround = false; // optional

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _shoot() {
    final gameStateProvider = Provider.of<GameStateProvider>(
        navigatorKey.currentContext!,
        listen: false);

    if ((gameStateProvider.bulletsCollected ?? 0) > 0) {
      Bullet b = Bullet(
        position: position,
        isLeft: game.player.horizontalMovement < 0,
      );
      parent?.add(b);
      gameStateProvider.deductBulletsCollected = 1;
    }
    isShooting = false;
  }

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 400);
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1;
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;
    _updatePlayerState();
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint({bool? isAllLightsRequired}) async {
    int? lightsRequired = Provider.of<GameStateProvider>(
            navigatorKey.currentContext!,
            listen: false)
        .lightsRequired;
    int? lightCollected = Provider.of<GameStateProvider>(
            navigatorKey.currentContext!,
            listen: false)
        .lightsCollected;
    if (isAllLightsRequired == true) {
      if ((lightCollected ?? 0) < (lightsRequired ?? 0)) {
        current = PlayerState.idle;
        reachedCheckpoint = true;

        gameRef.pauseEngine();

        await KLoadingToast.showCharacterDialog(
          title: "Oh No, Not Yet!",
          message:
              "You've reached the win point, but there's still energy to save! Every light switched off is a beacon of hope for our planet. Keep pushing forward, Guardian, until every watt is saved!",
          explorerImage: KExplorers.explorer8,
          hidePrimary: true,
          hideSecondary: true,
        );

        gameRef.resumeEngine();
        current = PlayerState.idle;
        reachedCheckpoint = false;
      } else {
        _won();
      }
    } else {
      _won();
    }
  }

  void _won() async {
    reachedCheckpoint = true;
    if (game.playSounds) {
      FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }
    if (scale.x > 0) {
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640);

    Provider.of<GameStateProvider>(navigatorKey.currentContext!, listen: false)
        .reset();

    KLoadingToast.showCharacterDialog(
      title: "Energy Guardian Triumph!",
      message:
          "You did it! Every switched-off light brings us closer to a brighter, sustainable future. Keep up the fantastic work, Guardian!",
      explorerImage: KExplorers.explorer8,
      primaryLabel: "Onward to the Next Victory!",
      onPrimaryPressed: () {
        Navigator.pop(navigatorKey.currentContext!);
      },
      hideSecondary: true,
    );

    game.loadNextLevel();
    // const waitToChangeDuration = Duration(seconds: 3);
    // Future.delayed(waitToChangeDuration, () => game.loadNextLevel());
  }

  void collidedwithEnemy() {
    _respawn();
  }
}
