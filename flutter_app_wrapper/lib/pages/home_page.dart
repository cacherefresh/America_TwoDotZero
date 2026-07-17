import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';
import 'package:poe/poe.dart';
import 'package:abe/abe.dart';
import 'package:about/about.dart';
import '../widgets/animated_icons.dart';

/// Home page with persistent navigation bar using IndexedStack.
class MyHomePage extends StatefulWidget {
  final Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const MyHomePage({
    super.key,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 6;

  late final List<Widget> _pages = [
    const SizedBox.expand(child: Center(
      child: Text(
        'Select an app from the menu above! Have Fun!\n\n 🚧 UNDER CONSTRUCTION 🚧\n🦺not concepts of a plan 😂, \n🏗️ Everything is WELL DETAILED. ^_~ just not on the site yet. \n\n🏗️ I\'m a one man show🎶 at the moment ^_~\n----------------------------------- \n\n~I need funding, DONATIONS go a long way~\n\nDonate to:\n 💸 paypal.me/cacherefresh \n 💸 cashapp: @cacherefresh\n\n - 52% of all donations will go to resolving the actual problem. \nCould you IMAGINE AMERICA if every Political Candidate did this?\nWe would have every child fed, teachers paid well, AMAZING Infrastructure, the Border Walls of Troy, AND Free Healthcare, flying cars, etc etc... \n... but we got rallys, bumperstickers, ads, lawn ornaments of your favorite candidate and some half billion worth of political concerts.\n\n So I\'ll trendset and post receipts (give me time, I\'m human)',
        style: TextStyle(fontSize: 18),
      ),
    )),
    const Web2View(),
    const GameView(),
    const WeThePeopleView(),
    const POEView(),
    const ABEView(),
    const AboutView(),
  ];

  void _onNavButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                RadioListTile<ThemeMode>(
                  title: const Text('Light (Override)'),
                  value: ThemeMode.light,
                  groupValue: widget.currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      widget.onThemeModeChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark (Override)'),
                  value: ThemeMode.dark,
                  groupValue: widget.currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      widget.onThemeModeChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('System (Default)'),
                  value: ThemeMode.system,
                  groupValue: widget.currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    if (value != null) {
                      widget.onThemeModeChanged(value);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () => _onNavButtonPressed(0),
              isSelected: _selectedIndex == 0,
            ),
            IconButton(
              tooltip: 'Web 2.0',
              icon: const Icon(Icons.public),
              onPressed: () => _onNavButtonPressed(1),
              isSelected: _selectedIndex == 1,
            ),
            IconButton(
              tooltip: 'Game',
              icon: const Icon(Icons.videogame_asset),
              onPressed: () => _onNavButtonPressed(2),
              isSelected: _selectedIndex == 2,
            ),
            AnimatedWTPIcon(
              onPressed: () => _onNavButtonPressed(3),
              isSelected: _selectedIndex == 3,
            ),
            AnimatedPOEIcon(
              onPressed: () => _onNavButtonPressed(4),
              isSelected: _selectedIndex == 4,
            ),
            IconButton(
              tooltip: 'A.B.E.',
              icon: const Icon(Icons.checklist),
              onPressed: () => _onNavButtonPressed(5),
              isSelected: _selectedIndex == 5,
            ),
            IconButton(
              tooltip: 'About',
              icon: const Text('🪶', style: TextStyle(fontSize: 20)),
              onPressed: () => _onNavButtonPressed(6),
              isSelected: _selectedIndex == 6,
            ),
            const Spacer(),
            Flexible(
              child: Text(
              'Donate: paypal.me/cacherefresh | cashapp: @cacherefresh',
              style: TextStyle(fontSize: 14), 
              overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
