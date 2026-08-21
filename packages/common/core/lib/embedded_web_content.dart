import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ambient flag that tells descendant [EmbeddedWebContent]s to disable
/// pointer events on their iframe.
///
/// Embedded iframes are real DOM elements, so a Flutter overlay (e.g. a
/// slide-out nav panel) painted on top of one does not stop the browser
/// from routing clicks straight to the iframe underneath. Wrap the page
/// content in this scope (e.g. `suppress: true` while the panel is open) so
/// the iframe steps out of the way without having to hide the page itself.
class SuppressEmbeddedInteraction extends InheritedWidget {
  final bool suppress;

  const SuppressEmbeddedInteraction({
    required this.suppress,
    required super.child,
    super.key,
  });

  static bool of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<SuppressEmbeddedInteraction>();
    return scope?.suppress ?? false;
  }

  @override
  bool updateShouldNotify(SuppressEmbeddedInteraction oldWidget) =>
      suppress != oldWidget.suppress;
}

/// Embeds [url] in an iframe (web) / WebView (native).
///
/// Some sites (GitHub in particular) send `X-Frame-Options`/CSP headers that
/// block being framed at all, which would otherwise just render blank with
/// no way for Flutter to detect it. When [alternateText] is given, it's
/// always shown as a link that opens [url] directly, above the embed.
class EmbeddedWebContent extends StatefulWidget {
  final String url;
  final String? alternateText;

  const EmbeddedWebContent({
    required this.url,
    this.alternateText,
    super.key,
  });

  @override
  State<EmbeddedWebContent> createState() => _EmbeddedWebContentState();
}

class _EmbeddedWebContentState extends State<EmbeddedWebContent> {
  late String _iframeElementId;
  late WebViewController _webViewController;
  html.IFrameElement? _iframeElement;

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
        _iframeElement = iframe;
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
    if (kIsWeb) {
      final suppress = SuppressEmbeddedInteraction.of(context);
      _iframeElement?.style.pointerEvents = suppress ? 'none' : 'auto';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.alternateText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: InkWell(
              onTap: _openExternally,
              child: Text(
                widget.alternateText!,
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
