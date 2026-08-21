import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'config/app_registry.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apps = await loadInstalledApps();
  runApp(MyApp(apps: apps));
}

class MyApp extends StatefulWidget {
  final List<AppMeta> apps;

  const MyApp({super.key, required this.apps});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'America 2.0',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        apps: widget.apps,
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            _themeMode = mode;
          });
        },
        currentThemeMode: _themeMode,
      ),
    );
  }
}
