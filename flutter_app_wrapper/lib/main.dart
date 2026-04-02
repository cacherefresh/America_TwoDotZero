import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';

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

/// Home page with two buttons that push routes with animations.
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  Route _buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        // slide from right with ease-in-out curve
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
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
              tooltip: 'Web 2.0',
              icon: const Icon(Icons.public),
              onPressed: () {
                Navigator.of(context).push(_buildRoute(const Web2View()));
              },
            ),
            IconButton(
              tooltip: 'Game',
              icon: const Icon(Icons.videogame_asset),
              onPressed: () {
                Navigator.of(context).push(_buildRoute(const GameView()));
              },
            ),
            IconButton(
              tooltip: 'We the People',
              icon: const Icon(Icons.people),
              onPressed: () {
                Navigator.of(context).push(_buildRoute(const WeThePeopleView()));
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Select an app from the menu above',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
