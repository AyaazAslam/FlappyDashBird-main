import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';
import 'package:my_flame_project/game/widgets/score_display.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this._game, {super.key});

  final Game _game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool _isPaused = false;
  final bool _isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return _buildMobileTapWrapper(
      Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 30,
              child: ScoreDisplay(game: widget._game),
            ),
            Positioned(
              top: 30,
              right: 30,
              child: _buildPauseButton(),
            ),
            if (_isPaused)
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 72.0,
                right: MediaQuery.of(context).size.width / 2 - 72.0,
                child: _buildPauseIcon(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTapWrapper(Widget child) {
    if (_isMobile) {
      return GestureDetector(
        onTap: () => (widget._game as FlappyDashBird).player.fly(),
        child: child,
      );
    }

    return child;
  }

  ElevatedButton _buildPauseButton() => ElevatedButton(
        child: _isPaused
            ? const Icon(
                Icons.play_arrow,
                size: 48,
              )
            : const Icon(
                Icons.pause,
                size: 48,
              ),
        onPressed: () {
          (widget._game as FlappyDashBird).togglePauseState();
          setState(
            () {
              _isPaused = !_isPaused;
            },
          );
        },
      );

  Icon _buildPauseIcon() => const Icon(
        Icons.pause_circle,
        size: 144.0,
        color: Colors.black12,
      );
}
