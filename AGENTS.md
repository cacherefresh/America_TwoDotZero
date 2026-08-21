# AGENTS.md

Orientation for agents picking up work in this repo.

## What this is

A Flutter monorepo: `flutter_app_wrapper/` is the main web app (an OS-like
shell). Under `packages/`, two subfolders split by role:

- **`packages/isolated_apps/*`** — the individual "apps" the shell hosts (Web
  2.0, We the People, P.O.E., A.B.E., About, Guilds). Each is a full app
  package with its own `AppMeta` config, shown in the nav.
- **`packages/common/*`** — shared helpers/libraries an app can depend on,
  not apps themselves: `common/core` (the `AppMeta` type,
  `EmbeddedWebContent`, `SuppressEmbeddedInteraction`) and
  `common/markdown_view` (a rendering component `web_2` uses).

Rule of thumb: if it shows up in the nav, it belongs in `isolated_apps/`; if
it's a library other packages import, it belongs in `common/`.

## Nav / app list

**Read [docs/nav-and-apps.md](docs/nav-and-apps.md) before touching anything
nav-related.** Short version: each app package exports an `AppMeta` (icon,
short/long description, page) from its own `<package>_config.dart`; the
wrapper's `flutter_app_wrapper/lib/config/app_registry.dart` maps ids to
those, and `flutter_app_wrapper/assets/list_of_apps_config.yaml` decides
which apps show and in what order. **Do not hardcode a new app directly into
`home_page.dart`** — add its `AppMeta` config file, one registry map entry,
and one YAML line instead (steps are in the doc).

## Embedded (iframe) apps

Anything that embeds an external site goes through `EmbeddedWebContent`
(`packages/common/core/lib/embedded_web_content.dart`) rather than rolling its own
iframe code — it handles the GitHub-style "site blocks framing, renders
blank with no error" case (always shows a fallback link) and the
"iframe swallows clicks meant for a Flutter overlay on top of it" case
(`SuppressEmbeddedInteraction`). Reuse it for any new embedded app.

## Verifying changes

This is a Flutter **web** app whose core interactions (embedded iframes,
`dart:html`) don't run under `flutter test`'s VM target — `flutter test`
will fail to compile for reasons unrelated to your change (pre-existing,
not a regression to chase). The real verification path used throughout this
project's history:

1. `flutter analyze` in every touched package.
2. `flutter build web --release` in `flutter_app_wrapper/`.
3. Serve `build/web` statically (e.g. `npx serve -l <port> -s build/web`) and
   drive it with headless Chromium (Playwright) — screenshot and check
   console errors. Test both a desktop viewport (≥600px, shows the icon row)
   and a narrow one (<600px, shows the hamburger/slide-out panel).

If you spin up multiple browser sessions across iterations, kill leftover
`chrome.exe` processes between runs — they accumulate and can cause WebGL
context loss that looks like a real bug but isn't.

## Docs

- [docs/nav-and-apps.md](docs/nav-and-apps.md) — nav/app architecture, how to
  add a new app, and why it's shaped this way.
- [README.md](README.md) — project overview, build instructions, structure.
- [SYSOPS_README.md](SYSOPS_README.md) — deployment to GitHub Pages.
