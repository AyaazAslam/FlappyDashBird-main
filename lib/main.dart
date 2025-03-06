import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_flame_project/game/flappy_dash_bird.dart';
import 'package:my_flame_project/game/util/color_schemes.dart';
import 'package:my_flame_project/game/util/string_utils.dart';
import 'game/overlays/overlay_factory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      themeMode: ThemeMode.dark,
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Game? _game;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    FlameAudio.bgm.initialize();

    // Preload all game sounds
    FlameAudio.audioCache.loadAll([
      'start_game.mp3',
      'die.wav',
      'score.wav',
      'flap.wav',
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartGameDialog();
    });
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('high_score') ?? 0;
    });
  }

  void _showStartGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text("Flappy Bird Game",
              style: GoogleFonts.audiowide(
                  fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("By: Ayaz Aslam",
                  style: GoogleFonts.audiowide(
                      fontSize: 13, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text("High Score: $_highScore",
                  style: GoogleFonts.audiowide(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startGame();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Start Game",
                    style: GoogleFonts.audiowide(
                        fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startGame() {
    setState(() {
      _game = FlappyDashBird(
        onGameOver: (int score) {
          FlameAudio.play('die.wav');
        },
        onScore: () {
          FlameAudio.play('score.wav');
        },
        onStartGame: () {
          FlameAudio.play('flap.wav');
        },
      );
    });

    // Load and play sound safely
    FlameAudio.audioCache.load('start_game.mp3').then((_) {
      FlameAudio.play('start_game.mp3');
    }).catchError((e) {
      debugPrint("Error loading sound: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 800, minWidth: 550),
            child: _game == null
                ? const SizedBox()
                : GameWidget(
                    game: _game!,
                    overlayBuilderMap: OverlayFactory().supportedOverlays,
                  ),
          );
        }),
      ),
    );
  }
}
