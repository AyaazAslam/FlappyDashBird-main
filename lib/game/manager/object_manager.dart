import 'dart:math';

import 'package:flame/components.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';
import 'package:my_flame_project/game/util/num_utils.dart';
import 'package:my_flame_project/sprites/pipes/bottom_pipe.dart';
import 'package:my_flame_project/sprites/pipes/pipe.dart';
import 'package:my_flame_project/sprites/pipes/top_pipe.dart';

class ObjectManager extends Component with HasGameRef<FlappyDashBird> {
  ObjectManager({
    double minDistanceBetweenPipes = 200,
    required double pipesSpeed,
  })  : _minDistanceBetweenPipes = minDistanceBetweenPipes,
        _pipesSpeed = pipesSpeed,
        _probabilityGenerator = ProbabilityGenerator(),
        _pipes = [];

  final double _minDistanceBetweenPipes;
  double _pipesSpeed;
  final ProbabilityGenerator _probabilityGenerator;
  final List<Pipe> _pipes;

  set pipesSpeed(double newSpeed) {
    _pipesSpeed = newSpeed;
  }

  @override
  void onMount() {
    final nextPipe = _createSemiRandomPipe();
    _addPipe(nextPipe);

    super.onMount();
  }

  @override
  void update(double dt) {
    final addPipe = Random().nextBool();

    final distanceBetweenPipesValid =
        gameRef.size.x - _pipes.last.position.x > _minDistanceBetweenPipes;

    if (addPipe && distanceBetweenPipesValid) {
      final nextPipe = _createSemiRandomPipe();
      _addPipe(nextPipe);

      gameRef.gameManager.increaseScore();
    }

    _cleanUpPipes();

    super.update(dt);
  }

  Pipe _createSemiRandomPipe() {
    if (_probabilityGenerator.generateWithProbability(50)) {
      return TopPipe(_pipesSpeed);
    }

    return BottomPipe(_pipesSpeed);
  }

  void _cleanUpPipes() {
    final firstPipeHidden =
        _pipes.first.position.x < -gameRef.screenBufferSpace;

    if (_pipes.isNotEmpty && firstPipeHidden) {
      _popPipe();
    }
  }

  void _addPipe(Pipe newPipe) {
    add(newPipe);
    _pipes.add(newPipe);
  }

  void _popPipe() {
    remove(_pipes.first);
    _pipes.removeAt(0);
  }
}
