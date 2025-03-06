import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';

class World extends ParallaxComponent<FlappyDashBird>
    {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('game/background/background-day.png'),
      ],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(5, 0),
      velocityMultiplierDelta: Vector2(1.2, 0),
    );
  }
}
