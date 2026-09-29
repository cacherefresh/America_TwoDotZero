import 'package:flutter/widgets.dart';

import 'interop/holo_view_factory.dart';

/// Hosts the three.js particle/wireframe background scene behind the
/// holographic landing page.
class HoloBackgroundView extends StatelessWidget {
  const HoloBackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: HtmlElementView(viewType: holoViewType),
    );
  }
}
