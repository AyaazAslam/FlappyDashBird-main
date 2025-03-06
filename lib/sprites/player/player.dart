import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';

enum PlayerState {
  center,
  flying,
  falling,
}

class Player extends SpriteGroupComponent<PlayerState>
    with HasGameRef<FlappyDashBird>, KeyboardHandler, CollisionCallbacks {
  Player({
    super.position,
    double flyingSpeed = 350,
  })  : _flyingSpeed = flyingSpeed,
        _velocity = Vector2.zero(),
        _gravity = 9,
        super(
          size: Vector2(60, 50),
          priority: 1,
        );

  final double _flyingSpeed;
  final Vector2 _velocity;
  final double _gravity;

  bool get isFalling => _velocity.y > 0;

  Vector2 get _initialPosition => Vector2(
        _initialXPosition,
        _initialYPosition,
      );

  double get _initialXPosition => gameRef.camera.viewport.effectiveSize.x / 3.5;

  double get _initialYPosition => gameRef.camera.viewport.effectiveSize.y / 2;

  bool get _isOutOfBounds => position.y > gameRef.size.y || position.y < 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(CircleHitbox());
    await _loadCharacterSprites();

    current = PlayerState.center;
    position = _initialPosition;
  }

  @override
  void update(double dt) {
    if (_isOutOfBounds) {
      gameRef.onLose();
      return;
    }

    _velocity.y += _gravity;

    if (isFalling) {
      current = PlayerState.falling;
    }

    // new_position = current_position + (velocity * time-elapsed-since-last-game-loop-tick)
    position += _velocity * dt;

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    gameRef.onLose();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      fly();
    }

    return true;
  }

  void fly() {
    _velocity.y = -_flyingSpeed;

    current = PlayerState.flying;
  }

  Future<void> _loadCharacterSprites() async {
    final center = await gameRef.loadSprite('game/bluebird-midflap.png');
    final flying = await gameRef.loadSprite('game/bluebird-upflap.png');
    final falling = await gameRef.loadSprite('game/bluebird-downflap.png');

    sprites = <PlayerState, Sprite>{
      PlayerState.center: center,
      PlayerState.flying: flying,
      PlayerState.falling: falling,
    };
  }

  void reset() {
    current = PlayerState.center;
    position = _initialPosition;
    _velocity.setZero();
  }
}
