import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';

abstract class Pipe extends SpriteComponent
    with HasGameRef<FlappyDashBird>, CollisionCallbacks {
  Pipe(this._speed)
      : _hitbox = RectangleHitbox(),
        _velocity = Vector2.zero(),
        super(
          size: Vector2(50, 250),
          priority: 2,
        );

  final RectangleHitbox _hitbox;

  final Vector2 _velocity;

  final double _speed;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    await add(_hitbox);
  }

  void _move(double dt) {
    _velocity.x = _speed;

    position += _velocity * dt;
  }

  @override
  void update(double dt) {
    _move(dt);
    super.update(dt);
  }
}
