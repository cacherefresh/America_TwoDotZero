import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'game.dart';

final AppMeta gameMeta = AppMeta(
  id: 'game',
  icon: const Icon(Icons.videogame_asset),
  shortDescription: 'Guilds',
  longDescription: 'Guilds — an in-browser game demo and interactive experience.',
  page: const GameView(),
);
