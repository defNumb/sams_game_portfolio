import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:sams_game_portfolio/game_file.dart';
import 'ground.dart';

class MyBackground extends TiledComponent<MyFirstGame> {
  static final backgroundVelocity = Vector2(3.0, 0);
  static const framesPerSec = 60.0;
  static const threshold = 0.005;
  Vector2 lastCameraPosition = Vector2.zero();
  late TiledComponent homeMap;
  Vector2 velocity = Vector2(0, 0);

  MyBackground(super.tileMap);

  // game ref

  @override
  Future<void> onLoad() async {
    super.onLoad();
    TiledComponent homeMap = await TiledComponent.load(
      'map.tmx',
      Vector2.all(32),
    );
    var obstacleGroup = homeMap.tileMap.getLayer<ObjectGroup>('ground');
    for (final obj in obstacleGroup!.objects) {
      add(
        Ground(
          size: Vector2(obj.width + 2000, obj.height + 50),
          position: Vector2(obj.x, obj.y - 140),
        ),
      );
    }
    // final backParallax = [
    //   await ParallaxImageData(
    //     'background.png',
    //   ),
    //   await ParallaxImageData(
    //     'background2.png',
    //   ),
    // ];

    // parallax = await gameRef.loadParallax(
    //   backParallax,
    //   baseVelocity: Vector2(1.8, 1.0),
    //   velocityMultiplierDelta: Vector2(1.8, 0.0),
    // );
  }

  // @override
  // void update(double dt) async {
  //   super.update(dt);
  //   final cameraPosition = gameRef.camera.viewfinder.position;
  //   final delta = dt > threshold ? 1.0 / (dt * framesPerSec) : 1.0;
  //   final baseVelocity = cameraPosition
  //     ..sub(lastCameraPosition)
  //     ..multiply(backgroundVelocity)
  //     ..multiply(Vector2(delta, delta));

  //   parallax!.baseVelocity.setFrom(baseVelocity);
  //   lastCameraPosition.setFrom(gameRef.camera.viewfinder.position);
  // }
}
