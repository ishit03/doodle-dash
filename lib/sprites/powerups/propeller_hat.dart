import 'dart:async';

import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:doodle_dash/sprites/dash.dart';
import 'package:flame/components.dart';

import 'abstract_powerup.dart';
import 'powerup_state.dart';

class PropellerHat extends Powerup {
  PropellerHat({required super.position, super.state = PowerupState.inactive})
      : super(size: Vector2(70.0, 40.0));

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    final inactivePropeller = await gameRef.loadSpriteAnimation(
        'propeller_idle.webp',
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(150.0, 90.0)));
    final activePropeller = await gameRef.loadSpriteAnimation(
        'propeller_sprites.webp',
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.05, textureSize: Vector2(150.0, 90.0)));
    animations = {
      PowerupState.inactive: inactivePropeller,
      PowerupState.active: activePropeller
    };
    current = super.state;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    ///Same as Jetpack class
    if (other is Dash && !other.hasPowerup && parent is Cloud) {
      removeFromParent();
      current = PowerupState.active;
      position = Vector2(45.0, 10.0);
      addToParent(gameRef.dash);
      other.powerup = this;
    }
  }
}
