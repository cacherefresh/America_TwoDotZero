import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../config/app_registry.dart';
import 'holo_background_view.dart';
import 'holographic_scene_controller.dart';
import 'holographic_window.dart';

/// Immersive sci-fi landing page: a three.js particle/wireframe background
/// with a floating holographic window for every app in the top menu, all
/// visible and clickable without scrolling. Move the mouse for a parallax
/// response, and click a window to expand its app content.
class HolographicLandingPage extends StatefulWidget {
  const HolographicLandingPage({super.key});

  @override
  State<HolographicLandingPage> createState() =>
      _HolographicLandingPageState();
}

class _HolographicLandingPageState extends State<HolographicLandingPage> {
  static const _scene = HolographicSceneController();
  final ScrollController _scrollController = ScrollController();
  int? _expandedIndex;

  // The canvas matches the viewport 1:1 so every app orb is visible and
  // clickable without scrolling. Extra height (below 1.0) is only used as a
  // safety margin on very short/narrow viewports.
  static const double _virtualCanvasHeightFactor = 1.0;

  late final List<AppEntry> _apps = buildAppRegistry();

  late final List<AppSlot> _slots = [
    for (final app in _apps)
      AppSlot(
        name: app.name,
        description: app.description,
        glyph: app.orbGlyph,
        accentColor: app.accentColor,
        child: app.pageBuilder(),
      ),
  ];

  /// Evenly spaces orbs around an ellipse centered on the viewport, so a
  /// new [AppEntry] never needs a hand-picked position.
  Offset _anchorFor(int index, int total) {
    if (total == 1) return const Offset(0.5, 0.5);
    final angle = -math.pi / 2 + (2 * math.pi * index / total);
    const radiusX = 0.32;
    const radiusY = 0.28;
    return Offset(
      0.5 + radiusX * math.cos(angle),
      0.5 + radiusY * math.sin(angle),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() => _scene.updateScroll(_scrollController.offset);

  void _handlePointerHover(PointerHoverEvent event, Size viewSize) {
    _scene.updatePointer(
      Offset(
        (event.position.dx / viewSize.width) * 2 - 1,
        (event.position.dy / viewSize.height) * 2 - 1,
      ),
    );
  }

  void _toggleWindow(int index) {
    final next = _expandedIndex == index ? null : index;
    setState(() => _expandedIndex = next);
    _scene.setFocusedIndex(next ?? -1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewSize = constraints.biggest;
        final canvasHeight = viewSize.height * _virtualCanvasHeightFactor;
        final expandedWidth =
            viewSize.width < 700 ? viewSize.width * 0.92 : viewSize.width * 0.7;
        final expandedHeight = viewSize.height * 0.78;

        return MouseRegion(
          onHover: (event) => _handlePointerHover(event, viewSize),
          child: Stack(
            children: [
              const Positioned.fill(child: HoloBackgroundView()),
              SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  width: viewSize.width,
                  height: canvasHeight,
                  child: Stack(
                    // The expanded window (if any) must paint last so it
                    // sits above every collapsed orb, regardless of index.
                    children: [
                      for (var i = 0; i < _slots.length; i++)
                        if (i != _expandedIndex)
                          _buildOrb(
                            i,
                            viewSize,
                            canvasHeight,
                            expandedWidth,
                            expandedHeight,
                          ),
                      if (_expandedIndex != null)
                        _buildOrb(
                          _expandedIndex!,
                          viewSize,
                          canvasHeight,
                          expandedWidth,
                          expandedHeight,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrb(
    int index,
    Size viewSize,
    double canvasHeight,
    double expandedWidth,
    double expandedHeight,
  ) {
    final expanded = _expandedIndex == index;
    final anchor = _anchorFor(index, _slots.length);
    final baseLeft = anchor.dx * viewSize.width;
    final baseTop = anchor.dy * canvasHeight;

    final rect = expanded
        ? Rect.fromLTWH(
            (viewSize.width - expandedWidth) / 2,
            (baseTop - expandedHeight / 2).clamp(
              0,
              canvasHeight - expandedHeight,
            ),
            expandedWidth,
            expandedHeight,
          )
        : Rect.fromLTWH(baseLeft - 60, baseTop - 60, 120, 120);

    return AnimatedPositioned(
      key: ValueKey('holo-window-$index'),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Tooltip(
        message: _slots[index].name,
        child: HolographicWindow(
          slot: _slots[index],
          expanded: expanded,
          onToggle: () => _toggleWindow(index),
        ),
      ),
    );
  }
}
