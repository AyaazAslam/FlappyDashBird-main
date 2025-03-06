import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:my_flame_project/game/manager/game_manager.dart';
import 'package:my_flame_project/game/manager/level_manager.dart';
import 'package:my_flame_project/game/manager/object_manager.dart';
import 'package:my_flame_project/game/overlays/overlay_factory.dart';
import 'package:my_flame_project/game/world.dart';
import 'package:my_flame_project/sprites/player/player.dart';

class FlappyDashBird extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {

  FlappyDashBird({required this.onGameOver, required this.onScore,required this.onStartGame})
      : gameManager = GameManager(),
        _levelManager = LevelManager(),
        _world = World(),
        player = Player(),
        screenBufferSpace = 300;

  final void Function(int score) onGameOver;
  final void Function() onScore;
  final void Function() onStartGame;

  final GameManager gameManager;
  final LevelManager _levelManager;
  final World _world;
  final Player player;
  late ObjectManager _objectManager;

  int screenBufferSpace;

  @override
  Future<void> onLoad() async {
    await add(_world);

    _objectManager = ObjectManager(pipesSpeed: _levelManager.pipesSpeed);
    await add(_objectManager);

    await add(gameManager);
    await add(_levelManager);
    await add(player);

    overlays.add(OverlayFactory.gameOverlay);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameManager.isGameOver) {
      return;
    }

    increaseDifficulty();
  }

  void togglePauseState() {
    paused ? resumeEngine() : pauseEngine();
  }

  void initializeGameStart() {
    gameManager.reset();
    _levelManager.reset();
    player.reset();

    add(player);

    _objectManager = ObjectManager(pipesSpeed: _levelManager.pipesSpeed);
    add(_objectManager);
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
  }

  void onLose() {
    gameManager.state = GameState.gameOver;

    player.removeFromParent();
    _objectManager.removeFromParent();

    overlays.add(OverlayFactory.gameOverOverlay);

    // Call the game-over callback
    onGameOver(gameManager.score.value);
  }

  void resetGame() {
    startGame();
    overlays.remove(OverlayFactory.gameOverOverlay);
  }

  void increaseDifficulty() {
    if (_levelManager.shouldLevelUp(gameManager.score.value)) {
      _levelManager.increasePipesSpeed(gameManager.score.value);
      _objectManager.pipesSpeed = _levelManager.pipesSpeed;
    }
  }
}
