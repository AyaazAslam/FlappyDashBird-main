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
      title: appName,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
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
  Game? _game; // Game instance
  int _highScore = 0; // High score

  @override
  void initState() {
    super.initState();
    _loadHighScore();
    FlameAudio.bgm.initialize(); // Initialize audio

    // Ensures _showStartGameDialog() runs after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartGameDialog();
    });
  }

  // Load high score from shared preferences
  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('high_score') ?? 0;
    });
  }

  // Save high score to shared preferences
  Future<void> _saveHighScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    if (score > _highScore) {
      await prefs.setInt('high_score', score);
      setState(() {
        _highScore = score;
      });
    }
  }

  void _showStartGameDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            "Flappy Bird Game",
            style: GoogleFonts.audiowide(
                fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "By: Ayaz Aslam",
                style: GoogleFonts.audiowide(
                    fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "High Score: $_highScore",
                style: GoogleFonts.audiowide(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _startGame(); // Start the game
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Start Game",
                  style:
                      GoogleFonts.audiowide(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startGame() {
    setState(() {
      _game = FlappyDashBird();
    });

    // Play start game sound
    FlameAudio.play('start_game.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
              minWidth: 550,
            ),
            child: _game == null
                ? const SizedBox() // Show nothing before starting
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
