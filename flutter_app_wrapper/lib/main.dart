import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'holographic/interop/holo_view_factory.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  if (kIsWeb) {
    registerHoloViewFactory();
  }
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: MyHomePage(
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
