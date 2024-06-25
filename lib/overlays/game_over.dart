import 'package:doodle_dash/doodle_dash.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  const GameOver({required this.game, super.key});

  final DoodleDash game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GAME OVER',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.brown.shade800, fontWeight: FontWeight.bold),
            ),
            Text(
              'Score - ${game.score.value}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  game.resetGame();
                },
                child: const Text('PLAY AGAIN')),
          ],
        ),
      ),
    );
  }
}
