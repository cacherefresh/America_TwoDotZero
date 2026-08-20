library about;

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// A widget that loads the About page at robertcoffman.cacherefresh.io.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmbeddedWebContent(
      url: 'https://robertcoffman.cacherefresh.io',
    );
  }
}
