import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<LightSaverGame>, TapCallbacks {
  JumpButton();

  final margin = 30;
  final buttonSize = 64;

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache(
        'game_images/HUD/JumpButton.png',
      ),
    );
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );

    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
