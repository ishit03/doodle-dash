import 'dart:async';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'powerup_state.dart';

abstract class Powerup extends SpriteAnimationGroupComponent
    with HasGameRef<DoodleDash>, CollisionCallbacks {
  Powerup({required super.size, required super.position, required this.state})
      : super(anchor: Anchor.center, priority: 1);

  final RectangleHitbox _hitbox =
      RectangleHitbox(collisionType: CollisionType.active);
  final PowerupState state;

  @mustCallSuper
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    await add(_hitbox);
  }
}
