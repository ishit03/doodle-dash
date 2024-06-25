import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/overlays/game_over.dart';
import 'package:doodle_dash/overlays/intro.dart';
import 'package:doodle_dash/overlays/score.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Flame.device.fullScreen();
  runApp(GameWidget(
    game: DoodleDash(prefs),
    overlayBuilderMap: {
      'gameOver': (BuildContext context, DoodleDash game) =>
          GameOver(game: game),
      'playing': (BuildContext context, DoodleDash game) =>
          ScoreOverlay(game: game),
      'intro': (BuildContext context, DoodleDash game) =>
          IntroOverlay(game: game),
    },
  ));
}
