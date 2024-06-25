import 'dart:async';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Cloud extends SpriteComponent with HasGameRef<DoodleDash> {
  Cloud({super.position}) : super(size: Vector2(100, 50), priority: 1);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    await add(RectangleHitbox(collisionType: CollisionType.passive));
    final cloud = await gameRef.loadSprite('cloud.png');
    sprite = cloud;
  }
}
