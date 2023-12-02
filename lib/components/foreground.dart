import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../game_file.dart';

class MyForeground extends ParallaxComponent<MyFirstGame>
    with HasGameRef<MyFirstGame> {
  static final backgroundVelocity = Vector2(3.0, 0);
  static const framesPerSec = 60.0;
  static const threshold = 0.005;
  Vector2 lastCameraPosition = Vector2.zero();
  late TiledComponent homeMap;
  Vector2 velocity = Vector2(0, 0);

  // game ref

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final frontParallax = [
      ParallaxImageData(
        'background3.png',
      ),
      ParallaxImageData(
        'background4.png',
      ),
    ];

    parallax = await gameRef.loadParallax(
      frontParallax,
      baseVelocity: Vector2(1.8, 1.0),
      velocityMultiplierDelta: Vector2(2.5, 0.0),
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
}
