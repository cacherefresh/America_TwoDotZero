import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Embeds [url] in an iframe (web) / WebView (native).
///
/// Some sites (GitHub in particular) send `X-Frame-Options`/CSP headers that
/// block being framed at all, which would otherwise just render blank with
/// no way for Flutter to detect it. So this always shows [alternateText] as
/// a link that opens [url] directly, above the embed.
class EmbeddedWebContent extends StatefulWidget {
  final String url;
  final String alternateText;

  const EmbeddedWebContent({
    required this.url,
    required this.alternateText,
    super.key,
  });

  @override
  State<EmbeddedWebContent> createState() => _EmbeddedWebContentState();
}

class _EmbeddedWebContentState extends State<EmbeddedWebContent> {
  late String _iframeElementId;
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    } else {
      _iframeElementId =
          'embed-${identityHashCode(this)}-${DateTime.now().millisecondsSinceEpoch}';
      _registerIframeElement();
    }
  }

  void _registerIframeElement() {
    ui.platformViewRegistry.registerViewFactory(
      _iframeElementId,
      (int viewId) {
        final html.IFrameElement iframe = html.IFrameElement();
        iframe.src = widget.url;
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        return iframe;
      },
    );
  }

  Future<void> _openExternally() async {
    if (!await launchUrl(Uri.parse(widget.url))) {
      throw 'Could not launch ${widget.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: InkWell(
            onTap: _openExternally,
            child: Text(
              widget.alternateText,
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: kIsWeb
              ? HtmlElementView(viewType: _iframeElementId)
              : WebViewWidget(controller: _webViewController),
        ),
      ],
    );
  }
}
