import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';
import 'package:my_flame_project/game/widgets/score_display.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this._game, {super.key});

  final Game _game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildGameOverTitle(context),
              const SizedBox(height: 50),
              ScoreDisplay(game: _game),
              const SizedBox(height: 50),
              _buildPlayAgainButton(context),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildPlayAgainButton(BuildContext context) => ElevatedButton(
        onPressed: () {
          (_game as FlappyDashBird).resetGame();
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            const Size(200, 75),
          ),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.titleLarge),
        ),
        child: const Text('Play Again'),
      );

  Text _buildGameOverTitle(BuildContext context) => Text(
        'Game Over',
        style: Theme.of(context).textTheme.displayMedium!.copyWith(),
      );
}
