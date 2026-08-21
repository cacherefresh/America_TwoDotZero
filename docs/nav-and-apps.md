# Nav & apps: how it works, and how to add a new one

`flutter_app_wrapper` is a thin OS-like shell: it doesn't know anything about
what any individual app *is*, only how to list, tooltip, and switch between
whatever apps are installed. Each app package describes itself; the wrapper
just reads that list and renders it.

## The pieces

**`AppMeta`** (`packages/common/core/lib/app_meta.dart`) — one app's self-description:

```dart
class AppMeta {
  final String id;               // matches an id in list_of_apps_config.yaml
  final Widget icon;
  final String shortDescription; // mobile panel row label, tooltip fallback
  final String longDescription;  // desktop hover tooltip text
  final Widget page;
}
```

**Per-package config** — every app package exports exactly one `AppMeta` from
a `<package>_config.dart` file, e.g. `packages/isolated_apps/game/lib/game_config.dart`
exports `gameMeta`. This is also where an app's *icon* lives — including
anything custom, like `we_the_people`'s and `poe`'s animated emoji glyphs
(`AnimatedWTPGlyph`, `AnimatedPOEGlyph`), which are defined right there in
their own package now, not in the wrapper. An app's icon is that app's
concern, not the shell's.

**`packages/isolated_apps/`** holds every app in the nav (`web_2`,
`we_the_people`, `poe`, `abe`, `about`, `game`). **`packages/common/`** holds
shared code that isn't itself an app — `common/core` (this `AppMeta` type,
`EmbeddedWebContent`, `SuppressEmbeddedInteraction`) and
`common/markdown_view` (a rendering component `web_2` pulls in). The split is
deliberate: anything under `isolated_apps/` shows up in the nav; anything
under `common/` is a library an app can depend on.

**The registry** (`flutter_app_wrapper/lib/config/app_registry.dart`) —
two things:
1. `_registry`: a `Map<String, AppMeta>` from id → that package's `AppMeta`.
   This is the one place the wrapper unavoidably has to know each app
   package exists — Dart is compiled, not reflective, so there's no way to
   *automatically* discover "any package that exists" at runtime without a
   codegen step. Think of it as the OS's installed-binaries table.
2. `loadInstalledApps()`: reads `assets/list_of_apps_config.yaml`, resolves
   its ordered id list against `_registry`, and returns the ordered
   `List<AppMeta>` to actually show. **This is the genuinely data-driven
   part** — which apps show, and in what order, is a YAML edit, not a
   Dart-code edit.

`homeMeta` also lives in `app_registry.dart`, but *outside* the
registry/YAML — Home is the shell's own start screen, not an installed app
(same as a real OS's home screen isn't itself a listed application), so it's
always shown first regardless of what's in the YAML.

**`list_of_apps_config.yaml`** (`flutter_app_wrapper/assets/`):

```yaml
apps:
  - id: web_2
  - id: we_the_people
  - id: poe
  - id: abe
  - id: about
  - id: game
```

**Startup wiring** — `main()` is `async`, calls `loadInstalledApps()` once
before `runApp`, and threads the resolved list down through `MyApp` →
`MyHomePage(apps: ...)`. `_MyHomePageState` combines it with `homeMeta` once
in `initState()` and builds three things from that single list:
- the desktop icon row (`IconButton` per entry, tooltip = `longDescription`)
- the mobile slide-out panel (`ListTile` per entry, label = `shortDescription`)
- the `IndexedStack` of pages, switched by index

All three always agree with each other because they're built from the same
list — there's no separate index bookkeeping to keep in sync anymore.
`_selectedIndex` starts at `0`, i.e. `homeMeta` — the app opens on Home.

## Add a new app

1. Create the package (`packages/isolated_apps/my_app/`), with whatever
   `MyAppView` widget renders its page.
2. Add `packages/isolated_apps/my_app/lib/my_app_config.dart` exporting
   `final AppMeta myAppMeta = AppMeta(id: 'my_app', icon: ..., shortDescription: ..., longDescription: ..., page: const MyAppView());`
3. In `flutter_app_wrapper/lib/config/app_registry.dart`: import the config
   file, add one line to `_registry`.
4. In `flutter_app_wrapper/pubspec.yaml`: add
   `my_app: path: ../packages/isolated_apps/my_app`.
5. In `flutter_app_wrapper/assets/list_of_apps_config.yaml`: add `- id: my_app`
   wherever you want it to sit in the order.

That's it — no index math, no touching the nav row or panel code.

## A note on embedded (iframe) apps

Apps that embed an external site (About, Guilds, A.B.E., P.O.E.'s README
preview) go through `EmbeddedWebContent` (`packages/common/core/lib/embedded_web_content.dart`)
rather than each rolling their own iframe code:
- If the embedded site blocks framing (GitHub does, via `X-Frame-Options`),
  Flutter has no way to detect that — the iframe just renders blank with no
  error event. So `EmbeddedWebContent` always shows an `alternateText` link
  above the embed that opens the URL directly, rather than trying to detect
  the failure.
- A real iframe is a DOM element, so a Flutter overlay (like the mobile nav
  panel) painted *visually* on top of one doesn't stop the browser from
  routing clicks straight to the iframe underneath. `SuppressEmbeddedInteraction`
  (an `InheritedWidget`, also in `core`) lets the wrapper flip the iframe's
  `pointer-events` CSS off while the panel is open, without having to hide
  the page itself.

## Why this shape (history)

1. **Originally**: every icon was a hand-written `IconButton` directly in
   `home_page.dart`'s `AppBar`, with a parallel hardcoded `_pages` list kept
   in sync by list *position* — adding/reordering an app meant editing two
   lists and re-deriving index numbers by hand.
2. **`NavItem`/`navItems`** (a single wrapper-owned list of
   `{icon, shortDescription, page}`): collapsed that to one list, so the nav
   row, mobile panel, and page stack all read from the same source instead
   of three. Still centralized in the wrapper, though — it inlined every
   app's icon and label directly, and the wrapper imported every app
   package's view widget just to describe it.
3. **`AppMeta` + per-package config + YAML registry** (current): moved each
   app's self-description into its own package (icon included), and moved
   the *ordering/inclusion* decision out of Dart entirely into
   `list_of_apps_config.yaml`. The wrapper's only remaining app-specific
   knowledge is the one-line-per-app `_registry` map — everything else
   (order, which apps are shown) is data, not code.
