library game;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_view/markdown_view.dart';

/// A simple scaffold representing the game body.
class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assets/vault/MDs/IDEA_TEMPLATE.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return MarkdownDisplay(markdownText: snapshot.data ?? '');
          }
        },
      ),
    );
  }
}
