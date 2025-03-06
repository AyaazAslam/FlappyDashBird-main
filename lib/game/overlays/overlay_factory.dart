import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:my_flame_project/game/widgets/game_over_overlay.dart';
import 'package:my_flame_project/game/widgets/game_overlay.dart';

class OverlayFactory {
  OverlayFactory();

  static const String gameOverlay = 'gameOverlay';
  static const String gameOverOverlay = 'gameOverOverlay';

  get supportedOverlays => <String, Widget Function(BuildContext, Game)>{
        gameOverlay: (context, game) => GameOverlay(game),
        gameOverOverlay: (context, game) => GameOverOverlay(game),
      };
}
