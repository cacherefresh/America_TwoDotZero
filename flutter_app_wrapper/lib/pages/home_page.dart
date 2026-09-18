import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_registry.dart';
import '../holographic/holographic_landing_page.dart';
import '../holographic/holographic_landing_page_fallback.dart';

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
  int _selectedIndex = 0;

  late final List<AppEntry> _apps = buildAppRegistry();

  late final List<Widget> _pages = [
    kIsWeb
        ? const HolographicLandingPage()
        : const HolographicLandingPageFallback(),
    for (final app in _apps) app.pageBuilder(),
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
            for (var i = 0; i < _apps.length; i++)
              _apps[i].navIconBuilder(
                () => _onNavButtonPressed(i + 1),
                _selectedIndex == i + 1,
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
