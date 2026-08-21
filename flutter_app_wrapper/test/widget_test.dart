import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

import 'package:flutter_app_wrapper/main.dart';

void main() {
  testWidgets('App shell builds and shows the settings icon',
      (WidgetTester tester) async {
    final apps = [
      const AppMeta(
        id: 'about',
        icon: Icon(Icons.info),
        shortDescription: 'About',
        longDescription: 'About',
        page: SizedBox.shrink(),
      ),
    ];

    await tester.pumpWidget(MyApp(apps: apps));

    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
