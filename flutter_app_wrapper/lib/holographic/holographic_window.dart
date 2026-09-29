import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// How a [HolographicWindow] is currently presented.
enum HoloWindowMode {
  /// Small drifting glowing orb on the landing page.
  orb,

  /// Glass-morphic bordered window, opened by tapping the orb.
  window,

  /// Edge-to-edge opaque view, opened from the top nav bar. Visually the
  /// plain full-screen app tab, but backed by the same mounted widget as
  /// the orb so nothing is built twice.
  fullscreen,
}

/// Static app metadata + content shown inside a [HolographicWindow].
class AppSlot {
  const AppSlot({
    required this.name,
    required this.description,
    required this.glyph,
    required this.accentColor,
    required this.child,
  });

  final String name;
  final String description;
  final String glyph;
  final Color accentColor;
  final Widget child;
}

/// A floating holographic interface: a small glowing orb when collapsed, a
/// glass-morphic bordered window when tapped open, and an edge-to-edge view
/// when reached from the top nav bar.
///
/// [slot.child] is mounted exactly once for the life of the page and is
/// never rebuilt or repositioned when the mode changes. Every mode renders
/// the *same* tree shape — only decoration and [Visibility] flags differ —
/// because apps that register web platform views/iframes in `initState`
/// (Guilds/POE/ABE/About) would reload their iframe if this widget's child
/// slot ever moved in the tree.
class HolographicWindow extends StatefulWidget {
  const HolographicWindow({
    super.key,
    required this.slot,
    required this.mode,
    required this.onToggle,
  });

  final AppSlot slot;
  final HoloWindowMode mode;
  final VoidCallback onToggle;

  @override
  State<HolographicWindow> createState() => _HolographicWindowState();
}

class _HolographicWindowState extends State<HolographicWindow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driftController;

  bool get _isOrb => widget.mode == HoloWindowMode.orb;
  bool get _isWindow => widget.mode == HoloWindowMode.window;
  bool get _isFullscreen => widget.mode == HoloWindowMode.fullscreen;

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.slot.accentColor;
    final radius = _isOrb
        ? 999.0
        : _isWindow
            ? 20.0
            : 0.0;

    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, child) {
        final drift = _isOrb
            ? Offset(
                6 * math.sin(_driftController.value * 2 * math.pi),
                6 * math.cos(_driftController.value * 2 * math.pi),
              )
            : Offset.zero;
        return Transform.translate(offset: drift, child: child);
      },
      child: GestureDetector(
        // Only the orb toggles on a body tap; an open window closes from its
        // title bar, and a full-screen app must not swallow its own taps.
        onTap: _isOrb ? widget.onToggle : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isFullscreen
                  // Opaque, so the three.js scene cannot bleed through an
                  // app page that has its own translucent background.
                  ? const [Color(0xFF05060B), Color(0xFF05060B)]
                  : [
                      accent.withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.35),
                    ],
            ),
            border: _isFullscreen
                ? null
                : Border.all(
                    color: accent.withValues(alpha: _isWindow ? 0.9 : 0.6),
                    width: _isWindow ? 1.5 : 1,
                  ),
            boxShadow: _isFullscreen
                ? null
                : [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.55),
                      blurRadius: _isWindow ? 30 : 18,
                      spreadRadius: _isWindow ? 2 : 1,
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Visibility(
                      visible: _isOrb,
                      maintainState: true,
                      child: Tooltip(
                        message: widget.slot.name,
                        child: Center(
                          child: Text(
                            widget.slot.glyph,
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: !_isOrb,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: Column(
                        children: [
                          // Always present so [slot.child] keeps a stable
                          // slot in the Column; it just collapses to zero
                          // height outside window mode.
                          Visibility(
                            visible: _isWindow,
                            child: _buildTitleBar(context, accent),
                          ),
                          Expanded(child: widget.slot.child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: accent.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.slot.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  widget.slot.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: widget.onToggle,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }
}
