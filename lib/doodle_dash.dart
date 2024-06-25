import 'dart:async';

import 'package:doodle_dash/cloud_manager.dart';
import 'package:doodle_dash/sprites/sprites.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameState { intro, playing, gameOver }

class DoodleDash extends FlameGame
    with
        SingleGameInstance,
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        HorizontalDragDetector {
  DoodleDash(this._prefs) : super();
  final SharedPreferences _prefs;

  final Dash _dash = Dash();
  CloudManager _cloudManager = CloudManager();
  ValueNotifier<int> score = ValueNotifier<int>(0);
  GameState state = GameState.intro;

  bool get isGameOver => state == GameState.gameOver;

  bool get isPlaying => state == GameState.playing;

  bool get isInitial => state == GameState.intro;

  Dash get dash => _dash;

  int get highScore => _prefs.getInt('high-score') ?? 0;

  @override
  Color backgroundColor() => Colors.blue.shade100;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    children.register<CameraComponent>();
    children.register<CloudManager>();

    await world.add(_cloudManager);
    await world.add(_dash);

    _resetCamera();

    overlays.add('intro');
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (!isPlaying) return;

    //To restrict camera from following dash when it is going down
    if (_dash.isGoingDown) {
      camera.setBounds(Rectangle.fromLTRB(
          0.0, double.negativeInfinity, size.x, camera.viewfinder.position.y));
    }

    //If dash is outside the bottom of the screen, game is over.
    if (_dash.position.y > camera.viewfinder.position.y + size.y / 2 &&
        !camera.canSee(_dash)) {
      gameOver();
    }
  }

  //To listen to gestures on mobile version
  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    _dash.move(info.delta.global.x);
  }

  @override
  void onHorizontalDragEnd(DragEndInfo info) {
    _dash.move(0.0);
  }

  void resetGame() async {
    if (world.contains(_cloudManager)) world.remove(_cloudManager);

    _dash.reset();

    _resetCamera();

    score.value = 0;

    _cloudManager = CloudManager();
    await world.add(_cloudManager);

    overlays.remove('gameOver');
    overlays.add('intro');
    state = GameState.intro;
  }

  void gameOver() {
    overlays.remove('playing');
    _maybeUpdateHighscore();
    state = GameState.gameOver;
    overlays.add('gameOver');
  }

  void startGame() {
    overlays.remove('intro');
    state = GameState.playing;
    _dash.megaJump();
    overlays.add('playing');
  }

  void _resetCamera() {
    camera.removeFromParent();
    camera = CameraComponent(world: world);
    camera
        .setBounds(Rectangle.fromLTRB(0.0, -double.maxFinite, size.x, size.y));
    camera.follow(_dash, verticalOnly: true, snap: true);
  }

  void _maybeUpdateHighscore() {
    if (score.value > highScore) {
      _prefs.setInt('high-score', score.value);
    }
  }
}
