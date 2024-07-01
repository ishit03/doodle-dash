class DifficultyManager {
  static final DifficultyManager _instance = DifficultyManager._internal();

  DifficultyManager._internal();

  static DifficultyManager get instance => _instance;

  double minDistanceToNextCloud = 100.0;
  double maxDistanceToNextCloud = 300.0;

  ///The probabilities are cumulative probabilities to make it simple to use.

  //70% chance of normal cloud
  double normalCloudProbability = 7.0;

  //15% chance of moving cloud
  //normal cloud probability (7.0) + moving cloud probability (1.5)
  double movingCloudProbability = 8.5;

  //15% chance of thunder cloud
  //normal(7.0) + moving(1.5) + thunder(1.5)
  double thunderCloudProbability = 9.9;

  void handleScoreChange(int score) {
    ///We increase difficulty every multiple of 300
    if (score % 300 != 0 || score > 1500) return;

    if (score == 0) {
      _resetDifficulty();
    } else if (minDistanceToNextCloud != maxDistanceToNextCloud) {
      minDistanceToNextCloud += 50;
    } else {
      normalCloudProbability = 3.0;
      movingCloudProbability = 8.0;
    }
  }

  void _resetDifficulty() {
    minDistanceToNextCloud = 100.0;
    maxDistanceToNextCloud = 300.0;

    normalCloudProbability = 7.0;
    movingCloudProbability = 8.5;
    thunderCloudProbability = 9.9;
  }
}
