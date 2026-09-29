import 'dart:ui';

import 'package:flutter/material.dart';

import 'under_construction_copy.dart';

/// Glass-morphic strip pinned along the bottom of the holographic landing
/// page, carrying the site's under-construction notice and donation pledge.
///
/// Collapsed it shows [underConstructionHeadline] and [donationHandles] —
/// enough that the 52% pledge is on screen without any interaction. Tapping
/// it grows the strip upward into a scrollable panel holding
/// [underConstructionCopy] in full.
///
/// The landing page reserves [collapsedHeight] out of its orb canvas, so the
/// collapsed strip never covers an orb; the expanded panel is allowed to
/// float over them.
class UnderConstructionBanner extends StatelessWidget {
  const UnderConstructionBanner({
    super.key,
    required this.expanded,
    required this.onToggle,
    required this.expandedHeight,
  });

  /// Vertical space the collapsed strip occupies, and the amount the landing
  /// page keeps clear at the bottom of its orb canvas.
  static const double collapsedHeight = 104;

  static const Color _accent = Color(0xFFFFC14D);

  final bool expanded;
  final VoidCallback onToggle;

  /// Height of the panel when [expanded]; the landing page sizes this from
  /// the viewport so the panel never outgrows the screen.
  final double expandedHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      height: expanded ? expandedHeight : collapsedHeight,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _accent.withValues(alpha: 0.7))),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _accent.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onToggle,
                child: expanded ? _buildExpanded(context) : _buildCollapsed(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsed() {
    // Each line is Flexible so that a narrow viewport, a large system text
    // scale or a longer headline shrinks the lines instead of overflowing a
    // strip whose height the landing page has already reserved.
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              underConstructionHeadline,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Flexible(
            child: Text(
              donationHandles,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _accent.withValues(alpha: 0.95),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 2),
          const Flexible(
            child: Text(
              'tap to read the whole thing  ▲',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'A note from the one man show',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_down,
                    color: Colors.white70),
                onPressed: onToggle,
                tooltip: 'Collapse',
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              underConstructionCopy,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
