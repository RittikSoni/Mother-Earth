import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class LightSaverBackgroundTile extends ParallaxComponent with HasGameRef {
  final String? imagePath;
  final double? scrollSpeed;

  LightSaverBackgroundTile({
    this.imagePath,
    this.scrollSpeed,
    position,
  }) : super(
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    priority = -10;
    size = Vector2.all(64);
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData(
            imagePath ?? 'game_images/Background/summer 4/Summer4.png'),
        // ParallaxImageData('game_images/Background/summer 4/1.png'),
      ],
      baseVelocity: Vector2(scrollSpeed ?? 0, 0),
      // baseVelocity: Vector2(0, -scrollSpeed),
      repeat: ImageRepeat.repeat,
      fill: LayerFill.height,
    );
    return super.onLoad();
  }
}
