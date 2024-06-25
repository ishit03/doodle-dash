import 'dart:async';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/sprites/sprites.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum DashDirection { left, right }

class Dash extends SpriteGroupComponent<DashDirection>
    with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks {
  Dash() : super(priority: 2, anchor: Anchor.center, size: Vector2.all(100.0));

  double _jumpSpeed = 0.0;
  double _moveSpeed = 0.0;
  double _gravity = 0.0;

  Vector2 _velocity = Vector2.zero();
  int _hAxis = 0; //1: going right -1: going left

  late final double outOfScreenX;
  bool _megaJump = false;

  bool isPaused = false; //Testing only

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    _initialize();

    await add(CircleHitbox(
        radius: 30, position: Vector2(50, 100), anchor: Anchor.bottomCenter));
    final dashLeft = await gameRef.loadSprite('left_dash.png');
    final dashRight = await gameRef.loadSprite('right_dash.png');

    //X-coordinate used to check if dash is out of the screen width
    outOfScreenX = gameRef.size.x / 2 + size.x / 2;

    sprites = {DashDirection.left: dashLeft, DashDirection.right: dashRight};
    current = DashDirection.right;
  }

  @override
  void update(double dt) {
    if (isPaused || !gameRef.isPlaying) return; //isPaused is testing only.

    //To avoid calculating score when dash is mega jumping
    if (_megaJump && _velocity.y > 0) _megaJump = false;

    _velocity.x = _hAxis * _moveSpeed;

    //We want to apply same gravity to screens with different FPS.
    //The dt for 60 FPS screen will be ~0.016, while for the 120 FPS it will be
    //around ~0.008. Hence applying constant gravity will lead to lower jumps on
    //the screen with higher FPS. So we take base FPS as 60 and calculate the
    //gravity dynamically from that, ensuring same behavior on different screens.
    _velocity.y += (_gravity * dt / 0.016);

    //Infinite horizontal dash movement
    //When dash goes out of the screen bounds from left side
    if (position.x < -outOfScreenX) {
      position.x = outOfScreenX;
      //When dash goes out of the screen bounds from right side
    } else if (position.x > outOfScreenX) {
      position.x = -outOfScreenX;
    }

    position += _velocity * dt;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxis = 0; // To avoid dash infinitely moving in given direction

    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      current = DashDirection.left;
      _hAxis = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      current = DashDirection.right;
      _hAxis = 1;
    }

    //Testing purpose. Must be removed
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      jump();
    }
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      isPaused = !isPaused;
    }

    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //FIX: A bit of inaccuracy when the dash is on the edge of cloud.
    //Also jumps when the dash's bottom is at cloud bottom

    //NOTE: The inaccuracy is probably fixed by positioning the hit box of dash.
    //Re-test needed for accuracy testing.
    if (other is Cloud) {
      //final bool isGoingDown = _velocity.y > 0;
      final bool isIntersectingVertically =
          (intersectionPoints.first.y - other.y).abs() < 5;
      if (isGoingDown && isIntersectingVertically) {
        jump();
      }
    }
  }

  void _initialize() {
    _jumpSpeed = 600.0;
    _moveSpeed = (gameRef.size.x * .5).ceilToDouble();
    _gravity = 7.0;
  }

  bool get isGoingDown => _velocity.y > 0;

  bool get isMegaJump => _megaJump;

  //Handled movement on mobile horizontal gestures
  void move(double x) {
    _hAxis = 0;
    if (x > 0) {
      _hAxis = 1;
      current = DashDirection.right;
    }
    if (x < 0) {
      _hAxis = -1;
      current = DashDirection.left;
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
  }
}
