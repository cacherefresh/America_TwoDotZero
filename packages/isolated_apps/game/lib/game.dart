library game;

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// A widget that loads the Guilds game from GitHub Pages.
class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmbeddedWebContent(
      url: 'https://guilds.cacherefresh.io/',
    );
  }
}
