library web_2;

import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// A simple scaffold representing the Web 2.0 body.
class Web2View extends StatelessWidget {
  const Web2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CoreUtils.welcomeMessage(),
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            const Text(
              'Web 2.0 Scaffold',
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
