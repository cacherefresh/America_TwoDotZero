import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'poe.dart';

/// Glyph that alternates between peace dove and raven emojis every 2 seconds.
class AnimatedPOEGlyph extends StatefulWidget {
  const AnimatedPOEGlyph({super.key});

  @override
  State<AnimatedPOEGlyph> createState() => _AnimatedPOEGlyphState();
}

class _AnimatedPOEGlyphState extends State<AnimatedPOEGlyph> {
  late Timer _timer;
  bool _showDove = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _showDove = !_showDove;
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
      _showDove ? '🕊️' : '🐦‍⬛',
      style: const TextStyle(fontSize: 20),
    );
  }
}

final AppMeta poeMeta = AppMeta(
  id: 'poe',
  icon: const AnimatedPOEGlyph(),
  shortDescription: 'P.O.E.',
  longDescription:
      "Peace On Earth — a world peace proposal inspired by Edgar Allan Poe, "
      "with a live preview of the project's README.",
  page: const POEView(),
);
