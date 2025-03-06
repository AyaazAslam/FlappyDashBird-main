import 'dart:math';

class ProbabilityGenerator {
  ProbabilityGenerator();

  final Random _random = Random();

  bool generateWithProbability(double percent) {
    // generate a number 1-100 inclusive
    var randomInt = _random.nextInt(100) + 1;

    return randomInt <= percent;
  }
}
