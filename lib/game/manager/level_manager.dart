import 'package:flame/components.dart';

class LevelManager extends Component {
  LevelManager({this.pipesSpeed = -60, int currentScore = 0})
      : _currentScore = currentScore;

  double pipesSpeed;
  int _currentScore;

  void reset() {
    pipesSpeed = -60;
    _currentScore = 0;
  }

  bool shouldLevelUp(int score) => _currentScore < score;

  void increasePipesSpeed(int currentScore) {
    pipesSpeed -= 5;

    _currentScore = currentScore;
  }
}
