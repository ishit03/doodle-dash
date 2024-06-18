import 'dart:async';

import 'package:doodle_dash/sprites/sprites.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DoodleDash extends FlameGame with HasKeyboardHandlerComponents {
  final Dash _dash = Dash();
  final Cloud _cloud = Cloud();

  @override
  Color backgroundColor() => Colors.blue.shade100;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await add(_dash);
    await add(_cloud);
  }
}
