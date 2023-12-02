import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:sams_game_portfolio/components/ground.dart';
import '../game_file.dart';

enum SlimeDirection { left, right, none }

class Slime extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyFirstGame> {
  Slime() : super() {
    debugMode = true;
  }

  SlimeDirection slimeDirection = SlimeDirection.none;
  bool onGround = false;
  bool isJumping = false;
  bool hitRight = false;
  bool hitLeft = false;
  double moveSpeed = 200;
  Vector2 velocity = Vector2(0, 0);

  // z index

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, other) {
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      gameRef.velocity.y = 0;
      onGround = true;
      isJumping = false;
    }
  }

  void updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (slimeDirection) {
      case SlimeDirection.left:
        dirX -= moveSpeed;
        break;
      case SlimeDirection.right:
        dirX += moveSpeed;
        break;
      case SlimeDirection.none:
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
