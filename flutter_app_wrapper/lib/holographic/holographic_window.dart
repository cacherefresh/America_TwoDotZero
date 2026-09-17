import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

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

/// A floating holographic interface: a small glowing orb when collapsed,
/// a glass-morphic bordered window when expanded.
///
/// [slot.child] is always mounted (via [Visibility.maintainState]), never
/// conditionally built — this keeps apps that register web platform
/// views/iframes in `initState` (GameView/POEView/ABEView) from being
/// remounted (and their iframes reloaded) every time this window opens
/// or closes.
class HolographicWindow extends StatefulWidget {
  const HolographicWindow({
    super.key,
    required this.slot,
    required this.expanded,
    required this.onToggle,
  });

  final AppSlot slot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  State<HolographicWindow> createState() => _HolographicWindowState();
}

class _HolographicWindowState extends State<HolographicWindow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driftController;

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
    final radius = widget.expanded ? 20.0 : 999.0;

    return AnimatedBuilder(
      animation: _driftController,
      builder: (context, child) {
        final drift = widget.expanded
            ? Offset.zero
            : Offset(
                6 * math.sin(_driftController.value * 2 * math.pi),
                6 * math.cos(_driftController.value * 2 * math.pi),
              );
        return Transform.translate(offset: drift, child: child);
      },
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: 0.25),
                Colors.black.withValues(alpha: 0.35),
              ],
            ),
            border: Border.all(
              color: accent.withValues(alpha: widget.expanded ? 0.9 : 0.6),
              width: widget.expanded ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.55),
                blurRadius: widget.expanded ? 30 : 18,
                spreadRadius: widget.expanded ? 2 : 1,
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
                      visible: !widget.expanded,
                      maintainState: true,
                      child: Center(
                        child: Text(
                          widget.slot.glyph,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Visibility(
                      visible: widget.expanded,
                      maintainState: true,
                      maintainAnimation: true,
                      maintainSize: true,
                      child: Column(
                        children: [
                          _buildTitleBar(context, accent),
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
