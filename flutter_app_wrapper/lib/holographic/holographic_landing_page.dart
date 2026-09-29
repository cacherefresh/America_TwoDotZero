import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../config/app_registry.dart';
import 'holo_background_view.dart';
import 'holographic_scene_controller.dart';
import 'holographic_window.dart';
import 'under_construction_banner.dart';

/// Immersive sci-fi landing page: a three.js particle/wireframe background
/// with a floating holographic window for every app in the top menu, all
/// visible and clickable without scrolling. Move the mouse for a parallax
/// response, and click a window to expand its app content.
///
/// This page is also the single host for every app's content. [appPages]
/// arrives already built from [MyHomePage] and each entry is mounted here
/// exactly once; selecting an app in the top nav bar sets [focusedIndex],
/// which promotes that app's existing window to
/// [HoloWindowMode.fullscreen] rather than building a second copy of it.
class HolographicLandingPage extends StatefulWidget {
  const HolographicLandingPage({
    super.key,
    required this.apps,
    required this.appPages,
    required this.focusedIndex,
    required this.onExitFocus,
  });

  final List<AppEntry> apps;

  /// One widget per entry in [apps], built once by the parent. Parallel to
  /// [apps] by index.
  final List<Widget> appPages;

  /// Index into [apps] of the app selected in the top nav bar, or -1 when
  /// Home is selected and the landing page proper is showing.
  final int focusedIndex;

  /// Invoked when a full-screen app asks to return to the landing page.
  final VoidCallback onExitFocus;

  @override
  State<HolographicLandingPage> createState() => _HolographicLandingPageState();
}

class _HolographicLandingPageState extends State<HolographicLandingPage> {
  static const _scene = HolographicSceneController();
  final ScrollController _scrollController = ScrollController();

  /// Orb the visitor opened by clicking it on the landing page. Distinct
  /// from [widget.focusedIndex], which comes from the top nav bar and shows
  /// the app full-screen instead.
  int? _expandedIndex;

  late final List<AppSlot> _slots = [
    for (var i = 0; i < widget.apps.length; i++)
      AppSlot(
        name: widget.apps[i].name,
        description: widget.apps[i].description,
        glyph: widget.apps[i].orbGlyph,
        accentColor: widget.apps[i].accentColor,
        child: widget.appPages[i],
      ),
  ];

  bool get _isFocused => widget.focusedIndex >= 0;

  /// Whichever window is currently promoted above the others, if any.
  int? get _highlightedIndex => _isFocused ? widget.focusedIndex : _expandedIndex;

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
  void didUpdateWidget(HolographicLandingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Picking an app from the nav bar supersedes an orb the visitor had
    // opened, so the landing page isn't still holding it open underneath.
    if (widget.focusedIndex != oldWidget.focusedIndex) {
      if (_isFocused && _expandedIndex != null) {
        _expandedIndex = null;
      }
      _scene.setFocusedIndex(_highlightedIndex ?? -1);
    }
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
    // A full-screen app's close action belongs to the nav bar, not here.
    if (_isFocused) {
      widget.onExitFocus();
      return;
    }
    final next = _expandedIndex == index ? null : index;
    setState(() => _expandedIndex = next);
    _scene.setFocusedIndex(next ?? -1);
  }

  void _toggleBanner() => setState(() => _bannerExpanded = !_bannerExpanded);

  bool _bannerExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewSize = constraints.biggest;

        // Orbs are laid out above the collapsed banner so the strip never
        // covers one; a full-screen app still gets the whole viewport.
        final orbAreaHeight = math.max(
          120.0,
          viewSize.height - UnderConstructionBanner.collapsedHeight,
        );
        final expandedWidth =
            viewSize.width < 700 ? viewSize.width * 0.92 : viewSize.width * 0.7;
        final expandedHeight = orbAreaHeight * 0.86;
        final highlighted = _highlightedIndex;

        return MouseRegion(
          onHover: (event) => _handlePointerHover(event, viewSize),
          child: Stack(
            children: [
              const Positioned.fill(child: HoloBackgroundView()),
              SingleChildScrollView(
                controller: _scrollController,
                child: SizedBox(
                  width: viewSize.width,
                  height: viewSize.height,
                  child: Stack(
                    // The promoted window (if any) must paint last so it
                    // sits above every collapsed orb, regardless of index.
                    children: [
                      for (var i = 0; i < _slots.length; i++)
                        if (i != highlighted)
                          _buildWindow(i, viewSize, orbAreaHeight,
                              expandedWidth, expandedHeight),
                      if (highlighted != null)
                        _buildWindow(highlighted, viewSize, orbAreaHeight,
                            expandedWidth, expandedHeight),
                    ],
                  ),
                ),
              ),
              if (!_isFocused)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: UnderConstructionBanner(
                    expanded: _bannerExpanded,
                    onToggle: _toggleBanner,
                    expandedHeight: math.max(
                      UnderConstructionBanner.collapsedHeight,
                      viewSize.height * 0.6,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWindow(
    int index,
    Size viewSize,
    double orbAreaHeight,
    double expandedWidth,
    double expandedHeight,
  ) {
    final mode = _modeFor(index);
    final anchor = _anchorFor(index, _slots.length);
    final baseLeft = anchor.dx * viewSize.width;
    final baseTop = anchor.dy * orbAreaHeight;

    final Rect rect;
    switch (mode) {
      case HoloWindowMode.fullscreen:
        rect = Rect.fromLTWH(0, 0, viewSize.width, viewSize.height);
      case HoloWindowMode.window:
        rect = Rect.fromLTWH(
          (viewSize.width - expandedWidth) / 2,
          (baseTop - expandedHeight / 2)
              .clamp(0.0, math.max(0.0, orbAreaHeight - expandedHeight)),
          expandedWidth,
          expandedHeight,
        );
      case HoloWindowMode.orb:
        rect = Rect.fromLTWH(baseLeft - 60, baseTop - 60, 120, 120);
    }

    // While one app is full-screen the other orbs are hidden, but stay
    // mounted and keep their laid-out size — the same mechanism the window
    // already uses internally, so their iframes are never torn down.
    final visible = !_isFocused || index == widget.focusedIndex;

    return AnimatedPositioned(
      key: ValueKey('holo-window-$index'),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Visibility(
        visible: visible,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        maintainInteractivity: false,
        // The name tooltip lives on the orb glyph inside the window, not out
        // here — wrapping the whole window would pop a tooltip over an entire
        // full-screen app.
        child: HolographicWindow(
          slot: _slots[index],
          mode: mode,
          onToggle: () => _toggleWindow(index),
        ),
      ),
    );
  }

  HoloWindowMode _modeFor(int index) {
    if (_isFocused) {
      return index == widget.focusedIndex
          ? HoloWindowMode.fullscreen
          : HoloWindowMode.orb;
    }
    return index == _expandedIndex ? HoloWindowMode.window : HoloWindowMode.orb;
  }
}
