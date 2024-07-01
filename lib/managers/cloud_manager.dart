import 'dart:math';

import 'package:doodle_dash/doodle_dash.dart';
import 'package:doodle_dash/managers/difficulty_manager.dart';
import 'package:doodle_dash/random_provider.dart';
import 'package:doodle_dash/sprites/clouds/cloud.dart';
import 'package:flame/components.dart';

class CloudManager extends Component with HasGameRef<DoodleDash> {
  final Random _random = RandomProvider.randomInstance;
  final List<Cloud> clouds = [];
  final CloudFactory _factory = CloudFactory();
  final DifficultyManager difficultyManager = DifficultyManager.instance;

  ///Represents the maximum and minimum(by making it negative) value of x coordinate.
  double _maxX = 0.0;

  @override
  void onMount() {
    ///Subtracting 50 (half the cloud width) so that cloud remains within screen.
    _maxX = gameRef.size.x / 2 - 50;

    ///The first cloud is always at the bottom of the screen
    double currentY = gameRef.size.y - (gameRef.size.y * .8);

    for (int i = 0; i < 10; ++i) {
      if (i != 0) {
        currentY = generateRandomY();
      }
      clouds.add(
          _factory.createRandomCloud(Vector2(generateRandomX(), currentY)));
    }

    for (final cloud in clouds) {
      add(cloud);
    }
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;

    final firstCloud = clouds.first;

    ///if the bottom most cloud is out of the screen, we remove it to optimize game
    ///and simultaneously generate a new cloud.
    if (!gameRef.camera.canSee(firstCloud)) {
      clouds.remove(firstCloud); //remove from list
      remove(firstCloud); //remove from the parent

      ///Generate new cloud and add it to the list as well as world
      final newCloud = _factory
          .createRandomCloud(Vector2(generateRandomX(), generateRandomY()));
      clouds.add(newCloud);
      add(newCloud);

      ///Do not update the score if dash is mega jumping
      if (!gameRef.dash.isMegaJump) {
        gameRef.score.value += 10;
      }
    }
  }

  ///Generate random x coordinate based on the value of [_maxX]
  double generateRandomX() => _random.nextInt((_maxX * 2).toInt()) - _maxX;

  ///Generate random y coordinate considering:
  /// - current top most cloud
  /// - min distance to next cloud
  /// - max distance to next cloud
  double generateRandomY() {
    final positionOfTopMostCloud = clouds.last.y;
    final nextY = difficultyManager.minDistanceToNextCloud +
        (_random.nextDouble() *
                (difficultyManager.maxDistanceToNextCloud -
                    difficultyManager.minDistanceToNextCloud))
            .floor();
    return positionOfTopMostCloud - nextY;
  }
}
