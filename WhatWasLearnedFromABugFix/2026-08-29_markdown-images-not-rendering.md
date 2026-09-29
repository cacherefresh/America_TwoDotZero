# Markdown images did not render on the web build

**Date:** 2026-08-29
**Branch:** `bugfix/markdownreader-genericimagefix`
**Affected:** `america2dot0.cacherefresh.io` — the Web 2.0 markdown viewer

---

## 1. Symptom

`assets/vault/MDs/LUNAR_PANDORA.md` shows its two figures correctly when the
`.md` file is browsed on GitHub, but shows nothing at all in the app's markdown
reader on the deployed web build. No error, no broken-image icon — just a gap.

The document references its figures the ordinary way:

```markdown
![Lunar Helium-3 Periodic Table Reaction Example](../images/lunar-pandora-0_helium3explanation.png)
![Lunar Helium-3 Mining Concept](../images/lunar-pandora-1_mining-concept.png)
```

## 2. Root cause

There were **two independent causes**. Either one alone was enough to produce a
blank gap, which is why the bug looked confusing: fixing one and re-testing
would have shown no improvement at all and could easily have led to reverting a
correct change.

### Cause A — the images were never in the app bundle

`flutter_app_wrapper/pubspec.yaml` declared only:

```yaml
  assets:
    - assets/vault/MDs/
```

A directory entry in `pubspec.yaml` covers **only the files directly inside that
directory**. It does not recurse into siblings or subdirectories. So
`assets/vault/images/` was never compiled into the bundle, and
`build/web/assets/assets/vault/images/` did not exist. The renderer could not
have found those images no matter how it asked for them.

### Cause B — the renderer resolved relative paths through `dart:io`

`MarkdownDisplay` passed the markdown straight to `flutter_markdown`'s
`Markdown` widget with no `imageBuilder`. That falls through to the package's
default, `kDefaultImageBuilder` in
`flutter_markdown-0.6.23/lib/src/_functions_io.dart`:

```dart
if (uri.scheme == 'http' || uri.scheme == 'https') {
  return Image.network(...);
} else if (uri.scheme == 'data') {
  ...
} else if (uri.scheme == 'resource') {
  return Image.asset(uri.path, ...);
} else {
  // <- `../images/foo.png` lands here: no scheme
  return Image.file(File.fromUri(fileUri), ...);
}
```

`../images/foo.png` has no URI scheme, so it took the final branch and became a
`dart:io` **filesystem** read. On a web build there is no filesystem, so this
can never succeed. It also silently produced nothing rather than reporting an
error, which is what made the failure so opaque.

Worse, the widget had **no way** to do better even in principle: `MarkdownDisplay`
only ever received `markdownText`. It never knew *which document* the text came
from, so it had no base path to resolve `../` against.

### Why GitHub worked

GitHub resolves relative links server-side against the repository tree before
serving the page. `assets/vault/MDs/` + `../images/x.png` →
`assets/vault/images/x.png`, which exists in the repo. GitHub working was never
evidence that the paths were "right for the app" — the two systems resolve
paths in completely different places.

## 3. The fix

The guiding decision: **the markdown is the portable artifact and must not
change.** `../images/...` is correct, it is what GitHub needs, and it is what
any other markdown tool would expect. The renderer was wrong, so the renderer
was fixed.

**`packages/markdown_view/lib/markdown_view.dart`**

- Added `resolveMarkdownAssetKey(Uri reference, String? sourcePath)`, a **pure
  function** that maps a document-relative reference to a bundle asset key. It
  parses against a synthetic `asset:///` base so `Uri` itself performs `..`/`.`
  normalization, then joins `pathSegments` (which decodes `%20` and friends to
  match how the asset manifest keys files). Returns `null` for `http(s)` and
  `data:` references, which are not bundled assets.
- Added a `MarkdownImage` widget that dispatches on scheme —
  `Image.network` / `Image.memory` / `Image.asset` — and **never** reaches
  `Image.file`.
- Added an `errorBuilder` that renders the alt text in a bordered box. A
  reference that cannot resolve is now visible instead of being a silent gap.
- Added an optional `sourcePath` to `MarkdownDisplay` and wired an
  `imageBuilder` that uses it.

**`packages/web_2/lib/web_2.dart`** — passes `sourcePath: selectedFile`, the
asset key already being loaded, so the resolver has a base to work from.

**`flutter_app_wrapper/pubspec.yaml`** — added `- assets/vault/images/`.

### Verification

- 7 unit tests on the pure resolver (`packages/markdown_view/test/`) covering
  `../`, `./`, bare-relative, repo-absolute, doubled `..`, percent-escapes,
  and the `http`/`data` pass-through cases.
- 3 tests in `flutter_app_wrapper/test/vault_images_test.dart`, including a
  **generic guard** that walks every `.md` in the bundle, extracts every image
  reference, resolves it, and asserts the result exists in the real
  `AssetManifest`.
- The guard was confirmed to actually catch the bug: deleting the
  `assets/vault/images/` line from `pubspec.yaml` makes it fail and name both
  offending references.
- `flutter build web`, then served `build/web` over HTTP: both PNGs return
  `HTTP 200` with `image/png` at the paths the resolver produces.

## 4. The more senior way

Honest review of the approach, including where it was lucky rather than good.

**What was right**

- **Fixing the renderer instead of the content.** The tempting fix is to edit
  the markdown until the app is happy — hardcode `assets/vault/images/...`.
  That "works" and breaks GitHub, converting one bug into a permanent tax on
  every future document. When two consumers disagree about a source file, the
  source file is usually not the thing to change.
- **Extracting a pure function.** `resolveMarkdownAssetKey` is the entire
  interesting logic and it takes two strings and returns a string. That made
  the important tests run in milliseconds with no widget tree at all, and
  turned the widget into a thin shell. This is the single most reusable lesson
  here: find the pure core of a bug and put the tests there.
- **The generic guard over the point fix.** The task said "generically fix
  this." A test that only checks the two LUNAR_PANDORA images satisfies the
  letter of that; a test that walks every vault document satisfies the intent
  and will catch the *next* document with a typo'd path.
- **Letting `Uri` do the path math.** Hand-rolling `..` collapsing with
  `split('/')` is a classic source of off-by-one bugs. `Uri.resolveUri` is
  already correct and already handles percent-encoding.

**What a more senior engineer would have done differently or sooner**

- **Checked the bundle before reading any code.** One `ls build/web/assets/`
  would have found Cause A in ten seconds and immediately reframed the problem
  as "two bugs, not one." Verify the artifact before theorizing about the code.
- **Suspected a second cause on principle.** After finding the missing
  `pubspec.yaml` entry it would have been very easy to declare victory, ship,
  and be confused when nothing changed. When a bug has a satisfying explanation,
  that is the moment to check whether it is the *only* explanation.
- **Treated the silent failure as its own defect.** The deepest problem was not
  that the path was wrong; it was that a wrong path rendered as *nothing*. The
  `errorBuilder` was added here almost as a nicety, but it is arguably the most
  valuable change in the diff — it converts every future instance of this bug
  from a mystery into a label on screen.
- **Noticed the API shape was the real bug.** `MarkdownDisplay(markdownText:)`
  discards the document's identity. Any relative reference — images, links,
  includes — was unresolvable by construction. The missing `sourcePath` was a
  design flaw waiting for someone to add an image; the image was just what
  finally triggered it.

## 5. Mistakes made during the fix

- **Awaited `rootBundle.loadString` inside `testWidgets`.** `testWidgets` runs
  in a fake-async zone; real file I/O never completes there. The test did not
  fail — it *hung*, and burned two multi-minute timeouts before the cause was
  clear. Real async work belongs in `setUpAll` or inside `tester.runAsync()`.
- **Added a `Tooltip` nobody asked for.** Showing alt text on hover seemed like
  a free improvement. It wrapped every image in an `OverlayPortal`, which
  changed the widget tree enough to break the finders, and cost a debugging
  round to discover. It was deleted. Scope creep inside a bugfix gets punished
  immediately and deserves to be.
- **Assumed `find.byType(Image)` would see the image.** It did not, and the
  first instinct was to suspect the fix. The widget was in the tree with the
  correct `AssetImage` key all along — an image whose bytes have not decoded has
  zero extent, and a lazy `ListView` sliver reports zero-extent children as
  offstage. The lesson: when a test disagrees with the code, dump the actual
  tree before changing either. `debugPrint(tester.allWidgets...)` resolved in
  one run what guessing would not have.
- **Assumed a browser was installed.** Time went into `flutter devices` output
  before checking whether any Chrome binary existed on the machine at all. It
  did not.

## 6. Follow-ups (found, deliberately not fixed)

- **`flutter_markdown` is discontinued.** Pinned at `0.6.23`; pub reports it as
  replaced by `flutter_markdown_plus` (`0.7.7+1` available). Migrating is a
  separate change — the `imageBuilder` contract is the same, so this fix ports
  over directly.
- **`assets/config.yaml` is loaded but not declared** in `pubspec.yaml`, so
  `AppConfig.initialize()` would throw. It is currently harmless *only* because
  `AppConfig` is dead code — nothing in the repo references it. It will break
  the moment someone wires it up.
- **`flutter_app_wrapper/test/widget_test.dart` is the stale default counter
  test** and fails to load. It was already failing before this work and is
  untouched by it.
- **The two PNGs total ~4.5 MB** and are shipped uncompressed to every web
  visitor. Worth resizing for a web build.
- **`web_2.dart` builds its `FutureBuilder` future inside `build()`**, so the
  document is re-read from the bundle on every rebuild. Not a correctness bug,
  but it is the standard `FutureBuilder` footgun.
