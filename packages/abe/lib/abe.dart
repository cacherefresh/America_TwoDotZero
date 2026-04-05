library abe;

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

/// A widget that loads the American Backlog Enhancement (A.B.E.) app from GitHub Pages in an iframe.
class ABEView extends StatefulWidget {
  const ABEView({super.key});

  @override
  State<ABEView> createState() => _ABEViewState();
}

class _ABEViewState extends State<ABEView> {
  late String _iframeElementId;

  @override
  void initState() {
    super.initState();
    _iframeElementId = 'abe-iframe-${DateTime.now().millisecondsSinceEpoch}';
    _registerIframeElement();
  }

  void _registerIframeElement() {
    // Create an iframe element that loads the American Backlog Enhancement app
    ui.platformViewRegistry.registerViewFactory(
      _iframeElementId,
      (int viewId) {
        final html.IFrameElement iframe = html.IFrameElement();
        iframe.src = 'https://cacherefresh.github.io/American-Backlog-Enhancement/';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.allow = 'accelerometer; ambient-light-sensor; autoplay; battery; camera; display-capture; document-domain; encrypted-media; execution-while-not-rendered; execution-while-out-of-viewport; fullscreen; geolocation; gyroscope; magnetometer; microphone; midi; navigation-override; payment; picture-in-picture; publickey-credentials-get; speaker-selection; sync-xhr; usb; vr; xr-spatial-tracking; xr; clipboard-read; clipboard-write; gamepad; hid; idle-detection; serial; window-placement; screen-wake-lock; web-share';
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _iframeElementId),
    );
  }
}
