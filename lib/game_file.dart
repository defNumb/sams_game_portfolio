import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sams_game_portfolio/actors/slime.dart';

import 'components/ground.dart';

class MyFirstGame extends FlameGame
    with KeyboardEvents, HasCollisionDetection, TapDetector {
  MyFirstGame() : super();
  //
  // VARIABLES
  //

  Slime slime = Slime();
  final double gravity = 1.8;
  final double jumpVelocity = 180;
  final double pushSpeed = 2.5;
  Vector2 velocity = Vector2(0, 0);
  late SpriteAnimation slimeIdleAnimation;
  Vector2 lastCameraPosition = Vector2.zero();
  static final backgroundVelocity = Vector2(3.0, 1.0);
  static const framesPerSec = 60.0;
  static const threshold = 0.005;
  // late final MyBackground myBackground;
  // late final MyForeground myForeground;
  late double delta;

  //
  //
  @override
  bool debugMode = true;

  @override
  Future<void> onLoad() async {
    // VARIABLES
    //

    TiledComponent homeMap = await TiledComponent.load(
      'map.tmx',
      Vector2.all(32),
    );
    TiledComponent foregroundMap = await TiledComponent.load(
      'map2.tmx',
      Vector2.all(32),
      priority: 1,
    );

    // map width
    double mapWidth = homeMap.tileMap.map.width * 32;

    // map height
    double mapHeight = homeMap.tileMap.map.height * 32;

    var obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');
    for (final obj in obstacleGroup!.objects) {
      world.add(
        Ground(
          size: Vector2(obj.width, obj.height),
          position: Vector2(obj.x, obj.y - 20),
        ),
      );
    }

    // ANIMATIONS
    //
    var slimeIdleAnimation = SpriteAnimation.spriteList(
        await fromJSONAtlas('slime_idle.png', 'slime_idle.json'),
        stepTime: 0.2);
    // CHARACTERS
    slime
      ..animation = slimeIdleAnimation
      ..size = Vector2(100, 100)
      ..scale = Vector2(0.75, 0.75)
      ..position = Vector2(500, 300);

    // ADDING TO WORLD

    world.add(homeMap);
    world.add(foregroundMap);
    world.add(slime);
    // CAMERA
    // //
    camera.follow(slime, horizontalOnly: true, snap: true, maxSpeed: 100);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2(0, 0);
    camera.viewport.position = Vector2(500, 0);
    camera.viewfinder.visibleGameSize = Vector2(500, 500);
    camera.viewport =
        FixedResolutionViewport(resolution: Vector2(1200, mapHeight));
    // set boundaries for camera
    camera.setBounds(
      Rectangle.fromLTWH(0, 0, mapWidth, 600), // world size
    ); // viewport size);

    await super.onLoad();
  }

  @override
  void update(double dt) async {
    super.update(dt);
    delta = dt > threshold ? 1.0 / (dt * framesPerSec) : 1.0;
    if (!slime.onGround) {
      velocity.y += gravity;
    }
    slime.position += velocity * dt;

    // if slime reaches the end of the screen, stop moving
    if (slime.position.x > 4400 - slime.size.x) {
      slime.position.x = 4400 - slime.size.x;
    } else if (slime.position.x < 0) {
      slime.position.x = 0;
    }
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
        // update background parallax speed
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        slime.slimeDirection = SlimeDirection.right;
        // update background parallax speed
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
