import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../config/app_registry.dart';

/// Home page with persistent navigation bar using IndexedStack.
///
/// The app list ([MyHomePage.apps]) is resolved before `runApp` by reading
/// `assets/list_of_apps_config.yaml` (see `app_registry.dart`) -- this page
/// just renders whatever it's given, prefixed with the OS's own Home screen.
///
/// Below [_mobileBreakpoint] the horizontal icon row is replaced by a
/// hamburger button that slides out a panel (icon + short description per
/// app) below the app bar, so the hamburger stays visible/tappable as a
/// toggle to close it again. Settings stays pinned top-right in both
/// layouts.
class MyHomePage extends StatefulWidget {
  final List<AppMeta> apps;
  final Function(ThemeMode) onThemeModeChanged;
  final ThemeMode currentThemeMode;

  const MyHomePage({
    super.key,
    required this.apps,
    required this.onThemeModeChanged,
    required this.currentThemeMode,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const double _mobileBreakpoint = 600;

class _MyHomePageState extends State<MyHomePage> {
  late final List<AppMeta> _apps = [homeMeta, ...widget.apps];
  late final List<Widget> _pages = _apps.map((e) => e.page).toList();
  // Home is always _apps[0] -- see the constructor above.
  int _selectedIndex = 0;

  bool _drawerOpen = false;

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
        for (var i = 0; i < _apps.length; i++)
          IconButton(
            tooltip: _apps[i].longDescription,
            icon: _apps[i].icon,
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
  static const _panelCornerRadius = BorderRadius.only(
    topRight: Radius.circular(16),
    bottomRight: Radius.circular(16),
  );

  Widget _buildSlideOutPanel(BuildContext context) {
    final panelWidth = MediaQuery.of(context).size.width * 2 / 3;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 80% opaque / 20% see-through, tinted light purple in light mode and
    // dark grey in dark mode, with a matching dark-purple accent border.
    final panelColor = isDark
        ? Colors.grey.shade900.withValues(alpha: 0.8)
        : colorScheme.primaryContainer.withValues(alpha: 0.8);
    final borderColor =
        isDark ? colorScheme.primaryContainer : colorScheme.primary;

    return Stack(
      children: [
        // Invisible tap-catcher to close on tap-outside -- fully see-through
        // so the page stays readable on the portion the panel doesn't cover.
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_drawerOpen,
            child: GestureDetector(
              onTap: () => setState(() => _drawerOpen = false),
              child: Container(color: Colors.transparent),
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
            color: Colors.transparent,
            elevation: 16,
            borderRadius: _panelCornerRadius,
            child: ClipRRect(
              borderRadius: _panelCornerRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: panelColor,
                    borderRadius: _panelCornerRadius,
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1.5),
                      right: BorderSide(color: borderColor, width: 1.5),
                      bottom: BorderSide(color: borderColor, width: 1.5),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: ListView(
                      children: [
                        for (var i = 0; i < _apps.length; i++)
                          ListTile(
                            leading: _apps[i].icon,
                            title: Text(_apps[i].shortDescription),
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
            ),
          ),
        ),
      ],
    );
  }

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
      // pointer events meant for the panel painted above them, even though
      // the panel paints on top -- so suppress just their pointer events
      // (not their visibility) while the panel is open.
      body: Stack(
        children: [
          SuppressEmbeddedInteraction(
            suppress: _drawerOpen,
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          if (isMobile) _buildSlideOutPanel(context),
        ],
      ),
    );
  }
}
