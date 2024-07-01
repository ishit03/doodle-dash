import 'dart:async';
import 'dart:math';

import 'package:doodle_dash/random_provider.dart';
import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:flame/components.dart';

class MovingCloud extends Cloud {
  MovingCloud({required super.position, super.powerup});

  final Random _random = RandomProvider.randomInstance;

  late final Vector2 _velocity;
  double _direction = 1.0;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('normal_cloud.webp');

    ///Generate a random move speed between 100-250
    final xSpeed = (_random.nextInt(151) + 100).toDouble();
    _velocity = Vector2(xSpeed, 0.0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isPlaying) return;

    if (position.x + size.x / 2 >= gameRef.size.x / 2) {
      _direction = -1.0;
    }
    if (position.x - size.x / 2 <= -gameRef.size.x / 2) {
      _direction = 1.0;
    }

    position += (_velocity * _direction) * dt;
  }
}
