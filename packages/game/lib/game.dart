library game;

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// A simple scaffold representing the game body.
class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CoreUtils.welcomeMessage(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const Text(
              'Game Scaffold',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
