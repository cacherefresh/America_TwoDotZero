import 'package:flutter/material.dart';

/// Plain landing page shown on non-web platforms, where the three.js
/// holographic background isn't available.
class HolographicLandingPageFallback extends StatelessWidget {
  const HolographicLandingPageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Select an app from the menu above! Have Fun!\n\n'
            '🚧 UNDER CONSTRUCTION 🚧\n'
            '🦺not concepts of a plan 😂, \n'
            '🏗️ Everything is WELL DETAILED. ^_~ just not on the site yet. \n\n'
            '🏗️ I\'m a one man show🎶 at the moment ^_~\n'
            '----------------------------------- \n\n'
            '~I need funding, DONATIONS go a long way~\n\n'
            'Donate to:\n 💸 paypal.me/cacherefresh \n 💸 cashapp: @cacherefresh\n\n'
            ' - 52% of all donations will go to resolving the actual problem. \n'
            'Could you IMAGINE AMERICA if every Political Candidate did this?\n'
            'We would have every child fed, teachers paid well, AMAZING '
            'Infrastructure, the Border Walls of Troy, AND Free Healthcare, '
            'flying cars, etc etc... \n'
            '... but we got rallys, bumperstickers, ads, lawn ornaments of '
            'your favorite candidate and some half billion worth of political '
            'concerts.\n\n'
            ' So I\'ll trendset and post receipts (give me time, I\'m human)',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
