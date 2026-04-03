library we_the_people;

import 'package:flutter/material.dart';

/// A landing page representing the We the People third party movement.
class WeThePeopleView extends StatelessWidget {
  const WeThePeopleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('We the People - Third Party'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We the People',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A Third Party Movement',
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Welcome',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Whether you wear a red hat, a blue hat, or stand proudly with the purple hat of a new movement—this is the place for you.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entry Fee & Transparency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'We believe in honest governance and transparent use of campaign contributions. We require a commitment to:',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• 52% of all campaign contributions must go directly to the campaign or cause you are running about',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• No shell games: Contributions cannot be diverted to foundations owned by relatives or associates',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• We understand overhead exists and people need to be paid fairly',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Instead of spending millions on lawn signs and attack ads, we could have already built the walls of Troy for our borders and provided universal healthcare to every citizen. We believe in directing resources toward real solutions, not political theater.',
              style: TextStyle(fontSize: 16, height: 1.8),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join the Movement',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This is the entry point for a new way of thinking about politics and governance. We welcome those from all backgrounds and beliefs to participate in building something better.',
                    style: TextStyle(fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
