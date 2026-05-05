library floating_peace_dove;

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// A floating peace dove overlay that randomly moves across the screen.
class FloatingPeaceDove extends StatefulWidget {
  final Duration moveInterval;
  final Duration animationDuration;
  final double doveSize;
  final double opacity;

  const FloatingPeaceDove({
    this.moveInterval = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 800),
    this.doveSize = 48.0,
    this.opacity = 0.7,
    super.key,
  });

  @override
  State<FloatingPeaceDove> createState() => _FloatingPeaceDoveState();
}

class _FloatingPeaceDoveState extends State<FloatingPeaceDove>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _moveTimer;
  late Offset _targetPosition;
  late Offset _currentPosition;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _currentPosition = Offset.zero;
    _targetPosition = Offset.zero;

    // Defer position generation until after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _targetPosition = _generateRandomPosition();
      _animationController.forward();
    });

    _moveTimer = Timer.periodic(widget.moveInterval, (_) {
      if (mounted) {
        _targetPosition = _generateRandomPosition();
        _animationController.forward(from: 0.0);
      }
    });
  }

  Offset _generateRandomPosition() {
    final size = MediaQuery.of(context).size;
    final maxWidth = (size.width - widget.doveSize).clamp(0, double.infinity);
    final maxHeight = (size.height - widget.doveSize).clamp(0, double.infinity);

    return Offset(
      _random.nextDouble() * maxWidth,
      _random.nextDouble() * maxHeight,
    );
  }

  @override
  void dispose() {
    _moveTimer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        _currentPosition = Offset.lerp(
          _currentPosition,
          _targetPosition,
          _animationController.value,
        )!;

        return Positioned(
          left: _currentPosition.dx,
          top: _currentPosition.dy,
          child: IgnorePointer(
            child: Opacity(
              opacity: widget.opacity,
              child: Text(
                '🕊️',
                style: TextStyle(
                  fontSize: widget.doveSize,
                  height: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A wrapper that adds the floating peace dove to any widget.
class WithFloatingPeaceDove extends StatelessWidget {
  final Widget child;
  final Duration moveInterval;
  final Duration animationDuration;
  final double doveSize;
  final double opacity;

  const WithFloatingPeaceDove({
    required this.child,
    this.moveInterval = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 800),
    this.doveSize = 48.0,
    this.opacity = 0.7,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        FloatingPeaceDove(
          moveInterval: moveInterval,
          animationDuration: animationDuration,
          doveSize: doveSize,
          opacity: opacity,
        ),
      ],
    );
  }
}
