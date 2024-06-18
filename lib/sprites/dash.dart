import 'dart:async';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum DashDirection { left, right }

class Dash extends SpriteGroupComponent<DashDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler {
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    final dashLeft = await gameRef.loadSprite('left_dash.png');
    final dashRight = await gameRef.loadSprite('right_dash.png');

    position = Vector2(gameRef.size.x / 2, gameRef.size.y / 2);
    size = Vector2.all(100);

    sprites = {DashDirection.left: dashLeft, DashDirection.right: dashRight};

    current = DashDirection.right;
  }

  @override
  void update(double dt) {}

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      current = DashDirection.left;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      current = DashDirection.right;
    }

    return true;
  }
}
