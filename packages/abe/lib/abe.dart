library abe;

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// A widget that loads the American Backlog Enhancement (A.B.E.) app.
class ABEView extends StatelessWidget {
  const ABEView({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmbeddedWebContent(
      url: 'https://github.com/cacherefresh/American-Backlog-Enhancement/',
      alternateText: 'Open A.B.E. on GitHub ↗',
    );
  }
}
