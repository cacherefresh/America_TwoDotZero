// Guards the vault's markdown -> image wiring.
//
// Vault documents reference images with paths relative to the document
// (`../images/foo.png`) so they render when the `.md` is browsed on GitHub.
// These tests verify the same references resolve to real bundled assets, which
// is what the web build at america2dot0.cacherefresh.io serves.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_view/markdown_view.dart';

/// Matches `![alt](target)`, capturing the target without any title or size.
final RegExp _imageRef = RegExp(r'!\[[^\]]*\]\(\s*([^\s)]+)');

Iterable<String> _imageRefsIn(String markdown) =>
    _imageRef.allMatches(markdown).map((RegExpMatch m) => m.group(1)!);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late List<String> assetKeys;

  setUpAll(() async {
    final AssetManifest manifest =
        await AssetManifest.loadFromAssetBundle(rootBundle);
    assetKeys = manifest.listAssets();
  });

  test('every image referenced by a vault document is a bundled asset',
      () async {
    final List<String> mdKeys = assetKeys
        .where((String k) =>
            k.startsWith('assets/vault/MDs/') && k.endsWith('.md'))
        .toList();
    expect(mdKeys, isNotEmpty, reason: 'no vault documents were bundled');

    final List<String> broken = <String>[];
    int checked = 0;

    for (final String mdKey in mdKeys) {
      final String markdown = await rootBundle.loadString(mdKey);
      for (final String ref in _imageRefsIn(markdown)) {
        final String? resolved =
            resolveMarkdownAssetKey(Uri.parse(ref), mdKey);
        if (resolved == null) {
          continue; // http(s) or data: reference, not a bundled asset.
        }
        checked++;
        if (!assetKeys.contains(resolved)) {
          broken.add('$mdKey -> "$ref" (resolved to "$resolved")');
        }
      }
    }

    expect(checked, greaterThan(0),
        reason: 'no relative image references found to verify');
    expect(broken, isEmpty,
        reason: 'image references that do not resolve to a bundled asset:\n'
            '${broken.join('\n')}');
  });

  testWidgets('a document-relative reference builds a bundled AssetImage',
      (WidgetTester tester) async {
    // Mirrors how LUNAR_PANDORA.md references its figures. Kept inline rather
    // than loading the real document because Markdown renders a lazy ListView
    // and the real figures sit below the test viewport's fold.
    const String docKey = 'assets/vault/MDs/LUNAR_PANDORA.md';
    const String ref = '../images/lunar-pandora-1_mining-concept.png';

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: MarkdownDisplay(
          markdownText: '![Lunar Helium-3 Mining Concept]($ref)',
          sourcePath: docKey,
        ),
      ),
    ));

    // skipOffstage: false because Markdown renders a lazy ListView and an
    // image whose bytes have not decoded yet has zero extent, so the sliver
    // reports it offstage. This asserts the wiring, not the paint.
    final Image image =
        tester.widget<Image>(find.byType(Image, skipOffstage: false));
    expect(
      (image.image as AssetImage).assetName,
      'assets/vault/images/lunar-pandora-1_mining-concept.png',
    );
  });

  testWidgets('a reference that resolves to nothing shows its alt text',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: MarkdownDisplay(
          markdownText: '![Missing figure](../images/does-not-exist.png)',
          sourcePath: 'assets/vault/MDs/LUNAR_PANDORA.md',
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('Missing figure'), findsOneWidget);
  });
}
