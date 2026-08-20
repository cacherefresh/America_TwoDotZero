import 'package:flutter/material.dart';
import '../config/nav_items.dart';

/// Home page with persistent navigation bar using IndexedStack.
///
/// Below [_mobileBreakpoint] the horizontal icon row is replaced by a
/// hamburger button that slides out a panel (icon + short description per
/// app) below the app bar, so the hamburger stays visible/tappable as a
/// toggle to close it again. Settings stays pinned top-right in both
/// layouts.
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

const double _mobileBreakpoint = 600;

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = navItems.indexWhere((e) => e.shortDescription == 'About');

  late final List<Widget> _pages = navItems.map((e) => e.page).toList();

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

  Widget _buildNavRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < navItems.length; i++)
          IconButton(
            tooltip: navItems[i].shortDescription,
            icon: navItems[i].icon,
            onPressed: () => _onNavButtonPressed(i),
            isSelected: _selectedIndex == i,
          ),
        const Spacer(),
        const Flexible(
          child: Text(
            'Donate: paypal.me/cacherefresh | cashapp: @cacherefresh',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Slide-out panel + its scrim, positioned to fill the body (i.e. already
  /// below the app bar) so the hamburger button above it stays visible and
  /// tappable as a toggle while the panel is open.
  Widget _buildSlideOutPanel(BuildContext context) {
    final panelWidth = MediaQuery.of(context).size.width * 2 / 3;
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _drawerOpen ? 1 : 0,
            child: IgnorePointer(
              ignoring: !_drawerOpen,
              child: GestureDetector(
                onTap: () => setState(() => _drawerOpen = false),
                child: Container(color: Colors.black54),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          left: _drawerOpen ? 0 : -panelWidth,
          width: panelWidth,
          child: Material(
            elevation: 16,
            child: SafeArea(
              top: false,
              child: ListView(
                children: [
                  for (var i = 0; i < navItems.length; i++)
                    ListTile(
                      leading: navItems[i].icon,
                      title: Text(navItems[i].shortDescription),
                      selected: _selectedIndex == i,
                      onTap: () {
                        setState(() {
                          _selectedIndex = i;
                          _drawerOpen = false;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _drawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < _mobileBreakpoint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: false,
        leading: isMobile
            ? IconButton(
                tooltip: _drawerOpen ? 'Close menu' : 'Menu',
                icon: Icon(_drawerOpen ? Icons.close : Icons.menu),
                onPressed: () => setState(() => _drawerOpen = !_drawerOpen),
              )
            : null,
        title: isMobile ? const Text('America 2.0') : _buildNavRow(),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      // Embedded app iframes are real DOM elements that otherwise swallow
      // pointer events meant for the panel painted above them, so fully
      // offstage them (index: null) rather than just hit-test-ignoring them.
      body: Stack(
        children: [
          IndexedStack(
            index: _drawerOpen ? null : _selectedIndex,
            children: _pages,
          ),
          if (isMobile) _buildSlideOutPanel(context),
        ],
      ),
    );
  }
}
