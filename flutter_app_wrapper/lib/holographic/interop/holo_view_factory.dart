import 'dart:ui_web' as ui_web;

import 'holo_bridge.dart';

/// Stable platform-view id for the three.js background host element.
const holoViewType = 'holo-three-host';

bool _registered = false;

/// Registers the platform view factory that hosts the three.js canvas.
///
/// Must be called exactly once, before the first [HtmlElementView] using
/// [holoViewType] is built (see `main.dart`) — registering more than once
/// per id is a silent no-op in the engine, but calling this lazily from a
/// widget that can be disposed/rebuilt would defeat the "mount once" design
/// the rest of the holographic layer relies on.
void registerHoloViewFactory() {
  if (_registered) return;
  _registered = true;
  const bridge = HoloBridge();
  ui_web.platformViewRegistry.registerViewFactory(
    holoViewType,
    (int viewId) => bridge.createHostElement(viewId),
  );
}
