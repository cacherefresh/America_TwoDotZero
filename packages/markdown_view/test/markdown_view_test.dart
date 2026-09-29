import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_view/markdown_view.dart';

void main() {
  const String doc = 'assets/vault/MDs/LUNAR_PANDORA.md';

  String? resolve(String reference, {String? sourcePath = doc}) =>
      resolveMarkdownAssetKey(Uri.parse(reference), sourcePath);

  group('resolveMarkdownAssetKey', () {
    test('resolves the ../images/ form used by the vault', () {
      expect(
        resolve('../images/lunar-pandora-1_mining-concept.png'),
        'assets/vault/images/lunar-pandora-1_mining-concept.png',
      );
    });

    test('resolves a sibling-relative reference', () {
      expect(resolve('diagram.png'), 'assets/vault/MDs/diagram.png');
      expect(resolve('./diagram.png'), 'assets/vault/MDs/diagram.png');
      expect(resolve('nested/diagram.png'),
          'assets/vault/MDs/nested/diagram.png');
    });

    test('resolves a repo-absolute reference', () {
      expect(resolve('/assets/vault/images/a.png'),
          'assets/vault/images/a.png');
    });

    test('collapses multiple parent segments', () {
      expect(resolve('../../images/a.png'), 'assets/images/a.png');
    });

    test('decodes percent-escaped segments to real asset keys', () {
      expect(resolve('../images/my%20image.png'),
          'assets/vault/images/my image.png');
    });

    test('returns null for references that are not bundled assets', () {
      expect(resolve('https://example.com/a.png'), isNull);
      expect(resolve('http://example.com/a.png'), isNull);
      expect(resolve('data:image/png;base64,iVBORw0KGgo='), isNull);
    });

    test('treats a relative reference as root-relative without a source path',
        () {
      expect(resolve('assets/vault/images/a.png', sourcePath: null),
          'assets/vault/images/a.png');
    });
  });
}
