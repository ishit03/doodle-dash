import 'dart:async';

import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:doodle_dash/sprites/dash.dart';
import 'package:flame/components.dart';

import 'abstract_powerup.dart';
import 'powerup_state.dart';

class Jetpack extends Powerup {
  Jetpack({required super.position, super.state = PowerupState.inactive})
      : super(size: Vector2(35.0, 70.0));

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    final inactiveJetpack = await gameRef.loadSpriteAnimation(
        'jetpack_idle.webp',
        SpriteAnimationData.sequenced(
            amount: 1, stepTime: 1, textureSize: Vector2(100.0, 250.0)));
    final activeJetpack = await gameRef.loadSpriteAnimation(
        'jetpack_sprites.webp',
        SpriteAnimationData.sequenced(
            amount: 4, stepTime: 0.1, textureSize: Vector2(100.0, 250.0)));
    animations = {
      PowerupState.inactive: inactiveJetpack,
      PowerupState.active: activeJetpack
    };
    current = super.state;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    ///We check if the parent is Cloud because when the powerup has been used
    ///it will still be inside the bounds of Dash's hit box, hence this function
    ///will be called again and the powerup will always stay attached.
    ///So we use [parent is Cloud] to equip powerup only if the parent is cloud.
    if (other is Dash && !other.hasPowerup && parent is Cloud) {
      removeFromParent();
      current = PowerupState.active;
      position = Vector2(80.0, 50.0);
      addToParent(gameRef.dash);
      other.powerup = this;
    }
  }
}
