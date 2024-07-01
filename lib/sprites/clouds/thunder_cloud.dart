import 'dart:async';

import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

///Need to do something better with this as scaling down is pretty useless as of now.
class ThunderCloud extends Cloud {
  ThunderCloud({required super.position, super.powerup});

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('thunder_cloud.webp');
  }

  void scaleDown() {
    final scaleEffect = ScaleEffect.to(
        Vector2.all(0.0), EffectController(duration: 1, curve: Curves.ease));
    add(scaleEffect);
  }
}
