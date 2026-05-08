import 'package:flutter/material.dart';
import 'dart:async';

/// Animated icon for We the People that alternates between people and declaration of independence icons every 2 seconds.
class AnimatedWTPIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const AnimatedWTPIcon({
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<AnimatedWTPIcon> createState() => _AnimatedWTPIconState();
}

class _AnimatedWTPIconState extends State<AnimatedWTPIcon> {
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
    return IconButton(
      tooltip: 'We the People',
      icon: Text(
        _showPeople ? '👥' : '📜',
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: widget.onPressed,
      isSelected: widget.isSelected,
    );
  }
}

/// Animated icon for P.O.E. that alternates between peace dove and raven emojis every 2 seconds.
class AnimatedPOEIcon extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSelected;

  const AnimatedPOEIcon({
    required this.onPressed,
    required this.isSelected,
  });

  @override
  State<AnimatedPOEIcon> createState() => _AnimatedPOEIconState();
}

class _AnimatedPOEIconState extends State<AnimatedPOEIcon> {
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
    return IconButton(
      tooltip: 'P.O.E.',
      icon: Text(
        _showDove ? '🕊️' : '🐦‍⬛',
        style: const TextStyle(fontSize: 20),
      ),
      onPressed: widget.onPressed,
      isSelected: widget.isSelected,
    );
  }
}
