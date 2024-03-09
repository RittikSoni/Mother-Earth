import 'dart:async';
import 'dart:io';

import 'package:eco_collect/mini_games/crush_the_plastic/widgets/level.dart';
import 'package:eco_collect/mini_games/crush_the_plastic/widgets/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class PlasticCrusher extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  Player player = Player(character: 'Ninja Frog');
  JoystickComponent? joystick;
  bool showControls = kIsWeb ? false : (Platform.isAndroid || Platform.isIOS);
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    'Level-01',
    'Level-02',
    'Level-03',
  ];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // Load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showControls) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 10,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('game_images/HUD/Knob.png'),
        ),
        size: Vector2.all(40.0),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('game_images/HUD/Joystick.png'),
        ),
        size: Vector2.all(100.0),
      ),
      margin: const EdgeInsets.only(left: 10, bottom: 32),
    );

    final jumpButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache('game_images/HUD/JumpButton.png'),
        ),
        size: Vector2.all(80.0),
      ),
      margin: const EdgeInsets.only(
        right: 30,
        bottom: 50,
      ),
      onPressed: () {
        player.hasJumped = true;
      },
    );

    cam.viewport.addAll([joystick!, jumpButton]);
  }

  void updateJoystick() {
    switch (joystick?.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);

    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    Future.delayed(const Duration(seconds: 1), () {
      Level world = Level(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );

      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );
      cam.viewfinder.anchor = Anchor.topLeft;

      addAll([cam, world]);
      if (showControls) {
        addJoystick();
      }
    });
  }
}
