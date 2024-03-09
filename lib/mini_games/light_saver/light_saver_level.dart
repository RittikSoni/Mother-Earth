import 'dart:async';

import 'package:eco_collect/providers/game_state_provider.dart';
import 'package:eco_collect/routes/kroutes.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:eco_collect/components/game_components/collectibles/collectibles_light.dart';
import 'package:eco_collect/components/game_components/win/checkpoint.dart';
import 'package:eco_collect/components/game_components/collectibles/collectibles.dart';
import 'package:eco_collect/components/game_components/game_miscs/collision_block.dart';
import 'package:eco_collect/components/game_components/enemies/follower_enemy.dart';
import 'package:eco_collect/components/game_components/hell/hell.dart';
import 'package:eco_collect/components/game_components/enemies/patrol_enemy.dart';
import 'package:eco_collect/constants/kenums.dart';
import 'package:eco_collect/mini_games/light_saver/light_saver_game.dart';
import 'package:eco_collect/components/game_components/player/player.dart';
import 'package:eco_collect/components/game_components/traps/saw.dart';
import 'package:provider/provider.dart';

class LightSaverLevel extends World with HasGameRef<LightSaverGame> {
  final String levelName;
  final LightSaverPlayer player;
  LightSaverLevel({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    // _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  // void _scrollingBackground() {
  //   final backgroundLayer = level.tileMap.getLayer('Background');

  //   if (backgroundLayer != null) {
  //     // final backgroundColor =
  //     //     backgroundLayer.properties.getValue('BackgroundColor');
  //     // ! Warning! Currently not in use.
  //     final backgroundTile = LightSaverBackgroundTile(
  //       position: Vector2(0, 0),
  //     );
  //     add(backgroundTile);
  //     // final backgroundClouds = LightSaverBackgroundTile(
  //     //   scrollSpeed: 0,
  //     //   imagePath: "game_images/Background/summer 4/1.png",
  //     //   position: Vector2(40, 0),
  //     // );
  //     // add(backgroundClouds);
  //   }
  // }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;

            add(player);
            break;
          case 'Apple':
            final fruit = Collectible(
              collectible: KenumGameCollectibles.apple,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Plastic Bottle':
            final plasticBottle = Collectible(
              collectible: KenumGameCollectibles.plasticBottle,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(plasticBottle);
            break;
          case 'Light':
            Provider.of<GameStateProvider>(navigatorKey.currentContext!,
                    listen: false)
                .addLightsRequired = 1;
            final light = CollectibleLight(
              collectible: KenumGameCollectibles.light,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(light);
            break;
          case 'Cherries':
            final cherries = Collectible(
              collectible: KenumGameCollectibles.cherries,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(cherries);
            break;
          case 'Bananas':
            final bananas = Collectible(
              collectible: KenumGameCollectibles.banana,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(bananas);
            break;
          case 'Hell':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final hell = Hell(
              isVertical: false,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(hell);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Spike Enemy':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final spikeEnemy = Saw(
              isSpikeEnemy: true,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(spikeEnemy);
            break;
          case 'Patrol Enemy':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final patrolEnemy = PatrolEnemy(
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(patrolEnemy);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Chicken':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final chicken = FollowerEnemy(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: offNeg,
              offPos: offPos,
            );
            add(chicken);
            break;
          case 'Bird':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final bird = FollowerEnemy(
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height),
                offNeg: offNeg,
                offPos: offPos,
                isBird: true);
            add(bird);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
