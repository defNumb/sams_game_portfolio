import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';

import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sams_game_portfolio/actors/slime.dart';
import 'components/background.dart';
import 'components/ground.dart';

class MyFirstGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, TapDetector {
  MyFirstGame() : super();

  Slime slime = Slime();
  final double gravity = 1.8;
  final double jumpVelocity = 180;
  final double pushSpeed = 2.5;
  Vector2 velocity = Vector2(0, 0);

  late final CameraComponent cameraComponent;
  // late final CameraComponent camera;
  late SpriteAnimation slimeIdleAnimation;

  @override
  bool debugMode = true;

  @override
  Future<void> onLoad() async {
    var homeMap = await TiledComponent.load(
      'map.tmx',
      Vector2.all(32),
      // atlasMaxX: 7000,
      // atlasMaxY: 7000,
    );

    double mapHeight = 32.0 * homeMap.height;
    double mapWidth = 32.0 * homeMap.width;

    var slimeIdleAnimation = SpriteAnimation.spriteList(
        await fromJSONAtlas('slime_idle.png', 'slime_idle.json'),
        stepTime: 0.2);
    slime
      ..animation = slimeIdleAnimation
      ..size = Vector2(100, 100)
      ..scale = Vector2(0.7, 0.7)
      ..position = Vector2(100, 300);

    var background = BackgroundComponent();

    world.add(background);

    world.add(slime);
    camera.setBounds(Rectangle.fromLTWH(0, 0, 5250, 725));
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1500, 725));
    camera.follow(slime, horizontalOnly: true);
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!slime.onGround) {
      velocity.y += gravity;
    }
    slime.position += velocity * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keys) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        slime.slimeDirection = SlimeDirection.left;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        slime.slimeDirection = SlimeDirection.right;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        if (slime.onGround) {
          velocity.y = -jumpVelocity;
          slime.isJumping = true;
          slime.onGround = false;
        }
      }
    } else if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        slime.slimeDirection = SlimeDirection.none;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        slime.slimeDirection = SlimeDirection.none;
      }
    }
    return KeyEventResult.handled;
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (slime.onGround) {
      velocity.y = -jumpVelocity;
      slime.isJumping = true;
      slime.onGround = false;
      if (info.eventPosition.global.x < 200) {
        velocity.x -= 200;
      } else {
        velocity.x += 200;
      }
    }
  }

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    if (slime.onGround) {
      velocity.y = -jumpVelocity;
      slime.isJumping = true;
      slime.onGround = false;
      if (info.eventPosition.global.x < 200) {
        velocity.x += 200;
      } else {
        velocity.x -= 200;
      }
    }
  }
}
