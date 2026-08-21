import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'we_the_people.dart';

/// Glyph that alternates between people and declaration of independence icons every 2 seconds.
class AnimatedWTPGlyph extends StatefulWidget {
  const AnimatedWTPGlyph({super.key});

  @override
  State<AnimatedWTPGlyph> createState() => _AnimatedWTPGlyphState();
}

class _AnimatedWTPGlyphState extends State<AnimatedWTPGlyph> {
  late Timer _timer;
  bool _showPeople = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _showPeople = !_showPeople;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _showPeople ? '👥' : '📜',
      style: const TextStyle(fontSize: 20),
    );
  }
}

final AppMeta weThePeopleMeta = AppMeta(
  id: 'we_the_people',
  icon: const AnimatedWTPGlyph(),
  shortDescription: 'We the People',
  longDescription:
      'We the People: a third-party movement built on campaign-contribution '
      'transparency, from entry fee rules to the platform itself.',
  page: const WeThePeopleView(),
);
