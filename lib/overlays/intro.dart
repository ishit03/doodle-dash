import 'package:doodle_dash/doodle_dash.dart';
import 'package:flutter/material.dart';

class IntroOverlay extends StatelessWidget {
  const IntroOverlay({required this.game, super.key});

  final DoodleDash game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.shade100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('DOODLE DASH',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => game.startGame(), child: const Text('PLAY'))
          ],
        ),
      ),
    );
  }
}
