import 'dart:async';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:doodle_dash/sprites/clouds/thunder_cloud.dart';
import 'package:doodle_dash/sprites/powerups/powerup.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

class Dash extends SpriteComponent
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Dash() : super(priority: 3, anchor: Anchor.center, size: Vector2.all(100.0));

  //Use these variables to handle difficulty too.
  //Come up with factors to increase these variables
  final double _jumpSpeed = 500.0;
  late final double _moveSpeed = (gameRef.size.x * .5).ceilToDouble();
  final double _gravity = 6.0;

  Vector2 _velocity = Vector2.zero();

  ///1: going right -1: going left
  int _hAxis = 0;

  bool isFacingLeft = true;

  ///X - coordinate to check if dash is out of the screen
  late final double outOfScreenX = gameRef.size.x / 2 + size.x / 2;
  bool _megaJump = false;

  ///To make sure Dash does not equip multiple powerups.
  Powerup? powerup;

  bool get hasPowerup => powerup != null;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    await add(CircleHitbox());
    sprite = await gameRef.loadSprite('dash.webp');
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;

    ///To avoid calculating score when dash is mega jumping
    if (_megaJump && _velocity.y > 0) _megaJump = false;

    ///Remove powerup when the powerup jump is completed.
    ///BUG: Sometimes when the powerup jump is completed and at the same moment
    ///dash jumps off the cloud, the powerup won't be released.
    ///Rarely happens.
    if (isGoingDown && hasPowerup) {
      powerup!.removeFromParent();
      powerup = null;
    }

    _velocity.x = _hAxis * _moveSpeed;

    ///We want to apply same gravity to screens with different FPS.
    ///The dt for 60 FPS screen will be ~0.016, while for the 120 FPS it will be
    ///around ~0.008. Hence applying constant gravity will lead to lower jumps on
    ///the screen with higher FPS. So we take base FPS as 60 and calculate the
    ///gravity dynamically from that, ensuring same behavior on different screens.
    _velocity.y += (_gravity * dt / 0.016);

    ///Infinite horizontal dash movement
    ///When dash goes out of the screen bounds from left side
    if (position.x < -outOfScreenX) {
      position.x = outOfScreenX;

      ///When dash goes out of the screen bounds from right side
    } else if (position.x > outOfScreenX) {
      position.x = -outOfScreenX;
    }
    position += _velocity * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxis = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _maybeChangeDirection(isGoingLeft: true);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _maybeChangeDirection(isGoingLeft: false);
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Cloud) {
      ///25.0 = half the height of cloud. To get the top y of cloud.
      ///50.0 = half the height of dash. To get the bottom y of dash.
      final bool isIntersecting =
          ((other.y - 25.0) - (position.y + 50.0)).abs() < 10;
      if (isGoingDown && isIntersecting) {
        jump();
        if (other is ThunderCloud) {
          other.scaleDown();
        }
      }
    }
  }

  @override
  void onChildrenChanged(Component child, ChildrenChangeType type) {
    if (type == ChildrenChangeType.added && hasPowerup) {
      if (child is Jetpack) {
        _velocity.y = -(_jumpSpeed * 2);
      }
      if (child is PropellerHat) {
        _velocity.y = -(_jumpSpeed * 1.5);
      }
    }
  }

  bool get isGoingDown => _velocity.y > 0;

  bool get isMegaJump => _megaJump;

  ///isGoingLeft means the user pressed/gestured to move left
  void _maybeChangeDirection({required bool isGoingLeft}) {
    if (isGoingLeft) {
      if (!isFacingLeft) {
        flipHorizontally();
        isFacingLeft = true;
      }
      _hAxis = -1;
    } else {
      if (isFacingLeft) {
        flipHorizontally();
        isFacingLeft = false;
      }
      _hAxis = 1;
    }
  }

  ///Handles movement for horizontal gestures
  void move(double x) {
    _hAxis = 0;
    if (x > 0) {
      _maybeChangeDirection(isGoingLeft: false);
    }
    if (x < 0) {
      _maybeChangeDirection(isGoingLeft: true);
    }
  }

  void megaJump() {
    _megaJump = true;
    _velocity.y = -(_jumpSpeed * 2);
  }

  void jump() {
    _velocity.y = -_jumpSpeed;
  }

  void reset() {
    _velocity = Vector2.zero();
    position = Vector2.zero();
    if (hasPowerup) {
      remove(powerup!);
      powerup = null;
    }
  }
}
