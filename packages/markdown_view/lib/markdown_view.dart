library markdown_view;

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

/// A widget to display markdown content.
class MarkdownDisplay extends StatelessWidget {
  final String markdownText;

  const MarkdownDisplay({super.key, required this.markdownText});

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdownText,
    );
  }
}
