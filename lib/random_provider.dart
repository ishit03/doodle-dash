import 'dart:math';

class RandomProvider {
  RandomProvider._(); //To prevent instantiation of this class

  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  static Random get randomInstance => _random;
}
