import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_wrapper/holographic/under_construction_banner.dart';
import 'package:flutter_app_wrapper/holographic/under_construction_copy.dart';

/// The under-construction notice and 52% donation pledge are hand-written
/// copy that predates the holographic landing page, and they were silently
/// dropped from the web build once the landing page became 3D. These tests
/// pin the wording character-for-character and prove it still reaches the
/// screen, so neither can happen again unnoticed.
void main() {
  // Transcribed from the pre-holographic landing page. If this ever needs to
  // change, change it here deliberately — don't "fix" it to match the widget.
  const original =
      'Select an app from the menu above! Have Fun!\n'
      '\n'
      ' 🚧 UNDER CONSTRUCTION 🚧\n'
      '🦺not concepts of a plan 😂, \n'
      '🏗️ Everything is WELL DETAILED. ^_~ just not on the site yet. \n'
      '\n'
      '🏗️ I\'m a one man show🎶 at the moment ^_~\n'
      '----------------------------------- \n'
      '\n'
      '~I need funding, DONATIONS go a long way~\n'
      '\n'
      'Donate to:\n'
      ' 💸 paypal.me/cacherefresh \n'
      ' 💸 cashapp: @cacherefresh\n'
      '\n'
      ' - 52% of all donations will go to resolving the actual problem. \n'
      'Could you IMAGINE AMERICA if every Political Candidate did this?\n'
      'We would have every child fed, teachers paid well, AMAZING Infrastructure, the Border Walls of Troy, AND Free Healthcare, flying cars, etc etc... \n'
      '... but we got rallys, bumperstickers, ads, lawn ornaments of your favorite candidate and some half billion worth of political concerts.\n'
      '\n'
      ' So I\'ll trendset and post receipts (give me time, I\'m human)';

  test('the donation pledge copy is preserved verbatim', () {
    expect(underConstructionCopy, original);
  });

  test('the copy still carries the pledge and both donation handles', () {
    expect(underConstructionCopy, contains('UNDER CONSTRUCTION'));
    expect(
      underConstructionCopy,
      contains('52% of all donations will go to resolving the actual problem'),
    );
    expect(underConstructionCopy, contains('paypal.me/cacherefresh'));
    expect(underConstructionCopy, contains('cashapp: @cacherefresh'));
    expect(donationHandles, contains('paypal.me/cacherefresh'));
    expect(donationHandles, contains('cashapp: @cacherefresh'));
    expect(underConstructionHeadline, contains('52%'));
  });

  Widget host(Widget child) => MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [Positioned(left: 0, right: 0, bottom: 0, child: child)],
          ),
        ),
      );

  testWidgets('collapsed banner shows the pledge without interaction',
      (tester) async {
    await tester.pumpWidget(host(
      UnderConstructionBanner(
        expanded: false,
        onToggle: () {},
        expandedHeight: 400,
      ),
    ));

    expect(find.text(underConstructionHeadline), findsOneWidget);
    expect(find.text(donationHandles), findsOneWidget);
  });

  testWidgets('expanded banner shows the copy in full', (tester) async {
    await tester.pumpWidget(host(
      UnderConstructionBanner(
        expanded: true,
        onToggle: () {},
        expandedHeight: 400,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text(underConstructionCopy), findsOneWidget);
  });

  testWidgets('tapping the collapsed banner asks to expand', (tester) async {
    var toggled = 0;
    await tester.pumpWidget(host(
      UnderConstructionBanner(
        expanded: false,
        onToggle: () => toggled++,
        expandedHeight: 400,
      ),
    ));

    await tester.tap(find.text(underConstructionHeadline));
    await tester.pump();

    expect(toggled, 1);
  });
}
