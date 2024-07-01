import 'dart:async';

import 'package:doodle_dash/sprites/clouds/cloud.dart';

class NormalCloud extends Cloud {
  NormalCloud({required super.position, super.powerup});

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('normal_cloud.webp');
  }
}
