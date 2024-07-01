import 'dart:async';
import 'dart:math';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/managers/difficulty_manager.dart';
import 'package:doodle_dash/random_provider.dart';
import 'package:doodle_dash/sprites/powerups/powerup.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'moving_cloud.dart';
import 'normal_cloud.dart';
import 'thunder_cloud.dart';

abstract class Cloud extends SpriteComponent with HasGameRef<DoodleDash> {
  Cloud({required super.position, required this.powerup})
      : super(size: Vector2(100, 50), priority: 2, anchor: Anchor.center);

  final RectangleHitbox _hitbox =
      RectangleHitbox(collisionType: CollisionType.passive);

  final Powerup? powerup;

  bool get hasPowerup => powerup != null;

  @mustCallSuper
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    await add(_hitbox);
    if (hasPowerup) {
      add(powerup!);
    }
  }
}

class CloudFactory {
  final Random _random = RandomProvider.randomInstance;
  final DifficultyManager diff = DifficultyManager.instance;

  Cloud createRandomCloud(Vector2 position) {
    final double probability =
        double.parse((_random.nextDouble() * 10).toStringAsFixed(1));
    final Powerup? powerup = _maybeAddPowerup();
    if (probability < diff.normalCloudProbability) {
      return NormalCloud(position: position, powerup: powerup);
    } else if (probability < diff.movingCloudProbability) {
      return MovingCloud(position: position, powerup: powerup);
    } else {
      return ThunderCloud(position: position, powerup: powerup);
    }
  }

  Powerup? _maybeAddPowerup() {
    final double probability =
        double.parse((_random.nextDouble() * 10).toStringAsFixed(1));
    switch (probability) {
      case <= 9.3:
        return null;
      case <= 9.6:
        return Jetpack(position: Vector2(50.0, -10.0));
      case <= 9.9:
        return PropellerHat(position: Vector2(50.0, -10.0));
    }
    return null;
  }
}
