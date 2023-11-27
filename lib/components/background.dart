import 'package:flame/components.dart';

import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';

import 'package:sams_game_portfolio/game_file.dart';

import 'ground.dart';

class BackgroundComponent extends ParallaxComponent {
  BackgroundComponent() : super() {
    debugMode = true;
  }
  Vector2 lastCameraPosition = Vector2.zero();
  late TiledComponent homeMap;
  final imagesNames = [
    ParallaxImageData('background.png'),
    ParallaxImageData('background2.png'),
    ParallaxImageData('background3.png'),
    ParallaxImageData('background4.png'),
  ];
  // game reference
  MyFirstGame gameRef = MyFirstGame();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    homeMap = await TiledComponent.load(
      'map.tmx',
      Vector2.all(32),
      atlasMaxX: 7000,
      atlasMaxY: 7000,
    );
    var obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');
    for (final obj in obstacleGroup!.objects) {
      add(
        Ground(
          size: Vector2(obj.width, obj.height + 50),
          position: Vector2(obj.x, obj.y - 50),
        ),
      );
    }
    var parallax = await ParallaxComponent.load(
      imagesNames,
      baseVelocity: Vector2(5.0, 0.0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      // fill: LayerFill.height,
    );
  }

  @override
  void update(double dt) async {
    super.update(dt);
    final cameraPosition = gameRef.camera.viewfinder.position;
    final delta = dt > threshold ? 1.0 / (dt * framesPerSec) : 1.0;
    final baseVelocity = cameraPosition
      ..sub(lastCameraPosition)
      ..multiply(backgroundVelocity)
      ..multiply(Vector2(delta, delta));
    parallax!.baseVelocity.setFrom(baseVelocity);
    lastCameraPosition.setFrom(gameRef.camera.viewfinder.position);
  }

  static final backgroundVelocity = Vector2(3.0, 0);
  static const framesPerSec = 60.0;
  static const threshold = 0.005;
}
