import 'dart:js_interop';

import 'package:web/web.dart' as web;

@JS('HoloBackground.createHostElement')
external web.HTMLElement _createHostElement(int viewId);

@JS('HoloBackground.setPointer')
external void _setPointer(double x, double y);

@JS('HoloBackground.setScroll')
external void _setScroll(double offset);

@JS('HoloBackground.setFocus')
external void _setFocus(int index);

@JS('HoloBackground.pause')
external void _pause();

@JS('HoloBackground.resume')
external void _resume();

@JS('HoloBackground.dispose')
external void _disposeScene(int viewId);

/// Dart-side bridge to the vendored three.js scene defined in
/// `web/three/holo-background.js`, called via `dart:js_interop`.
class HoloBridge {
  const HoloBridge();

  web.HTMLElement createHostElement(int viewId) => _createHostElement(viewId);

  void setPointer(double x, double y) => _setPointer(x, y);

  void setScroll(double offset) => _setScroll(offset);

  void setFocus(int index) => _setFocus(index);

  void pause() => _pause();

  void resume() => _resume();

  void dispose(int viewId) => _disposeScene(viewId);
}
