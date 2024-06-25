import 'dart:math';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/sprites/sprites.dart';
import 'package:flame/components.dart';

class CloudManager extends Component with HasGameRef<DoodleDash> {
  final Random _random = Random();
  final List<Cloud> clouds = [];

  double _minDistanceToNextCloud = 0.0;
  double _maxDistanceToNextCloud = 0.0;

  @override
  void onMount() {
    _initialize();
    //The first cloud is always at the bottom of the screen
    double currentY = gameRef.size.y - (gameRef.size.y * .8);

    for (int i = 0; i < 10; ++i) {
      if (i != 0) {
        currentY = generateRandomY();
      }
      clouds.add(Cloud(position: Vector2(generateRandomX(), currentY)));
    }

    for (final cloud in clouds) {
      add(cloud);
    }
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;

    final firstCloud = clouds.first;

    //if the bottom most cloud is out of the screen, we remove it to optimize game
    //and simultaneously generate a new cloud.
    if (!gameRef.camera.canSee(firstCloud)) {
      clouds.remove(firstCloud);
      remove(firstCloud);

      final newCloud =
          Cloud(position: Vector2(generateRandomX(), generateRandomY()));
      clouds.add(newCloud);
      add(newCloud);

      //Do not update the score if dash is mega jumping
      if (!gameRef.dash.isMegaJump) {
        gameRef.score.value += 10;
      }
    }
  }

  void _initialize() {
    _minDistanceToNextCloud = 250.0;
    _maxDistanceToNextCloud = 400.0;
  }

  //Generate x coordinate in range of -size.x / 2 to size.x / 2
  //The point (0,0) is at the center of the screen.
  //i.e if the width of screen is 500 then top left corner is (-250,-250)
  //We subtract 100 (width of cloud) so that clouds remain within the screen.
  double generateRandomX() =>
      _random.nextInt((gameRef.size.x - 100).toInt()) - (gameRef.size.x / 2);

  //Generate random y coordinate considering:
  // - current top most cloud
  // - min distance to next cloud
  // - max distance to next cloud
  double generateRandomY() {
    final positionOfTopMostCloud = clouds.last.y;
    final nextY = _minDistanceToNextCloud +
        (_random.nextDouble() *
                (_maxDistanceToNextCloud - _minDistanceToNextCloud))
            .floor();
    return positionOfTopMostCloud - nextY;
  }
}
