import 'dart:async';

import 'package:flame/components.dart';

class Cloud extends SpriteComponent with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    final cloud = await gameRef.loadSprite('cloud.png');

    size = Vector2.all(100);

    sprite = cloud;
  }
}
