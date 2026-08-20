import 'package:flutter/material.dart';
import 'dart:async';

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
