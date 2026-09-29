import 'dart:ui';

import 'interop/holo_bridge.dart';

/// Forwards pointer/scroll/focus input from the Flutter window layout
/// into the three.js background scene so both react to the same signals.
class HolographicSceneController {
  const HolographicSceneController({this.bridge = const HoloBridge()});

  final HoloBridge bridge;

  /// [normalized] components are expected in roughly [-1, 1].
  void updatePointer(Offset normalized) {
    bridge.setPointer(normalized.dx, normalized.dy);
  }

  void updateScroll(double offset) {
    bridge.setScroll(offset);
  }

  void setFocusedIndex(int index) {
    bridge.setFocus(index);
  }
}
