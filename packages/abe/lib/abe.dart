library abe;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:webview_flutter/webview_flutter.dart';

/// A widget that loads the American Backlog Enhancement (A.B.E.) app.
class ABEView extends StatefulWidget {
  const ABEView({super.key});

  @override
  State<ABEView> createState() => _ABEViewState();
}

class _ABEViewState extends State<ABEView> {
  late String _iframeElementId;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    
    // Only initialize WebViewController on non-web platforms
    if (!kIsWeb) {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse('https://github.com/cacherefresh/American-Backlog-Enhancement'));
    } else {
      // Register iframe for web platform
      _iframeElementId = 'abe-iframe-${DateTime.now().millisecondsSinceEpoch}';
      _registerIframeElement();
    }
  }

  void _registerIframeElement() {
    ui.platformViewRegistry.registerViewFactory(
      _iframeElementId,
      (int viewId) {
        final html.IFrameElement iframe = html.IFrameElement();
        iframe.src = 'https://github.com/cacherefresh/American-Backlog-Enhancement/';
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
