# America_TwoDotZero
America_2.0 - The planets have aligned Peace on Earth

## Application Overview

America 2.0 is a multi-tab Flutter web application that serves as a hub for several interconnected initiatives and tools. The application features a persistent purple header navigation bar, plus a slide-out panel on narrow/mobile screens.

### Available Apps

The nav is data-driven — see **[docs/nav-and-apps.md](docs/nav-and-apps.md)** for how it works and how to add a new one. Currently listed, in order:

1. **Home** (🏠) - Always-first start screen, shown by default on load (not an installed app, part of the shell itself)
2. **Web 2.0** (🌐) - Markdown content viewer and documentation hub
3. **We the People** (👥 ↔️ 📜) - Third-party movement platform with campaign contribution transparency requirements (alternates between people and scroll icons)
4. **P.O.E.** (🕊️ ↔️ 🐦‍⬛) - Peace On Earth initiative with world peace proposal details (alternates between peace dove and black raven)
5. **A.B.E.** (✓) - American Backlog Enhancement project tracking from GitHub (https://github.com/cacherefresh/American-Backlog-Enhancement)
6. **About** (🪶) - Window onto robertcoffman.cacherefresh.io
7. **Guilds** (🎮) - Embedded Guilds game application (https://guilds.cacherefresh.io)

### Key Features

- **Persistent Navigation** - Purple header bar stays visible when switching between tabs; below 600px width it collapses to a hamburger that slides out a translucent panel instead
- **Data-driven app list** - Which apps show, and in what order, comes from `flutter_app_wrapper/assets/list_of_apps_config.yaml`, not hardcoded Dart — see [docs/nav-and-apps.md](docs/nav-and-apps.md)
- **Embedded Applications** - Guilds and A.B.E. tabs embed external Flutter web apps via iframes; sites that block framing (like GitHub) get a fallback "open externally" link
- **Animated Icons** - We the People and P.O.E. icons animate every 2 seconds
- **Responsive Design** - Works on desktop, tablet, and mobile devices
- **Static Site Generation** - Builds to a fully functional static site for deployment

## Flutter Developer Notes

To clean, build and run this Flutter app:

### Navigate to flutter_app_wrapper
```bash
cd flutter_app_wrapper
```

### Clean previous builds
```bash
flutter clean
```

### Get dependencies
```bash
flutter pub get
```

### Build for web (production)
```bash
flutter build web --release
```

### Output location: build/web/

The build output contains a fully functional static site that can be deployed to GitHub Pages or any static hosting service.

## Project Structure

```
packages/
├── common/            - Shared helpers/utils (not apps themselves)
│   ├── core/              - AppMeta, EmbeddedWebContent, SuppressEmbeddedInteraction
│   └── markdown_view/     - Markdown rendering component
└── isolated_apps/     - Every app hosted in the nav
    ├── game/              - Guilds tab (iframe) + its AppMeta config
    ├── web_2/             - Web 2.0 markdown viewer + its AppMeta config
    ├── we_the_people/     - Third-party movement content + its AppMeta config
    ├── poe/               - Peace On Earth initiative + its AppMeta config
    ├── abe/               - American Backlog Enhancement (iframe) + its AppMeta config
    └── about/             - About tab (iframe) + its AppMeta config

flutter_app_wrapper/            - Main Flutter application (the "OS shell")
├── lib/main.dart               - Entry point: loads the app list, then runs the app
├── lib/config/app_registry.dart - Home + the id -> AppMeta registry + YAML loader
├── lib/pages/home_page.dart    - Nav row / mobile panel / page-switching, all built from that list
├── assets/list_of_apps_config.yaml - Which apps show, and in what order
├── build/web/                  - Build output (static site)
└── pubspec.yaml                 - Dependencies

docs/
└── nav-and-apps.md    - How the nav/app system works, and how to add a new app
```

See also **[AGENTS.md](AGENTS.md)** for a quick orientation if you're an agent picking up work in this repo.

## Deployment

For detailed deployment instructions to GitHub Pages with your cacherefresh.io domain, see **[SYSOPS_README.md](SYSOPS_README.md)**.
