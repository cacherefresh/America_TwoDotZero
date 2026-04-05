import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';
import 'package:poe/poe.dart';
import 'package:abe/abe.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'America 2.0',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// Animated icon for We the People that alternates between people and declaration of independence icons every 2 seconds.
class _AnimatedWTPIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const _AnimatedWTPIcon({
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<_AnimatedWTPIcon> createState() => _AnimatedWTPIconState();
}

class _AnimatedWTPIconState extends State<_AnimatedWTPIcon> {
  late Timer _timer;
  bool _showPeople = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _showPeople = !_showPeople;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'We the People',
      icon: Text(
        _showPeople ? '👥' : '📜',
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: widget.onPressed,
      isSelected: widget.isSelected,
    );
  }
}

/// Animated icon for P.O.E. that alternates between peace dove and raven emojis every 2 seconds.
class _AnimatedPOEIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const _AnimatedPOEIcon({
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<_AnimatedPOEIcon> createState() => _AnimatedPOEIconState();
}

class _AnimatedPOEIconState extends State<_AnimatedPOEIcon> {
  late Timer _timer;
  bool _showDove = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _showDove = !_showDove;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'P.O.E.',
      icon: Text(
        _showDove ? '🕊️' : '🐦‍⬛',
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: widget.onPressed,
      isSelected: widget.isSelected,
    );
  }
}
/// Home page with persistent navigation bar using IndexedStack.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const SizedBox.expand(child: Center(
      child: Text(
        'Select an app from the menu above',
        style: TextStyle(fontSize: 18),
      ),
    )),
    const Web2View(),
    const GameView(),
    const WeThePeopleView(),
    const POEView(),
    const ABEView(),
  ];

  void _onNavButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            _AnimatedWTPIcon(
              onPressed: () => _onNavButtonPressed(3),
              isSelected: _selectedIndex == 3,
            ),
            _AnimatedPOEIcon(
              onPressed: () => _onNavButtonPressed(4),
              isSelected: _selectedIndex == 4,
            ),
            IconButton(
              tooltip: 'A.B.E.',
              icon: const Icon(Icons.checklist),
              onPressed: () => _onNavButtonPressed(5),
              isSelected: _selectedIndex == 5,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
