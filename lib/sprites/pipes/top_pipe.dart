import 'package:flame/components.dart';
import 'package:my_flame_project/sprites/pipes/pipe.dart';

class TopPipe extends Pipe {
  TopPipe(super._speed);

  @override
  Future<void>? onLoad() async {
    sprite = await gameRef.loadSprite('game/pipe-green.png');

    flipVertically();

    position = Vector2(gameRef.size.x, size.y);

    await super.onLoad();
  }
}
