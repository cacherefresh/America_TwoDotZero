library game;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:webview_flutter/webview_flutter.dart';

/// A widget that loads the Guilds game from GitHub Pages.
class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late String _iframeElementId;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    
    // Only initialize WebViewController on non-web platforms
    if (!kIsWeb) {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('https://guilds.cacherefresh.io/'));
    } else {
      // Register iframe for web platform
      _iframeElementId = 'guilds-iframe-${DateTime.now().millisecondsSinceEpoch}';
      _registerIframeElement();
    }
  }

  void _registerIframeElement() {
    ui.platformViewRegistry.registerViewFactory(
      _iframeElementId,
      (int viewId) {
        final html.IFrameElement iframe = html.IFrameElement();
        iframe.src = 'https://guilds.cacherefresh.io/';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use WebViewWidget on mobile, iframe on web
    if (kIsWeb) {
      return SizedBox.expand(
        child: HtmlElementView(viewType: _iframeElementId),
      );
    } else {
      return WebViewWidget(controller: _webViewController);
    }
  }
}

