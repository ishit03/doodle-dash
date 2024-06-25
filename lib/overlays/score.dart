import 'package:doodle_dash/doodle_dash.dart';
import 'package:flutter/material.dart';

class ScoreOverlay extends StatelessWidget {
  const ScoreOverlay({required this.game, super.key});

  final DoodleDash game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
                valueListenable: game.score,
                builder: (context, value, child) {
                  return Text(
                    'SCORE - $value',
                    style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white60),
                  );
                }),
            Expanded(child: Container()),
            Text(
              'Hi - ${game.highScore}',
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white60),
            )
          ],
        ),
      ),
    );
  }
}
