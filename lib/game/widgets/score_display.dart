import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key, required Game game}) : _game = game;

  final Game _game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (_game as FlappyDashBird).gameManager.score,
      builder: (context, value, child) {
        return _buildScoreText(context, value);
      },
    );
  }

  Text _buildScoreText(BuildContext context, int value) =>
      Text('Score: $value', style: Theme.of(context).textTheme.displaySmall!);
}
