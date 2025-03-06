import 'package:flame/components.dart';
import 'package:my_flame_project/sprites/pipes/pipe.dart';

class BottomPipe extends Pipe {
  BottomPipe(super._speed);

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('game/pipe-green.png');

    position = Vector2(gameRef.size.x, gameRef.size.y - size.y);
    await super.onLoad();
  }
}
