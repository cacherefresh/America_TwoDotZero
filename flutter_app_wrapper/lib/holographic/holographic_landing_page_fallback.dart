import 'package:flutter/material.dart';

import 'under_construction_copy.dart';

/// Plain landing host shown on non-web platforms, where the three.js
/// holographic background isn't available.
///
/// Mirrors [HolographicLandingPage]'s contract: it owns the single mounted
/// copy of every app page and switches between them, so an app is never
/// built twice here either. Index 0 is the plain under-construction landing
/// text; index 1..n map to [appPages].
class HolographicLandingPageFallback extends StatelessWidget {
  const HolographicLandingPageFallback({
    super.key,
    required this.appPages,
    required this.selectedIndex,
  });

  /// The apps' page widgets, built once by the parent.
  final List<Widget> appPages;

  /// 0 for the landing text, otherwise the app's index in [appPages] + 1.
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: selectedIndex,
      children: [
        const SizedBox.expand(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Text(
                  underConstructionCopy,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        ...appPages,
      ],
    );
  }
}
