import 'dart:async';
import 'dart:io';

import 'package:eco_collect/mini_games/light_saver/light_saver_level.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:eco_collect/components/game_components/background/background_tile.dart';

import 'package:eco_collect/components/game_components/player/player.dart';

class LightSaverGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  LightSaverPlayer player = LightSaverPlayer();
  JoystickComponent? joystick;
  bool showControls = kIsWeb ? false : (Platform.isAndroid || Platform.isIOS);
  bool playSounds = true;
  double soundVolume = 1.0;
  List<String> levelNames = [
    // 'Energy-Saver-Level-Test',
    'Energy-Saver-Level-04',
    'Energy-Saver-Level-03',
    'Energy-Saver-Level-02',
    'Energy-Saver-Level-01',
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

    final fireButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache('game_images/HUD/FireButton.png'),
        ),
        size: Vector2.all(70.0),
      ),
      margin: const EdgeInsets.only(
        right: 10,
        bottom: 100,
      ),
      onPressed: () {
        player.isShooting = true;
      },
    );

    final jumpButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: Sprite(
          images.fromCache('game_images/HUD/JumpButton.png'),
        ),
        size: Vector2.all(70.0),
      ),
      margin: const EdgeInsets.only(
        right: 30,
        bottom: 10,
      ),
      onPressed: () {
        player.hasJumped = true;
      },
    );

    cam.viewport.addAll([joystick!, fireButton, jumpButton]);
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
    removeWhere((component) => component is LightSaverLevel);

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
    // debugMode = true;
    Future.delayed(const Duration(seconds: 1), () {
      LightSaverLevel world = LightSaverLevel(
        player: player,
        levelName: levelNames[currentLevelIndex],
      );
      cam = CameraComponent.withFixedResolution(
        world: world,
        width: 640,
        height: 360,
      );

      add(LightSaverBackgroundTile(
        scrollSpeed: 40,
        imagePath: "game_images/Background/summer 4/1.png",
      ));
      add(LightSaverBackgroundTile(
        scrollSpeed: 10,
        imagePath: "game_images/Background/summer 4/2.png",
      ));
      add(LightSaverBackgroundTile(
        scrollSpeed: 10,
        imagePath: "game_images/Background/summer 4/3.png",
      ));
      cam.viewfinder.anchor = Anchor.topCenter;
      // final halfViewportSize = camera.viewport.size / 2;
      // final worldSize = 1500.0; // Size from the center in each direction.
      cam.setBounds(
        Rectangle.fromPoints(Vector2(300, 0), Vector2.all(1800)),
        considerViewport: false,
      );
      cam.follow(
        player,
        horizontalOnly: true,
      );
      if (showControls) {
        addJoystick();
      }

      addAll([cam, world]);
    });
  }
}
