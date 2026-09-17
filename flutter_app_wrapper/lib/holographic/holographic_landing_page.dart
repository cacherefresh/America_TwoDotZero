import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:web_2/web_2.dart';
import 'package:game/game.dart';
import 'package:we_the_people/we_the_people.dart';
import 'package:poe/poe.dart';
import 'package:abe/abe.dart';

import '../config/app_config.dart';
import 'holo_background_view.dart';
import 'holographic_scene_controller.dart';
import 'holographic_window.dart';

/// Immersive sci-fi landing page: a three.js particle/wireframe background
/// with a floating holographic window for each app. Move the mouse for a
/// parallax response, scroll to reveal windows further down the canvas,
/// and click a window to expand its app content.
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

  static const double _virtualCanvasHeightFactor = 3.2;

  // Fractional (0..1) anchor positions within the virtual canvas.
  static const List<Offset> _orbAnchors = [
    Offset(0.2, 0.12),
    Offset(0.82, 0.28),
    Offset(0.25, 0.52),
    Offset(0.78, 0.75),
    Offset(0.5, 0.92),
  ];

  late final List<AppSlot> _slots = [
    AppSlot(
      name: AppConfig.web2Name,
      description: AppConfig.web2Description,
      glyph: '📖',
      accentColor: const Color(0xFF00E5FF),
      child: const Web2View(),
    ),
    AppSlot(
      name: AppConfig.gameName,
      description: AppConfig.gameDescription,
      glyph: '🎮',
      accentColor: const Color(0xFF8A5CFF),
      child: const GameView(),
    ),
    AppSlot(
      name: AppConfig.weThePeopleName,
      description: AppConfig.weThePeopleDescription,
      glyph: '🏛️',
      accentColor: const Color(0xFFFF5CF0),
      child: const WeThePeopleView(),
    ),
    AppSlot(
      name: AppConfig.poeName,
      description: AppConfig.poeDescription,
      glyph: '🕊️',
      accentColor: const Color(0xFF5CFFB0),
      child: const POEView(),
    ),
    AppSlot(
      name: AppConfig.abeName,
      description: AppConfig.abeDescription,
      glyph: '📋',
      accentColor: const Color(0xFFFFD75C),
      child: const ABEView(),
    ),
  ];

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
                    children: [
                      for (var i = 0; i < _slots.length; i++)
                        _buildOrb(
                          i,
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
    final anchor = _orbAnchors[index];
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
