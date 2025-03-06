import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';

enum GameState { playing, gameOver }

class GameManager extends Component with HasGameRef<FlappyDashBird> {
  GameManager()
      : score = ValueNotifier(0),
        state = GameState.playing;

  ValueNotifier<int> score;
  GameState state;

  bool get isPlaying => state == GameState.playing;

  bool get isGameOver => state == GameState.gameOver;

  void reset() {
    score.value = 0;
    state = GameState.playing;
  }

  void increaseScore() {
    score.value++;
  }
}
