library markdown_view;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Resolves an image reference found inside a markdown document to an asset key.
///
/// Markdown in the vault uses paths that are relative to the document itself
/// (`../images/foo.png`) so the images render on GitHub when browsing the raw
/// `.md` file. This turns that same reference into the bundle asset key the app
/// needs (`assets/vault/images/foo.png`) by resolving it against the directory
/// of [sourcePath].
///
/// Returns `null` when [reference] is not a bundled asset (an `http(s)` or
/// `data` URI), so callers can fall back to another loader.
String? resolveMarkdownAssetKey(Uri reference, String? sourcePath) {
  if (reference.hasScheme && reference.scheme != 'resource') {
    return null;
  }

  // A fake absolute base lets Uri do the `..` / `.` normalization for us.
  final Uri base = Uri.parse('asset:///${sourcePath ?? ''}');
  final Uri resolved = base.resolveUri(reference);

  // pathSegments decodes percent-escapes (`%20` -> ` `), which is what the
  // asset manifest keys on.
  return resolved.pathSegments.where((String s) => s.isNotEmpty).join('/');
}

/// Renders an image referenced from a markdown document.
///
/// Handles the three kinds of reference that show up in the vault: bundled
/// assets (relative paths), remote images and inline `data:` URIs. Unlike
/// `flutter_markdown`'s default builder it never falls back to `dart:io`
/// `Image.file`, which is what made relative paths silently fail on the web
/// build.
class MarkdownImage extends StatelessWidget {
  const MarkdownImage({
    super.key,
    required this.uri,
    this.alt,
    this.sourcePath,
  });

  final Uri uri;

  /// Alt text, shown in place of an image that cannot be loaded.
  final String? alt;

  /// Asset key of the document this image was referenced from, e.g.
  /// `assets/vault/MDs/LUNAR_PANDORA.md`.
  final String? sourcePath;

  @override
  Widget build(BuildContext context) {
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(uri.toString(), errorBuilder: _buildError);
    }
    if (uri.scheme == 'data') {
      return _buildDataUri();
    }

    final String? assetKey = resolveMarkdownAssetKey(uri, sourcePath);
    if (assetKey == null || assetKey.isEmpty) {
      return _buildError(context, 'unsupported image reference "$uri"', null);
    }
    return Image.asset(assetKey, errorBuilder: _buildError);
  }

  Widget _buildDataUri() {
    final UriData? data = uri.data;
    if (data == null) {
      return Builder(
        builder: (BuildContext context) =>
            _buildError(context, 'malformed data URI', null),
      );
    }
    final Uint8List bytes = data.isBase64
        ? data.contentAsBytes()
        : Uint8List.fromList(utf8.encode(Uri.decodeFull(data.contentText)));
    return Image.memory(bytes, errorBuilder: _buildError);
  }

  /// Shows the alt text in place of an image that could not load, so a broken
  /// reference is visible rather than a blank gap.
  Widget _buildError(BuildContext context, Object error, StackTrace? stack) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.broken_image_outlined,
              size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              alt?.isNotEmpty == true ? alt! : uri.toString(),
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget to display markdown content.
class MarkdownDisplay extends StatelessWidget {
  final String markdownText;

  /// Asset key of the document [markdownText] was loaded from, e.g.
  /// `assets/vault/MDs/LUNAR_PANDORA.md`. Relative image references in the
  /// document are resolved against this path's directory. Without it, only
  /// absolute references (`http(s)`, `data:`, `/assets/...`) can resolve.
  final String? sourcePath;

  const MarkdownDisplay({
    super.key,
    required this.markdownText,
    this.sourcePath,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdownText,
      imageBuilder: (Uri uri, String? title, String? alt) =>
          MarkdownImage(uri: uri, alt: alt, sourcePath: sourcePath),
    );
  }
}
