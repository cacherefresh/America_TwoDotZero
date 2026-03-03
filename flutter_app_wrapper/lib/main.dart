import 'package:flutter/material.dart';

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
      routes: {
        '/web2.0': (context) => const Web2View(),
        '/game': (context) => const GameView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentView = 'web2.0';

  void _navigateToView(String view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('menu'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () => _navigateToView('web2.0'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'web2.0'
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  child: const Text('web2.0'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _navigateToView('game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentView == 'game'
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  child: const Text('game'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _currentView == 'web2.0' ? const Web2View() : const GameView(),
    );
  }
}

class Web2View extends StatelessWidget {
  const Web2View({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'hello world',
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'game',
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}
