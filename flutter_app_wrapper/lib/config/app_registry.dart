import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';
import 'package:poe/poe.dart';
import 'package:abe/abe.dart';

import '../widgets/animated_icons.dart';
import 'app_config.dart';

/// One registered app. Appears as a top-menu nav button in [MyHomePage]
/// and as a floating orb on [HolographicLandingPage] — add an entry to
/// [buildAppRegistry] to add the app to both places at once.
class AppEntry {
  const AppEntry({
    required this.id,
    required this.navIconBuilder,
    required this.orbGlyph,
    required this.accentColor,
    required this.name,
    required this.description,
    required this.pageBuilder,
  });

  final String id;
  final Widget Function(VoidCallback onPressed, bool isSelected)
      navIconBuilder;
  final String orbGlyph;
  final Color accentColor;
  final String name;
  final String description;
  final Widget Function() pageBuilder;
}

/// Ordered list of apps shown in the top menu (after Home) and as
/// holographic orbs on the landing page. Requires [AppConfig.initialize]
/// to have already completed (guaranteed by `main()`).
List<AppEntry> buildAppRegistry() => [
      AppEntry(
        id: 'web_2',
        navIconBuilder: (onPressed, isSelected) => IconButton(
          tooltip: AppConfig.web2Name,
          icon: const Icon(Icons.public),
          onPressed: onPressed,
          isSelected: isSelected,
        ),
        orbGlyph: '📖',
        accentColor: const Color(0xFF00E5FF),
        name: AppConfig.web2Name,
        description: AppConfig.web2Description,
        pageBuilder: () => const Web2View(),
      ),
      AppEntry(
        id: 'game',
        navIconBuilder: (onPressed, isSelected) => IconButton(
          tooltip: AppConfig.gameName,
          icon: const Icon(Icons.videogame_asset),
          onPressed: onPressed,
          isSelected: isSelected,
        ),
        orbGlyph: '🎮',
        accentColor: const Color(0xFF8A5CFF),
        name: AppConfig.gameName,
        description: AppConfig.gameDescription,
        pageBuilder: () => const GameView(),
      ),
      AppEntry(
        id: 'we_the_people',
        navIconBuilder: (onPressed, isSelected) => AnimatedWTPIcon(
          onPressed: onPressed,
          isSelected: isSelected,
        ),
        orbGlyph: '🏛️',
        accentColor: const Color(0xFFFF5CF0),
        name: AppConfig.weThePeopleName,
        description: AppConfig.weThePeopleDescription,
        pageBuilder: () => const WeThePeopleView(),
      ),
      AppEntry(
        id: 'poe',
        navIconBuilder: (onPressed, isSelected) => AnimatedPOEIcon(
          onPressed: onPressed,
          isSelected: isSelected,
        ),
        orbGlyph: '🕊️',
        accentColor: const Color(0xFF5CFFB0),
        name: AppConfig.poeName,
        description: AppConfig.poeDescription,
        pageBuilder: () => const POEView(),
      ),
      AppEntry(
        id: 'abe',
        navIconBuilder: (onPressed, isSelected) => IconButton(
          tooltip: AppConfig.abeName,
          icon: const Icon(Icons.checklist),
          onPressed: onPressed,
          isSelected: isSelected,
        ),
        orbGlyph: '📋',
        accentColor: const Color(0xFFFFD75C),
        name: AppConfig.abeName,
        description: AppConfig.abeDescription,
        pageBuilder: () => const ABEView(),
      ),
    ];
