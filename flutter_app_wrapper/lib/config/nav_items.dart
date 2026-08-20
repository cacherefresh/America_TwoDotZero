import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';
import 'package:poe/poe.dart';
import 'package:abe/abe.dart';
import 'package:about/about.dart';
import '../widgets/animated_icons.dart';

/// A single top-nav entry: the icon/tooltip shown in the nav (desktop row or
/// mobile drawer) and the page it opens. Reorder or add entries here only —
/// the nav row, mobile drawer, and page stack are all built from this list.
class NavItem {
  final Widget icon;
  final String shortDescription;
  final Widget page;

  const NavItem({
    required this.icon,
    required this.shortDescription,
    required this.page,
  });
}

final List<NavItem> navItems = [
  NavItem(
    icon: const Icon(Icons.home),
    shortDescription: 'Home',
    page: const SizedBox.expand(child: Center(
      child: Text(
        'Select an app from the menu above! Have Fun!\n\n 🚧 UNDER CONSTRUCTION 🚧\n🦺not concepts of a plan 😂, \n🏗️ Everything is WELL DETAILED. ^_~ just not on the site yet. \n\n🏗️ I\'m a one man show🎶 at the moment ^_~\n----------------------------------- \n\n~I need funding, DONATIONS go a long way~\n\nDonate to:\n 💸 paypal.me/cacherefresh \n 💸 cashapp: @cacherefresh\n\n - 52% of all donations will go to resolving the actual problem. \nCould you IMAGINE AMERICA if every Political Candidate did this?\nWe would have every child fed, teachers paid well, AMAZING Infrastructure, the Border Walls of Troy, AND Free Healthcare, flying cars, etc etc... \n... but we got rallys, bumperstickers, ads, lawn ornaments of your favorite candidate and some half billion worth of political concerts.\n\n So I\'ll trendset and post receipts (give me time, I\'m human)',
        style: TextStyle(fontSize: 18),
      ),
    )),
  ),
  NavItem(
    icon: const Icon(Icons.public),
    shortDescription: 'Web 2.0',
    page: const Web2View(),
  ),
  NavItem(
    icon: const AnimatedWTPGlyph(),
    shortDescription: 'We the People',
    page: const WeThePeopleView(),
  ),
  NavItem(
    icon: const AnimatedPOEGlyph(),
    shortDescription: 'P.O.E.',
    page: const POEView(),
  ),
  NavItem(
    icon: const Icon(Icons.checklist),
    shortDescription: 'A.B.E.',
    page: const ABEView(),
  ),
  NavItem(
    icon: const Text('🪶', style: TextStyle(fontSize: 20)),
    shortDescription: 'About',
    page: const AboutView(),
  ),
  NavItem(
    icon: const Icon(Icons.videogame_asset),
    shortDescription: 'Guilds',
    page: const GameView(),
  ),
];
